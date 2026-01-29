# Guide d'Installation et de Génération MSI

## ColorExcel - Application Beeware/Toga

Ce guide vous explique comment installer, tester et générer un exécutable MSI pour Windows.

---

## Prérequis

- **Python >= 3.10** (recommandé: 3.12, vérifié avec `python --version`)
- **uv** (gestionnaire de paquets et environnements ultra-rapide)
- **Windows 10/11** (pour la génération MSI)
- **Git** (optionnel, pour le versioning)

---

## Étape 0: Installer uv (si pas déjà installé)

Ouvrez PowerShell et exécutez :

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Vérifiez l'installation :
```powershell
uv --version
```

Vous devriez voir quelque chose comme : `uv 0.9.27`

---

## Étape 1: Créer l'environnement virtuel et installer les dépendances

Ouvrez PowerShell dans le dossier du projet :

```powershell
cd C:\Users\User\Documents\myCode\python\excel_manipulation_couleur_beeware
```

Créez l'environnement virtuel et installez toutes les dépendances en une seule commande :

```powershell
uv venv
uv sync --all-extras
```

`uv` va automatiquement :
- Créer un environnement virtuel `.venv`
- Installer Python si nécessaire
- Installer toutes les dépendances (toga, pandas, openpyxl, briefcase, pytest, etc.)

Vérifiez l'installation :

```powershell
uv run briefcase --version
```

Vous devriez voir : `0.3.26`

---

## Étape 2: Tester l'application en mode développement

Pour tester l'application sans créer d'exécutable :

```powershell
uv run briefcase dev
```

Ou utilisez le script fourni :
```powershell
.\run.ps1
```

Cette commande :
- Lance l'application en mode développement
- Permet de voir les logs et erreurs en direct
- Utilise l'environnement virtuel géré par `uv`

**Testez l'interface :**
1. Choisissez un fichier Excel source (.xlsx ou .xls)
2. Sélectionnez une feuille source dans le dropdown
3. Choisissez un fichier Excel cible
4. Sélectionnez une feuille cible
5. Cliquez sur "Lancer le traitement"
6. Vérifiez que la barre de progression s'affiche
7. Enregistrez le fichier résultat avec "Enregistrer sous..."

---

## Étape 3: Créer l'application Windows

Pour créer une version Windows de l'application :

```powershell
uv run briefcase create windows
```

Cette commande :
- Crée un dossier `build/` dans le projet
- Installe toutes les dépendances nécessaires
- Prépare la structure de l'application Windows

---

## Étape 4: Compiler l'application

Pour compiler l'application :

```powershell
uv run briefcase build windows
```

Cette commande compile l'application et prépare l'exécutable.

---

## Étape 5: Générer le fichier MSI

Pour créer un installateur MSI :

```powershell
uv run briefcase package windows --no-sign
```

**Options :**
- `--no-sign` : Pas de signature (utilisé car nous n'avons pas de certificat de signature)
- `--adhoc-sign` : Alternative avec signature adhoc

**Résultat :**

Le fichier MSI sera créé dans :
```
dist\ColorExcel-0.1.0.msi
```

---

## Étape 6: Installer l'application sur Windows

Double-cliquez sur le fichier `.msi` généré pour installer l'application.

L'application sera installée dans :
```
C:\Program Files\ColorExcel\
```

Un raccourci sera créé dans le menu Démarrer.

---

## Commandes utiles

### Nettoyer les builds précédents

```powershell
uv run briefcase clean windows
```

### Tester l'application empaquetée sans MSI

```powershell
uv run briefcase run windows
```

Cette commande lance l'application empaquetée directement sans créer de MSI.

### Mettre à jour l'application après modifications

Après avoir modifié le code source :

```powershell
uv run briefcase update windows
uv run briefcase build windows
uv run briefcase package windows --no-sign
```

### Voir les logs détaillés

Ajoutez `-v` ou `-vv` pour plus de verbosité :

```powershell
uv run briefcase dev -vv
uv run briefcase build windows -v
```

### Ajouter une nouvelle dépendance au projet

```powershell
# Dépendance de production
uv add nom-du-package

# Dépendance de développement
uv add --dev nom-du-package

# Synchroniser l'environnement
uv sync
```

---

## Dépannage

### Erreur "Python version not compatible"

Vérifiez que vous utilisez Python >= 3.10 :
```powershell
uv run python --version
```

`uv` peut installer automatiquement la bonne version de Python si nécessaire.

### Erreur lors de l'installation de pandas ou openpyxl

Essayez de resynchroniser les dépendances :
```powershell
uv sync --reinstall
```

Ou installez manuellement une dépendance spécifique :
```powershell
uv add pandas openpyxl toga
```

### L'application ne se lance pas après installation

Vérifiez les logs dans :
```
C:\Users\<VotreNom>\AppData\Local\ColorExcel\Logs\
```

### Erreur "WiX Toolset not found" lors de la génération MSI

Briefcase téléchargera automatiquement WiX Toolset si nécessaire. Si l'erreur persiste, téléchargez et installez WiX manuellement depuis :
https://wixtoolset.org/

---

## Structure du projet

```
excel_manipulation_couleur_beeware/
├── src/
│   └── colorexcel/
│       ├── __init__.py
│       ├── __main__.py          # Interface Toga principale
│       ├── logic.py              # Logique métier Excel
│       └── resources/            # Icônes et ressources
├── pyproject.toml                # Configuration du projet (dépendances, Briefcase)
├── uv.lock                       # Fichier de verrouillage des dépendances
├── README.md                     # Documentation générale
├── INSTALL.md                    # Ce fichier
├── run.ps1                       # Script de lancement rapide
├── .gitignore                    # Fichiers à ignorer par Git
├── .venv/                        # Environnement virtuel (créé par uv)
├── build/                        # Builds de l'application
└── dist/                         # Packages MSI générés
```

---

## Icônes personnalisées (optionnel)

Pour ajouter une icône personnalisée à l'application :

1. Créez ou obtenez une icône au format PNG (512x512 recommandé)
2. Placez-la dans `src/colorexcel/resources/`
3. Renommez-la `colorexcel.png`
4. Décommentez la ligne `icon` dans `pyproject.toml` :
   ```toml
   icon = "src/colorexcel/resources/colorexcel"
   ```
5. Recréez l'application : `uv run briefcase create windows`

---

## Pourquoi utiliser `uv` ?

`uv` est un gestionnaire de paquets et d'environnements Python ultra-rapide (écrit en Rust) qui offre :

- **Performance** : 10-100x plus rapide que `pip` pour l'installation de paquets
- **Simplicité** : Une seule commande `uv sync` installe tout
- **Reproductibilité** : Le fichier `uv.lock` garantit des installations identiques
- **Gestion Python** : `uv` peut installer Python automatiquement si nécessaire
- **Compatibilité** : Fonctionne parfaitement avec `pyproject.toml` et les outils standards

**Comparaison :**

| Opération | Méthode classique | Avec uv |
|-----------|------------------|---------|
| Créer venv + installer | `python -m venv venv` + `pip install -e ".[dev]"` | `uv venv` + `uv sync --all-extras` |
| Lancer l'app | Activer venv + `briefcase dev` | `uv run briefcase dev` |
| Ajouter un package | Activer venv + `pip install` + éditer `pyproject.toml` | `uv add package-name` |

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
