#!/bin/bash
# Script de instalação de programas para Ubuntu/Debian

# Atualiza a lista de pacotes
sudo apt update -y

# Instala o VLC Player
sudo apt install vlc -y

# Instala o p7zip
sudo apt install p7zip-full p7zip-rar -y

# Instala o Slack (usando o pacote snap, que é o recomendado)
sudo snap install slack --classic

# Instala o Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y
rm google-chrome-stable_current_amd64.deb

echo "Instalação concluída com sucesso!"