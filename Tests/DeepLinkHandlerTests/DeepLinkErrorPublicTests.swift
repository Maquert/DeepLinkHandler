/// These tests exist to ensure that Deep link errors can be handled by the caller side.
import DeepLinkHandler
import Testing

@Test func initMissingQueryItemErrorForMyApp() throws {
  let missingParameter = DeepLinkError(.missingQueryItem)

  #expect(missingParameter.code.rawValue == "missing_query_item")
}
