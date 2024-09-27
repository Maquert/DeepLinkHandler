import DeepLinkHandler
import SwiftUI

@main
struct ExamplesApp: App {
  let deepLinkHandler = DeepLinkHandler.main

  var body: some Scene {
    WindowGroup {
      ContentView()
        .onOpenURL { deepLink in
          print("Retrieved deep link: \(deepLink)")

          do {
            try deepLinkHandler.handle(deepLink)
          } catch let error as DeepLinkHandleError {
            switch error {
            case .pathNotRegistered(_):
              assertionFailure(error.localizedDescription)
            case .missingQueryItem(_):
              assertionFailure(error.localizedDescription)
            }
          } catch let someError {
            assertionFailure(someError.localizedDescription)
          }
        }
    }
  }
}
