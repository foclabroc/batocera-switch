#!/usr/bin/env bash 
# BATOCERA.PRO INSTALLER
######################################################################
#--------------------------------------------------------------------- 
APPNAME="SWITCH-EMULATION FOR 42+" 
ORIGIN="github.com/foclabroc/batocera-switch" 
#---------------------------------------------------------------------
######################################################################
ORIGIN="${ORIGIN^^}"
extra=/userdata/system/switch/extra 
mkdir /userdata/system/switch 2>/dev/null 
mkdir /userdata/system/switch/extra 2>/dev/null 
sysctl -w net.ipv6.conf.default.disable_ipv6=1 1>/dev/null 2>/dev/null
sysctl -w net.ipv6.conf.all.disable_ipv6=1 1>/dev/null 2>/dev/null
#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
# --------------------------------------------------------------------
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\   
function batocera-pro-installer {
APPNAME=$1
ORIGIN=$2
# --------------------------------------------------------------------
# -- colors: 
###########################
X='\033[0m'               # / resetcolor
W='\033[0;37m'            # white
#-------------------------#
RED='\033[1;31m'          # red
BLUE='\033[1;34m'         # blue
GREEN='\033[1;32m'        # green
PURPLE='\033[1;35m'       # purple
DARKRED='\033[0;31m'      # darkred
DARKBLUE='\033[0;34m'     # darkblue
DARKGREEN='\033[0;32m'    # darkgreen
DARKPURPLE='\033[0;35m'   # darkpurple
###########################
# -- display theme:
L=$W
T=$W
R=$RED
B=$BLUE
G=$GREEN
P=$PURPLE
W=$X
# --------------------------------------------------------------------
clear
echo
echo
echo
echo -e "${X}${X}$APPNAME${X} INSTALLER ${X}"
echo
echo
echo
sleep 0.33

clear
echo
echo
echo
echo -e "${X}${X}$APPNAME${X} INSTALLER ${X}"
echo
echo
echo
sleep 0.33

clear
echo
echo
echo -e "${X}- - - - - - - - -"
echo -e "${X}${X}$APPNAME${X} INSTALLER ${X}"
echo -e "${X}- - - - - - - - -"
echo
echo
sleep 0.33
clear

echo
echo -e "${X}- - - - - - - - -"
echo
echo -e "${X}${X}$APPNAME${X} INSTALLER ${X}"
echo 
echo -e "${X}- - - - - - - - -"
echo
sleep 0.33

clear
echo -e "${X}- - - - - - - - -"
echo 
echo 
echo -e "${X}${X}$APPNAME${X} INSTALLER ${X}"
echo 
echo 
echo -e "${X}- - - - - - - - -"
sleep 0.33

clear
echo
echo
echo 
echo -e "${X}${X}$APPNAME${X} INSTALLER ${X}"
echo 
echo 
echo
sleep 0.33

echo -e "${X}INSTALLING $APPNAME FOR BATOCERA"
echo -e "${X}USING $ORIGIN"
echo 
echo
echo
sleep 3
# --------------------------------------------------------------------
# -- check system before proceeding
if [[ "$(uname -a | grep "x86_64")" != "" ]]; then 
:
else
echo
echo -e "${X}ERROR: SYSTEM NOT SUPPORTED"
echo -e "${X}YOU NEED BATOCERA X86_64${X}"
echo
sleep 5
exit 0
# quit
exit 0
fi
# --------------------------------------------------------------------
# -------------------------------------------------------------------- 
# -------------------------------------------------------------------- 
echo -e "${X}PLEASE WAIT${X} . . ." 
#echo -e "${X}${X}" 
# -------------------------------------------------------------------- 
# -------------------------------------------------------------------- 
# -------------------------------------------------------------------- 
# PRESERVE CONFIG FILE 
cfg=/userdata/system/switch/CONFIG.txt 
if [[ -f "$cfg" ]]; then 
      # check config file version & update ---------------------------
      link_defaultconfig=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-config.txt
      wget -q --no-check-certificate --no-cache --no-cookies -O "/tmp/.CONFIG.txt" "$link_defaultconfig"
         currentver=$(cat "$cfg" | grep "(ver " | head -n1 | sed 's,^.*(ver ,,g' | cut -d ")" -f1)
            if [[ "$currentver" = "" ]]; then currentver=1.0.0; fi
         latestver=$(cat "/tmp/.CONFIG.txt" | grep "(ver " | head -n1 | sed 's,^.*(ver ,,g' | cut -d ")" -f1)
            if [[ "$latestver" > "$currentver" ]]; then 
               cp /tmp/.CONFIG.txt $cfg 2>/dev/null
               echo -e "\n~/switch/CONFIG.txt FILE HAS BEEN UPDATED!\n"
            fi
      # check config file version & update ---------------------------
   cp $cfg /tmp/.userconfigfile 2>/dev/null
fi
# -------------------------------------------------------------------- 
# PURGE OLD INSTALLS 
#rm -rf /userdata/system/switch 2>/dev/null
rm /userdata/system/switch/*.AppImage 2>/dev/null
rm -rf /userdata/system/switch/configgen 2>/dev/null
rm -rf /userdata/system/switch/extra 2>/dev/null
rm -rf /userdata/system/switch/logs 2>/dev/null
rm -rf /userdata/system/switch/sudachi 2>/dev/null
rm "/userdata/system/switch/CONFIG.txt" 2>/dev/null
rm /userdata/system/configs/emulationstation/add_feat_switch.cfg 2>/dev/null
rm /userdata/system/configs/emulationstation/es_systems_switch.cfg 2>/dev/null
rm /userdata/system/configs/emulationstation/es_features_switch.cfg 2>/dev/null
rm /userdata/system/configs/emulationstation/es_features.cfg 2>/dev/null
rm "/userdata/roms/ports/Sudachi Qlauncher.sh" 2>/dev/null 
rm "/userdata/roms/ports/Sudachi Qlauncher.sh.keys" 2>/dev/null
rm "/userdata/roms/ports/Switch Updater40.sh.keys" 2>/dev/null
rm "/userdata/roms/ports/Switch Updater40.sh" 2>/dev/null
rm /userdata/system/switch/extra/suyu.png 2>/dev/null
rm /userdata/system/switch/extra/suyu-config.desktop 2>/dev/null
rm /userdata/system/switch/extra/batocera-config-suyu 2>/dev/null
rm /userdata/system/switch/extra/batocera-config-suyuQL 2>/dev/null
rm /userdata/system/.local/share/applications/suyu-config.desktop 2>/dev/null
rm /userdata/system/switch/extra/batocera-config-suyuQL 2>/dev/null
rm "/userdata/roms/ports/Suyu Qlauncher.sh.keys" 2>/dev/null 
rm "/userdata/roms/ports/Suyu Qlauncher.sh" 2>/dev/null
rm /userdata/system/configs/evmapy/switch.keys 2>/dev/null

# -------------------------------------------------------------------- 
# FILL PATHS
#mkdir -p /userdata/roms/ports/images 2>/dev/null
#mkdir -p /userdata/roms/switch 2>/dev/null
#mkdir -p /userdata/bios/switch 2>/dev/null
#mkdir -p /userdata/bios/switch/firmware 2>/dev/null
#mkdir -p /userdata/system/configs/emulationstation 2>/dev/null
#mkdir -p /userdata/system/configs/evmapy 2>/dev/null
#mkdir -p /userdata/system/switch/configgen/generators/yuzu 2>/dev/null
#mkdir -p /userdata/system/switch/configgen/generators/ryujinx 2>/dev/null
#mkdir -p /userdata/system/switch/extra 2>/dev/null

mkdir /userdata/roms/switch 2>/dev/null
mkdir /userdata/roms/ports 2>/dev/null
mkdir /userdata/roms/ports/images 2>/dev/null

mkdir /userdata/bios/switch 2>/dev/null
mkdir /userdata/bios/switch/firmware 2>/dev/null

mkdir /userdata/system/switch 2>/dev/null
mkdir /userdata/system/switch/extra 2>/dev/null
mkdir /userdata/system/switch/configgen 2>/dev/null
mkdir /userdata/system/switch/configgen/generators 2>/dev/null
mkdir /userdata/system/switch/configgen/generators/citron 2>/dev/null
mkdir /userdata/system/switch/configgen/generators/ryujinx 2>/dev/null
mkdir /userdata/system/switch/configgen/generators/sudachi 2>/dev/null

mkdir /userdata/system/configs 2>/dev/null
mkdir /userdata/system/configs/evmapy 2>/dev/null
mkdir /userdata/system/configs/emulationstation 2>/dev/null

# -------------------------------------------------------------------- 
# FILL /USERDATA/SYSTEM/SWITCH/EXTRA
path=/userdata/system/switch/extra
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-config-ryujinx" "$url/batocera-config-ryujinx"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-config-sudachi" "$url/batocera-config-sudachi"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-config-sudachiQL" "$url/batocera-config-sudachiQL"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-switch-libselinux.so.1" "$url/batocera-switch-libselinux.so.1"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-switch-libthai.so.0.3" "$url/batocera-switch-libthai.so.0.3"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-switch-libtinfo.so.6" "$url/batocera-switch-libtinfo.so.6"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-switch-sshupdater.sh" "$url/batocera-switch-sshupdater.sh"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-switch-tar" "$url/batocera-switch-tar"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-switch-tput" "$url/batocera-switch-tput"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-switch-updater.sh" "$url/batocera-switch-updater.sh"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/icon_ryujinx.png" "$url/icon_ryujinx.png"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/icon_ryujinxg.png" "$url/icon_ryujinxg.png"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/libthai.so.0.3.1" "$url/libthai.so.0.3.1"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/ryujinx-avalonia.png" "$url/ryujinx-avalonia.png"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/ryujinx.png" "$url/ryujinx.png"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/sudachi.png" "$url/sudachi.png"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/citron.png" "$url/citron.png"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batocera-config-citron" "$url/batocera-config-citron"

# -------------------------------------------------------------------- 
# + get default config file: 
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/CONFIG.txt" "https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-config.txt"
# -------------------------------------------------------------------- 
# FILL /USERDATA/SYSTEM/SWITCH/CONFIGGEN/GENERATORS/RYUJINX
path=/userdata/system/switch/configgen/generators/ryujinx
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/generators/ryujinx
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/__init__.py" "$url/__init__.py"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/ryujinxMainlineGenerator.py" "$url/ryujinxMainlineGenerator.py"
# -------------------------------------------------------------------- 
# FILL /USERDATA/SYSTEM/SWITCH/CONFIGGEN/GENERATORS/CITRON
path=/userdata/system/switch/configgen/generators/citron
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/generators/citron
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/citronGenerator.py" "$url/citronGenerator.py"
# -------------------------------------------------------------------- 
# FILL /USERDATA/SYSTEM/SWITCH/CONFIGGEN/GENERATORS/SUDACHI
path=/userdata/system/switch/configgen/generators/sudachi
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/generators/sudachi
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/sudachiGenerator.py" "$url/sudachiGenerator.py"
# -------------------------------------------------------------------- 
# FILL /USERDATA/SYSTEM/SWITCH/CONFIGGEN/GENERATORS
path=/userdata/system/switch/configgen/generators
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/generators
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/__init__.py" "$url/__init__.py"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/Generator.py" "$url/Generator.py"
# -------------------------------------------------------------------- 
# FILL /USERDATA/SYSTEM/SWITCH/CONFIGGEN
path=/userdata/system/switch/configgen
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/GeneratorImporter.py" "$url/GeneratorImporter.py"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/switchlauncher.py" "$url/switchlauncher.py"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/configgen-defaults.yml" "$url/configgen-defaults.yml"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/configgen-defaults-arch.yml" "$url/configgen-defaults-arch.yml"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/Emulator.py" "$url/Emulator.py"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/batoceraFiles.py" "$url/batoceraFiles.py"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/controllersConfig.py" "$url/controllersConfig.py"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/evmapy.py" "$url/evmapy.py"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/unixSettings.py" "$url/unixSettings.py"
# -------------------------------------------------------------------- 
# FILL /USERDATA/SYSTEM/CONFIGS/EMULATIONSTATION
path=/userdata/system/configs/emulationstation
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/configs/emulationstation
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/es_features_switch.cfg" "$url/es_features_switch.cfg"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/es_systems_switch.cfg" "$url/es_systems_switch.cfg"
# -------------------------------------------------------------------- 
# FILL /USERDATA/SYSTEM/CONFIGS/EMULATIONSTATION 
path=/userdata/system/configs/evmapy
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/configs/evmapy
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/switch.keys" "$url/switch.keys"
# -------------------------------------------------------------------- 
# FILL /USERDATA/ROMS/PORTS 
path=/userdata/roms/ports 
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/roms/ports
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/Switch Updater.sh" "$url/Switch Updater.sh"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/Sudachi Qlauncher.sh" "$url/Sudachi Qlauncher.sh"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/Sudachi Qlauncher.sh.keys" "$url/Sudachi Qlauncher.sh.keys"
# -------------------------------------------------------------------- 
# FILL /USERDATA/ROMS/PORTS/IMAGES 
path=/userdata/roms/ports/images
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/roms/ports/images
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/Switch Updater-boxart.png" "$url/Switch Updater-boxart.png"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/Switch Updater-cartridge.png" "$url/Switch Updater-cartridge.png"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/Switch Updater-mix.png" "$url/Switch Updater-mix.png"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/Switch Updater-screenshot.png" "$url/Switch Updater-screenshot.png"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/Switch Updater-wheel.png" "$url/Switch Updater-wheel.png"
# -------------------------------------------------------------------- 
# # FILL /USERDATA/SYSTEM/.LOCAL/SHARE/APPLICATIONS
# path=/userdata/system/.local/share/applications
# url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra
# wget --show-progress --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/citron-config.desktop" "$url/citron-config.desktop"
# # -------------------------------------------------------------------- 
# # FILL /USERDATA/SYSTEM/.LOCAL/SHARE/APPLICATIONS
# path=/userdata/system/.local/share/applications
# url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra
# wget --show-progress --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/sudachi-config.desktop" "$url/sudachi-config.desktop"
# -------------------------------------------------------------------- 
# FILL /USERDATA/ROMS/SWITCH
path=/userdata/roms/switch
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/roms/switch
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/_info.txt" "$url/_info.txt"
# -------------------------------------------------------------------- 
# FILL /USERDATA/BIOS/SWITCH 
path=/userdata/bios/switch
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/bios/switch
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/_info.txt" "$url/_info.txt"
# -------------------------------------------------------------------- 
# REMOVE OLD UPDATERS 
rm /userdata/roms/ports/updateyuzu.sh 2>/dev/null 
rm /userdata/roms/ports/updateyuzuea.sh 2>/dev/null
rm /userdata/roms/ports/updateyuzuEA.sh 2>/dev/null 
rm /userdata/roms/ports/updateryujinx.sh 2>/dev/null
rm /userdata/roms/ports/updateryujinxavalonia.sh 2>/dev/null
# --------------------------------------------------------------------
dos2unix /userdata/system/switch/extra/*.sh 2>/dev/null
dos2unix /userdata/system/switch/extra/batocera-config* 2>/dev/null
chmod a+x /userdata/system/switch/extra/*.sh 2>/dev/null
chmod a+x /userdata/system/switch/extra/batocera-config* 2>/dev/null
chmod a+x /userdata/system/switch/extra/batocera-switch-lib* 2>/dev/null
chmod a+x /userdata/system/switch/extra/*.desktop 2>/dev/null
chmod a+x /userdata/system/.local/share/applications/*.desktop 2>/dev/null
# --------------------------------------------------------------------
echo -e "${X} > INSTALLED OK${X}" 
sleep 1
echo
echo
echo
# restore xterm font
X='\033[0m' # / resetcolor
echo -e "${X}LOADING ${X}SWITCH UPDATER${X} . . ." 
echo -e "${X} "
rm -rf /userdata/system/switch/extra/installation 2>/dev/null
rm /tmp/batocera-switch-updater.sh 2>/dev/null 
mkdir -p /tmp 2>/dev/null
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/tmp/batocera-switch-updater.sh" "https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-updater.sh" 
sed -i 's,MODE=DISPLAY,MODE=CONSOLE,g' /tmp/batocera-switch-updater.sh 2>/dev/null
dos2unix /tmp/batocera-switch-updater.sh 2>/dev/null 
chmod a+x /tmp/batocera-switch-updater.sh 2>/dev/null 
/tmp/batocera-switch-updater.sh CONSOLE 
sleep 0.1 
echo "OK" >> /userdata/system/switch/extra/installation
sleep 0.1
   # --- \ restore user config file for the updater if running clean install/update from the switch installer 
   if [[ -e /tmp/.userconfigfile ]]; then 
      cp /tmp/.userconfigfile /userdata/system/switch/CONFIG.txt 2>/dev/null
   fi 
   # --- /
} 
export -f batocera-pro-installer 2>/dev/null 
# --------------------------------------------------------------------
batocera-pro-installer "$APPNAME" "$ORIGIN" 
# --------------------------------------------------------------------
sysctl -w net.ipv6.conf.default.disable_ipv6=0 1>/dev/null 2>/dev/null
sysctl -w net.ipv6.conf.all.disable_ipv6=0 1>/dev/null 2>/dev/null
X='\033[0m' # / resetcolor
if [[ -e /userdata/system/switch/extra/installation ]]; then
rm /userdata/system/switch/extra/installation 2>/dev/null
clear
echo 
echo -e "   ${BLUE}INSTALLER BY ${BLUE}"
echo -e "   ${GREEN}FOCLABROC ${GREEN}"
echo -e "   ${X}$APPNAME INSTALLED${X}" 
echo 
echo 
echo -e "   ${PURPLE}INFORMATION! ${PURPLE}"
echo -e "   ${PURPLE}USERDATA MUST BE IN EXT4/BTRFS! TO MAKE SWITCH EMULATION WORKS ${PURPLE}"
echo -e "   ${PURPLE}NO HELP PROVIDED IF YOU ARE NOT IN EXT4/BTRFS! ${PURPLE}"
echo -e "   ${PURPLE}IF YOU ARE ALREADY IN BTRFS/EXT4 YOU CAN IGNORE THIS MESSAGE ${PURPLE}"
echo 
echo -e "   ${X}IF INSTALLATION/DOWNLOAD FAIL ${X}"
echo -e "   ${X}> Add manualy appimage/tar/zip in /userdata/system/switch/appimages${X}" 
echo -e "   ${X}> FILES PACK AVAILABLE HERE : ${X}" 
echo -e "   ${GREEN}> https://1fichier.com/?8furupg6hic0booljbmy ${GREEN}" 
echo -e "   ${X}> After that launch SWITCH UPDATER from PORTS ${X}" 
echo
echo
echo -e "   ${X}-------------------------------------------------------------------${X}"
echo -e "   ${X}Place your keys into /userdata/bios/switch/${X}" 
echo -e "   ${X}Firmware *.nca into /userdata/bios/switch/firmware/${X}" 
echo
echo -e "   ${X}-------------------------------------------------------------------${X}"
echo -e "   ${X}NOTE : YuzuEA and Ryujinx Avalonia ${X}"
echo -e "   ${X}       no longer works in 42 for now ${X}"
echo -e "   ${X}       only Citron Ryujinx and Sudachi are available ${X}"
echo
echo -e "   ${X}-------------------------------------------------------------------${X}"
echo -e "   ${X}IN CASE OF CONTROLLER ISSUES: ${X}"
echo 
echo -e "   ${X}2) use [autocontroller = off] in advanced settings & ${X}"
echo -e "   ${X}   configure controller manually in f1-applications ${X}"
echo
echo -e "   ${X}-------------------------------------------------------------------${X}"
echo 
echo 
else
clear 
echo 
echo 
echo -e "   ${X}Looks like the installation failed :(${X}" 
echo
echo -e "   ${X}Try running the script again...${X}" 
echo
echo
echo -e "   ${X}If it still fails, try installing using this command instead: "
echo
echo -e "   ${X}cd /userdata ; wget -O s batocera.pro/s ; chmod 777 s ; ./s "
echo 
echo 
sleep 1
exit 0
fi
# done. 
