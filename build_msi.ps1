# Script PowerShell pour générer l'exécutable MSI
# Excel Color Manager - Build Script

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Excel Color Manager - Build MSI   " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier que Python est installé
Write-Host "Vérification de Python..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: Python n'est pas installé ou pas dans le PATH" -ForegroundColor Red
    exit 1
}
Write-Host "Python trouvé: $pythonVersion" -ForegroundColor Green

# Vérifier la version de Python
$versionMatch = $pythonVersion -match "Python (\d+)\.(\d+)"
if ($versionMatch) {
    $major = [int]$Matches[1]
    $minor = [int]$Matches[2]

    if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 8) -or $major -gt 3 -or ($major -eq 3 -and $minor -ge 13)) {
        Write-Host "ERREUR: Python $major.$minor n'est pas supporté" -ForegroundColor Red
        Write-Host "Veuillez installer Python 3.8 à 3.12" -ForegroundColor Yellow
        exit 1
    }
}
Write-Host ""

# Créer l'environnement virtuel si nécessaire
if (-not (Test-Path "venv")) {
    Write-Host "Création de l'environnement virtuel..." -ForegroundColor Yellow
    python -m venv venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERREUR: Impossible de créer l'environnement virtuel" -ForegroundColor Red
        exit 1
    }
    Write-Host "Environnement virtuel créé avec succès" -ForegroundColor Green
}
Write-Host ""

# Activer l'environnement virtuel
Write-Host "Activation de l'environnement virtuel..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

# Installer Briefcase
Write-Host "Installation de Briefcase..." -ForegroundColor Yellow
pip install --upgrade pip
pip install briefcase
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: Impossible d'installer Briefcase" -ForegroundColor Red
    exit 1
}
Write-Host "Briefcase installé avec succès" -ForegroundColor Green
Write-Host ""

# Menu de choix
Write-Host "Que voulez-vous faire?" -ForegroundColor Cyan
Write-Host "1. Tester l'application (briefcase dev)"
Write-Host "2. Créer l'application Windows (briefcase create)"
Write-Host "3. Compiler l'application (briefcase build)"
Write-Host "4. Générer le MSI (briefcase package)"
Write-Host "5. Tout faire (create + build + package)"
Write-Host "0. Quitter"
Write-Host ""

$choice = Read-Host "Votre choix"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Lancement de l'application en mode développement..." -ForegroundColor Yellow
        briefcase dev
    }
    "2" {
        Write-Host ""
        Write-Host "Création de l'application Windows..." -ForegroundColor Yellow
        briefcase create windows
    }
    "3" {
        Write-Host ""
        Write-Host "Compilation de l'application..." -ForegroundColor Yellow
        briefcase build windows
    }
    "4" {
        Write-Host ""
        Write-Host "Génération du MSI..." -ForegroundColor Yellow
        briefcase package windows --no-sign
        Write-Host ""
        Write-Host "Le fichier MSI a été créé dans le dossier windows/" -ForegroundColor Green
    }
    "5" {
        Write-Host ""
        Write-Host "Création de l'application Windows..." -ForegroundColor Yellow
        briefcase create windows
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "Compilation de l'application..." -ForegroundColor Yellow
            briefcase build windows
            if ($LASTEXITCODE -eq 0) {
                Write-Host ""
                Write-Host "Génération du MSI..." -ForegroundColor Yellow
                briefcase package windows --no-sign
                Write-Host ""
                Write-Host "Le fichier MSI a été créé dans le dossier windows/" -ForegroundColor Green
            }
        }
    }
    "0" {
        Write-Host "Au revoir!" -ForegroundColor Cyan
        exit 0
    }
    default {
        Write-Host "Choix invalide" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Terminé!" -ForegroundColor Green
