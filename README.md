[![CI](https://github.com/Maquert/DeepLinkHandler/actions/workflows/ci.yml/badge.svg)](https://github.com/Maquert/DeepLinkHandler/actions/workflows/ci.yml)
![Swift 6.0](https://img.shields.io/badge/swift_6.0-orange?style=flat&logo=swift&logoColor=white)
![Platforms: iOS, macOS, tvOS, visionOS, watchOS](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20tvOS%20|%20visionOS%20|%20watchOS%20-blue.svg?style=flat&logo=apple)
[![Swift Package Manager: compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat&logo=apple)](https://swift.org/package-manager/)
[![Licence](https://img.shields.io/badge/licence-MIT-green.svg)](https://github.com/Maquert/DeepLinkHandler/blob/main/LICENSE)
[![Last commit](https://img.shields.io/github/last-commit/Maquert/DeepLinkHandler.svg)](https://github.com/Maquert/DeepLinkHandler/commits/main)

# DeepLinkHandler

![DeepLinkHandler](https://github.com/maquert/DeepLinkHandler/blob/main/DeepLinkHandler_icon.png)


## Summary

DeepLinkHandler is a lightweight and opinionated package designed to streamline how a Swift application organises 
and manages deep links.


### What is a 'deep link'?

A deep link is a **direct route** to a specific screen or action within your application, enabling users to **access content without navigating through multiple screens**.

> [!Note] 
> This package distinguishes ‘deep links’ from ‘universal links’ in the context of mobile app URL 
> handling. While universal links mirror web counterparts and may change, deep links are treated 
> solely as internal links managed by mobile developers, independent of any web structure. 

> This package is not intended for universal link handling although universal links can be transformed into internal links.
> More about this [in the Usage section](#expected-uri-shape-for-deep-links).


## Installation
1. In Xcode, from the **File** menu, select **Add Package Dependencies...**
2. Enter "`https://github.com/Maquert/DeepLinkHandler`" into the text field. 
3. Add **DeepLinkHandler** to your app target.

> [!Note] 
> If you want to use DeepLinkHandler in a mixed combination of targets and SPM packages (or from other targets),
> you need to create a shared framework that includes DeepLinkHandler and then import it from all of your targets
> (as opposed to adding this package in multiple places).


## Usage

To utilize DeepLinkHandler, follow these two steps: registration and handling.

First, create an instance of `DeepLinkHandler`. It is recommended to integrate this library using
your preferred dependency management system, ensuring a single instance is accessible throughout
your codebase.

> [!Note] 
> DeepLinkHandler is a reference type.

You can initialize it as follows:

```swift
let deeplinkHandler = DeepLinkHandler() 
// or use its thread-safe static initialiser
let deeplinkHandler = DeepLinkHandler.main
```

To register a path with its corresponding action:
```swift
do {
  // Expects URLs like `/featureA/detail?id=123`
  try deeplinkHandler.register("/featureA/detail") { queryItems in
    guard let id = queryItems[.id] else { throw DeepLinkHandleError.missingQueryItem(name: Parameter.id.rawValue) }
    navigateToFeatureADetail(id: id)
  } catch let error as DeepLinkRegisterError {
    // Maybe you already registered this path?
  } catch let someError {
    // Fallback for generic errors
  }
}
```

When your app receives a URL, preprocess or transform it (more in the next section), then handle it 
using the DeepLinkHandler instance:

```swift
  // `https://domain.io/featureA/detail?id=123` or simply `/featureA/detail?id=123`
  let url = ... 
  do {
   try deeplinkHandler.handle(url)
  } catch let error as DeepLinkHandleError {
    switch error {
    case .pathNotRegistered(_):
      // Handle and log error
    case .missingQueryItem(_):
      // Handle and log error
    }
  } catch let someError {
    // Fallback for generic errors
  }
```

The closure registered earlier will execute, causing a side effect (typically navigation) beyond 
the closure’s scope.


## The philosophy behind DeepLinkHandler

### Is this for you?

This package seeks three core benefits:
- **Simplicity**: The implementation is straightforward enough that you could copy its content directly
 into your codebase. It’s designed to be intuitive and doesn’t require extensive configuration.
- **Feature Autonomy**: Actions can be registered from any location in your code. This is especially 
useful for applications with multiple packages or frameworks maintained by different teams. Each 
feature manages its own paths and can register them when relevant.
- **Safety**: All operations with DeepLinkHandler occur on the main thread. Swift’s main actor ensures 
that navigation closures are never executed from background threads, preventing potential issues in 
your app.

### Expected URI shape for deep links

The distinction between external and internal links lies in their **management**. External links are
 defined outside of app code, while internal links are compiled into the application. 
 DeepLinkHandler expects **external links to be transformed** into a specific **internal structure**:
  /<path_to_resource>?<param1=value1>&<param2=value2>

| External link | Internal link |
|:- |:- |
| `/domainA/<id>` | `/featureA/detail?id=<id>` |
| `/domainA/items/<id>` | `/featureA/detail?id=<id>` |
| `/domainA/items/some-seo-title-<id>` | `/featureA/detail?id=<id>` |

This illustrates that while external URLs may change or increase for various reasons (business needs, 
backend changes, SEO), internal URLs remain stable, maintained by app developers.

That is why **`DeepLinkHandler` prefers that the path points to the route of the feature** and the 
**query parameters to the dynamic values** that the feature needs to satisfy a particular request 
(identifiers, configuration, marketing campaigns, etc).

### About preprocessing URLs

**Preprocessing a URL involves transforming a specific shape into one that aligns with your** 
**app’s structure**. The complexity of this transformation increases with the complexity of the 
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

This is the reason why you want the shorter, more concise and more organised deep links for your app.


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
