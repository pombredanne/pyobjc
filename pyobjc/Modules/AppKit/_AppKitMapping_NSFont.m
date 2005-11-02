/*
 * NSFont mappings for 'difficult' methods:
 *
 * -positionsForCompositeSequence:numberOfGlyphs:pointArray:    [call, imp]
 * -fontWithName:matrix:
 */
#include <Python.h>
#include <Foundation/Foundation.h>
#include "pyobjc-api.h"

static PyObject*
call_NSFont_positionsForCompositeSequence_numberOfGlyphs_pointArray_(
	PyObject* method, PyObject* self, PyObject* arguments)
{
	PyObject* result;
	struct objc_super super;
	int numGlyphs;
	PyObject* glyphList;
	PyObject* seq;
	NSGlyph* glyphs;
	NSPoint* points;
	int i, len;

	if (!PyArg_ParseTuple(arguments, "Oi", &glyphList, &numGlyphs)) {
		return 0;
	}

	seq = PySequence_Fast(glyphList, "glyphList is not a sequence");
	if (seq == NULL) {
		return NULL;
	}
	
	len = PySequence_Fast_GET_SIZE(seq);
	if (len < numGlyphs) {
		PyErr_SetString(PyExc_ValueError, "Too few glyphs");
		Py_DECREF(seq);
		return NULL;
	}

	glyphs = PyMem_Malloc(sizeof(NSGlyph));
	if (glyphs == NULL) {
		Py_DECREF(seq);
		return NULL;
	}

	points = PyMem_Malloc(sizeof(NSPoint));
	if (glyphs == NULL) {
		PyMem_Free(glyphs);
		Py_DECREF(seq);
		return NULL;
	}

	for (i = 0; i < len; i++) {
		int r;

		r = PyObjC_PythonToObjC(@encode(NSGlyph), 
			PySequence_Fast_GET_ITEM(seq, i),
			glyphs + i);
		if (r == -1) {
			PyMem_Free(glyphs);
			PyMem_Free(points);
			Py_DECREF(seq);
			return NULL;
		}
	}
	Py_DECREF(seq);

	PyObjC_DURING
		if (PyObjCIMP_Check(method)) {
			len = ((int(*)(id, SEL, NSGlyph*, int, NSPoint*))
			 	PyObjCIMP_GetIMP(method))(
					PyObjCObject_GetObject(self),
					PyObjCIMP_GetSelector(method),
					glyphs, numGlyphs, points);
		} else {
			PyObjC_InitSuper(&super,
				PyObjCSelector_GetClass(method),
				PyObjCObject_GetObject(self));

			len = (int)objc_msgSendSuper(&super,
				PyObjCSelector_GetSelector(method),
				glyphs, numGlyphs, points);
		}
	PyObjC_HANDLER
		PyObjCErr_FromObjC(localException);
		len = -1;
	PyObjC_ENDHANDLER

	if (len == -1 && PyErr_Occurred()) {
		PyMem_Free(points);
		PyMem_Free(glyphs);
		return NULL;
	}

	PyMem_Free(glyphs);
	
	if (len > 0) {
		seq = PyObjC_CArrayToPython(@encode(NSPoint), points, len);
	} else {
		seq = PyTuple_New(0);
	}
	PyMem_Free(points);

	if (seq == NULL) {
		return NULL;
	}

	result = Py_BuildValue("(iO)", len, seq);
	Py_DECREF(seq);

	return result;
}

