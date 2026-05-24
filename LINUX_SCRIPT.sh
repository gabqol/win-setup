#!/bin/bash
# ==========================================
# GABRIELL UBUNTU AUTO SETUP ;D	
# ==========================================

clear

# Cores para o terminal
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Sem cor

# ==========================================
# VERIFICAR ROOT (ADMIN)
# ==========================================
if [ "$EUID" -ne 0 ]; then
    echo ""
    echo -e "${RED}Execute o script como ROOT (use sudo)!${NC}"
    echo ""
    exit 1
fi

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}        INICIANDO CONFIGURACAO            ${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

# ==========================================
# ATUALIZAR REPOSITÓRIOS
# ==========================================
echo -e "${YELLOW}[1/7] Atualizando lista de pacotes...${NC}"
apt update -y && apt upgrade -y

# ==========================================
# INSTALAR VLC
# ==========================================
echo ""
echo -e "${YELLOW}[2/7] Instalando VLC...${NC}"
apt install vlc -y

# ==========================================
# INSTALAR 7-ZIP
# ==========================================
echo ""
echo -e "${YELLOW}[3/7] Instalando 7-Zip...${NC}"
apt install p7zip-full p7zip-rar -y

# ==========================================
# INSTALAR CHROME
# ==========================================
echo ""
echo -e "${YELLOW}[4/7] Instalando Chrome...${NC}"
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
apt install /tmp/chrome.deb -y
rm /tmp/chrome.deb

# ==========================================
# INSTALAR SLACK
# ==========================================
echo ""
echo -e "${YELLOW}[5/7] Instalando Slack...${NC}"
snap install slack --classic

# ==========================================
# INSTALAR RUSTDESK
# ==========================================
echo ""
echo -e "${YELLOW}[6/7] Instalando RustDesk...${NC}"
# Baixa a versão mais recente estável direto do GitHub deles
wget -q https://github.com/rustdesk/rustdesk/releases/download/1.3.1/rustdesk-1.3.1-x86_64.deb -O /tmp/rustdesk.deb
apt install /tmp/rustdesk.deb -y
rm /tmp/rustdesk.deb

# ==========================================
# INSTALAR FORTICLIENT VPN
# ==========================================
echo ""
echo -e "${YELLOW}[7/7] Instalando FortiClient VPN...${NC}"
# Instala o suporte a Flatpak caso não tenha e adiciona o Flathub
apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# Instala o FortiClient via Flatpak de forma não interativa
flatpak install flathub com.fortinet.FortiClientRND -y

# ==========================================
# FINALIZACAO
# ==========================================
echo ""
echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}          CONFIGURACAO FINALIZADA         ${NC}"
echo -e "${GREEN}==========================================${NC}"
echo ""

echo -e "${CYAN}Sistema pronto para uso!${NC}"
echo ""
