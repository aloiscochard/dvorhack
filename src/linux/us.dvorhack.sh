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
partial alphanumeric_keys
xkb_symbols "dvorhack" {

    name[Group1]= "USA - Dvorhack";

    include "us(dvorak)"

    key <AE01> { [	    exclam,	1 		], type[Group1] = "FOUR_LEVEL_ALPHABETIC"  	};
    key <AE02> { [	    bracketleft,	2		], type[Group1] = "FOUR_LEVEL_ALPHABETIC"	};
    key <AE03> { [	    braceleft,	3	], type[Group1] = "FOUR_LEVEL_ALPHABETIC"	};
    key <AE04> { [	    parenleft, 	4,    EuroSign	], type[Group1] = "FOUR_LEVEL_ALPHABETIC"	};
    key <AE05> { [	    ampersand,	5		], type[Group1] = "FOUR_LEVEL_ALPHABETIC"	};
    key <AE06> { [	    numbersign,	6, dead_circumflex, dead_circumflex], type[Group1] = "FOUR_LEVEL_ALPHABETIC"	};
    key <AE07> { [	    parenright,	7	], type[Group1] = "FOUR_LEVEL_ALPHABETIC"	};
    key <AE08> { [	    braceright,	8	], type[Group1] = "FOUR_LEVEL_ALPHABETIC"	};
    key <AE09> { [	    bracketright,	9, dead_grave], type[Group1] = "FOUR_LEVEL_ALPHABETIC"	};
    key <AE10> { [	    asterisk,	0	], type[Group1] = "FOUR_LEVEL_ALPHABETIC"	};
    key <AE11> { [ dollar,	at	]	};
    key <AE12> { [ percent, asciicircum, dead_tilde] };

    // Based on dvorak-intl
    key <AD02> { [     comma,    less,  adiaeresis,       dead_caron ] };
    key <AD03> { [    period, greater, ecircumflex,   periodcentered	] };
    key <AD04> { [         p,       P,  ediaeresis,     dead_cedilla ] };
    key <AD05> { [         y,       Y,  udiaeresis ] };
    key <AD08> { [         c,       C,    ccedilla,    dead_abovedot ] };

    key <AC01> { [         a,       A,      agrave ] };
    key <AC02> { [         o,       O, ocircumflex ] };
    key <AC03> { [         e,       E,      eacute ] };
    key <AC04> { [         u,       U, ucircumflex ] };
    key <AC05> { [         i,       I, icircumflex ] };
    key <AC09> { [	       n,   	N,      nacute ] };
    key <AC10> { [         s,       S,      ssharp ] };

    key <AB01> { [ semicolon,   colon, acircumflex ] };
    key <AB02> { [         q,       Q,  odiaeresis,      dead_ogonek ] };
    key <AB03> { [         j,       J,      egrave, dead_doubleacute ] };
    key <AB04> { [         k,       K,      ugrave ] };
    key <AB05> { [         x,       X,  idiaeresis ] };

    include "level3(ralt_switch)"
};
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