static void
imp_NSFont_positionsForCompositeSequence_numberOfGlyphs_pointArray_(
	void* cif __attribute__((__unused__)), 
	void* resp, 
	void** args, 
	void* callable)
{
	id self = *(id*)args[0];
	//SEL _meth = *(SEL*)args[1];
	NSGlyph* glyphs = *(NSGlyph**)args[2];
	int numGlyphs = *(int*)args[3];
	NSPoint* points = *(NSPoint**)args[4];
	int* pretval = (int*)resp;

	PyObject* arglist = NULL;
	PyObject* result = NULL;
	PyObject* seq = NULL;
	PyObject* v;
	int i;
	PyObject* pyself = NULL;
	int cookie = 0;

	PyGILState_STATE state = PyGILState_Ensure();

	arglist = PyTuple_New(3);
	if (arglist == NULL) goto error;
	
	pyself = PyObjCObject_NewTransient(self, &cookie);
	if (pyself == NULL) goto error;
	PyTuple_SetItem(arglist, 0, pyself); 
	Py_INCREF(pyself);

	v = PyObjC_CArrayToPython(@encode(NSGlyph), glyphs, numGlyphs);
	if (v == NULL) goto error;
	PyTuple_SET_ITEM(arglist, 1, v);

	v = PyInt_FromLong(numGlyphs);
	if (v == NULL) goto error;
	PyTuple_SET_ITEM(arglist, 2, v);

	result = PyObject_Call((PyObject*)callable, arglist, NULL);
	Py_DECREF(arglist); arglist = NULL;
	PyObjCObject_ReleaseTransient(pyself, cookie); pyself = NULL;
	if (result == NULL) goto error;

	if (!PyTuple_Check(result)) {
		Py_DECREF(result);
		PyErr_SetString(PyExc_TypeError, 
			"Should return tuple (numPoints, points)");
		goto error;
	}

	if (PyObjC_PythonToObjC(
		@encode(int), PyTuple_GET_ITEM(result, 0), pretval) < 0) {
		goto error;
	}

	seq = PySequence_Fast(PyTuple_GET_ITEM(result, 1),
		"Should return tuple (numPoints, points)");
	if (seq == NULL) goto error;

	if (PySequence_Fast_GET_SIZE(seq) < *pretval) {
		PyErr_SetString(PyExc_ValueError, "Too few points returned");
		goto error;
	}

	if (*pretval > numGlyphs) {
		PyErr_SetString(PyExc_ValueError, "Too many points returned");
		goto error;
	}


	for (i = 0; i < *pretval; i++) {
		int r;

		r = PyObjC_PythonToObjC(@encode(NSPoint),
			PySequence_Fast_GET_ITEM(seq, i),
			points + i);
		if (r == -1) goto error;
	}
	Py_DECREF(seq);
	Py_DECREF(result);
	PyGILState_Release(state);
	return;

error:
	Py_XDECREF(arglist);
	if (pyself) {
		PyObjCObject_ReleaseTransient(pyself, cookie); 
	}
	Py_XDECREF(result);
	Py_XDECREF(seq);
	*pretval = -1;
	PyObjCErr_ToObjCWithGILState(&state);
}


static PyObject*
call_NSFont_fontWithName_matrix_(
	PyObject* method, PyObject* self, PyObject* arguments)
{
	struct objc_super super;
	id  font;
	id  typeface;
	PyObject* pyFontMatrix;
	float _matrix[6];
	float* volatile matrix;
	PyObject* seq;
	int i, len;

	if (!PyArg_ParseTuple(arguments, "O&O", 
			PyObjCObject_Convert, &typeface, &pyFontMatrix)) {
		return 0;
	}

	if (pyFontMatrix == Py_None) {
		matrix = NULL;

	} else {
		matrix = _matrix;

		seq = PySequence_Fast(pyFontMatrix, "fontMatrix is not a sequence");
		if (seq == NULL) {
			return NULL;
		}
		
		len = PySequence_Fast_GET_SIZE(seq);
		if (len != 6) {
			PyErr_SetString(PyExc_ValueError, "fontMatrix must be exactly 6 floats");
			Py_DECREF(seq);
			return NULL;
		}

		for (i = 0; i < len; i++) {
			int r;

			r = PyObjC_PythonToObjC(@encode(float), 
				PySequence_Fast_GET_ITEM(seq, i),
				matrix + i);
			if (r == -1) {
				Py_DECREF(seq);
				return NULL;
			}
		}
		Py_DECREF(seq);
	}

	PyObjC_DURING
		if (PyObjCIMP_Check(method)) {
			font = ((id(*)(id, SEL, id, float*))
			 	PyObjCIMP_GetIMP(method))(
					PyObjCObject_GetObject(self),
					PyObjCIMP_GetSelector(method),
					typeface, matrix);
		} else {
			PyObjC_InitSuperCls(&super,
				PyObjCSelector_GetClass(method),
				PyObjCClass_GetClass(self));
			font = objc_msgSendSuper(&super,
				PyObjCSelector_GetSelector(method),
				typeface, matrix);
		}
	PyObjC_HANDLER
		PyObjCErr_FromObjC(localException);
		font = nil;
	PyObjC_ENDHANDLER

	if (font == nil && PyErr_Occurred()) {
		return NULL;
	}

	return PyObjC_IdToPython(font);
}

