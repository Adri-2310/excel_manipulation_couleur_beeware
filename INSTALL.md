# Guide d'Installation et de Génération MSI

## Excel Color Manager - Application Beeware/Toga

Ce guide vous explique comment installer, tester et générer un exécutable MSI pour Windows.

---

## Prérequis

- **Python 3.8 à 3.12** (vérifié avec `python --version`)
- **Windows 10/11** (pour la génération MSI)
- **Git** (optionnel, pour le versioning)

---

## Étape 1: Créer l'environnement virtuel

Ouvrez PowerShell ou CMD dans le dossier du projet :

```bash
cd C:\Users\User\Documents\myCode\python\excel_manipulation_couleur_beeware
```

Créez un environnement virtuel :

```bash
python -m venv venv
```

Activez l'environnement virtuel :

**Sur Windows (CMD):**
```cmd
venv\Scripts\activate
```

**Sur Windows (PowerShell):**
```powershell
venv\Scripts\Activate.ps1
```

**Note:** Si vous avez une erreur d'exécution de scripts PowerShell, exécutez :
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## Étape 2: Installer Briefcase

Une fois l'environnement virtuel activé, installez Briefcase :

```bash
pip install --upgrade pip
pip install briefcase
```

Vérifiez l'installation :

```bash
briefcase --version
```

---

## Étape 3: Tester l'application en mode développement

Pour tester l'application sans créer d'exécutable :

```bash
briefcase dev
```

Cette commande :
- Installe automatiquement toutes les dépendances (toga, pandas, openpyxl)
- Lance l'application en mode développement
- Permet de voir les logs et erreurs en direct

**Testez l'interface :**
1. Choisissez un fichier Excel source (.xlsx ou .xls)
2. Sélectionnez une feuille source dans le dropdown
3. Choisissez un fichier Excel cible
4. Sélectionnez une feuille cible
5. Cliquez sur "Lancer le traitement"
6. Vérifiez que la barre de progression s'affiche
7. Enregistrez le fichier résultat avec "Enregistrer sous..."

---

## Étape 4: Créer l'application Windows

Pour créer une version Windows de l'application :

```bash
briefcase create windows
```

Cette commande :
- Crée un dossier `windows/` dans le projet
- Installe toutes les dépendances nécessaires
- Prépare la structure de l'application Windows

---

## Étape 5: Compiler l'application

Pour compiler l'application :

```bash
briefcase build windows
```

Cette commande compile l'application et prépare l'exécutable.

---

## Étape 6: Générer le fichier MSI

Pour créer un installateur MSI :

```bash
briefcase package windows --no-sign
```

**Options :**
- `--no-sign` : Ne pas signer l'installateur (nécessaire car nous n'avons pas de certificat de signature)

**Résultat :**

Le fichier MSI sera créé dans :
```
windows\Excel_Color_Manager-0.1.0.msi
```

---

## Étape 7: Installer l'application sur Windows

Double-cliquez sur le fichier `.msi` généré pour installer l'application.

L'application sera installée dans :
```
C:\Program Files\Excel Color Manager\
```

Un raccourci sera créé dans le menu Démarrer.

---

## Commandes utiles

### Nettoyer les builds précédents

```bash
briefcase clean windows
```

### Tester l'application empaquetée sans MSI

```bash
briefcase run windows
```

Cette commande lance l'application empaquetée directement sans créer de MSI.

### Mettre à jour l'application après modifications

Après avoir modifié le code source :

```bash
briefcase update windows
briefcase build windows
briefcase package windows --no-sign
```

### Voir les logs détaillés

Ajoutez `-v` ou `-vv` pour plus de verbosité :

```bash
briefcase dev -vv
briefcase build windows -v
```

---

## Dépannage

### Erreur "Python version not compatible"

Vérifiez que vous utilisez Python 3.8 à 3.12 :
```bash
python --version
```

### Erreur lors de l'installation de pandas ou openpyxl

Installez manuellement les dépendances :
```bash
pip install pandas openpyxl toga
```

### L'application ne se lance pas après installation

Vérifiez les logs dans :
```
C:\Users\<VotreNom>\AppData\Local\Excel Color Manager\Logs\
```

### Erreur "WiX Toolset not found" lors de la génération MSI

Briefcase téléchargera automatiquement WiX Toolset si nécessaire. Si l'erreur persiste, téléchargez et installez WiX manuellement depuis :
https://wixtoolset.org/

---

## Structure du projet

```
excel_manipulation_couleur_beeware/
├── src/
│   └── excel_color_manager/
│       ├── __init__.py
│       ├── __main__.py          # Interface Toga principale
│       ├── logic.py              # Logique métier Excel
│       └── resources/            # Icônes (optionnel)
├── pyproject.toml                # Configuration Briefcase
├── README.md                     # Documentation générale
├── INSTALL.md                    # Ce fichier
├── .gitignore                    # Fichiers à ignorer par Git
└── venv/                         # Environnement virtuel (créé par vous)
```

---

## Icônes personnalisées (optionnel)

Pour ajouter une icône personnalisée à l'application :

1. Créez ou obtenez une icône au format PNG (512x512 recommandé)
2. Placez-la dans `src/excel_color_manager/resources/`
3. Renommez-la `excel_color_manager.png`
4. Décommentez la ligne `icon` dans `pyproject.toml` :
   ```toml
   icon = "src/excel_color_manager/resources/excel_color_manager"
   ```
5. Recréez l'application : `briefcase create windows`

---

## Distribution

Pour distribuer l'application :

1. Partagez le fichier `.msi` généré
2. Les utilisateurs peuvent installer l'application en double-cliquant sur le `.msi`
3. Aucune installation de Python n'est requise sur la machine cible
4. Toutes les dépendances sont incluses dans l'installateur

---

## Support

Pour toute question ou problème :
- Vérifiez les logs de l'application
- Consultez la documentation Briefcase : https://briefcase.readthedocs.io/
- Consultez la documentation Toga : https://toga.readthedocs.io/

---

**Bon développement !**
