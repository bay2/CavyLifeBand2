#!/bin/sh

echo "build"

xctool -workspace $APP_NAME.xcworkspace -scheme $APP_NAME -sdk iphoneos -configuration Release OBJROOT=$PWD/build   SYMROOT=$PWD/build CODE_SIGN_IDENTITY="$DEVELOPER_NAME" ONLY_ACTIVE_ARCH=NO
