# Guide de Déploiement en Entreprise

## ColorExcel - Déploiement sur Domaine Active Directory

Ce guide explique comment déployer l'application ColorExcel dans un environnement d'entreprise.

---

## Contexte

L'application est packagée avec une signature adhoc (non officielle). Dans un environnement d'entreprise, cela peut entraîner des avertissements de sécurité mais l'installation reste possible avec les bonnes procédures.

---

## Prérequis

- **Droits administrateur** sur les PC cibles
- **Fichier MSI** : `ColorExcel-0.1.0.msi`
- **Système d'exploitation** : Windows 10/11

---

## Méthode 1 : Installation Standard avec Avertissements

### Étapes pour l'utilisateur final

1. **Copier le fichier MSI** sur le PC cible
   - Via réseau partagé, clé USB, ou email

2. **Double-cliquer sur le fichier MSI**
   - Un avertissement "Voulez-vous autoriser cette application à apporter des modifications ?" apparaîtra

3. **Cliquer sur "Oui"** pour autoriser l'installation

4. **Si SmartScreen s'affiche** :
   - Cliquer sur "Informations complémentaires"
   - Puis cliquer sur "Exécuter quand même"

5. **Suivre l'assistant d'installation**
   - Accepter les termes
   - Choisir le dossier d'installation (par défaut : `C:\Program Files\ColorExcel\`)
   - Cliquer sur "Installer"

6. **Installation terminée**
   - L'application est accessible via le menu Démarrer
   - Raccourci créé : "ColorExcel"

---

## Méthode 2 : Installation Silencieuse (pour IT/Admin)

Pour installer l'application sans interface utilisateur :

### Via PowerShell (en tant qu'administrateur)

```powershell
Start-Process msiexec.exe -ArgumentList '/i "ColorExcel-0.1.0.msi" /quiet /norestart' -Wait -NoNewWindow
```

### Via CMD (en tant qu'administrateur)

```cmd
msiexec /i "ColorExcel-0.1.0.msi" /quiet /norestart
```

**Options :**
- `/i` : Installer
- `/quiet` : Mode silencieux (pas d'interface)
- `/norestart` : Ne pas redémarrer le PC

### Installation avec log

Pour créer un fichier de log :

```powershell
msiexec /i "ColorExcel-0.1.0.msi" /quiet /norestart /l*v "C:\Temp\install_log.txt"
```

---

## Méthode 3 : Installation via Script de Déploiement

Créez un script PowerShell pour déployer sur plusieurs PC :

### deploy_colorexcel.ps1

```powershell
# Script de déploiement ColorExcel
# À exécuter en tant qu'administrateur

$msiPath = "\\serveur\partage\ColorExcel-0.1.0.msi"
$logPath = "C:\Temp\colorexcel_install.log"

# Créer le dossier pour les logs si nécessaire
New-Item -ItemType Directory -Force -Path "C:\Temp" | Out-Null

Write-Host "Début de l'installation de ColorExcel..." -ForegroundColor Green

# Installation silencieuse avec log
$arguments = "/i `"$msiPath`" /quiet /norestart /l*v `"$logPath`""
Start-Process msiexec.exe -ArgumentList $arguments -Wait -NoNewWindow

# Vérifier le code de retour
if ($LASTEXITCODE -eq 0) {
    Write-Host "Installation réussie !" -ForegroundColor Green
} else {
    Write-Host "Erreur lors de l'installation. Code: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "Consultez le log: $logPath" -ForegroundColor Yellow
}
```

**Utilisation :**
1. Placez le MSI sur un partage réseau accessible
2. Modifiez `$msiPath` avec le bon chemin
3. Exécutez le script avec des droits admin

---

## Méthode 4 : Contourner SmartScreen (si nécessaire)

### Option A : Débloquer le fichier MSI

Avant l'installation, débloquez le fichier :

**Via PowerShell :**
```powershell
Unblock-File -Path "ColorExcel-0.1.0.msi"
```

**Via Propriétés du fichier :**
1. Clic droit sur le MSI → Propriétés
2. Cocher "Débloquer" en bas
3. Cliquer sur "Appliquer" puis "OK"

### Option B : Ajouter une exception AppLocker/SmartScreen

Si votre entreprise utilise AppLocker, demandez au service IT d'ajouter une règle :

**Hash du fichier MSI :**
```powershell
Get-FileHash -Path "ColorExcel-0.1.0.msi" -Algorithm SHA256
```

Fournissez ce hash au service IT pour créer une exception.

---

## Désinstallation

### Via Interface Windows

1. Paramètres Windows → Applications
2. Rechercher "ColorExcel"
3. Cliquer sur "Désinstaller"

### Via PowerShell (silencieux)

```powershell
# Trouver le code produit
$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "ColorExcel" }

