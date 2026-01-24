"""
Point d'entrée principal de l'application ColorExcel.
"""

import toga
from toga.style import Pack
from toga.style.pack import COLUMN, ROW
import logging
import asyncio
from pathlib import Path

from .logic import get_sheet_names, apply_colors_to_file2

# Configuration du logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class ColorExcel(toga.App):
    """
    Application principale ColorExcel.

    Cette classe représente l'application Beeware/Toga qui permet
    de manipuler les couleurs dans les fichiers Excel.
    """

    def startup(self):
        """
        Construit et affiche l'interface graphique de l'application.

        Cette méthode est appelée automatiquement au démarrage de l'application.
        """
        # Initialisation des variables d'état
        self.source_file_path = None
        self.source_sheet_name = None
        self.target_file_path = None
        self.target_sheet_name = None
        self.processed_file_path = None

        # Conteneur principal
        main_box = toga.Box(style=Pack(direction=COLUMN, margin=10))

        # Titre de l'application
        title_label = toga.Label(
            "Manipulation de fichiers Excel",
            style=Pack(margin=(0, 10), font_size=22, font_weight="bold"),
        )

        # Divider après le titre
        divider1 = toga.Divider(style=Pack(margin=(5, 0)))

        # Section Fichier Source
        source_section_label = toga.Label(
            "Fichier Source",
            style=Pack(margin=(10, 5), font_size=16, font_weight="bold"),
        )

        self.source_button = toga.Button(
            "Choisir fichier source",
            on_press=self.select_source_file,
            style=Pack(margin=5),
        )

        self.source_file_label = toga.Label(
            "Aucun fichier sélectionné", style=Pack(margin=(0, 5), font_style="italic")
        )

        # Selection dropdown pour la feuille source (initialement caché)
        self.source_sheet_box = toga.Box(style=Pack(direction=COLUMN, margin=(5, 0)))
        source_sheet_label = toga.Label("Feuille source:", style=Pack(margin=(5, 5)))
        self.source_sheet_selection = toga.Selection(
            on_change=self.on_source_sheet_change, style=Pack(margin=5, flex=1)
        )
        self.source_sheet_box.add(source_sheet_label)
        self.source_sheet_box.add(self.source_sheet_selection)

        # Divider après la section source
        divider2 = toga.Divider(style=Pack(margin=(10, 0)))

        # Section Fichier Cible
        target_section_label = toga.Label(
            "Fichier Cible",
            style=Pack(margin=(10, 5), font_size=16, font_weight="bold"),
        )

        self.target_button = toga.Button(
            "Choisir fichier cible",
            on_press=self.select_target_file,
            style=Pack(margin=5),
        )

        self.target_file_label = toga.Label(
            "Aucun fichier sélectionné", style=Pack(margin=(0, 5), font_style="italic")
        )

        # Selection dropdown pour la feuille cible (initialement caché)
        self.target_sheet_box = toga.Box(style=Pack(direction=COLUMN, margin=(5, 0)))
        target_sheet_label = toga.Label("Feuille cible:", style=Pack(margin=(5, 5)))
        self.target_sheet_selection = toga.Selection(
            on_change=self.on_target_sheet_change, style=Pack(margin=5, flex=1)
        )
        self.target_sheet_box.add(target_sheet_label)
        self.target_sheet_box.add(self.target_sheet_selection)

        # Divider avant le bouton de traitement
        divider3 = toga.Divider(style=Pack(margin=(10, 0)))

        # Bouton "Lancer le traitement" (initialement désactivé)
        self.process_button = toga.Button(
            "Lancer le traitement",
            on_press=self.start_processing,
            enabled=False,
            style=Pack(margin=10),
        )

        # Barre de progression (initialement cachée)
        self.progress_box = toga.Box(style=Pack(direction=COLUMN, margin=(10, 0)))
        self.progress_bar = toga.ProgressBar(
            max=None, style=Pack(margin=5, flex=1)  # Mode indéterminé
        )
        progress_label = toga.Label(
            "Traitement en cours...", style=Pack(margin=(0, 5), text_align="center")
        )
        self.progress_box.add(progress_label)
        self.progress_box.add(self.progress_bar)

        # Message de résultat (initialement caché)
        self.result_box = toga.Box(style=Pack(direction=COLUMN, margin=(10, 0)))
        self.result_label = toga.Label(
            "", style=Pack(margin=5, text_align="center", font_weight="bold")
        )
        self.result_box.add(self.result_label)

        # Boutons post-traitement (initialement cachés)
        self.post_process_box = toga.Box(style=Pack(direction=ROW, margin=(10, 0)))
        self.save_as_button = toga.Button(
            "Enregistrer sous...",
            on_press=self.save_as_file,
            style=Pack(margin=5, flex=1),
        )
        self.new_process_button = toga.Button(
            "Nouveau traitement",
            on_press=self.reset_interface,
            style=Pack(margin=5, flex=1),
        )
        self.post_process_box.add(self.save_as_button)
        self.post_process_box.add(self.new_process_button)

        # Ajout des widgets au conteneur principal
        main_box.add(title_label)
        main_box.add(divider1)
        main_box.add(source_section_label)
        main_box.add(self.source_button)
        main_box.add(self.source_file_label)
        # source_sheet_box sera ajouté dynamiquement

        main_box.add(divider2)
        main_box.add(target_section_label)
        main_box.add(self.target_button)
        main_box.add(self.target_file_label)
        # target_sheet_box sera ajouté dynamiquement

        main_box.add(divider3)
        main_box.add(self.process_button)
        # progress_box, result_box et post_process_box seront ajoutés dynamiquement

        # Création de la fenêtre principale
        self.main_window = toga.MainWindow(title=self.formal_name)
        self.main_window.content = main_box
        self.main_window.show()

        logger.info("Application démarrée")

    async def select_source_file(self, widget):
        """
        Ouvre une boîte de dialogue pour sélectionner le fichier Excel source.

        Args:
            widget: Le widget qui a déclenché l'événement (bouton)
        """
        try:
            logger.info("Ouverture du sélecteur de fichier source")
            file_path = await self.main_window.dialog(
                toga.OpenFileDialog(
                    title="Sélectionner le fichier Excel source",
                    file_types=["xlsx", "xls"],
                )
            )

            if file_path:
                self.source_file_path = str(file_path)
                filename = Path(file_path).name
                self.source_file_label.text = f"Fichier: {filename}"
                logger.info(f"Fichier source sélectionné: {self.source_file_path}")

                # Récupération des noms de feuilles
                sheet_names = get_sheet_names(self.source_file_path)

                if sheet_names:
                    # Mise à jour de la liste déroulante
                    self.source_sheet_selection.items = sheet_names
                    self.source_sheet_selection.value = sheet_names[0]
                    self.source_sheet_name = sheet_names[0]

                    # Affichage du sélecteur de feuille
                    if self.source_sheet_box not in self.main_window.content.children:
                        # Trouver l'index après source_file_label
                        children = list(self.main_window.content.children)
                        idx = children.index(self.source_file_label) + 1
                        self.main_window.content.insert(idx, self.source_sheet_box)

                    logger.info(f"Feuilles disponibles: {sheet_names}")
                else:
                    await self.main_window.dialog(
                        toga.ErrorDialog(
                            "Erreur",
                            f"Impossible de lire les feuilles du fichier:\n{filename}",
                        )
                    )
                    self.source_file_path = None
                    self.source_file_label.text = "Aucun fichier sélectionné"

                # Vérifier si le bouton de traitement doit être activé
                self.update_process_button_state()

        except Exception as e:
            logger.error(
                f"Erreur lors de la sélection du fichier source: {e}", exc_info=True
            )
            await self.main_window.dialog(
                toga.ErrorDialog(
                    "Erreur",
                    f"Une erreur s'est produite lors de la sélection du fichier:\n{str(e)}",
                )
            )

    async def select_target_file(self, widget):
        """
        Ouvre une boîte de dialogue pour sélectionner le fichier Excel cible.

        Args:
            widget: Le widget qui a déclenché l'événement (bouton)
        """
        try:
            logger.info("Ouverture du sélecteur de fichier cible")
            file_path = await self.main_window.dialog(
                toga.OpenFileDialog(
                    title="Sélectionner le fichier Excel cible",
                    file_types=["xlsx", "xls"],
                )
            )

            if file_path:
                self.target_file_path = str(file_path)
                filename = Path(file_path).name
                self.target_file_label.text = f"Fichier: {filename}"
                logger.info(f"Fichier cible sélectionné: {self.target_file_path}")

                # Récupération des noms de feuilles
                sheet_names = get_sheet_names(self.target_file_path)

                if sheet_names:
                    # Mise à jour de la liste déroulante
                    self.target_sheet_selection.items = sheet_names
                    self.target_sheet_selection.value = sheet_names[0]
                    self.target_sheet_name = sheet_names[0]

                    # Affichage du sélecteur de feuille
                    if self.target_sheet_box not in self.main_window.content.children:
                        # Trouver l'index après target_file_label
                        children = list(self.main_window.content.children)
                        idx = children.index(self.target_file_label) + 1
                        self.main_window.content.insert(idx, self.target_sheet_box)

                    logger.info(f"Feuilles disponibles: {sheet_names}")
                else:
                    await self.main_window.dialog(
                        toga.ErrorDialog(
                            "Erreur",
                            f"Impossible de lire les feuilles du fichier:\n{filename}",
                        )
                    )
                    self.target_file_path = None
                    self.target_file_label.text = "Aucun fichier sélectionné"

                # Vérifier si le bouton de traitement doit être activé
                self.update_process_button_state()

        except Exception as e:
            logger.error(
                f"Erreur lors de la sélection du fichier cible: {e}", exc_info=True
            )
            await self.main_window.dialog(
                toga.ErrorDialog(
                    "Erreur",
                    f"Une erreur s'est produite lors de la sélection du fichier:\n{str(e)}",
                )
            )

    def on_source_sheet_change(self, widget):
        """
        Callback appelé quand la feuille source est changée.

        Args:
            widget: Le widget Selection
        """
        self.source_sheet_name = widget.value
        logger.info(f"Feuille source sélectionnée: {self.source_sheet_name}")
        self.update_process_button_state()

    def on_target_sheet_change(self, widget):
        """
        Callback appelé quand la feuille cible est changée.

        Args:
            widget: Le widget Selection
        """
        self.target_sheet_name = widget.value
        logger.info(f"Feuille cible sélectionnée: {self.target_sheet_name}")
        self.update_process_button_state()

    def update_process_button_state(self):
        """
        Active ou désactive le bouton de traitement selon l'état des sélections.
        """
        all_selected = (
            self.source_file_path is not None
            and self.source_sheet_name is not None
            and self.target_file_path is not None
            and self.target_sheet_name is not None
        )
        self.process_button.enabled = all_selected
        logger.debug(f"Bouton de traitement activé: {all_selected}")

    async def start_processing(self, widget):
        """
        Lance le traitement de copie des couleurs.

        Args:
            widget: Le widget qui a déclenché l'événement (bouton)
        """
        logger.info("Démarrage du traitement")

        # Désactiver les boutons de sélection et de traitement
        self.source_button.enabled = False
        self.target_button.enabled = False
        self.process_button.enabled = False
        self.source_sheet_selection.enabled = False
        self.target_sheet_selection.enabled = False

        # Afficher la barre de progression
        if self.progress_box not in self.main_window.content.children:
            self.main_window.content.add(self.progress_box)

        # Démarrer l'animation de la barre de progression
        self.progress_bar.start()

        try:
            # Exécuter le traitement dans un thread pour ne pas bloquer l'UI
            await asyncio.sleep(0.1)  # Permet à l'UI de se mettre à jour

            # Appel de la fonction de traitement
            apply_colors_to_file2(
                self.source_file_path,
                self.source_sheet_name,
                self.target_file_path,
                self.target_sheet_name,
            )

            # Sauvegarder le chemin du fichier traité
            self.processed_file_path = self.target_file_path

            logger.info("Traitement terminé avec succès")

            # Arrêter la barre de progression
            self.progress_bar.stop()

            # Cacher la barre de progression
            if self.progress_box in self.main_window.content.children:
                self.main_window.content.remove(self.progress_box)

            # Afficher le message de succès
            self.result_label.text = "Traitement terminé avec succès!"
            if self.result_box not in self.main_window.content.children:
                self.main_window.content.add(self.result_box)

            # Afficher les boutons post-traitement
            if self.post_process_box not in self.main_window.content.children:
                self.main_window.content.add(self.post_process_box)

            # Afficher une boîte de dialogue de confirmation
            await self.main_window.dialog(
                toga.InfoDialog(
                    "Succès",
                    f"Les couleurs ont été appliquées avec succès au fichier:\n{Path(self.target_file_path).name}",
                )
            )

        except Exception as e:
            logger.error(f"Erreur lors du traitement: {e}", exc_info=True)

            # Arrêter la barre de progression
            self.progress_bar.stop()

            # Cacher la barre de progression
            if self.progress_box in self.main_window.content.children:
                self.main_window.content.remove(self.progress_box)

            # Afficher le message d'erreur
            self.result_label.text = f"Erreur: {str(e)}"
            if self.result_box not in self.main_window.content.children:
                self.main_window.content.add(self.result_box)

            # Afficher le bouton de nouveau traitement
            if self.post_process_box not in self.main_window.content.children:
                self.main_window.content.add(self.post_process_box)

            # Afficher une boîte de dialogue d'erreur
            await self.main_window.dialog(
                toga.ErrorDialog(
                    "Erreur de traitement",
                    f"Une erreur s'est produite lors du traitement:\n{str(e)}",
                )
            )

            # Réactiver les boutons
            self.source_button.enabled = True
            self.target_button.enabled = True
            self.source_sheet_selection.enabled = True
            self.target_sheet_selection.enabled = True
            self.update_process_button_state()

    async def save_as_file(self, widget):
        """
        Permet de sauvegarder le fichier traité à un nouvel emplacement.

        Args:
            widget: Le widget qui a déclenché l'événement (bouton)
        """
        try:
            logger.info("Ouverture du sélecteur pour enregistrer sous")

            # Proposer un nom de fichier par défaut
            original_path = Path(self.processed_file_path)
            default_name = f"{original_path.stem}_colored{original_path.suffix}"

            save_path = await self.main_window.dialog(
                toga.SaveFileDialog(
                    title="Enregistrer le fichier sous...",
                    suggested_filename=default_name,
                    file_types=["xlsx"],
                )
            )

            if save_path:
                # Copier le fichier traité vers le nouvel emplacement
                import shutil

                shutil.copy2(self.processed_file_path, str(save_path))

                logger.info(f"Fichier enregistré sous: {save_path}")

                await self.main_window.dialog(
                    toga.InfoDialog(
                        "Succès",
                        f"Le fichier a été enregistré avec succès:\n{Path(save_path).name}",
                    )
                )

        except Exception as e:
            logger.error(f"Erreur lors de l'enregistrement: {e}", exc_info=True)
            await self.main_window.dialog(
                toga.ErrorDialog(
                    "Erreur",
                    f"Une erreur s'est produite lors de l'enregistrement:\n{str(e)}",
                )
            )

    async def reset_interface(self, widget):
        """
        Réinitialise l'interface pour un nouveau traitement.

        Args:
            widget: Le widget qui a déclenché l'événement (bouton)
        """
        logger.info("Réinitialisation de l'interface")

        # Réinitialiser les variables d'état
        self.source_file_path = None
        self.source_sheet_name = None
        self.target_file_path = None
        self.target_sheet_name = None
        self.processed_file_path = None

        # Réinitialiser les labels
        self.source_file_label.text = "Aucun fichier sélectionné"
        self.target_file_label.text = "Aucun fichier sélectionné"

        # Cacher les sélecteurs de feuilles
        if self.source_sheet_box in self.main_window.content.children:
            self.main_window.content.remove(self.source_sheet_box)
        if self.target_sheet_box in self.main_window.content.children:
            self.main_window.content.remove(self.target_sheet_box)

        # Cacher les éléments post-traitement
        if self.progress_box in self.main_window.content.children:
            self.main_window.content.remove(self.progress_box)
        if self.result_box in self.main_window.content.children:
            self.main_window.content.remove(self.result_box)
        if self.post_process_box in self.main_window.content.children:
            self.main_window.content.remove(self.post_process_box)

        # Réactiver les boutons
        self.source_button.enabled = True
        self.target_button.enabled = True
        self.source_sheet_selection.enabled = True
        self.target_sheet_selection.enabled = True

        # Désactiver le bouton de traitement
        self.process_button.enabled = False

        logger.info("Interface réinitialisée")


def main():
    """
    Fonction principale pour lancer l'application.

    Returns:
        ColorExcel: Instance de l'application
    """
    return ColorExcel("ColorExcel", "com.colorexcel.app")


if __name__ == "__main__":
    main().main_loop()
