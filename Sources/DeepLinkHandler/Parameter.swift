import Foundation

/// The ``Parameter`` type is a tagged type to replace String when retriving values from [URLQueryItem].
///
/// Extend it as:
/// ```
/// extension Parameter {
///   public static let customKey: Parameter = Self(rawValue: "custom_key")
/// }
/// ```
///
/// Use it when fetching values from an array of `URLQueryItem`.
/// ```
/// let queryItems: [URLQueryItem] = ...
/// guard let value: String? = queryItems[.customKey] else { ... }
/// ```
public struct Parameter: RawRepresentable, Sendable {
  public typealias RawValue = String
  public let rawValue: RawValue

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}

extension Array where Element == URLQueryItem {
  /// Returns the String value in this URLQueryItem array matching a `Parameter` value instead of a raw string.
  public subscript(_ parameter: Parameter) -> String? {
    first(where: { $0.name == parameter.rawValue })?.value
  }
}

extension Array where Element == URLQueryItem {
  /// Returns the String value in this URLQueryItem array matching a `String` value instead of a raw string.
  ///
  /// Use a ``Parameter`` instead of a `String` to provide a more consistent key for your keys.
  public subscript(_ key: String) -> String? {
    first(where: { $0.name == key })?.value
  }
}
