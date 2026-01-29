# Changelog

Tous les changements notables de ce projet seront documentés dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

---

## [Non publié]

### Ajouté
- Migration vers `uv` pour la gestion des dépendances
- Documentation de déploiement en entreprise consolidée
- Guide de contribution (CONTRIBUTING.md)
- Standards de code et constantes extraites

### Modifié
- Réorganisation de la documentation dans `docs/`
- Amélioration du code (suppression imports inutilisés, correction bugs)
- Mise à jour .gitignore pour couvrir tous les fichiers temporaires

### Corrigé
- Bug dans `hex_to_rvb` : variable `v` au lieu de `g` pour green

---

## [0.1.0] - 2026-01-29

### Ajouté
- Interface graphique avec Beeware/Toga
- Sélection de fichiers Excel source et cible
- Sélection de feuilles via menu déroulant
- Copie des couleurs de fond entre feuilles Excel
- Barre de progression pendant le traitement
- Export avec nouveau nom de fichier
- Support des formats .xlsx et .xls
- Logs détaillés pour le débogage
- Build MSI pour Windows
- Scripts PowerShell de déploiement

### Fonctionnalités
- **Copie de couleurs** : Transfère les couleurs de fond d'une feuille source vers une feuille cible
- **Correspondance intelligente** : Match basé sur les colonnes Implantation, Nom, Prénom
- **Préservation des données** : Les données et formules du fichier cible restent intactes
- **Interface intuitive** : Sélection simple avec boutons et menus déroulants

### Technologies
- Python 3.12
- Toga 0.5.3 (Framework UI)
- pandas 2.3.3 (Manipulation de données)
- openpyxl 3.1.5 (Lecture/écriture Excel)
- Briefcase 0.3.26 (Packaging)

### Limitations Connues
- Seules les couleurs de fond sont copiées (pas les bordures ni polices)
- Nécessite des colonnes exactes : Implantation, Nom, Prénom
- Formats Excel uniquement (.xlsx, .xls)

---

## [Futur] - Fonctionnalités Prévues

### v0.2.0 - Améliorations UI
- [ ] Glisser-déposer de fichiers
- [ ] Prévisualisation des couleurs avant traitement
- [ ] Historique des fichiers récents
- [ ] Thèmes de l'interface (clair/sombre)

### v0.3.0 - Fonctionnalités Avancées
- [ ] Copie des bordures et polices
- [ ] Sélection de colonnes de correspondance personnalisée
- [ ] Support des fichiers CSV
- [ ] Traitement par lot (plusieurs fichiers)

### v0.4.0 - Performance et Qualité
- [ ] Tests unitaires complets (>80% couverture)
- [ ] Gestion d'erreurs améliorée
- [ ] Optimisation des performances (fichiers volumineux)
- [ ] Documentation API complète

### v1.0.0 - Version Stable
- [ ] Support multilingue (FR/EN)
- [ ] Signature officielle du MSI
- [ ] Support macOS et Linux complet
- [ ] Plugin Excel (optionnel)

---

## Types de Changements

- `Ajouté` : pour les nouvelles fonctionnalités
- `Modifié` : pour les changements dans les fonctionnalités existantes
- `Déprécié` : pour les fonctionnalités qui seront supprimées dans les prochaines versions
- `Supprimé` : pour les fonctionnalités supprimées
- `Corrigé` : pour les corrections de bugs
- `Sécurité` : en cas de vulnérabilités

---

## Notes de Version

### Migration vers uv (2026-01-29)

Le projet utilise maintenant `uv` au lieu de `pip` et `venv` standard. Cela apporte :
- ⚡ Installation 10-100x plus rapide
- 🔒 Reproductibilité garantie via `uv.lock`
- 🎯 Gestion simplifiée des environnements

**Pour migrer :**
```bash
# Supprimer l'ancien venv
rm -rf venv/

# Installer avec uv
uv venv
uv sync --all-extras
```

### Réorganisation Documentation (2026-01-29)

La documentation a été réorganisée pour plus de clarté :
- `docs/INSTALL.md` : Installation pour développeurs
- `docs/USER_GUIDE.md` : Guide utilisateur final
- `docs/DEPLOYMENT.md` : Déploiement en entreprise (fusion de 2 fichiers redondants)

---

## Contributeurs

- User (@user) - Développeur principal
- Claude Sonnet 4.5 - Assistant de développement

---

[Non publié]: https://github.com/user/colorexcel/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/user/colorexcel/releases/tag/v0.1.0
