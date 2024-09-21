import Foundation

extension Array where Element == URLQueryItem {
  public subscript(_ key: String) -> Element? {
    first(where: { $0.name == key })
  }
}
