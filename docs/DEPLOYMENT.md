# Guide de Déploiement en Entreprise - ColorExcel

## Vue d'ensemble

Ce guide explique comment déployer l'application ColorExcel dans un environnement d'entreprise, que ce soit pour une installation unique ou un déploiement massif via Active Directory/GPO.

---

## Formats de Distribution Disponibles

### 1. Format MSI (Recommandé pour installation système)

**Fichier :** `dist\ColorExcel-0.1.0.msi` (33 Mo)

**Avantages :**
- Installation dans Program Files
- Raccourci automatique dans le menu Démarrer
- Entrée dans Ajout/Suppression de programmes
- Désinstallation propre via Windows
- Support du déploiement par GPO

**Inconvénients :**
- Nécessite des droits administrateur
- Avertissement SmartScreen possible (signature adhoc)

### 2. Format ZIP (Recommandé pour utilisation portable)

**Fichier :** `dist\ColorExcel-0.1.0.zip` (41 Mo)

**Avantages :**
- Aucun droit admin nécessaire
- Portable (clé USB, réseau partagé)
- Pas d'avertissement SmartScreen
- Plusieurs instances possibles sur un même PC

**Inconvénients :**
- Pas de raccourci automatique
- Pas d'entrée dans le système
- Mise à jour manuelle

---

## Prérequis

- **Système d'exploitation :** Windows 10/11
- **Droits :** Administrateur (pour MSI uniquement)
- **Espace disque :** 50 Mo minimum
- **Python :** Non requis (inclus dans le package)

---

## Méthode 1 : Installation Interactive MSI

### Pour Utilisateurs Finaux

1. **Copier le fichier MSI** sur le PC cible
   - Via réseau partagé, clé USB, ou email

2. **Double-cliquer sur** `ColorExcel-0.1.0.msi`

3. **Si SmartScreen s'affiche :**
   - Cliquer sur "Informations complémentaires"
   - Puis "Exécuter quand même"
   - Raison : Signature adhoc (non officielle mais sécurisée)

4. **Autoriser les modifications système**
   - Cliquer sur "Oui" dans l'UAC

