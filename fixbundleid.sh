#!/bin/bash

ORIGINAL_PREFIX="br.com.guilhermerambo"
RND=$(curl "https://www.random.org/strings/?num=1&len=10&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new" 2> /dev/null)
NEW_PREFIX="codes.sample.$RND"

echo "Will replace bundle ID prefix $ORIGINAL_PREFIX with $NEW_PREFIX in xcodeproj"

sed -i '' "s/$ORIGINAL_PREFIX/$NEW_PREFIX/g" ./Milkshakr.xcodeproj/project.pbxproj
sed -i '' "s/$ORIGINAL_PREFIX/$NEW_PREFIX/g" ./Clip/Resources/Clip.entitlements