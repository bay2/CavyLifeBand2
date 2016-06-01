#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi
if [[ "$TRAVIS_BRANCH" != "master" ]]; then
  echo "Testing on a branch other than master. No deployment will be done."
  exit 0
fi

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"
OUTPUTDIR="$PWD/build/Release-iphoneos"

xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/$APP_NAME.app" -o "$OUTPUTDIR/$APP_NAME.ipa"


if [ ! -z "$PGYER_APP_KEY" ] && [ ! -z "$PGYER_API_KEY" ]; then
  echo ""
  echo "***************************"
  echo "* Uploading to pgyer  *"
  echo "***************************"
  curl http://www.pgyer.com/apiv1/app/upload \
    -F uKey="$PGYER_APP_KEY" \
    -F _api_key="$PGYER_API_KEY" \
    -F file="@$OUTPUTDIR/$APP_NAME.ipa"
fi

zip -r $OUTPUTDIR/$APP_NAME.app.dSYM.zip $OUTPUTDIR/$APP_NAME.app.dSYM/*

if [ ! -z "$BUGHD_PROJECT_ID" ] && [ ! -z "$BUGHD_API_TOKEN" ]; then
  echo ""
  echo "***************************"
  echo "* Uploading to BugHD      *"
  echo "***************************"
  fir p $OUTPUTDIR/$APP_NAME.ipa \
  -m  $OUTPUTDIR/$APP_NAME.app.dSYM.zip \
  -P $BUGHD_PROJECT_ID \
  -T $BUGHD_API_TOKEN
fi
