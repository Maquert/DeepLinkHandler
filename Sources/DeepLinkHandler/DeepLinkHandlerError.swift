import Foundation

public enum DeepLinkHandlerError: LocalizedError {
  case actionAlreadyRegistered
  case actionNotRegistered
  case invalidParameter
  case notSupported

  var errorDescription: String {
    switch self {
    case .actionAlreadyRegistered: return "This action is already registered. This is a safe measure Unregister it first."
    case .actionNotRegistered: return "This action was not previously registered"
    case .invalidParameter: return "Invalid parameter"
    case .notSupported: return "This method is not supported"
    }
  }
}

extension DeepLinkHandlerError: CaseIterable {}
