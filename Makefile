PLATFORM_IOS = iOS Simulator,name=iPhone 16
PLATFORM_MACOS = macOS

test-all: test build

test-swift:
	swift test -v

build-ios:
	xcodebuild build \
		-workspace DeepLinkHandler.xcworkspace \
		-scheme DynamicFramework \
		-destination platform="$(PLATFORM_IOS)"

build-macos:
	xcodebuild build \
		-workspace DeepLinkHandler.xcworkspace \
		-scheme DynamicFramework \
		-destination platform="$(PLATFORM_MACOS)"

build-examples:
	xcodebuild build \
		-workspace DeepLinkHandler.xcworkspace \
		-scheme Examples \
		-destination platform="$(PLATFORM_IOS)"

format:
	swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		./Package.swift ./Sources ./Tests

.PHONY: format test