#!/bin/sh

#Check and install dependencies
python=$(python -c "import platform; print(platform.python_version())")

deps=( "enigma2-plugin-systemplugins-serviceapp" "exteplayer3" "gstplayer" "libc6" "libgcc1" "libstdc++6" "python3-core" "python3-cryptography" "python3-dateutil" "python3-fuzzywuzzy" "python3-levenshtein" "python3-pillow" "python3-rarfile" "python3-requests" "python3-six" "python3-sqlite3" "python3-zoneinfo" "uchardet" )

#check python version
python=$(python -c "import platform; print(platform.python_version())")
sleep 1;
case $python in 
3.13.0|3.13.1|3.13.2|3.13.3|3.13.4|3.13.5|3.13.6|3.13.7|3.13.8|3.13.9)
deps+=( "libpython3.13-1.0" )
;;
*)
echo "> your image python version: $python is not supported"
sleep 3
exit 1
;;
esac

left=">>>>"
right="<<<<"
LINE1="---------------------------------------------------------"
LINE2="-------------------------------------------------------------------------------------"

if [ -f /etc/opkg/opkg.conf ]; then
  STATUS='/var/lib/opkg/status'
  OSTYPE='Opensource'
  OPKG='opkg update'
  OPKGINSTAL='opkg install'
elif [ -f /etc/apt/apt.conf ]; then
  STATUS='/var/lib/dpkg/status'
  OSTYPE='DreamOS'
  OPKG='apt-get update'
  OPKGINSTAL='apt-get install -y'
fi

install() {
  if ! grep -qs "Package: $1" "$STATUS"; then
    $OPKG >/dev/null 2>&1
    rm -rf /run/opkg.lock
    echo -e "> Need to install ${left} $1 ${right} please wait..."
    echo "$LINE2"
    sleep 0.8
    echo
    if [ "$OSTYPE" = "Opensource" ]; then
      $OPKGINSTAL "$1"
      sleep 1
      clear
    elif [ "$OSTYPE" = "DreamOS" ]; then
      $OPKGINSTAL "$1" -y
      sleep 1
      clear
    fi
  fi
}

for i in "${deps[@]}"; do
  install "$i"
done

# Configuration
plugin="MS"
version="1.2"
targz_file="$plugin-$version.tar.gz"
temp_dir="/tmp"

# Determine url 
#check arch armv7l aarch64 mips 7401c0 sh4
arch=$(uname -m)
#check python version
pythonversion=$(python -c "import platform; print(platform.python_version())")
sleep 3s

if [ "$arch" == "aarch64" ]; then
case $pythonversion in 
3.13.0|3.13.1|3.13.2|3.13.3|3.13.4|3.13.5|3.13.6)
#check image name 
if [ -f /usr/lib/enigma2/python/Screens/BpBlue.pyc ]; then
    echo ""
IMAGE=openblackhole
elif [ -r /usr/lib/enigma2/python/Plugins/SystemPlugins/ViX ]; then
    echo ""
IMAGE=openvix
else
echo ""
fi
if [[ "$IMAGE" == "openvix" || "$IMAGE" == "openblackhole" ]]; then
url=https://github.com/Musa0124-cmyk/-DREAMOSATXSTREAM-IPTV-PLUGIN/raw/main/py3.13/aarch64/DreamosatXstream.tar.zst.gz
sleep 3
else
url=https://github.com/Musa0124-cmyk/-DREAMOSATXSTREAM-IPTV-PLUGIN/raw/main/py3.13/aarch64/DreamosatXstream.tar.zst.gz
sleep 3
fi;;
*)
echo "> Resimdeki Python sürümünüz: `$python` desteklenmiyor"
sleep 3
exit 1
;;
esac

elif [ "$arch" == "mips" ]; then
case $pythonversion in 
3.13.0|3.13.1|3.13.2|3.13.3|3.13.4|3.13.5|3.13.6|3.13.7|3.13.8|3.13.9)
#check image name 
if [ -f /usr/lib/enigma2/python/Screens/BpBlue.pyc ]; then
    echo ""
IMAGE=openblackhole
elif [ -r /usr/lib/enigma2/python/Plugins/SystemPlugins/ViX ]; then
    echo ""
IMAGE=openvix
else
echo ""
fi
if [[ "$IMAGE" == "openvix" || "$IMAGE" == "openblackhole" ]]; then
url=https://github.com/Musa0124-cmyk/-DREAMOSATXSTREAM-IPTV-PLUGIN/raw/main/py3.13/mips/DreamosatXstream.tar.zst.gz
sleep 3
else
url=https://github.com/Musa0124-cmyk/-DREAMOSATXSTREAM-IPTV-PLUGIN/raw/main/py3.13/mips/DreamosatXstream.tar.zst.gz
sleep 3
fi;;
*)
echo "> Resimdeki Python sürümünüz: `$python` desteklenmiyor"
sleep 3
exit 1
;;
esac

elif [ "$arch" == "armv7l" ]; then
case $pythonversion in 
3.13.0|3.13.1|3.13.2|3.13.3|3.13.4|3.13.5|3.13.6|3.13.7|3.13.8|3.13.9)
#check image name 
if [ -f /usr/lib/enigma2/python/Screens/BpBlue.pyc ]; then
    echo ""
IMAGE=openblackhole
elif [ -r /usr/lib/enigma2/python/Plugins/SystemPlugins/ViX ]; then
    echo ""
IMAGE=openvix
else
echo ""
fi
if [[ "$IMAGE" == "openvix" || "$IMAGE" == "openblackhole" ]]; then
url=https://github.com/Musa0124-cmyk/-DREAMOSATXSTREAM-IPTV-PLUGIN/raw/main/py3.13/arm/DreamosatXstream.tar.zst.gz
sleep 3
sleep 3
else
url=https://github.com/Musa0124-cmyk/-DREAMOSATXSTREAM-IPTV-PLUGIN/raw/main/py3.13/arm/DreamosatXstream.tar.zst.gz
sleep 3
fi;;
*)
echo "> Resimdeki Python sürümünüz: `$python` desteklenmiyor"
sleep 3
exit 1
;;
esac
fi

#Download & install package
echo "> $plugin-$version paketi indiriliyor, lütfen bekleyin. ..."
sleep 3
wget --show-progress -qO $temp_dir/$targz_file --no-check-certificate $url
set -e
if [ -e /etc/enigma2/DreamosatXstream/accounts.txt ]; then
mv -f /etc/enigma2/DreamosatXstream/accounts.txt /tmp
fi
tar -xzf $temp_dir/$targz_file -C /
extract=$?
rm -rf $temp_dir/$targz_file >/dev/null 2>&1

echo ''
if [ $extract -eq 0 ]; then
set -e
if [ -e /tmp/DreamosatXstream/accounts.txt ]; then
	rm -f /etc/enigma2/DreamosatXstream/accounts.txt

fi
echo "> $plugin-$version paketi başarıyla kuruldu"
sleep 3
echo "> Yükleme Musa0124"
else
echo "> $plugin-$version paketinin kurulumu başarısız oldu."
sleep 3
fi

fi