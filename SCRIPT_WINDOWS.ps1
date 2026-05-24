# ==========================================
# WINDOWS AUTO SETUP
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
Write-Host "        INICIANDO CONFIGURACAO            " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================
# ATUALIZAR WINGET
# ==========================================

Write-Host "[1/8] Atualizando Winget..." -ForegroundColor Yellow
winget source update

# ==========================================
# INSTALAR APPS
# ==========================================

Write-Host ""
Write-Host "[2/8] Instalando VLC..." -ForegroundColor Yellow
winget install --id VideoLAN.VLC -e --silent

Write-Host ""
Write-Host "[3/8] Instalando 7-Zip..." -ForegroundColor Yellow
winget install --id 7zip.7zip -e --silent

Write-Host ""
Write-Host "[4/8] Instalando Chrome..." -ForegroundColor Yellow
winget install --id Google.Chrome -e --silent

Write-Host ""
Write-Host "[5/8] Instalando Slack..." -ForegroundColor Yellow
winget install --id SlackTechnologies.Slack -e --silent

# ==========================================
# ATIVAR .NET FRAMEWORK
# ==========================================

Write-Host ""
Write-Host "[6/8] Ativando .NET Framework..." -ForegroundColor Yellow

Enable-WindowsOptionalFeature `
-Online `
-FeatureName NetFx3 `
-All `
-NoRestart

# ==========================================
# ATIVAR WSL
# ==========================================

Write-Host ""
Write-Host "[7/8] Ativando WSL..." -ForegroundColor Yellow

Enable-WindowsOptionalFeature `
-Online `
-FeatureName Microsoft-Windows-Subsystem-Linux `
-All `
-NoRestart

# ==========================================
# VIRTUAL MACHINE PLATFORM
# ==========================================

Write-Host ""
Write-Host "[8/8] Ativando Virtual Machine Platform..." -ForegroundColor Yellow

Enable-WindowsOptionalFeature `
-Online `
-FeatureName VirtualMachinePlatform `
-All `
-NoRestart

# ==========================================
# INSTALAR UBUNTU
# ==========================================

Write-Host ""
Write-Host "Instalando Ubuntu..." -ForegroundColor Yellow

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

