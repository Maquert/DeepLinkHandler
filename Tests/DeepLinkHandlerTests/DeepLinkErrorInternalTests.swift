import Testing
@testable import DeepLinkHandler

@Suite("Internal DeepLinkErrors") struct DeepLinkErrorInternalTests {
  @Test(arguments: DeepLinkError.allErrors) func deepLinkErrorsDescriptions(_ error: DeepLinkError) {
    #expect(error.errorDescription != "")
  }

  @Test func errorWithNoDescriptionReturnsNil() throws {
    #expect(DeepLinkError(.init(rawValue: "foo")).errorDescription == nil)
  }
}
