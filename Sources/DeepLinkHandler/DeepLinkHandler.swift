import Foundation

public class DeepLinkHandler {
  @MainActor
  public private(set) var paths: [String: ([URLQueryItem]?) throws -> Void]

  @MainActor
  public init(paths: [String: ([URLQueryItem]?) -> Void] = [:]) {
    self.paths = paths
  }

  // MARK: Register

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
}
