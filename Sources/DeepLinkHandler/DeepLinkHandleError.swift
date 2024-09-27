import Foundation

/// Describes an error in the ``DeepLinkHandler`` error domain when a URL is handled.
public enum DeepLinkHandleError: Error {
  case missingQueryItem(name: String)
  case pathNotRegistered(path: String)
}

extension DeepLinkHandleError: Equatable {}

extension DeepLinkHandleError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .missingQueryItem(let name):
      return "Missing query item: \(name)."
    case .pathNotRegistered(let path):
      return "This path was not previously registered: '\(path)'."
    }
  }
}
