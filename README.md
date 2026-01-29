# ColorExcel

Application de manipulation de couleurs dans fichiers Excel développée avec Beeware/Toga.

## Description

ColorExcel est une application de bureau multiplateforme qui permet de manipuler les couleurs dans les fichiers Excel de manière intuitive. Développée avec le framework Beeware et la bibliothèque Toga, elle offre une interface graphique native sur Windows, macOS et Linux.

## Fonctionnalités

- Interface graphique native multiplateforme
- Sélection de fichiers Excel (.xlsx, .xls)
- Manipulation des couleurs dans les cellules Excel
- Support de pandas et openpyxl pour le traitement des données

## Prérequis

- Python >= 3.10 (recommandé: 3.12)
- uv (gestionnaire de paquets et environnements ultra-rapide)

### Installation de uv

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Installation

### Mode développement

1. Cloner le dépôt:
```bash
git clone https://github.com/user/colorexcel.git
cd colorexcel
```

2. Créer l'environnement virtuel et installer toutes les dépendances:
```bash
uv venv
uv sync --all-extras
```

C'est tout ! `uv` gère automatiquement l'environnement virtuel et toutes les dépendances (production + développement).

## Utilisation

### Mode développement

Pour lancer l'application en mode développement:

```bash
uv run briefcase dev
```

Ou utilisez le script PowerShell fourni:
```powershell
.\run.ps1
```

### Construction de l'application

#### Windows (génération MSI)

```bash
# Créer l'application
uv run briefcase create windows

# Construire l'application
uv run briefcase build windows

# Générer le package MSI
uv run briefcase package windows --no-sign
```

Le fichier MSI sera généré dans le dossier `dist/`.

#### macOS

```bash
uv run briefcase create macOS
uv run briefcase build macOS
uv run briefcase package macOS
```

#### Linux

```bash
uv run briefcase create linux
uv run briefcase build linux
uv run briefcase package linux
```

## Structure du projet

```
excel_manipulation_couleur_beeware/
├── src/
│   └── colorexcel/
│       ├── __init__.py
│       ├── __main__.py
│       └── resources/
├── tests/
├── pyproject.toml
├── README.md
└── .gitignore
```

## Dépendances principales

- **toga** (>=0.4.0): Framework pour créer des interfaces graphiques natives
- **pandas** (>=2.0.0): Manipulation de données
- **openpyxl** (>=3.1.0): Lecture et écriture de fichiers Excel

## Développement

### Ajouter une nouvelle dépendance

```bash
# Dépendance de production
uv add nom-du-package

# Dépendance de développement
uv add --dev nom-du-package
```

### Exécuter les tests

```bash
uv run pytest
```

### Formatage du code

```bash
uv run black src/
```

### Vérification de la qualité du code

```bash
uv run flake8 src/
uv run mypy src/
```

### Mettre à jour les dépendances

```bash
uv sync
```

## Licence

MIT License - voir le fichier LICENSE pour plus de détails.

## Auteur

User

## Contribution

Les contributions sont les bienvenues! N'hésitez pas à ouvrir une issue ou une pull request.

## Support

Pour toute question ou problème, veuillez ouvrir une issue sur GitHub.

## Roadmap

- [ ] Implémentation de la lecture des fichiers Excel
- [ ] Interface pour visualiser les couleurs des cellules
- [ ] Outils de modification des couleurs
- [ ] Export des modifications
- [ ] Support des thèmes de couleurs
- [ ] Historique des modifications
- [ ] Prévisualisation en temps réel

## Changelog

### Version 0.1.0 (Initial Release)

- Structure initiale du projet
- Interface graphique de base
- Sélection de fichiers Excel
