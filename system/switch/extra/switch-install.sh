#!/bin/bash

# Récupération de la version principale de Batocera
version=$(batocera-es-swissknife --version | grep -oE '^[0-9]+')

# Vérification que la version est bien un nombre
if [[ -z "$version" ]]; then
    dialog --msgbox "Impossible de détecter une version valide de Batocera. Installation annulée." 8 60
    clear
    exit 1
fi

echo "[Foclabroc Switch Installer] Version détectée de Batocera : $version"
sleep 2

# Choix du bon script selon la version
case $version in
    39|40)
        echo "[Foclabroc Switch Installer] Déclenchement du script pour Batocera 39/40..."
        sleep 3
        curl -fsSL bit.ly/foclabroc-switchoff-40 | bash
        ;;
    41)
        echo "[Foclabroc Switch Installer] Déclenchement du script pour Batocera 41..."
        sleep 3
        curl -fsSL bit.ly/foclabroc-switchoff | bash
        ;;
    42)
        echo "[Foclabroc Switch Installer] Déclenchement du script pour Batocera 42..."
        sleep 3
        curl -fsSL bit.ly/foclabroc-batswitch | bash
        ;;
    *)
        echo "[Foclabroc Switch Installer] Version non prise en charge : $version"
        dialog --msgbox "Version de Batocera non prise en charge : $version. Installation annulée." 8 60
        clear
        ;;
esac