# Désinstaller
$app.Uninstall()
```

### Via MSI (silencieux)

```cmd
msiexec /x "ColorExcel-0.1.0.msi" /quiet /norestart
```

---

## Vérification Post-Installation

### Vérifier que l'application est installée

```powershell
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Where-Object { $_.DisplayName -eq "ColorExcel" } |
    Select-Object DisplayName, DisplayVersion, InstallLocation
```

### Lancer l'application via PowerShell

```powershell
Start-Process "C:\Program Files\ColorExcel\src\ColorExcel.exe"
```

---

## Problèmes Courants

### 1. "Cette application a été bloquée par votre administrateur"

**Cause :** Politique de restriction logicielle (SRP) ou AppLocker
**Solution :**
- Demander une exception au service IT
- Fournir le hash SHA256 du fichier MSI et de l'exécutable
- Alternative : utiliser la version ZIP portable (voir ci-dessous)

### 2. "L'éditeur n'a pas pu être vérifié"

**Cause :** Signature adhoc non reconnue
**Solution :**
- Cliquer sur "Informations complémentaires" puis "Exécuter quand même"
- Ou débloquer le fichier avec `Unblock-File`

### 3. Installation échoue avec code d'erreur 1603

**Cause :** Droits insuffisants ou conflit avec version précédente
**Solution :**
- Exécuter en tant qu'administrateur
- Désinstaller toute version précédente
- Vérifier les logs d'installation

### 4. Antivirus bloque l'installation

**Cause :** Faux positif (application non signée)
**Solution :**
- Ajouter une exception dans l'antivirus
- Soumettre le fichier à l'équipe de sécurité IT pour analyse

---

## Alternative : Version Portable (ZIP)

Si le MSI pose trop de problèmes, vous pouvez créer une version portable :

### Créer la version ZIP

```bash
briefcase package windows --packaging-format zip
```

Le fichier ZIP sera créé dans :
```
dist\ColorExcel-0.1.0.zip
```

### Utilisation de la version ZIP

1. Extraire le ZIP dans un dossier (ex: `C:\Apps\ColorExcel\`)
2. Lancer directement `src\ColorExcel.exe`
3. **Avantages :**
   - Pas de droits admin nécessaires
   - Pas d'installation système
   - Portable (copier/coller sur clé USB)
4. **Inconvénients :**
   - Pas de raccourci automatique dans le menu Démarrer
   - Pas d'entrée dans "Ajout/Suppression de programmes"

---

## Checklist de Déploiement

Avant de déployer dans votre entreprise :

- [ ] Tester l'installation sur un PC test du domaine
- [ ] Vérifier que l'application fonctionne correctement
- [ ] Documenter les avertissements de sécurité rencontrés
- [ ] Informer le service IT du déploiement
- [ ] Préparer le script de déploiement si installation multiple
- [ ] Créer une documentation utilisateur
- [ ] Tester la désinstallation
- [ ] Vérifier la compatibilité avec l'antivirus d'entreprise

---

## Contact et Support

Pour tout problème de déploiement, vérifiez :
1. Les logs d'installation (si installation silencieuse)
2. Les événements Windows (Event Viewer → Application)
3. Les logs de l'application : `%LOCALAPPDATA%\ColorExcel\Logs\`

---

## Notes de Version

- **Version actuelle :** 0.1.0
- **Signature :** Adhoc (non officielle)
- **Compatibilité :** Windows 10/11
- **Python intégré :** 3.12.9 (embarqué, pas d'installation requise)

---

**Important :** Cette application est packagée avec toutes ses dépendances. Les utilisateurs finaux n'ont PAS besoin d'installer Python ou d'autres bibliothèques.
