# Déploiement ColorExcel en Entreprise

## Fichiers Disponibles

Vous disposez de **deux formats** pour déployer l'application :

### 1. Format MSI (Recommandé pour installation système)
- **Fichier :** `dist\ColorExcel-0.1.0.msi` (33 Mo)
- **Installation :** Via double-clic ou script PowerShell
- **Avantages :**
  - Installation dans Program Files
  - Raccourci dans le menu Démarrer
  - Entrée dans Ajout/Suppression de programmes
  - Désinstallation propre
- **Inconvénients :**
  - Nécessite des droits administrateur
  - Avertissement SmartScreen possible

### 2. Format ZIP (Recommandé pour utilisation portable)
- **Fichier :** `dist\ColorExcel-0.1.0.zip` (41 Mo)
- **Installation :** Extraction simple
- **Avantages :**
  - Pas de droits admin nécessaires
  - Portable (clé USB, réseau)
  - Pas d'avertissement SmartScreen
  - Plusieurs instances possibles
- **Inconvénients :**
  - Pas de raccourci automatique
  - Pas d'entrée dans le système

---

## Installation Rapide

### Option A : Installation MSI avec Script (Recommandé)

1. **Ouvrir PowerShell en tant qu'administrateur**
   - Clic droit sur PowerShell → "Exécuter en tant qu'administrateur"

2. **Naviguer vers le dossier du projet**
   ```powershell
   cd "C:\Users\User\Documents\myCode\python\excel_manipulation_couleur_beeware"
   ```

3. **Lancer le script d'installation**
   ```powershell
   .\deploy_colorexcel.ps1
   ```

   **Installation silencieuse (sans interface) :**
   ```powershell
   .\deploy_colorexcel.ps1 -Silent
   ```

### Option B : Installation MSI Manuelle

1. **Double-cliquer sur** `dist\ColorExcel-0.1.0.msi`

2. **Si SmartScreen s'affiche :**
   - Cliquer sur "Informations complémentaires"
   - Puis "Exécuter quand même"

3. **Suivre l'assistant d'installation**

### Option C : Version Portable (ZIP)

1. **Extraire** `dist\ColorExcel-0.1.0.zip` dans un dossier
   - Exemple : `C:\Apps\ColorExcel\`

2. **Lancer** `src\ColorExcel.exe`

3. **Optionnel :** Créer un raccourci sur le Bureau

---

## Scripts PowerShell Fournis

### 1. `deploy_colorexcel.ps1` - Installation
- Vérifie les droits admin
- Débloque le fichier MSI
- Détecte les versions existantes
- Installe l'application
- Affiche le résultat

**Usage :**
```powershell
# Installation interactive
.\deploy_colorexcel.ps1

# Installation silencieuse
.\deploy_colorexcel.ps1 -Silent

# Installation depuis un partage réseau
.\deploy_colorexcel.ps1 -MsiPath "\\serveur\partage\ColorExcel-0.1.0.msi"
```

### 2. `uninstall_colorexcel.ps1` - Désinstallation
- Recherche l'application installée
- Désinstalle proprement
- Affiche le résultat

**Usage :**
```powershell
# Désinstallation interactive
.\uninstall_colorexcel.ps1

# Désinstallation silencieuse
.\uninstall_colorexcel.ps1 -Silent
```

---

## Installation sur Plusieurs PC

### Méthode 1 : Partage Réseau

1. **Placer le MSI sur un partage réseau**
   ```
   \\serveur\partage\ColorExcel-0.1.0.msi
   ```

2. **Créer un script de déploiement**
   ```powershell
   # Sur chaque PC, exécuter :
   .\deploy_colorexcel.ps1 -MsiPath "\\serveur\partage\ColorExcel-0.1.0.msi" -Silent
   ```

### Méthode 2 : Remote PowerShell

```powershell
# Liste des PC cibles
$computers = @("PC001", "PC002", "PC003")

# Chemin du MSI sur le réseau
$msiPath = "\\serveur\partage\ColorExcel-0.1.0.msi"

