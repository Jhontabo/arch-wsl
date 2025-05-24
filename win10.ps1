# Script para instalar 30 aplicaciones gratuitas y útiles con Chocolatey
# Ejecutar como administrador

# Verificar si Chocolatey está instalado
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Error "Chocolatey no está instalado. Instálalo con: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    exit 1
}

# Crear archivo de log
$logFile = "$env:USERPROFILE\Desktop\install_apps_log.txt"
Add-Content -Path $logFile -Value ("Inicio de instalación: " + (Get-Date))

# Lista de aplicaciones a instalar
$apps = @(
    # Navegadores
    "googlechrome",
    "firefox",
    "brave",
    # Edición de fotos
    "gimp",
    # Productividad
    "onlyoffice",
    "libreoffice",
    "notepadplusplus",
    "obsidian",
    # Multimedia
    "vlc",
    "spotify",
    "audacity",
    # Mensajería
    "whatsapp",
    "discord",
    "telegram-desktop",
    # Compresión
    "7zip",
    "winrar",
    # Desarrollo
    "python3",
    "vscode",
    "nodejs",
    # Utilidades
    "everything",
    "powertoys",
    "sharex",
    "putty",
    "filezilla",
    # Seguridad
    "malwarebytes",
    # Otros
    "sumatrapdf",
    "qbittorrent",
    "paint.net",
    "rufus",
    "cpu-z",
    "greenshot"
)

# Confirmación del usuario
Write-Host "Aplicaciones a instalar: $($apps -join ', ')"
$confirm = Read-Host "¿Instalar todas las aplicaciones? (S/N)"
if ($confirm -ne 'S') {
    Write-Host "Instalación cancelada." -ForegroundColor Yellow
    Add-Content -Path $logFile -Value ("Instalación cancelada por el usuario: " + (Get-Date))
    exit
}

# Función para instalar una aplicación
function Install-App {
    param (
        [string]$AppName
    )
    # Verificar si la aplicación ya está instalada
    $installed = choco list --local-only | Select-String $AppName
    if ($installed) {
        Write-Host "$AppName ya está instalado. Omitiendo..." -ForegroundColor Yellow
        Add-Content -Path $logFile -Value ("$AppName ya está instalado. Omitiendo: " + (Get-Date))
        return
    }

    Write-Host "Instalando $AppName..."
    Add-Content -Path $logFile -Value ("Instalando $AppName: " + (Get-Date))
    try {
        # Capturar salida y errores del comando choco install
        $output = choco install $AppName -y 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "$AppName instalado correctamente." -ForegroundColor Green
            Add-Content -Path $logFile -Value ("$AppName instalado correctamente.")
        } else {
            Write-Warning "Error al instalar $AppName. Detalle: $output"
            Add-Content -Path $logFile -Value ("Error al instalar $AppName. Detalle: " + $output)
        }
    } catch {
        Write-Error ("Excepción al instalar $AppName: " + $_)
        Add-Content -Path $logFile -Value ("Excepción al instalar $AppName: " + $_)
    }
}

# Instalar cada aplicación
foreach ($app in $apps) {
    Install-App -AppName $app
}

# Mensaje final
Write-Host "Instalación completada. Revisa el log en $logFile." -ForegroundColor Cyan
Add-Content -Path $logFile -Value ("Instalación completada: " + (Get-Date))

