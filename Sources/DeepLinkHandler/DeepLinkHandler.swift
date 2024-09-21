import Foundation

public class DeepLinkHandler {
  @MainActor
  public private(set) var paths: [String: ([URLQueryItem]?) throws -> Void]

  @MainActor
  public init(paths: [String: ([URLQueryItem]?) -> Void] = [:]) {
    self.paths = paths
  }

  // MARK: Register
  
  /// Registers a path and its corresponding action to be executed at a later time.
  ///
  /// To register the same path twice would throw the error `.actionAlreadyRegistered`.
  /// If you want to remove this safety check use ``unsafeRegister(_:action:)``.
  /// To remove a path or to safely overwrite an existent one, use ``unregister(_:)``.
  ///
  /// This method must be called from the main thread to avoid race conditions.
  ///
  /// - Parameters:
  ///   - path: the URL path expected to match a corresponding action. Do not consider query items nor the host here.
  ///   - action: the closure that will be executed for a matching URL path. The parameter passes any query items if present in the handled URL.
  @MainActor
  public func register(_ path: String, action: @escaping ([URLQueryItem]?) throws -> Void) throws {
    guard paths.keys.contains(path) == false else {
      throw DeepLinkHandlerError.actionAlreadyRegistered
    }

    paths[path] = action
  }

  @MainActor
  public func unsafeRegister(_ path: String, action: @escaping ([URLQueryItem]?) throws -> Void) {
    paths[path] = action
  }

  @MainActor
  public func unregister(_ path: String) {
    paths.removeValue(forKey: path)
  }

  // MARK: Handle

  @MainActor
  public func handle(_ uri: String) throws {
    guard
      let urlComponents = URLComponents(string: uri),
      urlComponents.path.isEmpty == false
    else {
      throw URLError(.badURL)
    }
    guard let action = paths[urlComponents.path] else {
      throw DeepLinkHandlerError.actionNotRegistered
    }

    try action(urlComponents.queryItems)
  }

  @MainActor
  public func handle(_ url: URL) throws {
    try self.handle(url.absoluteString)
  }
}
