#!/usr/bin/env bash
# tools/store-screenshots.sh [play|iphone|ipad|all] [fr|en]
#
# Generates the store screenshots on an Android emulator by resizing its
# display to each store format and walking the app with
# integration_test/store_screenshots_test.dart. The PNGs come from the Flutter
# surface (no status bar, no navigation buttons) and land in
# store/screenshots/<locale>/<target>/.
#
#   play    1080 x 1920  Google Play phone (9:16; Play refuses ratios above 2:1)
#   iphone  1320 x 2868  App Store, iPhone 6.9" (the required iPhone size)
#   ipad    2064 x 2752  App Store, iPad 13" (required because the app targets iPad)
#
# Requirements: an AVD (default api36), adb, ImageMagick, network on the
# emulator (the walk loads the real feeds). Uploading is done by hand.
set -euo pipefail
cd "$(dirname "$0")/.."

TARGET=${1:-all}
LOCALE=${2:-fr}
AVD=${AVD:-api36}
PORT=${PORT:-5594}
SERIAL=emulator-$PORT
PKG=enpleineconscience.lesmeditations
OUT=store/screenshots/$LOCALE

declare -A SIZE=([play]=1080x1920 [iphone]=1320x2868 [ipad]=2064x2752)
declare -A DPI=([play]=420 [iphone]=460 [ipad]=264)
declare -A LOCALE_TAG=([fr]=fr-FR [en]=en-US)

case "$TARGET" in
  all) targets=(play iphone ipad) ;;
  play|iphone|ipad) targets=("$TARGET") ;;
  *) echo "usage: $0 [play|iphone|ipad|all] [fr|en]" >&2; exit 2 ;;
esac

adb_() { adb -s "$SERIAL" "$@"; }

if ! adb devices | grep -q "^$SERIAL\s*device"; then
  echo "== booting $AVD on port $PORT"
  nohup "$HOME/Android/Sdk/emulator/emulator" -avd "$AVD" -port "$PORT" -memory 2048 -cores 2 \
    -no-window -no-snapshot-save -no-boot-anim -no-audio >/tmp/store-screenshots-emu.log 2>&1 &
  timeout 300 bash -c "until [ \"\$(adb -s $SERIAL shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')\" = 1 ]; do sleep 5; done"
  sleep 5
fi

# The app follows the device locale. Ask for a per-app locale only when the
# device speaks something else (it only sticks once the app is installed).
device_locale=$(adb_ shell getprop persist.sys.locale | tr -d '\r')
if [ "${device_locale%%-*}" != "$LOCALE" ] && adb_ shell pm list packages | grep -q "^package:$PKG$"; then
  adb_ shell cmd locale set-app-locales "$PKG" --user 0 --locale-tags "${LOCALE_TAG[$LOCALE]}" >/dev/null 2>&1 \
    || echo "!! could not set the app locale to $LOCALE; screenshots will be in $device_locale" >&2
fi

restore() {
  adb_ shell wm size reset >/dev/null 2>&1 || true
  adb_ shell wm density reset >/dev/null 2>&1 || true
}
trap restore EXIT

for t in "${targets[@]}"; do
  size=${SIZE[$t]}; dpi=${DPI[$t]}
  echo "== $t: $size @ ${dpi}dpi -> $OUT/$t"
  rm -rf "$OUT/$t"; mkdir -p "$OUT/$t"
  adb_ shell wm size "$size"
  adb_ shell wm density "$dpi"
  sleep 4
  adb_ shell am force-stop "$PKG" || true

  SHOT_DIR="$OUT/$t" flutter drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/store_screenshots_test.dart \
    -d "$SERIAL" --no-pub 2>&1 | grep -E "screenshot:|All tests passed|Some tests failed|Error|error:" || true

  # Stores want 24-bit PNG without alpha, at exactly the requested size.
  w=${size%x*}; h=${size#*x}
  for f in "$OUT/$t"/*.png; do
    [ -e "$f" ] || { echo "!! no screenshots for $t" >&2; continue; }
    convert "$f" -background "#FBF5F2" -alpha remove -alpha off -define png:color-type=2 "$f"
    got=$(identify -format '%wx%h' "$f")
    if [ "$got" != "$size" ]; then echo "!! $f is $got, expected $size" >&2; fi
  done
  ls "$OUT/$t"
done

adb_ shell cmd locale set-app-locales "$PKG" --user 0 --locale-tags "" >/dev/null 2>&1 || true
echo "== done: $OUT"
