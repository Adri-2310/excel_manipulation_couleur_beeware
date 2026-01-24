# ============================================================================
# Script de Déploiement ColorExcel
# ============================================================================
#
# Ce script installe ColorExcel sur un PC Windows
# À exécuter en tant qu'administrateur
#
# Usage:
#   .\deploy_colorexcel.ps1
#   .\deploy_colorexcel.ps1 -Silent
#   .\deploy_colorexcel.ps1 -MsiPath "\\serveur\partage\ColorExcel-0.1.0.msi"
#
# ============================================================================

param(
    [string]$MsiPath = ".\dist\ColorExcel-0.1.0.msi",
    [switch]$Silent = $false,
    [string]$LogPath = "$env:TEMP\colorexcel_install.log"
)

# Vérifier les droits administrateur
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Bannière
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "   Installation de ColorExcel v0.1.0" -ForegroundColor Cyan
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host ""

# Vérification des droits admin
if (-not (Test-Administrator)) {
    Write-Host "[ERREUR] Ce script nécessite des droits administrateur." -ForegroundColor Red
    Write-Host ""
    Write-Host "Relancez PowerShell en tant qu'administrateur :" -ForegroundColor Yellow
    Write-Host "  1. Clic droit sur PowerShell" -ForegroundColor Yellow
    Write-Host "  2. 'Exécuter en tant qu'administrateur'" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "[OK] Droits administrateur détectés" -ForegroundColor Green

# Vérifier que le fichier MSI existe
if (-not (Test-Path $MsiPath)) {
    Write-Host "[ERREUR] Fichier MSI introuvable: $MsiPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Vérifiez le chemin du fichier MSI." -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] Fichier MSI trouvé: $MsiPath" -ForegroundColor Green

# Débloquer le fichier MSI si nécessaire
Write-Host ""
Write-Host "Déblocage du fichier MSI..." -ForegroundColor Cyan
try {
    Unblock-File -Path $MsiPath -ErrorAction SilentlyContinue
    Write-Host "[OK] Fichier débloqué" -ForegroundColor Green
} catch {
    Write-Host "[INFO] Déblocage non nécessaire ou déjà effectué" -ForegroundColor Yellow
}

# Vérifier si une version est déjà installée
Write-Host ""
Write-Host "Vérification des installations existantes..." -ForegroundColor Cyan
$existingApp = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "ColorExcel" }

if ($existingApp) {
    Write-Host "[INFO] Version existante détectée: $($existingApp.Version)" -ForegroundColor Yellow

    if (-not $Silent) {
        $response = Read-Host "Voulez-vous désinstaller la version existante ? (O/N)"
        if ($response -eq "O" -or $response -eq "o") {
            Write-Host "Désinstallation en cours..." -ForegroundColor Cyan
            $existingApp.Uninstall() | Out-Null
            Write-Host "[OK] Ancienne version désinstallée" -ForegroundColor Green
        }
    } else {
        Write-Host "Désinstallation automatique de la version existante..." -ForegroundColor Cyan
        $existingApp.Uninstall() | Out-Null
        Write-Host "[OK] Ancienne version désinstallée" -ForegroundColor Green
    }
} else {
    Write-Host "[OK] Aucune version existante" -ForegroundColor Green
}

# Préparer les arguments d'installation
$installArgs = "/i `"$MsiPath`" /l*v `"$LogPath`""

if ($Silent) {
    $installArgs += " /quiet /norestart"
    Write-Host ""
    Write-Host "Installation silencieuse en cours..." -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "Lancement de l'installation interactive..." -ForegroundColor Cyan
}

# Lancer l'installation
Write-Host "Commande: msiexec.exe $installArgs" -ForegroundColor Gray
Write-Host ""

$process = Start-Process msiexec.exe -ArgumentList $installArgs -Wait -PassThru -NoNewWindow

# Vérifier le résultat
Write-Host ""
if ($process.ExitCode -eq 0) {
    Write-Host "============================================================================" -ForegroundColor Green
    Write-Host "   Installation réussie !" -ForegroundColor Green
    Write-Host "============================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "L'application est maintenant disponible :" -ForegroundColor Green
    Write-Host "  - Menu Démarrer > ColorExcel" -ForegroundColor White
    Write-Host "  - Dossier: C:\Program Files\ColorExcel\" -ForegroundColor White
    Write-Host ""
    Write-Host "Log d'installation: $LogPath" -ForegroundColor Gray
} elseif ($process.ExitCode -eq 3010) {
    Write-Host "============================================================================" -ForegroundColor Yellow
    Write-Host "   Installation réussie (redémarrage requis)" -ForegroundColor Yellow
    Write-Host "============================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Redémarrez votre PC pour finaliser l'installation." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Log d'installation: $LogPath" -ForegroundColor Gray
} else {
    Write-Host "============================================================================" -ForegroundColor Red
    Write-Host "   Erreur lors de l'installation" -ForegroundColor Red
    Write-Host "============================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Code d'erreur: $($process.ExitCode)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Consultez le log d'installation pour plus de détails:" -ForegroundColor Yellow
    Write-Host "  $LogPath" -ForegroundColor White
    Write-Host ""

    # Codes d'erreur courants
    switch ($process.ExitCode) {
        1602 { Write-Host "Cause probable: Installation annulée par l'utilisateur" -ForegroundColor Yellow }
        1603 { Write-Host "Cause probable: Erreur fatale lors de l'installation" -ForegroundColor Yellow }
        1618 { Write-Host "Cause probable: Une autre installation est en cours" -ForegroundColor Yellow }
        1619 { Write-Host "Cause probable: Package MSI introuvable" -ForegroundColor Yellow }
        1625 { Write-Host "Cause probable: Installation bloquée par la stratégie de groupe" -ForegroundColor Yellow }
        default { Write-Host "Consultez https://docs.microsoft.com/en-us/windows/win32/msi/error-codes" -ForegroundColor Yellow }
    }
}

Write-Host ""
Write-Host "============================================================================" -ForegroundColor Cyan

exit $process.ExitCode
