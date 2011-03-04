#! /bin/bash --
#
# us.pts_magyar.sh: Script to install the pts_magyar layout for X11 (X.Org)
# by pts@fazekas.hu at Sat Jun 12 22:37:08 CEST 2010
#
# This script hash been tested and found working on Ubuntu Karmic and Ubuntu
# Lucid.

if test "$EUID" = 0; then SUDO=; else SUDO=sudo; fi

exec $SUDO bash /dev/stdin "$@" <<'ENDSUDO'

set -ex

perl -pi -0777 -e \
    's@^// BEGIN dvorhack\s.*?\n// END dvorhack[ \t]*\n@@mgs' \
    /usr/share/X11/xkb/symbols/us
cat >>/usr/share/X11/xkb/symbols/us <<'END'
// BEGIN dvorhack
// END dvorhack
END

# evdev.lst is enough for Ubuntu Lucid.
for F in /usr/share/X11/xkb/rules/{base,evdev,xorg,xfree86}.lst; do
  if test -f "$F"; then
    perl -pi -e '$_="" if /\bdvorhack\b/' "$F"
    # After /^! variant\n/
    perl -pi -0777 -e 's@^(  dvorak-intl[ \t]*us: .*)@$1\n  dvorhack us: Dvorhack@gm' "$F"
  fi
done

# evdev.xml is enough for Ubuntu Lucid
for F in /usr/share/X11/xkb/rules/{base,evdev,xorg,xfree86}.xml; do
  if test -f "$F"; then
    perl -pi -0777 -e 's@^[ \t]*<variant>\s*<configItem>\s*<name>dvorhack</name>.*?</variant>[ \t]*@@gsm' "$F"
    perl -pi -0777 -e 's@^([ \t]*<variant>\s*<configItem>\s*<name>dvorak-intl</name>.*?</variant>)[ \t]*\n@$1\n        <variant>\n          <configItem>\n            <name>dvorhack</name>\n            <description>Dvorhack</description>\n          </configItem>\n        </variant>\n@gsm' "$F"
  fi
done
ENDSUDO
