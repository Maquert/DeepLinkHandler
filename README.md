[![Swift 6.0](https://img.shields.io/badge/Swift-6.0%20.svg?style=flat&logo=swift)](https://developer.apple.com/swift)
![Platforms: iOS, macOS, tvOS, visionOS, watchOS](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20tvOS%20|%20visionOS%20|%20watchOS%20-blue.svg?style=flat&logo=apple)
[![Swift Package Manager: compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat&logo=apple)](https://swift.org/package-manager/)

# README

## DeepLinkHandler

`DeepLinkHandler` is a lightweight package designed to streamline how a Swift application organizes 
and manages deep links.

### What is a 'deep link'?

A deep link is a **direct route** to a specific screen or action within your application, enabling users to **access content without navigating through multiple screens**.

This package distinguishes ‘deep links’ from ‘universal links’ in the context of mobile app URL 
handling. While universal links mirror web counterparts and may change, deep links are treated 
solely as internal links managed by mobile developers, independent of any web structure. This 
package is not intended for universal link handling.

[More on this in the Usage section](###Expected-URI-shape-for-deep-links).

## DeepLinkError

## Usage

To utilize DeepLinkHandler, follow these two steps: registration and handling.

First, create an instance of `DeepLinkHandler`. It is recommended to integrate this library using
your preferred dependency management system, ensuring a single instance is accessible throughout
your codebase.

📙 Note: DeepLinkHandler is a reference type.

You can initialize it as follows:

```swift
let deeplinkHandler = DeepLinkHandler() 
let deeplinkHandler = DeepLinkHandler.main // or use its static thread-safe instance
```

To register a path with its corresponding action:
```swift
do {
  // Expects URLs like `/featureA/detail?id=123`
  deeplinkHandler.register("/featureA/detail") { queryItems in
    guard let id = queryItems[.id] else { throw DeepLinkError(.missingQueryItem) }
    navigateToFeatureADetail(id: id)
  }
}
```

When your app receives a URL, preprocess or transform it (more in the next section), then handle it 
using the DeepLinkHandler instance:

```swift
  let url = ... // `https://domain.io/featureA/detail?id=123` or simply `/featureA/detail?id=123`
  deeplinkHandler.handle(url)
```

The closure registered earlier will execute, causing a side effect (typically navigation) beyond 
the closure’s scope.


## The philosophy behind DeepLinkHandler

### Is this for you?

This package seeks three core benefits:
- Simplicity: The implementation is straightforward enough that you could copy its content directly
 into your codebase. It’s designed to be intuitive and doesn’t require extensive configuration.
- Feature Autonomy: Actions can be registered from any location in your code. This is especially 
useful for applications with multiple packages or frameworks maintained by different teams. Each 
feature manages its own paths and can register them when relevant.
- Safety: All operations with DeepLinkHandler occur on the main thread. Swift’s main actor ensures 
that navigation closures are never executed from background threads, preventing potential issues in 
your app.

### Expected URI shape for deep links

The distinction between external and internal links lies in their management. External links are
 defined outside of app code, while internal links are compiled into the application. 
 DeepLinkHandler expects external links to be transformed into a specific internal structure:
  /<path_to_resource>?<param1=value1>&<param2=value2>

| External link | Internal link |
|:- |:- |
| `/domainA/<id>` | `/featureA/detail?id=<id>` |
| `/domainA/items/<id>` | `/featureA/detail?id=<id>` |
| `/domainA/items/some-seo-title-<id>` | `/featureA/detail?id=<id>` |

This illustrates that while external URLs may change for various reasons (business needs, 
backend changes, SEO), internal URLs remain stable, maintained by app developers.

That is why **`DeepLinkHandler` prefers that the path points to the route of the feature** and the 
**query parameters to the dynamic values** that the feature needs to satisfy a particular request 
(identifiers, configuration, marketing campaigns, etc).

### About preprocessing URLs

Preprocessing a URL involves transforming a specific shape into one that aligns with your 
app’s structure. The complexity of this transformation increases with the complexity of the 
external URL.

#### Example

For instance, consider receiving the URL: `https://mydomain.io/domainA/items/872346`. You might 
transform it as follows:

```swift
func internalLink(from externalLink: URL) throws -> URL {
  guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { throw ... }
  
  switch urlComponents.path {
  case let path where path.hasPrefix("/domainA/items"):
    guard
        let identifier = path.components(separatedBy: "/").last,
        identifier != ""
    else { throw ... }
    
    var internalURLComponents = URLComponents()
    ...
    internalURLComponents.path = "/featureA/"
    internalURLComponents.queryItems = [URLQueryItem(name: "id", value: identifier)]
    return internalURLComponents.url

  // `https://mydomain.io/a/872346` is also a valid URL, just shorter!
  case let path where path.hasPrefix("/a/"):
      // ... now repeat a similar process
  default:
    throw ...
}
```

A lot of boilerplate, yes. And it's a simplified version that omits things like the external URL 
query parameters, optionals and error handling. The used URL is not even a sophisticated one. 

This is the reason why you want the shorter, more concise and more organized deep links for your app.


### About the `Parameter` type

`Parameter` is a non-mandatory —yet convenient— type in this package. It allows query item names 
to be defined at compile time, reducing the risk of errors and ensuring consistency across features.

#### Example

```swift
let url = URL(string: "https://domain.io/foo/bar?id=123")
...
let queryItems: [URLQueryItem] = ...
let value: String? = queryItems[.id]
```

You can also extend Parameter with custom values:

```swift
extension Parameter {
  public static let custom = Self(rawValue: "custom")
}

// Usage
let value: String? = queryItems[.custom]
```
