import Foundation

/// Describes an error in the ``DeepLinkHandler`` error domain.
public struct DeepLinkError: Error, Equatable {
  public let code: Code

  public struct Code: RawRepresentable, Hashable, Sendable {
    public typealias RawValue = String
    public let rawValue: RawValue

    public init(rawValue: RawValue) {
      self.rawValue = rawValue
    }
  }

  /// ``DeepLinkError`` can be initialised with a predefined ``DeepLinkError.Code``.
  /// - Parameter code: Any ``DeepLinkError.Code``. This type conforms to `RawRepresentable`.
  public init(_ code: Code) {
    self.code = code
  }
}

extension DeepLinkError: LocalizedError {
  public var errorDescription: String? {
    switch self.code {
    case .pathAlreadyRegistered:
      return "This path is already registered. This is a safe measure Unregister it first."
    case .pathNotRegistered: return "This path was not previously registered"
    case .missingQueryItem: return "Invalid parameter"
    default: return nil
    }
  }
}
