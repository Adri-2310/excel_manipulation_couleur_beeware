#!/bin/bash
# Script Bash pour générer l'exécutable MSI
# Excel Color Manager - Build Script

echo "====================================="
echo "  Excel Color Manager - Build MSI   "
echo "====================================="
echo ""

# Vérifier que Python est installé
echo "Vérification de Python..."
if ! command -v python &> /dev/null; then
    echo "ERREUR: Python n'est pas installé ou pas dans le PATH"
    exit 1
fi

pythonVersion=$(python --version 2>&1)
echo "Python trouvé: $pythonVersion"

# Vérifier la version de Python
if [[ $pythonVersion =~ Python\ ([0-9]+)\.([0-9]+) ]]; then
    major=${BASH_REMATCH[1]}
    minor=${BASH_REMATCH[2]}

    if [ $major -lt 3 ] || ([ $major -eq 3 ] && [ $minor -lt 8 ]) || [ $major -gt 3 ] || ([ $major -eq 3 ] && [ $minor -ge 13 ]); then
        echo "ERREUR: Python $major.$minor n'est pas supporté"
        echo "Veuillez installer Python 3.8 à 3.12"
        exit 1
    fi
fi
echo ""

# Créer l'environnement virtuel si nécessaire
if [ ! -d "venv" ]; then
    echo "Création de l'environnement virtuel..."
    python -m venv venv
    if [ $? -ne 0 ]; then
        echo "ERREUR: Impossible de créer l'environnement virtuel"
        exit 1
    fi
    echo "Environnement virtuel créé avec succès"
fi
echo ""

# Activer l'environnement virtuel
echo "Activation de l'environnement virtuel..."
source venv/Scripts/activate

# Installer Briefcase
echo "Installation de Briefcase..."
pip install --upgrade pip
pip install briefcase
if [ $? -ne 0 ]; then
    echo "ERREUR: Impossible d'installer Briefcase"
    exit 1
fi
echo "Briefcase installé avec succès"
echo ""

# Menu de choix
echo "Que voulez-vous faire?"
echo "1. Tester l'application (briefcase dev)"
echo "2. Créer l'application Windows (briefcase create)"
echo "3. Compiler l'application (briefcase build)"
echo "4. Générer le MSI (briefcase package)"
echo "5. Tout faire (create + build + package)"
echo "0. Quitter"
echo ""

read -p "Votre choix: " choice

case $choice in
    1)
        echo ""
        echo "Lancement de l'application en mode développement..."
        briefcase dev
        ;;
    2)
        echo ""
        echo "Création de l'application Windows..."
        briefcase create windows
        ;;
    3)
        echo ""
        echo "Compilation de l'application..."
        briefcase build windows
        ;;
    4)
        echo ""
        echo "Génération du MSI..."
        briefcase package windows --no-sign
        echo ""
        echo "Le fichier MSI a été créé dans le dossier windows/"
        ;;
    5)
        echo ""
        echo "Création de l'application Windows..."
        briefcase create windows
        if [ $? -eq 0 ]; then
            echo ""
            echo "Compilation de l'application..."
            briefcase build windows
            if [ $? -eq 0 ]; then
                echo ""
                echo "Génération du MSI..."
                briefcase package windows --no-sign
                echo ""
                echo "Le fichier MSI a été créé dans le dossier windows/"
            fi
        fi
        ;;
    0)
        echo "Au revoir!"
        exit 0
        ;;
    *)
        echo "Choix invalide"
        exit 1
        ;;
esac

echo ""
echo "Terminé!"
