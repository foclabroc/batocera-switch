#!/bin/bash

batocera-mouse show

# Lancer Citron comme avant
"/userdata/system/switch/citron.AppImage" "$@"
RET=$?

# Exécuté juste après la fermeture de Citron
batocera-mouse hide

exit $RET