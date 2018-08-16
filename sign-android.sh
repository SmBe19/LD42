#!/bin/sh
rm export/android/ld42-aligned.apk
rm export/android/ld42-signed.apk
~/Android/Sdk/build-tools/27.0.3/zipalign -v -p 4 export/android/ld42-unsigned.apk export/android/ld42-aligned.apk
~/Android/Sdk/build-tools/27.0.3/apksigner sign --ks ~/.android/20180816-ld.keystore --out export/android/ld42-signed.apk export/android/ld42-aligned.apk

