import Foundation

/// Describes an error in the ``DeepLinkHandler`` error domain when a URL is registered.
public enum DeepLinkRegisterError: Error {
  case pathAlreadyRegistered(path: String)
}

extension DeepLinkRegisterError: Equatable {}

extension DeepLinkRegisterError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .pathAlreadyRegistered(let path):
      return "Path '\(path)' is already registered. This is a safety measure Unregister it first."
    }
  }
}
