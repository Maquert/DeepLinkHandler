# DeepLinkHandler - Examples

This is a demo project to play with the library using a real SwiftUI application.


## How to use
Install an app like [Control Room](https://github.com/twostraws/ControlRoom) or [RocketSIM](https://www.rocketsim.app/) to simulate deep links to iOS and check the results in the Example app.

Alternativately, you can also paste deep links into Safari.

The example deep links must be like this:

`deeplinkhandler://app/navigate?id=123&action=abc`.

Where:

- `deeplinkhandler://` is the scheme necessary to trigger the app.
- `app` is the host. Unused because the app captures the scheme.
- `/<path>` is the section of the URL that is used to register deep link actions.
- The `?param1=A&param2=B` items are the dynamic values that you can capture in the closure action to append dynamic values like resource identifiers.

## Run

Open `DeepLinkHandler.xcworkspace`, compile and run the app. Once installed in the simulator, you can open deep links.

The results will appear on screen.