import Foundation
import Testing
import DeepLinkHandler

@Suite("When I have an array of query items") struct URLQueryItemParameterTests {
  @Test func retrieveTheIdAsParameter() throws {
    let items: [URLQueryItem] = [URLQueryItem(name: "id", value: "_id_value_")]

    let identifier = try #require(items[.id])

    #expect(identifier == "_id_value_")
  }

  @Test func retrieveTheIdAsString() throws {
    let items: [URLQueryItem] = [URLQueryItem(name: "id", value: "_id_value_")]

    let identifier = try #require(items["id"])

    #expect(identifier == "_id_value_")
  }
}