static void
imp_NSFont_fontWithName_matrix_(
	void* cif __attribute__((__unused__)), 
	void* resp, 
	void** args, 
	void* callable)
{
	id self = *(id*)args[0];
	//SEL _meth = *(SEL*)args[1];
	NSString* typeface = *(NSString**)args[2];
	const float* matrix = *(const float**)args[3];
	id* pretval = (id*)resp;

	PyObject* arglist = NULL;
	PyObject* result;
	PyObject* v;
	int i;

	PyGILState_STATE state = PyGILState_Ensure();

	arglist = PyTuple_New(3);
	if (arglist == NULL) goto error;

	v = PyObjC_ObjCToPython(@encode(Class), &self);
	if (v == NULL) goto error;
	PyTuple_SET_ITEM(arglist, 0, v);

	v = PyObjC_IdToPython(typeface);
	if (v == NULL) goto error;
	PyTuple_SET_ITEM(arglist, 1, v);

	if (matrix == NULL) {
		v = Py_None;
		Py_INCREF(Py_None);
		PyTuple_SET_ITEM(arglist, 2, v);
	} else {
		v = PyTuple_New(6);
		if (v == NULL) goto error;
		PyTuple_SET_ITEM(arglist, 2, v);

		for (i = 0; i < 6; i++) {
			PyObject* t = PyFloat_FromDouble(matrix[i]);
			if (t == NULL) goto error;
			PyTuple_SET_ITEM(v, i, t);
		}
	}

	result = PyObject_Call((PyObject*)callable, arglist, NULL);
	Py_DECREF(arglist); arglist = NULL;
	if (result == NULL) goto error;

	*pretval = PyObjC_PythonToId(result);
	Py_DECREF(result);
	if (*pretval == nil && PyErr_Occurred()) goto error;

	PyGILState_Release(state);
	return;

error:
	Py_XDECREF(arglist);
	*pretval = nil;
	PyObjCErr_ToObjCWithGILState(&state);
}

static PyObject*
call_NSFont_matrix(
	PyObject* method, PyObject* self, PyObject* arguments)
{
	struct objc_super super;
	PyObject* pyFontMatrix;
	float* matrix;

	if (!PyArg_ParseTuple(arguments, "")) {
		return 0;
	}

	PyObjC_DURING
		if (PyObjCIMP_Check(method)) {
			matrix = ((float*(*)(id, SEL))
			 	PyObjCIMP_GetIMP(method))(
					PyObjCObject_GetObject(self),
					PyObjCIMP_GetSelector(method));
		} else {
			PyObjC_InitSuper(&super,
				PyObjCSelector_GetClass(method),
				PyObjCObject_GetObject(self));

			matrix = (float*)objc_msgSendSuper(&super,
				PyObjCSelector_GetSelector(method));
		}
	PyObjC_HANDLER
		PyObjCErr_FromObjC(localException);
		matrix = NULL;
	PyObjC_ENDHANDLER

	if (matrix == NULL && PyErr_Occurred()) {
		return NULL;
	}

	pyFontMatrix = PyObjC_CArrayToPython(@encode(float), matrix, 6);
	if (pyFontMatrix == NULL) {
		return NULL;
	}

	return pyFontMatrix;
}


static int 
_pyobjc_install_NSFont(void)
{
	if (PyObjC_RegisterMethodMapping(objc_lookUpClass("NSFont"), 
		@selector(positionsForCompositeSequence:numberOfGlyphs:pointArray:),
		call_NSFont_positionsForCompositeSequence_numberOfGlyphs_pointArray_,
		imp_NSFont_positionsForCompositeSequence_numberOfGlyphs_pointArray_) < 0 ) {

		return -1;
	}

	if (PyObjC_RegisterMethodMapping(objc_lookUpClass("NSFont"), 
		@selector(fontWithName:matrix:),
		call_NSFont_fontWithName_matrix_,
		imp_NSFont_fontWithName_matrix_) < 0 ) {

		return -1;
	}

	if (PyObjC_RegisterMethodMapping(objc_lookUpClass("NSFont"), 
		@selector(matrix),
		call_NSFont_matrix,
		PyObjCUnsupportedMethod_IMP) < 0 ) {

		return -1;
	}

	return 0;
}