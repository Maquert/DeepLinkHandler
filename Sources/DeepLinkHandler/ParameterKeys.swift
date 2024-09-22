/// Predefined Parameter values.
///
/// You can use `Parameter` to harcode values at compile time to avoid mistakes.
///
/// ```
/// let queryItems: [URLQueryItem] = ...
/// let value: String? = queryItems[.id]
/// ```
extension Parameter {
  /// Parameter "id"
  public static let id: Parameter = Self(rawValue: "id")
}
