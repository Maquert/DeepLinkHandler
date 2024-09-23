extension DeepLinkHandler {
  /// This is the concurrency-safe designated initialiser for ``DeepLinkHandler``.
  @MainActor public static var main = DeepLinkHandler(paths: [:])
}
