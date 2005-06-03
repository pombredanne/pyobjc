/*
 * Special wrappers for pointer values
 *
 * Pointer arguments to methods can be split into 3 classes:
 * - Pass-by-reference arguments (in, out, inout). 
 *   This is supported by using the modifiers _C_IN, _C_OUT and _C_INOUT
 * - Pointers to buffers
 *   This requires special support, you can't detect the size of the buffer
 *   from the signature
 * - Opaque values
 *   Types like FSRef are for all intents and purposes opaque values,
 *   that happen to be represented using pointers (to structs). The functions
 *   in this file allow extension modules to register functions to convert these
 *   values to and from their Python representation.
 *
 * NOTE:
 * - The pythonify and depythonify functions have the same interface as
 *   the *_New and *_Convert functions in MacPython (pymactoolbox.h), this
 *   makes it easier to interface with that packages.
 */
#include "pyobjc.h"


#ifdef MACOSX
#include <pymactoolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#endif

struct wrapper {
	const char* signature;
	int offset;
	PyObject* (*pythonify)(void*);
	int (*depythonify)(PyObject*, void*);
};

/* Using an array is pretty lame, this needs to be replaced by a more
 * efficient datastructure. However: As long as their is only a limited
 * number of custom wrappers this should not be a problem.
 */
static struct wrapper* items = 0;
static int item_count = 0;

/*
 * If signature is a pointer to a structure return the index of the character
 * just beyond the end of the struct name. This information is needed because
 * @encode(struct foo*) can return two different strings:
 * 1) ^{foo} if the compiler has not yet seen a full definition of struct foo
 * 2) ^{foo=...} if the compiler has ssen a full definition of the struct
 * We want to treat those two pointer as the same type, therefore we need to
 * ignore everything beyond the end of the struct name.
 */
static int find_end_of_structname(const char* signature) {
	if (signature[1] == _C_STRUCT_B) {
		int o1, o2;

		o1 = strchr(signature, _C_STRUCT_E) - signature;
		o2 = strchr(signature, '=') - signature;

		return (o1 < o2) ? o1 : o2;
	}
	return strlen(signature);
}

static struct wrapper*
FindWrapper(const char* signature)
{
	int i;
	int len;

	len = strlen(signature);

	for (i = 0; i < item_count; i++) {
		if (strncmp(signature, items[i].signature, items[i].offset) == 0) {
			/* See comment just above find_end_of_structname */
			if (signature[1] != _C_STRUCT_B) {
				if (signature[items[i].offset] == '\0') {
					return items + i;
				}
			} else {
				char ch = signature[items[i].offset];
				if (ch == '=' || ch == _C_STRUCT_E) {
					return items + i;
				}
			}
		}
	}
	return NULL;
}

int 
PyObjCPointerWrapper_Register(
	const char* signature,
	PyObjCPointerWrapper_ToPythonFunc pythonify,
	PyObjCPointerWrapper_FromPythonFunc depythonify

	) 
{
	struct wrapper* value;

	/*
	 * Check if we already have a wrapper, if so replace that.
	 * This makes it possible to replace a default wrapper by something
	 * better.
	 */
	if (signature == NULL) {
		return -1;
	}
	value = FindWrapper(signature);
	if (value != NULL) {
		value->pythonify = pythonify;
		value->depythonify = depythonify;
		return 0;
	}

	if (items == NULL) {
		items = PyMem_Malloc(sizeof(struct wrapper));
		if (items == NULL) {
			PyErr_NoMemory();
			return -1;
		}
		item_count = 1;
	} else {
		struct wrapper* tmp;

		tmp = PyMem_Realloc(
			items, sizeof(struct wrapper) *  (item_count+1));
		if (tmp == NULL) {
			PyErr_NoMemory();
			return -1;
		}
		items = tmp;
		item_count ++;
	}

	value = items + (item_count-1);

	value->signature = signature;
	value->offset = find_end_of_structname(signature);

	value->pythonify = pythonify;
	value->depythonify = depythonify;

	return 0;
}



PyObject* 
PyObjCPointerWrapper_ToPython(const char* type, void* datum)
{
	struct wrapper* item;

	item = FindWrapper(type);
	if (item == NULL) {
		return NULL;
	}

	return item->pythonify(*(void**)datum);
}


int 
PyObjCPointerWrapper_FromPython(
	const char* type, PyObject* value, void* datum)
{
	struct wrapper* item;
	int r;

	if (value == PyObjC_NULL) {
		*(void**)datum = NULL;
		return 0;
	}

	item = FindWrapper(type);
	if (item == NULL) {
		return -1;
	}

	r = item->depythonify(value, datum);
	if (r == 0) {
		return 0;
	} else {
		return -1;
	}
}

static PyObject*
PyObjectPtr_New(void *obj)
{
	return (PyObject*)obj;
}

static int
PyObjectPtr_Convert(PyObject* obj, void* pObj)
{
	*(void**)pObj = (void *)obj;
	return 0;
}

#ifdef MACOSX
/*
 * Generic CF type support 
 */
static PyObject*
CF_to_py(void* cfValue)
{
	return PyObjC_IDToCFType((id)cfValue);
}

static int
py_to_CF(PyObject* obj, void* output)
{
	id tmp = PyObjC_CFTypeToID(obj);
	if (tmp == NULL && PyErr_Occurred()) {
		return -1;
	}
	*(void**)output = tmp;
	return 0;
}

int PyObjCPointerWrapper_RegisterCF(const char *signature) {
	return PyObjCPointerWrapper_Register(signature, 
		(PyObjCPointerWrapper_ToPythonFunc)&CF_to_py, 
		(PyObjCPointerWrapper_FromPythonFunc)&py_to_CF);
}


#endif



int 
PyObjCPointerWrapper_Init(void)
{
	int r = 0;

#ifdef MACOSX
	r = PyObjCPointerWrapper_RegisterCF(@encode(CFURLRef)); 
	if (r == -1) return -1;

	r = PyObjCPointerWrapper_RegisterCF(@encode(CFSetRef)); 
	if (r == -1) return -1;

#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_2
	r = PyObjCPointerWrapper_RegisterCF(@encode(CFNetServiceRef)); 
	if (r == -1) return -1;
#endif

	r = PyObjCPointerWrapper_RegisterCF(@encode(CFReadStreamRef)); 
	if (r == -1) return -1;

	r = PyObjCPointerWrapper_RegisterCF(@encode(CFRunLoopRef)); 
	if (r == -1) return -1;

#endif

	r = PyObjCPointerWrapper_Register(@encode(PyObject*),
		PyObjectPtr_New, PyObjectPtr_Convert);
	if (r == -1) return -1;

	return 0;
}