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

- Python >= 3.8 et < 3.13
- pip (gestionnaire de paquets Python)

## Installation

### Mode développement

1. Cloner le dépôt:
```bash
git clone https://github.com/user/colorexcel.git
cd colorexcel
```

2. Créer un environnement virtuel:
```bash
python -m venv venv
```

3. Activer l'environnement virtuel:
- Windows:
  ```bash
  venv\Scripts\activate
  ```
- macOS/Linux:
  ```bash
  source venv/bin/activate
  ```

4. Installer les dépendances:
```bash
pip install -e .
```

5. Installer Briefcase pour la génération d'applications:
```bash
pip install briefcase
```

## Utilisation

### Mode développement

Pour lancer l'application en mode développement:

```bash
briefcase dev
```

### Construction de l'application

#### Windows (génération MSI)

```bash
# Créer l'application
briefcase create windows

# Construire l'application
briefcase build windows

# Générer le package MSI
briefcase package windows --no-sign
```

Le fichier MSI sera généré dans le dossier `windows/`.

#### macOS

```bash
briefcase create macOS
briefcase build macOS
briefcase package macOS
```

#### Linux

```bash
briefcase create linux
briefcase build linux
briefcase package linux
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

### Exécuter les tests

```bash
pytest
```

### Formatage du code

```bash
black src/
```

### Vérification de la qualité du code

```bash
flake8 src/
mypy src/
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
