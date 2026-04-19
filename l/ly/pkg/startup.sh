#!/bin/sh
# Set up TTY2 for ly display manager
# Load font with Unicode box-drawing glyphs (only affects TTY2/ly, not other TTYs)
setfont Lat2-Terminus16 < /dev/tty2 2>/dev/null || true
# Switch TTY2 to UTF-8 mode
printf '\033%%G' > /dev/tty2 2>/dev/null || true
stty -F /dev/tty2 iutf8 2>/dev/null || true
kbd_mode -u 2>/dev/null || true
