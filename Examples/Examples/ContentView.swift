import DeepLinkHandler
import SwiftUI

struct ContentView: View {
  let deepLinkHandler = DeepLinkHandler.main

  @State private var identifier: String?
  @State private var action: String?
  @State private var errorMessage: String?

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Action identifier: \(identifier ?? "-")")
      Text("Opened action: \(action ?? "None")")
    }
    .padding()
    .onAppear {
      do {
        try deepLinkHandler.register("/navigate") { parameters in
          guard let id = parameters?[.id] else {
            throw DeepLinkError(.missingQueryItem)
          }
          guard let custom = parameters?[.action] else {
            throw DeepLinkError(.missingQueryItem)
          }
          self.action = custom
          self.identifier = id
        }
      } catch let error as DeepLinkError {
        switch error.code {
        case .pathAlreadyRegistered:
          errorMessage = "Path already registered"
        default:
          errorMessage = "Unknown error"
        }
      } catch let someError {
        errorMessage = someError.localizedDescription
      }
    }
  }
}

#Preview {
  ContentView()
}

extension Parameter {
  static let action = Parameter(rawValue: "action")
}
