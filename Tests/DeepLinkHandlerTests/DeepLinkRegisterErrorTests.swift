import DeepLinkHandler
import Testing

@testable import DeepLinkHandler

@Suite("DeepLinkRegisterError tests") struct DeepLinkRegisterErrorTests {
  @Test(arguments: [
    DeepLinkRegisterError.pathAlreadyRegistered(path: "/foo/bar")
  ])
  func deepLinkErrorsDescriptions(_ error: DeepLinkRegisterError) {
    switch error {
    case .pathAlreadyRegistered:
      #expect(
        error.errorDescription
          == "Path '/foo/bar' is already registered. This is a safety measure Unregister it first.")
    }
  }
}
