#!/bin/sh

#remove unnecessary files and folders
if [  -d "/CONTROL" ]; then
rm -r  /CONTROL >/dev/null 2>&1
fi
rm -rf /control >/dev/null 2>&1
rm -rf /postinst >/dev/null 2>&1
rm -rf /preinst >/dev/null 2>&1
rm -rf /prerm >/dev/null 2>&1
rm -rf /postrm >/dev/null 2>&1
rm -rf /tmp/*.ipk >/dev/null 2>&1
rm -rf /tmp/*.tar.gz >/dev/null 2>&1

#config
plugin=DreamosatXstream
version=2.30
url=https://github.com/Musa0124-cmyk/-DREAMOSATXSTREAM-IPTV-PLUGIN/raw/main/py3.13/DreamosatXstream.tar.gz
package=/var/volatile/tmp/$plugin-$version.tar.gz

#download & install
echo "> $plugin-$version paketi indiriliyor lütfen bekleyin ..."
sleep 3s

wget --show-progress -qO $package --no-check-certificate $url
tar -xzf $package -C /
extract=$?
rm -rf $package >/dev/null 2>&1

echo ''
if [ $extract -eq 0 ]; then
echo "> $plugin-$version paketi başarıyla kuruldu"
echo "> dostlar By Musa0124"
sleep 3s
fi