from PyObjCTools.TestSupport import *
import objc

from Foundation import *
import Foundation

class TestNSExceptionInteraction(TestCase):
    def testRepeatedAllocInit(self):
        for i in range(1,1000):
            a = NSException.alloc().initWithName_reason_userInfo_( u"Bogus", u"A bad reason", { u"foo" : u"bar" } )

    def testFormat(self):
        try:
            NSException.raise_format_('ExceptionName', 'Format: %s %d', 'hello', 42)

        except TypeError:
            raise

        except objc.error, e:
            self.assertEquals(e._pyobjc_info_['name'], 'ExceptionName')
            self.assertEquals(e._pyobjc_info_['reason'], 'Format: hello 42')

        self.assertRaises(TypeError, NSException.raise_format_arguments_, "FooError", "foo", [])


class TestNSException (TestCase):
    def testConstants(self):
        self.failUnless( isinstance(NSGenericException, unicode) )
        self.failUnless( isinstance(NSRangeException, unicode) )
        self.failUnless( isinstance(NSInvalidArgumentException, unicode) )
        self.failUnless( isinstance(NSInternalInconsistencyException, unicode) )
        self.failUnless( isinstance(NSMallocException, unicode) )
        self.failUnless( isinstance(NSObjectInaccessibleException, unicode) )
        self.failUnless( isinstance(NSObjectNotAvailableException, unicode) )
        self.failUnless( isinstance(NSDestinationInvalidException, unicode) )
        self.failUnless( isinstance(NSPortTimeoutException, unicode) )
        self.failUnless( isinstance(NSInvalidSendPortException, unicode) )
        self.failUnless( isinstance(NSInvalidReceivePortException, unicode) )
        self.failUnless( isinstance(NSPortSendException, unicode) )
        self.failUnless( isinstance(NSPortReceiveException, unicode) )
        self.failUnless( isinstance(NSOldStyleException, unicode) )

    def testUncaughtExceptionHandler(self):
        self.fail("NSGetUncaughtExceptionHandler")
        self.fail("NSSetUncaughtExceptionHandler")

    def testNoAssert(self):
        self.failIf(hasattr(Foundation, 'NSAssert5'))
        self.failIf(hasattr(Foundation, 'NSAssert4'))
        self.failIf(hasattr(Foundation, 'NSAssert3'))
        self.failIf(hasattr(Foundation, 'NSAssert2'))
        self.failIf(hasattr(Foundation, 'NSAssert1'))
        self.failIf(hasattr(Foundation, 'NSAssert'))
        self.failIf(hasattr(Foundation, 'NSParameterAssert'))
        self.failIf(hasattr(Foundation, 'NSCAssert5'))
        self.failIf(hasattr(Foundation, 'NSCAssert4'))
        self.failIf(hasattr(Foundation, 'NSCAssert3'))
        self.failIf(hasattr(Foundation, 'NSCAssert2'))
        self.failIf(hasattr(Foundation, 'NSCAssert1'))
        self.failIf(hasattr(Foundation, 'NSCAssert'))
        self.failIf(hasattr(Foundation, 'NSCParameterAssert'))
    
    def testAssertionHandler(self):
        o = NSAssertionHandler.currentHandler()
        m = o.handleFailureInMethod_object_file_lineNumber_description_.__metadata__()
        self.failUnless(m['variadic'])
        self.failUnless(m['arguments'][6]['printf_format'])

        m = o.handleFailureInFunction.__metadata__()
        self.failUnless(m['variadic'])
        self.failUnless(m['arguments'][5]['printf_format'])


if __name__ == '__main__':
    main()
