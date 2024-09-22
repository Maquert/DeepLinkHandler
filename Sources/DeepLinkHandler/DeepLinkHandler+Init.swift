extension DeepLinkHandler {
  /// This is the concurrency-safe designated initialiser for ``DeepLinkHandler``.
  @MainActor public static let live = DeepLinkHandler(paths: [:])
}
