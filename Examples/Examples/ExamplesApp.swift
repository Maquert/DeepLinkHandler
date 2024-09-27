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
          } catch let error as DeepLinkError {
            switch error.code {
            case .pathNotRegistered:
              assertionFailure(error.localizedDescription)
            case .missingQueryItem:
              assertionFailure(error.localizedDescription)
            default:
              assertionFailure("Unknown error")
            }
          } catch let someError {
            assertionFailure(someError.localizedDescription)
          }
        }
    }
  }
}
