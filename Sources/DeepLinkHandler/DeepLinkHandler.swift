import Foundation

/// ``DeepLinkHandler`` registers URI paths and action closures that can be executed at a later time.
///
/// You must register a path (a String with the shape of `/anypath`) and its corresponding action closure
/// before you can later on handle a URL that contains that path.
/// If your app tries to handle a URL for a path that was not previously register DeepLinkHandler will
/// throw an error (`.pathNotRegistered`).
///
/// This class is designed to be used in a **main-thread** context to ensure thread safety.
public class DeepLinkHandler {
  /// Stored paths. Each path contains a closure that is executed when ``handle(_:)-63eew`` receives a matching one.
  @MainActor
  public private(set) var paths: [String: ([URLQueryItem]?) throws -> Void]

  /// Initialises a `DeepLinkHandler` instance. You can provide default paths.
  /// - Parameter paths: default paths.
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
  /// The stored action closure will be executed when a matching path is passed to ``handle(_:)-63eew``.
  ///
  /// ## Note on escaping closures
  /// When you register an action its closure is stored and executed at a later time (`@escaping`).
  /// Use `[weak self]` within the closure to avoid a retain cycle and memory leaks if you are calling it from a class.
  ///
  /// - Parameters:
  ///   - path: the URL path expected to match a corresponding action. Do not consider query items nor the host here.
  ///   - action: the closure that will be executed for a matching URL path. The parameter passes any query items if present in the handled URL.
  @MainActor
  public func register(_ path: String, action: @escaping ([URLQueryItem]?) throws -> Void) throws {
    guard paths.keys.contains(path) == false else {
      throw DeepLinkRegisterError.pathAlreadyRegistered(path: path)
    }

    paths[path] = action
  }

  /// Registers a path and its corresponding action to be executed at a later time.
  ///
  /// Prefer ``register(_:action:)`` to avoid overwritting existing values by accident.
  ///
  /// ## Note on escaping closures
  /// When you register an action its closure is stored and executed at a later time (`@escaping`).
  /// Use `[weak self]` within the closure to avoid a retain cycle and memory leaks if you are calling it from a class.
  ///
  /// - Parameters:
  ///   - path: the URL path expected to match a corresponding action. Do not consider query items nor the host here.
  ///   - action: the closure that will be executed for a matching URL path. The parameter passes any query items if present in the handled URL.
  @MainActor
  public func unsafeRegister(_ path: String, action: @escaping ([URLQueryItem]?) throws -> Void) {
    paths[path] = action
  }

  /// Removes a path from `DeepLinkHandler`.
  ///
  /// - Parameter path: path to be removed from the array of paths.
  @MainActor
  public func unregister(_ path: String) {
    paths.removeValue(forKey: path)
  }

  // MARK: Handle

  /// Handles a URI string and executes the action closure provided when registered if a
  /// matching path is found.
  ///
  /// To handle a URI, only the path is taken into account. Any query items present in the URI
  /// will be passed to the executing closure.
  ///
  /// - Parameter uri: URL string. You may provide a full URL, but only the path and the query items will be considered. Other elements will be ignored.
  @MainActor
  public func handle(_ uri: String) throws {
    guard
      let urlComponents = URLComponents(string: uri),
      urlComponents.path.isEmpty == false
    else {
      throw URLError(.badURL)
    }
    guard let action = paths[urlComponents.path] else {
      throw DeepLinkHandleError.pathNotRegistered(path: urlComponents.path)
    }

    try action(urlComponents.queryItems)
  }

  /// Handles a URL and executes the action closure provided when registered if a
  /// matching path is found.
  ///
  /// To handle a URI, only the path is taken into account. Any query items present in the URI
  /// will be passed to the executing closure.
  ///
  /// - Parameter url: URL string. You may provide a full URL, but only the path and the query items will be considered. Other elements will be ignored.
  @MainActor
  public func handle(_ url: URL) throws {
    try self.handle(url.absoluteString)
  }
}
