#!/bin/bash
echo "creator script Astro_lp" 
echo "Select action:"
echo "1. Installation"
echo "2. Start project"

read choice

if [ $choice -eq 1 ]; then
    apt-get update
    apt-get -o Dpkg::Options::="--force-confold" full-upgrade -y
    pkg install tur-repo -y
    pkg install mongodb proot-distro -y
    proot-distro install alpine
    proot-distro login alpine --termux-home << EOF
    apk update
    apk upgrade
    apk add sudo curl wget npm nodejs git
    sudo su
    git clone https://github.com/danny-avila/LibreChat.git
    cd LibreChat
    cp .env.example .env

    npm ci --parallel
    npm run frontend
    exit
EOF
elif [ $choice -eq 2 ]; then
    mongod &
    proot-distro login alpine --termux-home << EOF
    sudo su
    cd LibreChat
    sed -i 's|HOST=localhost|HOST=127.0.0.1|g' .env
    npm run backend
EOF
else
    echo "Wrong choice. Please select 1 or 2."
fi
