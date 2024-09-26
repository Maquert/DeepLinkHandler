// All these tests use the public API. No internal or private code is used here.
import DeepLinkHandler
import Foundation
import Testing

@Suite("When a DeepLinkHandler is created") struct DeepLinkHandlerInitests {
  @MainActor @Test func initialisesWith0Elements() {
    let sut = DeepLinkHandler()

    #expect(sut.paths.keys.count == 0)
  }

  @MainActor @Test func unlessIProvideMyOwn() {
    let sut = DeepLinkHandler(paths: ["/foo": { _ in }])

    #expect(sut.paths.keys.count == 1)
  }

  // Swift 6 concurrency check
  @MainActor @Test func withTheIsolatedContextInitialiser() {
    let sut = DeepLinkHandler.main

    #expect(sut.paths.keys.count == 0)
  }
}

@Suite("When a DeepLinkHandler registers a path") struct DeepLinkHandlerRegisterTests {

  @MainActor @Test func aNewPathIsAdded() {
    let sut = DeepLinkHandler()

    try! sut.register("/foo/bar", action: { _ in })

    #expect(sut.paths.keys.count == 1)
  }

  @MainActor @Test func anExistingPathIsNOTAdded() {
    let sut = DeepLinkHandler(paths: ["/foo/bar": { _ in }])

    #expect(throws: DeepLinkError(.pathAlreadyRegistered)) {
      try sut.register("/foo/bar", action: { _ in })
    }

    #expect(sut.paths.keys.count == 1)
  }

  @MainActor @Test func anExistingPathCanBeOverwritten() throws {
    var testedValue = false
    let firstClosure: ([URLQueryItem]?) -> Void = { _ in testedValue = false }
    let secondClosure: ([URLQueryItem]?) -> Void = { _ in testedValue = true }
    let sut = DeepLinkHandler(paths: ["/foo/bar": firstClosure])

    sut.unsafeRegister("/foo/bar", action: secondClosure)
    try! sut.handle("/foo/bar")

    #expect(sut.paths.keys.count == 1)
    #expect(testedValue == true)
  }

  @MainActor @Test func thePathCanBeUnregistered() {
    let sut = DeepLinkHandler()

    try! sut.register("/foo/bar", action: { _ in })
    sut.unregister("/foo/bar")

    #expect(sut.paths.keys.count == 0)
  }
}

@Suite("When a DeepLinkHandler contains one path") struct DeepLinkHandlerTests {

  @MainActor @Test func itsActionCanBeHandled() {
    var handledFooBar = false
    let sut = DeepLinkHandler(paths: ["/foo/bar": { _ in handledFooBar = true }])

    try! sut.handle("/foo/bar")

    #expect(handledFooBar == true)
  }

  @MainActor @Test func itsActionCanBeHandledUsingAFullURL() throws {
    var handledFooBar = false
    let sut = DeepLinkHandler(paths: ["/foo/bar": { _ in handledFooBar = true }])
    let url = "http://somehost.com/foo/bar"

    try #require(try sut.handle(url))

    #expect(handledFooBar == true)
  }

  @MainActor @Test func itsActionCanBeHandledUsingARealURLObject() throws {
    var handledFooBar = false
    let sut = DeepLinkHandler(paths: ["/foo/bar": { _ in handledFooBar = true }])
    let url = try #require(URL(string: "http://somehost.com/foo/bar"))

    try #require(try sut.handle(url))

    #expect(handledFooBar == true)
  }

  @MainActor @Test func itsActionParametersCanBeHandled() throws {
    var handledFooBarParams: [URLQueryItem]?
    let sut = DeepLinkHandler()

    try #require(
      sut.register("/foo/bar") {
        params in handledFooBarParams = params
      })
    try #require(try sut.handle("/foo/bar?param1=123&param2=ABC"))

    #expect(
      handledFooBarParams == [
        URLQueryItem(name: "param1", value: "123"),
        URLQueryItem(name: "param2", value: "ABC"),
      ])
  }

  @MainActor @Test func throwsAnErrorIfTriesToHandleANotRegisteredPath() {
    let sut = DeepLinkHandler(paths: ["/foo/bar": { _ in }])

    #expect(throws: DeepLinkError(.pathNotRegistered)) { @MainActor in
      try sut.handle("/baz/qux")
    }
  }

  @MainActor @Test func throwsAnErrorIfThePathIsNotAURL() {
    let sut = DeepLinkHandler()
    let badURL = "#@^"  // The initial # character prevents URLComponents from creating a path

    #expect(throws: URLError(.badURL)) {
      try sut.handle(badURL)
    }
  }
}
