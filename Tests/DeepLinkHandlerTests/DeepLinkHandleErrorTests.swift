import Testing

@testable import DeepLinkHandler

@Suite("DeepLinkHandleError tests") struct DeepLinkHandleErrorTests {
  @Test(arguments: [
    DeepLinkHandleError.missingQueryItem(name: "foo"),
    DeepLinkHandleError.pathNotRegistered(path: "/foo/bar"),
  ])
  func deepLinkErrorsDescriptions(_ error: DeepLinkHandleError) {
    switch error {
    case .missingQueryItem:
      #expect(error.errorDescription == "Missing query item: foo.")
    case .pathNotRegistered:
      #expect(error.errorDescription == "This path was not previously registered: '/foo/bar'.")
    }
  }
}
