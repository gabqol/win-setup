# ==========================================
# GABRIELL WINDOWS AUTO SETUP ;D	
# ==========================================

Clear-Host

# ==========================================
# VERIFICAR ADMIN
# ==========================================

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {

    Write-Host ""
    Write-Host "Execute o PowerShell como ADMINISTRADOR!" -ForegroundColor Red
    Write-Host ""

    pause
    exit
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "         INICIANDO CONFIGURACAO            " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================
# ATUALIZAR WINGET
# ==========================================

Write-Host "[1/11] Atualizando Winget..." -ForegroundColor Yellow
winget source update

# ==========================================
# INSTALAR APPS
# ==========================================

Write-Host ""
Write-Host "[2/11] Instalando VLC..." -ForegroundColor Yellow
winget install --id VideoLAN.VLC -e --silent

Write-Host ""
Write-Host "[3/11] Instalando 7-Zip..." -ForegroundColor Yellow
winget install --id 7zip.7zip -e --silent

Write-Host ""
Write-Host "[4/11] Instalando Chrome..." -ForegroundColor Yellow
winget install --id Google.Chrome -e --silent

Write-Host ""
Write-Host "[5/11] Instalando Slack..." -ForegroundColor Yellow
winget install --id SlackTechnologies.Slack -e --silent

Write-Host ""
Write-Host "[6/11] Instalando FortiClient VPN..." -ForegroundColor Yellow
winget install --id Fortinet.FortiClientVPN -e --silent

Write-Host ""
Write-Host "[7/11] Instalando RustDesk..." -ForegroundColor Yellow
winget install --id RustDesk.RustDesk -e --silent

# ==========================================
# ATIVAR .NET FRAMEWORK
# ==========================================

Write-Host ""
Write-Host "[8/11] Ativando .NET Framework..." -ForegroundColor Yellow

Enable-WindowsOptionalFeature `
-Online `
-FeatureName NetFx3 `
-All `
-NoRestart

# ==========================================
# ATIVAR WSL
# ==========================================

Write-Host ""
Write-Host "[9/11] Ativando WSL..." -ForegroundColor Yellow

Enable-WindowsOptionalFeature `
-Online `
-FeatureName Microsoft-Windows-Subsystem-Linux `
-All `
-NoRestart

# ==========================================
# VIRTUAL MACHINE PLATFORM
# ==========================================

Write-Host ""
Write-Host "[10/11] Ativando Virtual Machine Platform..." -ForegroundColor Yellow

Enable-WindowsOptionalFeature `
-Online `
-FeatureName VirtualMachinePlatform `
-All `
-NoRestart

# ==========================================
# INSTALAR UBUNTU
# ==========================================

Write-Host ""
Write-Host "[11/11] Instalando Ubuntu..." -ForegroundColor Yellow

wsl --install -d Ubuntu

# ==========================================
# FINALIZACAO
# ==========================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "          CONFIGURACAO FINALIZADA         " -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

Write-Host "O computador sera reiniciado em 15 segundos..." -ForegroundColor Cyan

Start-Sleep -Seconds 15

Restart-Computer -Force
