import DeepLinkHandler
import SwiftUI

struct ContentView: View {
  let deepLinkHandler = DeepLinkHandler.main

  @State private var identifier: String?
  @State private var action: String?
  @State private var errorMessage: String?

  var body: some View {
    VStack(spacing: 16) {
      Text("Deep Link Handler")
        .font(.largeTitle)

      Text(
        """
        Open a deep link like 
        'deeplinkhandler://app/navigate?id=123&action=abc'
        to see its contents appear here.
        """
      )
      .font(.footnote)
      .foregroundStyle(.gray)

      Spacer()

      Image(systemName: "link")
        .imageScale(.large)
        .font(.largeTitle)
        .foregroundStyle(.tint)

      VStack(alignment: .leading) {
        if let identifier {
          Text("Action identifier: \(identifier)")
        }
        if let action {
          Text("Opened action: \(action)")
        }
      }

      Spacer()

      if let errorMessage {
        HStack {
          Image(systemName: "exclamationmark.warninglight")
            .imageScale(.large)
          Text("Error: \(errorMessage)")
            .foregroundStyle(.red)
        }
      }

    }
    .padding()
    .onAppear {
      registerPaths()
    }
  }

  func registerPaths() {
    do {
      try deepLinkHandler.register("/navigate") { parameters in
        guard let id = parameters?[.id] else {
          throw DeepLinkHandleError.missingQueryItem(name: Parameter.id.rawValue)
        }
        guard let action = parameters?[.action] else {
          throw DeepLinkHandleError.missingQueryItem(name: Parameter.action.rawValue)
        }
        self.action = action
        self.identifier = id
      }
    } catch let error as DeepLinkHandleError {
      errorMessage = error.localizedDescription
    } catch let someError {
      errorMessage = someError.localizedDescription
    }
  }
}

#Preview {
  ContentView()
}

extension Parameter {
  static let action = Parameter(rawValue: "action")
}
