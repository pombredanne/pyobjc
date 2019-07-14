from PyObjCTools.TestSupport import *
from AppKit import *

class TestNSTextCheckingClientHelper (NSObject):
    def annotatedSubstringForProposedRange_actualRange_(self, a, b): return 1
    def setAnnotations_range_(self, a, b): pass
    def addAnnotations_range_(self, a, b): pass
    def removeAnnotations_range_(self, a, b): pass
    def replaceCharactersInRange_withAnnotatedString_(self, a, b): pass
    def selectAndShowRange_(self, a): pass
    def viewForRange_firstRect_actualRange_(self, a, b, c): return 1

    def autocorrectionType(self): return 1
    def spellCheckingType(self): return 1
    def grammarCheckingType(self): return 1
    def smartQuotesType(self): return 1
    def smartDashesType(self): return 1
    def smartInsertDeleteType(self): return 1
    def textReplacementType(self): return 1
    def dataDetectionType(self): return 1
    def linkDetectionType(self): return 1
    def textCompletionType(self): return 1

    def setAutocorrectionType_(self, a): pass
    def setSpellCheckingType_(self, a): pass
    def setGrammarCheckingType_(self, a): pass
    def setSmartQuotesType_(self, a): pass
    def setSmartDashesType_(self, a): pass
    def setSmartInsertDeleteType_(self, a): pass
    def setTextReplacementType_(self, a): pass
    def setDataDetectionType_(self, a): pass
    def setLinkDetectionType_(self, a): pass
    def setTextCompletionType_(self, a): pass

class TestNSTextCheckingClient (TestCase):
    def test_constants(self):
        self.assertEqual(NSTextInputTraitTypeDefault, 0)
        self.assertEqual(NSTextInputTraitTypeNo, 1)
        self.assertEqual(NSTextInputTraitTypeYes, 2)

    def test_methods(self):
        self.assertResultHasType(TestNSTextCheckingClientHelper.autocorrectionType, objc._C_NSInteger)
        self.assertResultHasType(TestNSTextCheckingClientHelper.spellCheckingType, objc._C_NSInteger)
        self.assertResultHasType(TestNSTextCheckingClientHelper.grammarCheckingType, objc._C_NSInteger)
        self.assertResultHasType(TestNSTextCheckingClientHelper.smartQuotesType, objc._C_NSInteger)
        self.assertResultHasType(TestNSTextCheckingClientHelper.smartDashesType, objc._C_NSInteger)
        self.assertResultHasType(TestNSTextCheckingClientHelper.smartInsertDeleteType, objc._C_NSInteger)
        self.assertResultHasType(TestNSTextCheckingClientHelper.textReplacementType, objc._C_NSInteger)
        self.assertResultHasType(TestNSTextCheckingClientHelper.dataDetectionType, objc._C_NSInteger)
        self.assertResultHasType(TestNSTextCheckingClientHelper.linkDetectionType, objc._C_NSInteger)
        self.assertResultHasType(TestNSTextCheckingClientHelper.textCompletionType, objc._C_NSInteger)

        self.assertArgHasType(TestNSTextCheckingClientHelper.autocorrectionType_, 0, objc._C_NSInteger)
        self.assertArgHasType(TestNSTextCheckingClientHelper.spellCheckingType_, 0, objc._C_NSInteger)
        self.assertArgHasType(TestNSTextCheckingClientHelper.grammarCheckingType_, 0, objc._C_NSInteger)
        self.assertArgHasType(TestNSTextCheckingClientHelper.smartQuotesType_, 0, objc._C_NSInteger)
        self.assertArgHasType(TestNSTextCheckingClientHelper.smartDashesType_, 0, objc._C_NSInteger)
        self.assertArgHasType(TestNSTextCheckingClientHelper.smartInsertDeleteType_, 0, objc._C_NSInteger)
        self.assertArgHasType(TestNSTextCheckingClientHelper.textReplacementType_, 0, objc._C_NSInteger)
        self.assertArgHasType(TestNSTextCheckingClientHelper.dataDetectionType_, 0, objc._C_NSInteger)
        self.assertArgHasType(TestNSTextCheckingClientHelper.linkDetectionType_, 0, objc._C_NSInteger)
        self.assertArgHasType(TestNSTextCheckingClientHelper.textCompletionType_, 0, objc._C_NSInteger)

        self.assertArgHasType(TestNSTextCheckingClientHelper.annotatedSubstringForProposedRange_actualRange_, 0, NSRange.__typestr__)
        self.assertArgHasType(TestNSTextCheckingClientHelper.annotatedSubstringForProposedRange_actualRange_, 1, b'o^' + NSRange.__typestr__)
        self.assertArgHasType(TestNSTextCheckingClientHelper.setAnnotations_range_, 1, NSRange.__typestr__)
        self.assertArgHasType(TestNSTextCheckingClientHelper.addAnnotations_range_, 1, NSRange.__typestr__)
        self.assertArgHasType(TestNSTextCheckingClientHelper.removeAnnotations_range_, 1, NSRange.__typestr__)
        self.assertArgHasType(TestNSTextCheckingClientHelper.replaceCharactersInRange_withAnnotatedString_, 0, NSRange.__typestr__)
        self.assertArgHasType(TestNSTextCheckingClientHelper.selectAndShowRange_, 0, NSRange.__typestr__)
        self.assertArgHasType(TestNSTextCheckingClientHelper.viewForRange_firstRect_actualRange_, 0, NSRange.__typestr__)
        self.assertArgHasType(TestNSTextCheckingClientHelper.viewForRange_firstRect_actualRange_, 1, b'o^'+NSRect.__typestr__)
        self.assertArgHasType(TestNSTextCheckingClientHelper.viewForRange_firstRect_actualRange_, 2, b'o^'+NSRange.__typestr__)

    @min_sdk_level('10.15')
    def test_protocols(self):
        objc.protocolNamed('NSTextInputTraits')
        objc.protocolNamed('NSTextCheckingClient')



if __name__ == "__main__":
    main()