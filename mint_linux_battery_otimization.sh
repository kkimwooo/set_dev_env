#!/bin/bash

set -e

echo "🔋 Mint Linux 배터리 최적화 스크립트 실행 중..."

# 1. TLP 설치
echo "📦 TLP 설치 중..."
sudo apt update
sudo apt install -y tlp tlp-rdw

# 2. TLP 활성화 및 자동 실행 설정
echo "🚀 TLP 서비스 활성화..."
sudo systemctl enable tlp
sudo systemctl start tlp

# 3. CPU scaling governor 설정: powersave
echo "🧠 CPU governor 설정 중..."
sudo apt install -y cpufrequtils
echo 'GOVERNOR="powersave"' | sudo tee /etc/default/cpufrequtils
sudo systemctl disable ondemand || true
sudo systemctl enable cpufrequtils
sudo cpufreq-set -g powersave || echo "⛔ 일부 CPU에서는 즉시 설정되지 않을 수 있음."

# 4. Wi-Fi 전력 절약 설정
echo "🌐 Wi-Fi 절전 모드 설정..."
sudo sed -i '/^WIFI_PWR_ON_AC=/c\WIFI_PWR_ON_AC=1' /etc/tlp.conf
sudo sed -i '/^WIFI_PWR_ON_BAT=/c\WIFI_PWR_ON_BAT=1' /etc/tlp.conf

# 5. GRUB 전력 최적화 설정
echo "⚙️ GRUB 전력 옵션 설정..."
GRUB_CONF="/etc/default/grub"
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& pcie_aspm=force i915.enable_dc=1 i915.enable_fbc=1/' "$GRUB_CONF"

echo "🔁 GRUB 업데이트 중..."
sudo update-grub

# 6. 시스템 재시작 권장 메시지
echo -e "\n✅ 최적화 완료! 시스템을 재시작해야 모든 설정이 적용됩니다.\n"
