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

Write-Host "[1/12] Atualizando Winget..." -ForegroundColor Yellow
winget source update

# ==========================================
# INSTALAR APPS
# ==========================================

Write-Host ""
Write-Host "[2/12] Instalando VLC..." -ForegroundColor Yellow
winget install --id VideoLAN.VLC -e --silent

Write-Host ""
Write-Host "[3/12] Instalando 7-Zip..." -ForegroundColor Yellow
winget install --id 7zip.7zip -e --silent

Write-Host ""
Write-Host "[4/12] Instalando Chrome..." -ForegroundColor Yellow
winget install --id Google.Chrome -e --silent

Write-Host ""
Write-Host "[5/12] Instalando Slack..." -ForegroundColor Yellow
winget install --id SlackTechnologies.Slack -e --silent

Write-Host ""
Write-Host "[6/12] Instalando FortiClient VPN..." -ForegroundColor Yellow
winget install --id Fortinet.FortiClientVPN -e --silent

Write-Host ""
Write-Host "[7/12] Instalando RustDesk..." -ForegroundColor Yellow
winget install --id RustDesk.RustDesk -e --silent

# ==========================================
# ATIVAR .NET FRAMEWORK
# ==========================================

Write-Host ""
Write-Host "[8/12] Ativando .NET Framework..." -ForegroundColor Yellow

Enable-WindowsOptionalFeature `
-Online `
-FeatureName NetFx3 `
-All `
-NoRestart

# ==========================================
# ATIVAR WSL
# ==========================================

Write-Host ""
Write-Host "[9/12] Ativando WSL..." -ForegroundColor Yellow

Enable-WindowsOptionalFeature `
-Online `
-FeatureName Microsoft-Windows-Subsystem-Linux `
-All `
-NoRestart

# ==========================================
# VIRTUAL MACHINE PLATFORM
# ==========================================

Write-Host ""
Write-Host "[10/12] Ativando Virtual Machine Platform..." -ForegroundColor Yellow

Enable-WindowsOptionalFeature `
-Online `
-FeatureName VirtualMachinePlatform `
-All `
-NoRestart

# ==========================================
# INSTALAR UBUNTU
# ==========================================

Write-Host ""
Write-Host "[11/12] Instalando Ubuntu..." -ForegroundColor Yellow

wsl --install -d Ubuntu

# ==========================================
# ATUALIZAÇÃO AUTOMÁTICA DE DRIVERS
# ==========================================

Write-Host ""
Write-Host "[12/12] Verificando fabricante para atualizar drivers..." -ForegroundColor Yellow

$vendor = (Get-CimInstance Win32_ComputerSystem).Manufacturer
$model = (Get-CimInstance Win32_ComputerSystem).Model

Write-Host "Equipamento detectado: $vendor ($model)" -ForegroundColor Cyan

if ($vendor -like "*Dell*") {
    Write-Host "Fabricante Dell detectado! Instalando Dell Command | Update..." -ForegroundColor Green
    winget install --id Dell.CommandUpdate.Universal -e --silent
    
    Write-Host "Buscando e aplicando drivers/BIOS da Dell..." -ForegroundColor Cyan
    & "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates -reboot=disable
} 
elseif ($vendor -like "*Lenovo*") {
    Write-Host "Fabricante Lenovo detectado! Instalando Lenovo System Update..." -ForegroundColor Green
    winget install --id Lenovo.SystemUpdate -e --silent
    
    Write-Host "Buscando e aplicando drivers da Lenovo..." -ForegroundColor Cyan
    & "C:\Program Files (x86)\Lenovo\System Update\tvsu.exe" /CM -search A -action INSTALL -includereboot
}
elseif ($vendor -like "*HP*") {
    Write-Host "Fabricante HP detectado! Instalando HP Image Assistant..." -ForegroundColor Green
    winget install --id HP.ImageAssistant -e --silent
    
    Write-Host "Executando análise básica do HP Image Assistant..." -ForegroundColor Cyan
    & "C:\Program Files (x86)\HP\HP Image Assistant\HPImageAssistant.exe" /Operation:Analyze /Action:Install
}
else {
    # DICA DE OURO COMANDO NATIVO: Funciona em qualquer Windows sem instalar módulos externos
    Write-Host "Fabricante generico ou sem CLI propria. Buscando drivers via Windows Update Nativo..." -ForegroundColor Magenta
    
    try {
        # Cria a sessão de atualização do Windows
        $updateSession = New-Object -ComObject Microsoft.Update.Session
        $updateSearcher = $updateSession.CreateUpdateSearcher()
        
        Write-Host "Procurando drivers disponiveis (isso pode levar alguns minutos)..." -ForegroundColor Cyan
        # Filtra apenas por atualizações de hardware/drivers que não estejam instaladas
        $searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Driver'")
        
        if ($searchResult.Updates.Count -gt 0) {
            Write-Host "Encontrados $($searchResult.Updates.Count) drivers pendentes. Baixando..." -ForegroundColor Green
            
            # Cria a lista de downloads
            $updatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
            foreach ($update in $searchResult.Updates) {
                $updatesToDownload.Add($update) | Out-Null
            }
            
            # Baixa os drivers
            $downloader = $updateSession.CreateUpdateDownloader()
            $downloader.Updates = $updatesToDownload
            $downloader.Download() | Out-Null
            
            Write-Host "Instalando drivers..." -ForegroundColor Cyan
            # Cria a lista de instalação
            $updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
            foreach ($update in $searchResult.Updates) {
                if ($update.IsDownloaded) {
                    $updatesToInstall.Add($update) | Out-Null
                }
            }
            
            # Instala os drivers baixados
            $installer = $updateSession.CreateUpdateInstaller()
            $installer.Updates = $updatesToInstall
            $installationResult = $installer.Install()
            
            Write-Host "Instalacao de drivers concluida!" -ForegroundColor Green
        } else {
            Write-Host "Nenhum driver pendente encontrado no Windows Update." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Nao foi possivel buscar drivers automaticamente: $_" -ForegroundColor Red
        Write-Host "Os drivers serao atualizados normalmente pelo Windows Update apos o reinicio." -ForegroundColor Yellow
    }
}

# ==========================================
# FINALIZACAO
# ==========================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "          CONFIGURACAO FINALIZADA         " -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

Write-Host "O computador sera reiniciado em 5 segundos..." -ForegroundColor Cyan

Start-Sleep -Seconds 5

Write-Host "to zuando" -ForegroundColor Cyan