5. **Suivre l'assistant d'installation**
   - Accepter les termes de la licence MIT
   - Choisir le dossier (défaut : `C:\Program Files\ColorExcel\`)
   - Cliquer sur "Installer"

6. **Lancement**
   - Menu Démarrer → ColorExcel
   - Ou chercher "ColorExcel" dans la barre de recherche

---

## Méthode 2 : Installation Silencieuse

### Via PowerShell (Recommandé)

Ouvrir PowerShell en tant qu'administrateur :

```powershell
# Installation silencieuse
msiexec /i "ColorExcel-0.1.0.msi" /quiet /norestart

# Installation silencieuse avec log détaillé
msiexec /i "ColorExcel-0.1.0.msi" /quiet /norestart /l*v "C:\Temp\colorexcel_install.log"
```

### Via CMD

```cmd
msiexec /i "ColorExcel-0.1.0.msi" /quiet /norestart
```

**Options msiexec :**
- `/i` : Installer
- `/quiet` : Mode silencieux (pas d'interface)
- `/qn` : Complètement silencieux (alternative à /quiet)
- `/norestart` : Ne pas redémarrer le PC
- `/l*v` : Log détaillé (tous les messages)

---

## Méthode 3 : Scripts PowerShell Fournis

Le projet inclut des scripts PowerShell prêts à l'emploi pour simplifier le déploiement.

### Script `deploy_colorexcel.ps1`

**Fonctionnalités :**
- Vérifie les droits administrateur
- Débloque le fichier MSI (zone sécurité)
- Détecte les versions existantes
- Installe avec gestion d'erreurs
- Affiche le résultat (succès/échec)

**Usage :**

```powershell
# Installation interactive
.\deploy_colorexcel.ps1

# Installation silencieuse
.\deploy_colorexcel.ps1 -Silent

# Installation depuis un partage réseau
.\deploy_colorexcel.ps1 -MsiPath "\\serveur\partage\ColorExcel-0.1.0.msi"
```

### Script `uninstall_colorexcel.ps1`

**Fonctionnalités :**
- Recherche l'application installée via registre
- Désinstalle proprement (mode silencieux ou interactif)
- Vérifie la suppression complète
- Affiche le résultat

**Usage :**

```powershell
# Désinstallation interactive
.\uninstall_colorexcel.ps1

# Désinstallation silencieuse
.\uninstall_colorexcel.ps1 -Silent
```

---

## Méthode 4 : Déploiement par GPO (Active Directory)

### Étape 1 : Préparation

1. **Copier le MSI** sur un partage réseau accessible
   ```
   \\domaine\NETLOGON\Applications\ColorExcel-0.1.0.msi
   ```

2. **Donner les droits de lecture** au groupe "Ordinateurs du domaine"

### Étape 2 : Créer une GPO

1. Ouvrir **Gestion des stratégies de groupe**

2. **Créer une nouvelle GPO**
   - Nom : "Déploiement ColorExcel"

3. **Éditer la GPO** → Aller à :
   ```
   Configuration ordinateur
   └── Stratégies
       └── Paramètres du logiciel
           └── Installation de logiciel
   ```

4. **Ajouter un package**
   - Clic droit → Nouveau → Package
   - Sélectionner le MSI via le chemin UNC
   - Méthode : **Affecté** (installation automatique)

5. **Configurer le package** (optionnel)
   - Onglet "Déploiement"
   - Cocher "Installer l'application lors de la connexion"

6. **Lier la GPO** à une unité d'organisation
   - Exemple : OU=Workstations

### Étape 3 : Forcer la mise à jour

Sur un PC test :
```powershell
gpupdate /force
```

Au prochain redémarrage, l'application sera installée automatiquement.

---

## Méthode 5 : Installation Portable (ZIP)

### Pour Clé USB ou Usage Nomade

1. **Extraire** `ColorExcel-0.1.0.zip` dans un dossier
   - Exemple : `D:\Applications\ColorExcel\`

2. **Lancer** `src\ColorExcel.exe`

3. **Créer un raccourci** (optionnel)
   - Clic droit sur `ColorExcel.exe` → Envoyer vers → Bureau (créer un raccourci)

**Note :** Le format portable ne nécessite aucune installation système.

---

## Gestion de la Sécurité

### SmartScreen et Signature

L'application est signée avec une **signature adhoc** (non officielle). Cela entraîne :

**Avertissement SmartScreen :**
> "Windows a protégé votre PC"

**Solution pour l'utilisateur :**
1. Cliquer sur "Informations complémentaires"
2. Cliquer sur "Exécuter quand même"

### Pour les IT : Contourner SmartScreen

#### Option 1 : Débloquer le fichier MSI

```powershell
Unblock-File -Path "ColorExcel-0.1.0.msi"
```

#### Option 2 : Désactiver SmartScreen via GPO (non recommandé)

```
Configuration ordinateur
└── Modèles d'administration
    └── Composants Windows
        └── Windows Defender SmartScreen
            └── Explorer : Configurer Windows Defender SmartScreen
                → Désactivé (pour ce package spécifiquement)
```

#### Option 3 : Whitelist via AppLocker

Créer une règle AppLocker basée sur le hash du fichier :

```powershell
# Obtenir le hash du MSI
Get-FileHash "ColorExcel-0.1.0.msi" -Algorithm SHA256
```

Ajouter le hash dans AppLocker pour autoriser l'exécution.

### Antivirus et Faux Positifs

Certains antivirus peuvent signaler l'application comme suspecte (faux positif).

**Solution :**
- Ajouter `C:\Program Files\ColorExcel\` aux exclusions
- Ou obtenir le hash et whitelist dans l'antivirus d'entreprise

---

## Vérification Post-Déploiement

### Vérifier l'Installation

```powershell
# Vérifier que l'application est installée
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
  Where-Object {$_.DisplayName -like "*ColorExcel*"}

# Vérifier la version
(Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
  Where-Object {$_.DisplayName -like "*ColorExcel*"}).DisplayVersion

# Vérifier que l'exécutable existe
Test-Path "C:\Program Files\ColorExcel\src\ColorExcel.exe"
```

### Tester le Lancement

```powershell
# Lancer l'application
Start-Process "C:\Program Files\ColorExcel\src\ColorExcel.exe"
```

---

## Désinstallation

### Méthode 1 : Interface Windows

1. **Ouvrir** Paramètres → Applications → Applications et fonctionnalités
2. **Rechercher** "ColorExcel"
3. **Cliquer** sur Désinstaller

### Méthode 2 : PowerShell Silencieux

```powershell
# Trouver le code produit
$app = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq "ColorExcel"}