foreach ($computer in $computers) {
    Write-Host "Installation sur $computer..." -ForegroundColor Cyan

    Invoke-Command -ComputerName $computer -ScriptBlock {
        param($path)
        Start-Process msiexec.exe -ArgumentList "/i `"$path`" /quiet /norestart" -Wait -NoNewWindow
    } -ArgumentList $msiPath

    Write-Host "[OK] Installation terminée sur $computer" -ForegroundColor Green
}
```

---

## Avertissements de Sécurité Attendus

### Windows SmartScreen
**Message :** "L'éditeur n'a pas pu être vérifié. Voulez-vous vraiment exécuter ce logiciel ?"

**Cause :** L'application est signée avec une signature adhoc (non officielle)

**Solution :**
- Cliquer sur "Informations complémentaires"
- Puis "Exécuter quand même"
- Ou utiliser le script `deploy_colorexcel.ps1` qui débloque automatiquement

### Contrôle de Compte d'Utilisateur (UAC)
**Message :** "Voulez-vous autoriser cette application à apporter des modifications ?"

**Cause :** Installation nécessite des droits administrateur

**Solution :**
- Cliquer sur "Oui"

---

## Vérification Post-Installation

### Vérifier que l'application est installée

```powershell
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Where-Object { $_.DisplayName -eq "ColorExcel" } |
    Select-Object DisplayName, DisplayVersion, InstallLocation
```

### Lancer l'application

**Via le Menu Démarrer :**
- Rechercher "ColorExcel"
- Cliquer sur l'icône

**Via PowerShell :**
```powershell
Start-Process "C:\Program Files\ColorExcel\src\ColorExcel.exe"
```

---

## Problèmes Courants et Solutions

### 1. Script PowerShell bloqué

**Erreur :** "L'exécution de scripts est désactivée sur ce système"

**Solution :**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 2. "Accès refusé" lors de l'installation

**Cause :** Droits administrateur manquants

**Solution :**
- Exécuter PowerShell en tant qu'administrateur
- Clic droit sur PowerShell → "Exécuter en tant qu'administrateur"

### 3. Installation bloquée par AppLocker

**Cause :** Politique de sécurité de l'entreprise

**Solution :**
1. Obtenir le hash du fichier :
   ```powershell
   Get-FileHash -Path "dist\ColorExcel-0.1.0.msi" -Algorithm SHA256
   ```
2. Demander au service IT d'ajouter une exception avec ce hash
3. Ou utiliser la version ZIP portable

### 4. Antivirus bloque l'installation

**Cause :** Faux positif (application non signée)

**Solution :**
- Ajouter une exception dans l'antivirus
- Soumettre le fichier à l'équipe de sécurité pour analyse

---

## Désinstallation

### Via PowerShell (Recommandé)
```powershell
.\uninstall_colorexcel.ps1
```

### Via Windows
1. **Paramètres** → **Applications**
2. Rechercher **"ColorExcel"**
3. Cliquer sur **"Désinstaller"**

---

## Documentation Complète

- **Guide d'installation détaillé :** [INSTALL.md](INSTALL.md)
- **Guide de déploiement entreprise :** [DEPLOIEMENT_ENTREPRISE.md](DEPLOIEMENT_ENTREPRISE.md)
- **Documentation utilisateur :** [README.md](README.md)

---

## Support

### Logs d'Installation
- **Installation MSI :** `%TEMP%\colorexcel_install.log`
- **Application :** `%LOCALAPPDATA%\ColorExcel\Logs\`

### Événements Windows
- Ouvrir **Event Viewer**
- Aller dans **Windows Logs** → **Application**
- Filtrer par source "MsiInstaller"

---

## Informations Techniques

- **Version :** 0.1.0
- **Format MSI :** 33 Mo
- **Format ZIP :** 41 Mo
- **Python intégré :** 3.12.9 (pas d'installation Python requise)
- **Dépendances incluses :** toga, pandas, openpyxl
- **Compatibilité :** Windows 10/11
- **Signature :** Adhoc (non officielle)

---

**Note :** L'application inclut toutes les dépendances nécessaires. Les utilisateurs n'ont pas besoin d'installer Python ou d'autres bibliothèques.
