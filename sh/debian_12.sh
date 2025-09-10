#!/bin/bash
set -e

# 設定套件源
echo "設定套件源"
cat << 'EOF' | sudo tee /etc/apt/sources.list > /dev/null
deb http://ftp.tw.debian.org/debian bookworm main contrib
deb http://ftp.tw.debian.org/debian bookworm-updates main contrib
deb http://security.debian.org bookworm-security main contrib
deb http://security.debian.org/debian-security bookworm-security main contrib
EOF

# 更新套件清單
echo "更新套件"
sudo apt update

# 升級系統
echo "升級套件"
sudo apt upgrade -y

# 安裝基本套件
echo "安裝基本套件"
sudo apt install ufw rsync wget curl tar zip unzip nano vim git sysbench stress-ng htop iotop bc fio qemu-guest-agent --fix-missing -y

# 啟用 QEMU Guest Agent
echo "啟用 QEMU Guest Agent"
sudo systemctl enable qemu-guest-agent

# 設定語系
echo "設定語系"
sudo localectl set-locale LANG=en_US.UTF-8

# 設定時區
echo "設定時區"
sudo timedatectl set-timezone Asia/Taipei

# 重新配置 dash
echo "重新配置 dash"
sudo dpkg-reconfigure -f noninteractive dash

# 設定系統參數
echo "設定系統參數"
echo "net.ipv4.icmp_echo_ignore_all = 1" | sudo tee -a /etc/sysctl.conf > /dev/null
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf > /dev/null
echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf > /dev/null
sudo sysctl -p

# 更新 GRUB 設定
echo "更新 GRUB 設定"
sudo sed -i -e "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"ipv6.disable=1 /g" /etc/default/grub
sudo update-grub

# 建立 swap 檔案
echo "建立 swap"
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 下載並設定系統資訊腳本
echo "設定系統資訊腳本"
sudo curl -f -o /usr/local/bin/sysinfo https://gist.githubusercontent.com/pardnchiu/561ef0581911eac7aed33c898a1a2b21/raw/4859f901ed986522fd7a4b694a513f0716a3c7ac/sysinfo
sudo chmod +x /usr/local/bin/sysinfo
sudo cp -f /usr/local/bin/sysinfo /etc/update-motd.d/99-custom
sudo chmod +x /etc/update-motd.d/99-custom
sudo run-parts /etc/update-motd.d/

# 執行測試腳本
echo "執行效能測試"
curl -s https://gist.githubusercontent.com/pardnchiu/8f23f9e98af9af4c9b1e139816a21118/raw/eadcc04a45cd5cefa0ad97403326dd022176ac69/test | bash

sudo reboot