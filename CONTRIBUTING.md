# Guide de Contribution - ColorExcel

Merci de votre intérêt pour contribuer à ColorExcel ! Ce document explique comment participer au développement du projet.

---

## Table des Matières

- [Code de Conduite](#code-de-conduite)
- [Comment Contribuer](#comment-contribuer)
- [Configuration de l'Environnement](#configuration-de-lenvironnement)
- [Standards de Code](#standards-de-code)
- [Processus de Contribution](#processus-de-contribution)
- [Tests](#tests)
- [Documentation](#documentation)

---

## Code de Conduite

En participant à ce projet, vous acceptez de respecter les principes suivants :

- Être respectueux envers tous les contributeurs
- Accepter les critiques constructives
- Se concentrer sur ce qui est meilleur pour la communauté
- Faire preuve d'empathie envers les autres membres

---

## Comment Contribuer

Il existe plusieurs façons de contribuer au projet :

### Signaler des Bugs

1. **Vérifier** que le bug n'a pas déjà été signalé dans les [Issues](https://github.com/user/colorexcel/issues)
2. **Créer une nouvelle issue** en utilisant le template de bug report
3. **Inclure** :
   - Description claire du problème
   - Étapes pour reproduire
   - Comportement attendu vs observé
   - Version de l'application et du système d'exploitation
   - Logs si disponibles

### Proposer des Fonctionnalités

1. **Ouvrir une issue** décrivant la fonctionnalité proposée
2. **Expliquer** :
   - Le problème que cela résout
   - Comment cela devrait fonctionner
   - Exemples d'utilisation
3. **Attendre** le feedback avant de commencer l'implémentation

### Corriger des Bugs ou Implémenter des Fonctionnalités

1. **Commenter** l'issue pour indiquer que vous travaillez dessus
2. **Fork** le dépôt
3. **Créer une branche** pour votre travail
4. **Implémenter** vos modifications
5. **Soumettre** une Pull Request

---

## Configuration de l'Environnement

### Prérequis

- **Python** >= 3.10 (recommandé: 3.12)
- **uv** (gestionnaire de paquets)
- **Git**

### Installation

1. **Installer uv** :

   ```powershell
   # Windows
   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

   # macOS/Linux
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

2. **Cloner le dépôt** :

   ```bash
   git clone https://github.com/user/colorexcel.git
   cd colorexcel
   ```

3. **Créer l'environnement virtuel et installer les dépendances** :

   ```bash
   uv venv
   uv sync --all-extras
   ```

4. **Vérifier l'installation** :

   ```bash
   uv run briefcase dev
   ```

---

## Standards de Code

### Style Python

Nous suivons les conventions PEP 8 et utilisons les outils suivants :

#### Black (Formatage)

```bash
uv run black src/
```

**Configuration** : `line-length = 88` (définie dans `pyproject.toml`)

#### Flake8 (Linting)

```bash
uv run flake8 src/
```

**Configuration** : Voir `.flake8`

#### Mypy (Type Checking)

```bash
uv run mypy src/
```

**Configuration** : Voir `[tool.mypy]` dans `pyproject.toml`

### Conventions de Nommage

- **Variables et fonctions** : `snake_case`
- **Classes** : `PascalCase`
- **Constantes** : `UPPER_SNAKE_CASE`
- **Fichiers** : `snake_case.py`

### Type Hints

Tous les nouveaux code doivent inclure des type hints :

```python
def apply_colors(source_file: str, target_file: str) -> None:
    """Apply colors from source to target file."""
    pass
```

### Docstrings

Utilisez le format Google pour les docstrings :

```python
def my_function(param1: str, param2: int) -> bool:
    """
    Short description of the function.

    Longer description if needed, explaining the context
    and any important details.

    Args:
        param1: Description of param1
        param2: Description of param2

    Returns:
        Description of the return value

    Raises:
        ValueError: When param2 is negative
    """
    pass
```

### Gestion des Erreurs

- **Utiliser des exceptions spécifiques** plutôt que `Exception`
- **Documenter** les exceptions levées dans les docstrings
- **Logger** les erreurs avec le niveau approprié

```python
# Mauvais
try:
    do_something()
except Exception:
    pass

# Bon
try:
    do_something()
except FileNotFoundError as e:
    logger.error(f"File not found: {e}")
    raise
```

---

## Processus de Contribution

### 1. Fork et Branche

```bash
# Fork le dépôt sur GitHub, puis :
git clone https://github.com/VOTRE-USERNAME/colorexcel.git
cd colorexcel

# Créer une branche pour votre travail
git checkout -b feature/ma-nouvelle-fonctionnalite
# ou
git checkout -b fix/correction-bug-xyz
```

### 2. Développement

- **Faites des commits atomiques** (un commit = une modification logique)
- **Écrivez des messages de commit clairs** :

  ```
  Add color validation for hex codes

  - Implement hex_to_rgb validation
  - Add tests for invalid formats
  - Update documentation
  ```

- **Testez votre code** régulièrement

### 3. Tests

Avant de soumettre une PR :

```bash
# Exécuter tous les tests
uv run pytest

# Vérifier la couverture
uv run pytest --cov=src/colorexcel

# Formater le code
uv run black src/

# Vérifier le style
uv run flake8 src/

# Vérifier les types
uv run mypy src/
```

### 4. Pull Request

1. **Pusher** votre branche :

   ```bash
   git push origin feature/ma-nouvelle-fonctionnalite
   ```

2. **Créer une Pull Request** sur GitHub

3. **Remplir le template** de PR avec :
   - Description des modifications
   - Type de changement (bug fix, feature, etc.)
   - Tests effectués
   - Screenshots si applicable
   - Issues liées (fixes #123)

4. **Attendre la review** :
   - Répondre aux commentaires
   - Effectuer les modifications demandées
   - Pousser les updates (ils apparaîtront automatiquement dans la PR)

### 5. Review et Merge

- Les maintainers vont **review** votre code
- Des **modifications** peuvent être demandées
- Une fois approuvée, votre PR sera **mergée**

---

## Tests

### Structure des Tests

```
tests/
├── __init__.py
├── test_logic.py        # Tests pour logic.py
├── test_app.py          # Tests pour __main__.py
└── fixtures/            # Fichiers Excel de test
    ├── source.xlsx
    └── target.xlsx
```

### Écrire des Tests

```python
import pytest
from colorexcel.logic import hex_to_rvb

def test_hex_to_rvb_valid():
    """Test conversion of valid hex color."""
    result = hex_to_rvb("FF0000")
    assert result == (255, 0, 0)

def test_hex_to_rvb_with_alpha():
    """Test conversion with alpha prefix."""
    result = hex_to_rvb("FFFF0000")
    assert result == (255, 0, 0)

def test_hex_to_rvb_invalid():
    """Test handling of invalid hex code."""
    result = hex_to_rvb("invalid")
    assert result is None
```

### Exécuter les Tests

```bash
# Tous les tests
uv run pytest

# Un fichier spécifique
uv run pytest tests/test_logic.py

# Une fonction spécifique
uv run pytest tests/test_logic.py::test_hex_to_rvb_valid

# Avec verbosité
uv run pytest -v

# Avec couverture
uv run pytest --cov=src/colorexcel --cov-report=html
```

---

## Documentation

### Mettre à Jour la Documentation

Si vos modifications affectent l'utilisation de l'application :

1. **Mettre à jour** le README.md
2. **Mettre à jour** docs/USER_GUIDE.md ou docs/INSTALL.md
3. **Ajouter** une entrée dans CHANGELOG.md

### Format Markdown

- Utiliser des **titres clairs** avec `#`, `##`, `###`
- **Code inline** avec \`backticks\`
- **Blocs de code** avec triple backticks et langage :

  ````markdown
  ```python
  print("Hello")
  ```
  ````

- **Liens** : `[Texte](URL)`
- **Images** : `![Alt text](path/to/image.png)`

---

## Questions et Support

Si vous avez des questions :

- **Issues** : Ouvrez une issue avec le label `question`
- **Discussions** : Utilisez la section Discussions de GitHub
- **Email** : user@example.com

---

## Remerciements

Merci à tous les contributeurs qui aident à améliorer ColorExcel ! 🎉

### Liste des Contributeurs

Voir [CONTRIBUTORS.md](CONTRIBUTORS.md) pour la liste complète.

---

## Licence

En contribuant à ColorExcel, vous acceptez que vos contributions soient licenciées sous la licence MIT du projet.
