#!/bin/sh

xcodebuild clean build test -workspace $APP_NAME.xcworkspace -scheme $APP_NAME"Tests" -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.2' OTHER_SWIFT_FLAGS=" -D UITEST"  | xcpretty
bash <(curl -s https://codecov.io/bash) || echo "Codecov did not collect coverage reports"
