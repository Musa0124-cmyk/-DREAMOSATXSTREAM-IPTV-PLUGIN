#!/bin/bash

# ---------------------------------------------------------
# DREAMOSATXSTREAM-IPTV-PLUGIN KURULUM BETİĞİ
# ---------------------------------------------------------

# Eski kalıntıları temizle
rm -rf /tmp/*.ipk /tmp/*.tar.gz >/dev/null 2>&1

# Değişkenler
plugin="DREAMOSATXSTREAM"
version="2.30"
temp_ipk="/tmp/dreamosatxstream.ipk"

# Sistem bilgilerini al
arch=$(uname -m)
pythonversion=$(python -c "import platform; print(platform.python_version())" 2>/dev/null)

echo "> Sistem Mimarisi: $arch"
echo "> Python Sürümü: $pythonversion"
sleep 2

# Mimari ve Python Sürümü Kontrolü (Sadece Python 3.13 için yapılandırıldı)
if [[ $pythonversion == 3.13.* ]]; then
    case $arch in
        "aarch64")
            url="https://github.com/Musa0124-cmyk/-DREAMOSATXSTREAM-IPTV-PLUGIN/raw/main/python3.13/aarch64/enigma2-plugin-extensions-dreamosatxstream_2.3.0%2Bgit17%2B3dd0cec0%2B3dd0cec6d4-r0_aarch64.ipk"
            ;;
        "mips"|"mipsel")
            url="https://github.com/Musa0124-cmyk/-DREAMOSATXSTREAM-IPTV-PLUGIN/raw/main/python3.13/mipsel/enigma2-plugin-extensions-dreamosatxstream_2.3.0%2Bgit17%2B3dd0cec0%2B3dd0cec6d4-r0_mips32el.ipk"
            ;;
        "armv7l")
            url="https://github.com/Musa0124-cmyk/-DREAMOSATXSTREAM-IPTV-PLUGIN/raw/main/python3.13/arm/enigma2-plugin-extensions-dreamosatxstream_2.3.0%2Bgit17%2B3dd0cec0%2B3dd0cec6d4-r0_cortexa15hf-neon-vfpv4.ipk"
            ;;
        *)
            echo "!!! HATA: Mimariniz ($arch) bu paketle uyumlu değil."
            exit 1
            ;;
    esac
else
    echo "!!! HATA: Bu paket sadece Python 3.13.x sürümü içindir. Mevcut: $pythonversion"
    exit 1
fi

# Paket İndirme
echo "> $plugin paketi indiriliyor..."
wget --no-check-certificate "$url" -O "$temp_ipk"

if [ $? -ne 0 ]; then
    echo "!!! HATA: Dosya indirilemedi. Lütfen internet bağlantısını veya URL'yi kontrol edin."
    exit 1
fi

# Hesap Yedekleme (Eğer varsa)
if [ -f /etc/enigma2/DreamosatXstream/accounts.txt ]; then
    echo "> Mevcut hesaplar yedekleniyor..."
    cp /etc/enigma2/DreamosatXstream/accounts.txt /tmp/accounts_backup.txt
fi

# Kurulum
echo "> Kurulum başlatılıyor (opkg)..."
opkg install "$temp_ipk"

if [ $? -eq 0 ]; then
    echo "> Kurulum başarıyla tamamlandı."
    # Yedeği geri yükle
    if [ -f /tmp/accounts_backup.txt ]; then
        mkdir -p /etc/enigma2/DreamosatXstream/
        mv /tmp/accounts_backup.txt /etc/enigma2/DreamosatXstream/accounts.txt
        echo "> Hesaplar geri yüklendi."
    fi
    echo "> Lütfen cihazınızı (GUI) yeniden başlatın."
else
    echo "!!! HATA: Kurulum başarısız oldu. Bağımlılıkları kontrol edin."
fi

# Temizlik
rm -f "$temp_ipk"

exit 0