#!/usr/bin/env sh

cd `dirname $0`/../
git clone https://github.com/snide/sphinx_rtd_theme.git sphinx_rtd_theme_latest
rm -rf sphinx_rtd_theme
mv sphinx_rtd_theme_latest/sphinx_rtd_theme .
rm -rf sphinx_rtd_theme_latest
echo "Theme updated"