# Désinstaller
$app.Uninstall()
```

### Méthode 3 : Script Fourni

```powershell
.\uninstall_colorexcel.ps1 -Silent
```

---

## Problèmes Courants

### Problème 1 : SmartScreen Bloque l'Installation

**Symptôme :** "Windows a protégé votre PC"

**Solution :**
- Cliquer sur "Informations complémentaires" → "Exécuter quand même"
- OU débloquer le MSI : `Unblock-File "ColorExcel-0.1.0.msi"`

### Problème 2 : Droits Administrateur Insuffisants

**Symptôme :** Erreur lors de l'installation

**Solution :**
- Clic droit sur le MSI → "Exécuter en tant qu'administrateur"
- OU utiliser le format ZIP (pas besoin d'admin)

### Problème 3 : Installation Échoue Sans Message

**Solution :**
- Créer un log détaillé :
  ```powershell
  msiexec /i "ColorExcel-0.1.0.msi" /l*v "C:\Temp\install.log"
  ```
- Consulter le log pour identifier l'erreur

### Problème 4 : L'Application ne Se Lance Pas

**Symptôme :** Rien ne se passe au clic

**Solution :**
- Vérifier les logs dans `C:\Users\<User>\AppData\Local\ColorExcel\Logs\`
- Réinstaller l'application
- Vérifier que Python 3.12 est bien inclus dans le package

### Problème 5 : Antivirus Bloque l'Exécution

**Symptôme :** L'antivirus met en quarantaine

**Solution :**
- Ajouter aux exclusions : `C:\Program Files\ColorExcel\`
- Signaler le faux positif à l'éditeur antivirus

---

## Codes de Retour MSI

| Code | Signification | Action |
|------|---------------|--------|
| 0 | Installation réussie | Aucune |
| 1602 | Annulé par l'utilisateur | Réessayer |
| 1603 | Erreur fatale | Vérifier les logs |
| 1618 | Installation déjà en cours | Attendre et réessayer |
| 1619 | Package non trouvé | Vérifier le chemin |
| 3010 | Redémarrage requis | Redémarrer le PC |

---

## Déploiement Avancé : SCCM / Intune

### SCCM (Microsoft Endpoint Configuration Manager)

1. Créer une application dans SCCM
2. Type de déploiement : Windows Installer (*.msi)
3. Ligne de commande d'installation :
   ```
   msiexec /i ColorExcel-0.1.0.msi /quiet /norestart
   ```
4. Ligne de commande de désinstallation :
   ```
   msiexec /x {CODE-PRODUIT} /quiet /norestart
   ```
5. Déployer sur une collection de PC

### Intune (Microsoft Endpoint Manager)

1. Applications → Ajouter → Application métier (LOB)
2. Télécharger le MSI
3. Configurer les informations de l'application
4. Affecter aux groupes d'utilisateurs/appareils
5. Déploiement automatique via Intune

---

## Support et Assistance

### Logs de Diagnostic

**Logs d'installation :**
- Générer avec : `msiexec /i ColorExcel-0.1.0.msi /l*v install.log`

**Logs d'exécution :**
- Emplacement : `C:\Users\<User>\AppData\Local\ColorExcel\Logs\`

### Contact

Pour toute question ou problème de déploiement :
- **Issues GitHub :** https://github.com/user/colorexcel/issues
- **Email :** user@example.com

---

## Checklist de Déploiement

- [ ] MSI copié sur partage réseau
- [ ] Droits de lecture configurés
- [ ] GPO créée et configurée (si applicable)
- [ ] Installation testée sur PC pilote
- [ ] SmartScreen contourné ou documentation fournie
- [ ] Antivirus configuré (exclusions si nécessaire)
- [ ] Formation utilisateurs prévue
- [ ] Documentation utilisateur distribuée
- [ ] Support IT préparé (FAQ, logs)
- [ ] Plan de désinstallation documenté

---

**Version du document :** 1.0
**Date :** 2026-01-29
**Application :** ColorExcel v0.1.0
