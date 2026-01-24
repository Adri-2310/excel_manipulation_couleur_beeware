# ============================================================================
# Script de Désinstallation ColorExcel
# ============================================================================
#
# Ce script désinstalle ColorExcel d'un PC Windows
# À exécuter en tant qu'administrateur
#
# Usage:
#   .\uninstall_colorexcel.ps1
#   .\uninstall_colorexcel.ps1 -Silent
#
# ============================================================================

param(
    [switch]$Silent = $false
)

# Vérifier les droits administrateur
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Bannière
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "   Désinstallation de ColorExcel" -ForegroundColor Cyan
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host ""

# Vérification des droits admin
if (-not (Test-Administrator)) {
    Write-Host "[ERREUR] Ce script nécessite des droits administrateur." -ForegroundColor Red
    Write-Host ""
    Write-Host "Relancez PowerShell en tant qu'administrateur." -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] Droits administrateur détectés" -ForegroundColor Green

# Rechercher l'application installée
Write-Host ""
Write-Host "Recherche de ColorExcel..." -ForegroundColor Cyan

$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "ColorExcel" }

if (-not $app) {
    Write-Host "[INFO] ColorExcel n'est pas installé sur ce PC" -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

Write-Host "[OK] Application trouvée" -ForegroundColor Green
Write-Host "  - Nom: $($app.Name)" -ForegroundColor White
Write-Host "  - Version: $($app.Version)" -ForegroundColor White
Write-Host "  - Éditeur: $($app.Vendor)" -ForegroundColor White

# Confirmation
if (-not $Silent) {
    Write-Host ""
    $response = Read-Host "Voulez-vous désinstaller ColorExcel ? (O/N)"
    if ($response -ne "O" -and $response -ne "o") {
        Write-Host ""
        Write-Host "Désinstallation annulée." -ForegroundColor Yellow
        exit 0
    }
}

# Désinstallation
Write-Host ""
Write-Host "Désinstallation en cours..." -ForegroundColor Cyan

try {
    $result = $app.Uninstall()

    if ($result.ReturnValue -eq 0) {
        Write-Host ""
        Write-Host "============================================================================" -ForegroundColor Green
        Write-Host "   Désinstallation réussie !" -ForegroundColor Green
        Write-Host "============================================================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "ColorExcel a été supprimé de ce PC." -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "============================================================================" -ForegroundColor Red
        Write-Host "   Erreur lors de la désinstallation" -ForegroundColor Red
        Write-Host "============================================================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "Code d'erreur: $($result.ReturnValue)" -ForegroundColor Red
        Write-Host ""
        exit 1
    }
} catch {
    Write-Host ""
    Write-Host "============================================================================" -ForegroundColor Red
    Write-Host "   Erreur lors de la désinstallation" -ForegroundColor Red
    Write-Host "============================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    exit 1
}

Write-Host "============================================================================" -ForegroundColor Cyan

exit 0
