# Guide Utilisateur - ColorExcel

## Installation Simple (Pour Utilisateurs)

### Vous avez reçu un fichier `.msi` ?

1. **Double-cliquez** sur le fichier `ColorExcel-0.1.0.msi`

2. **Un message de sécurité apparaît ?**
   - Cliquez sur **"Informations complémentaires"**
   - Puis cliquez sur **"Exécuter quand même"**

3. **Autorisation administrateur**
   - Cliquez sur **"Oui"** quand Windows demande l'autorisation

4. **Suivez l'assistant d'installation**
   - Cliquez sur **"Suivant"**
   - Acceptez les termes
   - Cliquez sur **"Installer"**

5. **C'est terminé !**
   - Recherchez **"ColorExcel"** dans le menu Démarrer

---

### Vous avez reçu un fichier `.zip` ?

1. **Faites un clic droit** sur le fichier `ColorExcel-0.1.0.zip`

2. **Sélectionnez** "Extraire tout..."

3. **Choisissez un dossier** (par exemple : `C:\Apps\ColorExcel`)

4. **Ouvrez le dossier extrait**

5. **Allez dans le sous-dossier** `src`

6. **Double-cliquez sur** `ColorExcel.exe`

7. **Optionnel : Créer un raccourci**
   - Clic droit sur `ColorExcel.exe`
   - "Envoyer vers" → "Bureau (créer un raccourci)"

---

## Utilisation de l'Application

### 1. Lancement
- **Menu Démarrer** → Recherchez **"ColorExcel"**
- Ou double-cliquez sur l'icône du Bureau (si créée)

### 2. Interface Principale

L'application vous permet de copier les couleurs d'un fichier Excel vers un autre.

#### Étape 1 : Choisir le fichier source
- Cliquez sur **"Parcourir"** à côté de "Fichier Excel source"
- Sélectionnez le fichier Excel qui contient les couleurs à copier

#### Étape 2 : Sélectionner la feuille source
- Dans le menu déroulant, choisissez la feuille Excel source

#### Étape 3 : Choisir le fichier cible
- Cliquez sur **"Parcourir"** à côté de "Fichier Excel cible"
- Sélectionnez le fichier Excel qui recevra les couleurs

#### Étape 4 : Sélectionner la feuille cible
- Dans le menu déroulant, choisissez la feuille Excel cible

#### Étape 5 : Lancer le traitement
- Cliquez sur le bouton **"Lancer le traitement"**
- Une barre de progression s'affiche

#### Étape 6 : Enregistrer le résultat
- Cliquez sur **"Enregistrer sous..."**
- Choisissez le nom et l'emplacement du fichier résultat
- Cliquez sur **"Enregistrer"**

### 3. Conseils d'utilisation

✅ **Formats acceptés :**
- `.xlsx` (Excel 2007 et plus récent)
- `.xls` (Excel 97-2003)

✅ **Bonnes pratiques :**
- Sauvegardez vos fichiers originaux avant traitement
- Vérifiez que les feuilles source et cible ont la même structure
- Le traitement copie les couleurs de fond de cellule

⚠️ **Limitations :**
- Les fichiers source et cible doivent avoir le même nombre de colonnes
- Seules les couleurs de fond sont copiées (pas les bordures ou polices)

---

## Désinstallation

### Méthode 1 : Via Windows

1. **Ouvrez les Paramètres Windows**
   - Touche Windows + I

2. **Allez dans Applications**

3. **Recherchez** "ColorExcel"

4. **Cliquez sur** "Désinstaller"

5. **Confirmez** la désinstallation

### Méthode 2 : Via le Panneau de Configuration

1. **Panneau de configuration** → **Programmes** → **Programmes et fonctionnalités**

2. **Trouvez** "ColorExcel" dans la liste

3. **Clic droit** → **Désinstaller**

---

## Problèmes Courants

### L'application ne démarre pas

**Solution 1 : Vérifiez qu'elle est bien installée**
- Menu Démarrer → Recherchez "ColorExcel"
- Si absent, réinstallez l'application

**Solution 2 : Redémarrez votre ordinateur**
- Parfois nécessaire après l'installation

### Message "Fichier corrompu" ou "Erreur d'ouverture"

**Vérifiez que votre fichier Excel est valide :**
- Ouvrez le fichier dans Excel pour confirmer qu'il fonctionne
- Le fichier ne doit pas être protégé par un mot de passe
- Le fichier ne doit pas être ouvert dans Excel pendant le traitement

### Le traitement ne fonctionne pas

**Vérifications :**
- Les deux fichiers sont bien au format Excel (.xlsx ou .xls)
- Les feuilles sélectionnées existent
- Les fichiers ne sont pas ouverts ailleurs
- Vous avez les droits d'écriture sur le dossier de destination

### Message "Accès refusé"

**Cause :** Le fichier est ouvert dans Excel ou protégé en écriture

**Solution :**
- Fermez Excel complètement
- Vérifiez les permissions du fichier
- Essayez d'enregistrer dans un autre dossier (ex: Bureau)

---

## Caractéristiques Techniques

- **Version :** 0.1.0
- **Formats supportés :** .xlsx, .xls
- **Système requis :** Windows 10/11
- **Installation :** Aucun logiciel supplémentaire requis (Python inclus)
- **Taille :** ~33 Mo (MSI) ou ~41 Mo (ZIP)

---

## Besoin d'Aide ?

### Logs de l'application

En cas d'erreur, les logs peuvent aider au diagnostic :

**Emplacement des logs :**
```
C:\Users\[VotreNom]\AppData\Local\ColorExcel\Logs\
```

**Pour y accéder rapidement :**
1. Appuyez sur **Windows + R**
2. Tapez : `%LOCALAPPDATA%\ColorExcel\Logs`
3. Appuyez sur **Entrée**

### Contacter le Support

Fournissez ces informations :
- Version de Windows (Windows 10 ou 11)
- Description du problème
- Message d'erreur exact (si affiché)
- Fichier de log (si disponible)

---

## Foire Aux Questions (FAQ)

### Q : L'application nécessite-t-elle une connexion Internet ?
**R :** Non, l'application fonctionne 100% hors ligne.

### Q : Mes données sont-elles envoyées quelque part ?
**R :** Non, toutes les opérations sont locales sur votre PC.

### Q : Puis-je utiliser l'application sur plusieurs PC ?
**R :** Oui, installez-la sur chaque PC ou utilisez la version ZIP portable.

### Q : L'application modifie-t-elle mes fichiers originaux ?
**R :** Non, vous enregistrez toujours un nouveau fichier. Vos originaux restent intacts.

### Q : Quels types de couleurs sont copiées ?
**R :** Les couleurs de fond des cellules (background color).

### Q : Les formules Excel sont-elles copiées ?
**R :** Non, seules les couleurs sont copiées. Les formules et données restent inchangées.

### Q : Puis-je traiter plusieurs feuilles à la fois ?
**R :** Non, le traitement se fait feuille par feuille. Répétez l'opération pour chaque feuille.

---

**Bonne utilisation de ColorExcel !**
