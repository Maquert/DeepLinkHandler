extension DeepLinkError.Code {
  /// An expected query item doesn't contain any value.
  public static let missingQueryItem: DeepLinkError.Code = .init(rawValue: "missing_query_item")
  /// An attempt to register a path and a action that were already stored in ``DeepLinkHandler``.
  public static let pathAlreadyRegistered: DeepLinkError.Code = .init(rawValue: "path_already_registered")
  /// An attempt to handle a path that has not been previously registered.
  /// This could happen if your app handles a deep link before its corresponding feature had a chance
  /// to register an action for it.
  public static let pathNotRegistered: DeepLinkError.Code = .init(rawValue: "path_not_registered")
}

// MARK: Internal usage

extension DeepLinkError {
  static let allErrors: [Self] = [
    DeepLinkError.Code.missingQueryItem,
    DeepLinkError.Code.pathAlreadyRegistered,
    DeepLinkError.Code.pathNotRegistered
  ].map(Self.init)
}
