#!/usr/bin/env bash
################################################################################
# v3.3                SWITCH EMULATORS UPDATER FOR BATOCERA                    #
#                   ----------------------------------------                   #
#                     > github.com/foclabroc/batocera-switch                   #
#                                                                              #     
################################################################################
#  ---------------
#     SETTINGS 
#  ---------------
#
EMULATORS="YUZUEA RYUJINX RYUJINXAVALONIA" 
#        |
#        default: "YUZU YUZUEA RYUJINX RYUJINXLDN RYUJINXAVALONIA"
#
#   EMULATORS="RYUJINX YUZU"  -->  will only update ryujinx & then yuzu   
#   EMULATORS="YUZUEA"  -->  will only update yuzu early access     
#
################################################################################
#
MODE=DISPLAY 
#   | 
#   default: DISPLAY 
#
#   MODE=DISPLAY  -->  for ports; uses fullscreen xterm process to show updater  
#   MODE=CONSOLE  -->  for ssh/console/xterm; no colors, no additional display  
#                
    ANIMATION=NO
#   plays loading animation when starting the udpater    
#
################################################################################
#
UPDATES=UNLOCKED
#      | 
#      default: LOCKED
#       
#   UPDATES=LOCKED  -->  limit ryujinx to version 1.1.382 for compatibility 
#   UPDATES=UNLOCKED  -->  download latest versions of ryujinx emulators 
#
#   *) use this option if you want to update ryujinx to latest releases, 
#   and use manual controller config (you can do it in 
#   [[ f1 menu ]] --> ryujinx-avalonia   
#
#################################################################################
#
TEXT_SIZE=AUTO
#        |
#        default: AUTO
#
#   TEXT_SIZE=10  -->  will use custom font size, = 10  
# 
################################################################################
#
TEXT_COLOR=WHITE
THEME_COLOR=WHITE
THEME_COLOR_OK=WHITE
THEME_COLOR_RYUJINX=BLUE
#
#   AVAILABLE COLORS:
#   |
#   WHITE,BLACK,RED,GREEN,BLUE,YELLOW,PURPLE,CYAN
#   DARKRED,DARKGREEN,DARKBLUE,DARKYELLOW,DARKPURPLE,DARKCYAN#
#
######################################################################
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@                @@@@@            @@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@                   @@@@@                @@@@@@@@@@@@@@@
# @@@@@@@@@@@     @@@@@@@@@@@@    @@@@@                  @@@@@@@@@@@@@
# @@@@@@@@@     @@@@@@@@@@@@@@    @@@@@                   @@@@@@@@@@@@
# @@@@@@@@@    @@@@@      @@@@    @@@@@                   @@@@@@@@@@@@
# @@@@@@@@@    @@@         @@@    @@@@@                   @@@@@@@@@@@@
# @@@@@@@@@    @@@@        @@@    @@@@@                   @@@@@@@@@@@@
# @@@@@@@@@    @@@@@@   %@@@@@    @@@@@                   @@@@@@@@@@@@
# @@@@@@@@@    @@@@@@@@@@@@@@@    @@@@@       @@@@        @@@@@@@@@@@@
# @@@@@@@@@    @@@@@@@@@@@@@@@    @@@@@     @@@@@@@@      @@@@@@@@@@@@
# @@@@@@@@@    @@@@@@@@@@@@@@@    @@@@@    @@@@@@@@@@     @@@@@@@@@@@@
# @@@@@@@@@    @@@@@@@@@@@@@@@    @@@@@     @@@@@@@@      @@@@@@@@@@@@
# @@@@@@@@@    @@@@@@@@@@@@@@@    @@@@@        @@         @@@@@@@@@@@@
# @@@@@@@@@    @@@@@@@@@@@@@@@    @@@@@                   @@@@@@@@@@@@
# @@@@@@@@@    @@@@@@@@@@@@@@@    @@@@@                   @@@@@@@@@@@@
# @@@@@@@@@    @@@@@@@@@@@@@@@    @@@@@                   @@@@@@@@@@@@
# @@@@@@@@@@     @@@@@@@@@@@@@    @@@@@                  @@@@@@@@@@@@@
# @@@@@@@@@@@@      @@@@@@@@@@    @@@@@                @@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@                 @@@@@             @@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#                > github.com/foclabroc/batocera-switch           #
#                    > https://discord.gg/SWBvBkmn9P                 #
######################################################################
######################################################################
######################################################################
######################################################################
# --------------------------------------------------------------------
sysctl -w net.ipv6.conf.default.disable_ipv6=1 1>/dev/null 2>/dev/null
sysctl -w net.ipv6.conf.all.disable_ipv6=1 1>/dev/null 2>/dev/null
# --------------------------------------------------------------------
export DISPLAY=:0.0
# --------------------------------------------------------------------
cp $(which xterm) /tmp/batocera-switch-updater && chmod 777 /tmp/batocera-switch-updater
# --------------------------------------------------------------------
if [[ "$1" = "CONSOLE" ]] || [[ "$1" = "console" ]]; then 
MODE=CONSOLE
fi
function check-connection() {
# CHECK CONNECTION
net="on" ; net1="on" ; net2="on" ; net3="on"
case "$(curl -s --max-time 2 -I http://github.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
  [23]) net1="on";;
  5) net1="off";;
  *) net1="off";;
esac 
ping -q -w 1 -c 1 github.com > /dev/null && net2="on" || net2="off"
wget -q --spider http://github.com && if [ $? -eq 0 ]; then net3="on"; else net3="off"; fi
if [[ "$net1" = "off" ]] && [[ "$net2" = "off" ]] && [[ "$net3" = "off" ]]; then net="off"; fi 
if [[ "$net1" = "on" ]] || [[ "$net2" = "on" ]] || [[ "$net3" = "on" ]]; then net="on"; fi 
##
if [[ "$net" = "off" ]]; then 
DISPLAY=:0.0 /tmp/batocera-switch-updater -fs 10 -maximized -fg black -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c "echo -e \"\n \033[0;37m NO INTERNET CONNECTION :( \033[0;30m \" & sleep 3" 2>/dev/null && exit 0 & exit 1 & exit 2
fi 
}
function check_internet() {
    # Check using curl
    if curl -s --max-time 2 -I http://github.com | grep -q "HTTP/[12].[01] [23].."; then
        return 0
    fi 
    
    # Check using ping
    if ping -q -w 1 -c 1 github.com > /dev/null; then
        return 0
    fi

    # Check using wget
    if wget -q --spider http://github.com; then
        return 0
    fi

    # If all methods fail, report no connectivity
    return 1
}
# Check for an internet connection
if check_internet; then
   net="on"
else 
   DISPLAY=:0.0 /tmp/batocera-switch-updater -fs 10 -maximized -fg black -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c "echo -e \"\n \033[0;37m NO INTERNET CONNECTION :( \033[0;30m \" & sleep 3" 2>/dev/null && exit 0 && exit 1 && exit 2   
fi
# --------------------------------------------------------------------
# clear old logs: 
rm -rf /userdata/system/switch/extra/logs 2>/dev/null
mkdir -p /userdata/system/switch/logs 2>/dev/null
# --------------------------------------------------------------------
# clear all old/broken/user desktop shortcuts: 
rm -rf /userdata/system/switch/*.desktop 2>/dev/null
# --------------------------------------------------------------------
# PREPARE SHORTCUTS FOR F1-APPLICATIONS MENU 
# --------------------------------------------------------------------
function generate-shortcut-launcher { 
# SCALING FOR F1 APPS, DEFAULT 128@1 
DPI=128
SCALE=1
Name=$1
name=$2
extra=/userdata/system/switch/extra
# --------------------------------------------------------------------
f=$extra/$Name.desktop
# --------------------------------------------------------------------
rm -rf "$f" 2>/dev/null
   echo "[Desktop Entry]" >> "$f"
   echo "Version=1.0" >> "$f"
      if [[ "$Name" = "citron" ]]; then 
         echo "Icon=/userdata/system/switch/extra/citron.png" >> "$f"
         echo 'Exec=/userdata/system/switch/extra/batocera-config-citron' >> "$f" 
         fi
      if [[ "$Name" = "sudachi" ]]; then 
         echo "Icon=/userdata/system/switch/extra/sudachi.png" >> "$f"
         echo 'Exec=/userdata/system/switch/extra/batocera-config-sudachi' >> "$f" 
         fi
      if [[ "$Name" = "Ryujinx" ]]; then 
         echo "Icon=/userdata/system/switch/extra/icon_ryujinxg.png" >> "$f"
         echo 'Exec=/userdata/system/switch/Ryujinx.AppImage' >> "$f" 
         fi
   echo "Terminal=false" >> "$f"
   echo "Type=Application" >> "$f"
   echo "Categories=Game;batocera.linux;" >> "$f"
   ####
   # if [[ "$Name" != "switch-updater" ]]; then 
      # echo "Name=$name-config" >> "$f"
   # else
      # echo "Name=$name" >> "$f"
   # fi 
   ####
      dos2unix "$f" 2>/dev/null
      chmod a+x "$f" 2>/dev/null
} 
# -----------------------------------------------------------------
#
# remove old version dekstop shortcuts from ~/.local/share/applications 
rm /userdata/system/.local/share/applications/yuzu-config.desktop 2>/dev/null
rm /userdata/system/.local/share/applications/yuzuEA-config.desktop 2>/dev/null
rm /userdata/system/.local/share/applications/citron-config.desktop 2>/dev/null
rm /userdata/system/.local/share/applications/sudachi-config.desktop 2>/dev/null
rm /userdata/system/.local/share/applications/ryujinx-config.desktop 2>/dev/null
rm /userdata/system/.local/share/applications/ryujinxavalonia-config.desktop 2>/dev/null
rm /userdata/system/.local/share/applications/ryujinxldn-config.desktop 2>/dev/null
# remove old version dekstop shortcuts from /usr/share/applications:
rm /usr/share/applications/citron-config.desktop 2>/dev/null
rm /usr/share/applications/sudachi-config.desktop 2>/dev/null
rm /usr/share/applications/yuzu-config.desktop 2>/dev/null
rm /usr/share/applications/yuzuEA-config.desktop 2>/dev/null
rm /usr/share/applications/ryujinx-config.desktop 2>/dev/null
rm /usr/share/applications/Ryujinx-Avalonia.desktop 2>/dev/null
rm /usr/share/applications/ryujinxldn-config.desktop 2>/dev/null
rm /usr/share/applications/yuzu-config.desktop 2>/dev/null
rm /usr/share/applications/yuzuEA.desktop 2>/dev/null
rm /usr/share/applications/ryujinx-config.desktop 2>/dev/null
rm /usr/share/applications/ryujinxavalonia-config.desktop 2>/dev/null
rm /usr/share/applications/ryujinxldn-config.desktop 2>/dev/null
# generate new desktop shortcuts: 
generate-shortcut-launcher 'citron' 'citron'
generate-shortcut-launcher 'Ryujinx' 'ryujinx'
generate-shortcut-launcher 'sudachi' 'sudachi'
######################################################################
######################################################################
######################################################################
######################################################################
if [[ "$EMULATORS" == *"DEFAULT"* ]] || [[ "$EMULATORS" == *"default"* ]] || [[ "$EMULATORS" == *"ALL"* ]] || [[ "$EMULATORS" == *"all"* ]]; then
   EMULATORS="RYUJINX "
   EMULATORS=$(echo "$EMULATORS ")
fi
if [ "$(echo $EMULATORS | grep "-")" = "" ]; then 
EMULATORS="$EMULATORS-"
fi
EMULATORS="$(echo $EMULATORS | sed 's/ /-/g')"
   # GET EMULATORS FROM CONFIG FILE -------------------------------------
   cfg=/userdata/system/switch/CONFIG.txt
   if [[ ! -f $cfg ]]; then 
      link_defaultconfig=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-config.txt
      wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/CONFIG.txt" "$link_defaultconfig"
      ###curl -sSf "$link_defaultconfig" -o "/userdata/system/switch/CONFIG.txt"
   fi 
   dos2unix $cfg 1>/dev/null 2>/dev/null
   if [[ -f $cfg ]]; then 
      # check config file version & update ---------------------------
      link_defaultconfig=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-config.txt
      rm "/tmp/.CONFIG.txt" 2>/dev/null
      wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/tmp/.CONFIG.txt" "$link_defaultconfig"
      ###curl -sSf "$link_defaultconfig" -o "/tmp/.CONFIG.txt"
         currentver=$(cat "/userdata/system/switch/CONFIG.txt" | grep "(ver " | head -n1 | sed 's,^.*(ver ,,g' | cut -d ")" -f1)
         if [[ "$currentver" = "" ]]; then currentver=1.0.0; fi
         latestver=$(cat "/tmp/.CONFIG.txt" | grep "(ver " | head -n1 | sed 's,^.*(ver ,,g' | cut -d ")" -f1)
            currentver=$(echo "$currentver" | sed 's,\.,,g')
            latestver=$(echo "$latestver" | sed 's,\.,,g')            
               if [ $latestver -gt $currentver ]; then 
                  cp /tmp/.CONFIG.txt $cfg 2>/dev/null
                  echo -e "\n~/switch/CONFIG.txt FILE HAS BEEN UPDATED!\n"
               fi
      # check config file version & update ---------------------------
      EMULATORS=$(cat /userdata/system/switch/CONFIG.txt | grep "EMULATORS=" | cut -d "=" -f2 | head -n1 | cut -d \" -f2 | tr -d '\0')
         if [[ "$EMULATORS" == *"DEFAULT"* ]] || [[ "$EMULATORS" == *"default"* ]] || [[ "$EMULATORS" == *"ALL"* ]] || [[ "$EMULATORS" == *"all"* ]]; then
            EMULATORS="RYUJINX"
         fi
         if [ "$(echo $EMULATORS | grep "-")" = "" ]; then 
            EMULATORS="$EMULATORS-"
            EMULATORS=$(echo $EMULATORS | sed 's/ /-/g')
         fi
   #echo "2EMULATORS=$EMULATORS"
   fi 
#exit 0
   # /GET EMULATORS FROM CONFIG FILE -------------------------------------
# -------------------------------------------------------------------
rm /tmp/updater-settings 2>/dev/null
if [[ "$UPDATES" = "LOCKED" ]] || [[ "$UPDATES" = "locked" ]]; then 
echo "updates=locked" >> /tmp/updater-settings 
fi 
if [[ "$UPDATES" = "UNLOCKED" ]] || [[ "$UPDATES" = "unlocked" ]]; then 
echo "updates=unlocked" >> /tmp/updater-settings 
fi 
# -------------------------------------------------------------------
rm /tmp/updater-mode 2>/dev/null
echo "MODE=$MODE" >> /tmp/updater-mode 
# -------------------------------------------------------------------
# get animation
#if [[ "$MODE" = "DISPLAY" ]] || [[ "$MODE" = "display" ]]; then 
#   if [[ ( "$ANIMATION" = "YES" ) || ( "$ANIMATION" = "yes" ) ]]; then
#   url_loader=https://github.com/uureel/batocera-switch/raw/refs/heads/42/system/switch/extra/loader.mp4
#   loader=/userdata/system/switch/extra/loader.mp4 
#      if [[ ! -e "$loader" ]]; then 
#         wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O $loader $url_loader 2>/dev/null
#         ###curl -sSf "$url_loader" -o "$loader"
#      fi 
#      if [[ -e "$loader" ]] && [[ "$(wc -c $loader | awk '{print $1}')" < "6918849" ]]; then 
#         wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O $loader $url_loader 2>/dev/null
#         ###curl -sSf "$url_loader" -o "$loader"
#      fi
#   fi
#fi
#-------------------------------------------------------------------
# get tar dependencies 
# \\ 
link_tar=https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/batocera-switch-tar
link_libselinux=https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/batocera-switch-libselinux.so.1
if [[ -e "$extra/batocera-switch-tar" ]]; then 
chmod a+x "$extra/batocera-switch-tar"
else 
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$extra/batocera-switch-tar" "$link_tar"
###curl -sSf "$link_tar" -o "$extra/batocera-switch-tar"
chmod a+x "$extra/batocera-switch-tar"
fi
if [[ ! -e "/usr/lib/libselinux.so.1" ]]; then
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$extra/batocera-switch-libselinux.so.1" "$link_libselinux"
###curl -sSf "$link_libselinux" -o "$extra/batocera-switch-libselinux.so.1"
chmod a+x "$extra/batocera-switch-libselinux.so.1"
cp "$extra/batocera-switch-libselinux.so.1" "/usr/lib/libselinux.so.1" 2>/dev/null
fi
if [[ -e "/userdata/system/switch/extra/batocera-switch-libselinux.so.1" ]]; then 
   cp /userdata/system/switch/extra/batocera-switch-libselinux.so.1 cp /userdata/system/switch/extra/libselinux.so.1 2>/dev/null
fi
# //
# -------------------------------------------------------------------
rm /tmp/updater-textsize 2>/dev/null
   if [[ "$(echo $TEXT_SIZE | grep "AUTO")" != "" ]] || [[ "$(echo $TEXT_SIZE | grep "auto")" != "" ]]; then 
      echo "$TEXT_SIZE" >> /tmp/updater-textsize 
   fi
# -------------------------------------------------------------------
temp=/userdata/system/switch/extra/downloads
mkdir /userdata/system/switch 2>/dev/null
mkdir /userdata/system/switch/extra 2>/dev/null
mkdir /userdata/system/switch/extra/downloads 2>/dev/null
#clear 
# TEXT & THEME COLORS: 
###########################
X='\033[0m'               # / resetcolor
RED='\033[1;31m'          # red
BLUE='\033[1;34m'         # blue
GREEN='\033[1;32m'        # green
YELLOW='\033[1;33m'       # yellow
PURPLE='\033[1;35m'       # purple
CYAN='\033[1;36m'         # cyan
#-------------------------#
DARKRED='\033[0;31m'      # darkred
DARKBLUE='\033[0;34m'     # darkblue
DARKGREEN='\033[0;32m'    # darkgreen
DARKYELLOW='\033[0;33m'   # darkyellow
DARKPURPLE='\033[0;35m'   # darkpurple
DARKCYAN='\033[0;36m'     # darkcyan
#-------------------------#
WHITE='\033[0;37m'        # white
BLACK='\033[0;30m'        # black
###########################
# PARSE COLORS FOR THEMING:
# ---------------------------------------------------------------------------------- 
if [ "$TEXT_COLOR" = "RED" ]; then TEXT_COLOR="$RED"; fi
if [ "$TEXT_COLOR" = "BLUE" ]; then TEXT_COLOR="$BLUE"; fi
if [ "$TEXT_COLOR" = "GREEN" ]; then TEXT_COLOR="$GREEN"; fi
if [ "$TEXT_COLOR" = "YELLOW" ]; then TEXT_COLOR="$YELLOW"; fi
if [ "$TEXT_COLOR" = "PURPLE" ]; then TEXT_COLOR="$PURPLE"; fi
if [ "$TEXT_COLOR" = "CYAN" ]; then TEXT_COLOR="$CYAN"; fi
if [ "$TEXT_COLOR" = "DARKRED" ]; then TEXT_COLOR="$DARKRED"; fi
if [ "$TEXT_COLOR" = "DARKBLUE" ]; then TEXT_COLOR="$DARKBLUE"; fi
if [ "$TEXT_COLOR" = "DARKGREEN" ]; then TEXT_COLOR="$DARKGREEN"; fi
if [ "$TEXT_COLOR" = "DARKYELLOW" ]; then TEXT_COLOR="$DARKYELLOW"; fi
if [ "$TEXT_COLOR" = "DARKPURPLE" ]; then TEXT_COLOR="$DARKPURPLE"; fi
if [ "$TEXT_COLOR" = "DARKCYAN" ]; then TEXT_COLOR="$DARKCYAN"; fi
if [ "$TEXT_COLOR" = "WHITE" ]; then TEXT_COLOR="$WHITE"; fi
if [ "$TEXT_COLOR" = "BLACK" ]; then TEXT_COLOR="$BLACK"; fi
# ---------------------------------------------------------------------------------- 
if [ "$THEME_COLOR" = "RED" ]; then THEME_COLOR="$RED"; fi
if [ "$THEME_COLOR" = "BLUE" ]; then THEME_COLOR="$BLUE"; fi
if [ "$THEME_COLOR" = "GREEN" ]; then THEME_COLOR="$GREEN"; fi
if [ "$THEME_COLOR" = "YELLOW" ]; then THEME_COLOR="$YELLOW"; fi
if [ "$THEME_COLOR" = "PURPLE" ]; then THEME_COLOR="$PURPLE"; fi
if [ "$THEME_COLOR" = "CYAN" ]; then THEME_COLOR="$CYAN"; fi
if [ "$THEME_COLOR" = "DARKRED" ]; then THEME_COLOR="$DARKRED"; fi
if [ "$THEME_COLOR" = "DARKBLUE" ]; then THEME_COLOR="$DARKBLUE"; fi
if [ "$THEME_COLOR" = "DARKGREEN" ]; then THEME_COLOR="$DARKGREEN"; fi
if [ "$THEME_COLOR" = "DARKYELLOW" ]; then THEME_COLOR="$DARKYELLOW"; fi
if [ "$THEME_COLOR" = "DARKPURPLE" ]; then THEME_COLOR="$DARKPURPLE"; fi
if [ "$THEME_COLOR" = "DARKCYAN" ]; then THEME_COLOR="$DARKCYAN"; fi
if [ "$THEME_COLOR" = "WHITE" ]; then THEME_COLOR="$WHITE"; fi
if [ "$THEME_COLOR" = "BLACK" ]; then THEME_COLOR="$BLACK"; fi
# ---------------------------------------------------------------------------------- 
if [ "$THEME_COLOR_OK" = "RED" ]; then THEME_COLOR_OK="$RED"; fi
if [ "$THEME_COLOR_OK" = "BLUE" ]; then THEME_COLOR_OK="$BLUE"; fi
if [ "$THEME_COLOR_OK" = "GREEN" ]; then THEME_COLOR_OK="$GREEN"; fi
if [ "$THEME_COLOR_OK" = "YELLOW" ]; then THEME_COLOR_OK="$YELLOW"; fi
if [ "$THEME_COLOR_OK" = "PURPLE" ]; then THEME_COLOR_OK="$PURPLE"; fi
if [ "$THEME_COLOR_OK" = "CYAN" ]; then THEME_COLOR_OK="$CYAN"; fi
if [ "$THEME_COLOR_OK" = "DARKRED" ]; then THEME_COLOR_OK="$DARKRED"; fi
if [ "$THEME_COLOR_OK" = "DARKBLUE" ]; then THEME_COLOR_OK="$DARKBLUE"; fi
if [ "$THEME_COLOR_OK" = "DARKGREEN" ]; then THEME_COLOR_OK="$DARKGREEN"; fi
if [ "$THEME_COLOR_OK" = "DARKYELLOW" ]; then THEME_COLOR_OK="$DARKYELLOW"; fi
if [ "$THEME_COLOR_OK" = "DARKPURPLE" ]; then THEME_COLOR_OK="$DARKPURPLE"; fi
if [ "$THEME_COLOR_OK" = "DARKCYAN" ]; then THEME_COLOR_OK="$DARKCYAN"; fi
if [ "$THEME_COLOR_OK" = "WHITE" ]; then THEME_COLOR_OK="$WHITE"; fi
if [ "$THEME_COLOR_OK" = "BLACK" ]; then THEME_COLOR_OK="$BLACK"; fi
# ---------------------------------------------------------------------------------- 
if [ "$THEME_COLOR_YUZUEA" = "RED" ]; then THEME_COLOR_YUZUEA="$RED"; fi
if [ "$THEME_COLOR_YUZUEA" = "BLUE" ]; then THEME_COLOR_YUZUEA="$BLUE"; fi
if [ "$THEME_COLOR_YUZUEA" = "GREEN" ]; then THEME_COLOR_YUZUEA="$GREEN"; fi
if [ "$THEME_COLOR_YUZUEA" = "YELLOW" ]; then THEME_COLOR_YUZUEA="$YELLOW"; fi
if [ "$THEME_COLOR_YUZUEA" = "PURPLE" ]; then THEME_COLOR_YUZUEA="$PURPLE"; fi
if [ "$THEME_COLOR_YUZUEA" = "CYAN" ]; then THEME_COLOR_YUZUEA="$CYAN"; fi
if [ "$THEME_COLOR_YUZUEA" = "DARKRED" ]; then THEME_COLOR_YUZUEA="$DARKRED"; fi
if [ "$THEME_COLOR_YUZUEA" = "DARKBLUE" ]; then THEME_COLOR_YUZUEA="$DARKBLUE"; fi
if [ "$THEME_COLOR_YUZUEA" = "DARKGREEN" ]; then THEME_COLOR_YUZUEA="$DARKGREEN"; fi
if [ "$THEME_COLOR_YUZUEA" = "DARKYELLOW" ]; then THEME_COLOR_YUZUEA="$DARKYELLOW"; fi
if [ "$THEME_COLOR_YUZUEA" = "DARKPURPLE" ]; then THEME_COLOR_YUZUEA="$DARKPURPLE"; fi
if [ "$THEME_COLOR_YUZUEA" = "DARKCYAN" ]; then THEME_COLOR_YUZUEA="$DARKCYAN"; fi
if [ "$THEME_COLOR_YUZUEA" = "WHITE" ]; then THEME_COLOR_YUZUEA="$WHITE"; fi
if [ "$THEME_COLOR_YUZUEA" = "BLACK" ]; then THEME_COLOR_YUZUEA="$BLACK"; fi
# ---------------------------------------------------------------------------------- 
if [ "$THEME_COLOR_RYUJINX" = "RED" ]; then THEME_COLOR_RYUJINX="$RED"; fi
if [ "$THEME_COLOR_RYUJINX" = "BLUE" ]; then THEME_COLOR_RYUJINX="$BLUE"; fi
if [ "$THEME_COLOR_RYUJINX" = "GREEN" ]; then THEME_COLOR_RYUJINX="$GREEN"; fi
if [ "$THEME_COLOR_RYUJINX" = "YELLOW" ]; then THEME_COLOR_RYUJINX="$YELLOW"; fi
if [ "$THEME_COLOR_RYUJINX" = "PURPLE" ]; then THEME_COLOR_RYUJINX="$PURPLE"; fi
if [ "$THEME_COLOR_RYUJINX" = "CYAN" ]; then THEME_COLOR_RYUJINX="$CYAN"; fi
if [ "$THEME_COLOR_RYUJINX" = "DARKRED" ]; then THEME_COLOR_RYUJINX="$DARKRED"; fi
if [ "$THEME_COLOR_RYUJINX" = "DARKBLUE" ]; then THEME_COLOR_RYUJINX="$DARKBLUE"; fi
if [ "$THEME_COLOR_RYUJINX" = "DARKGREEN" ]; then THEME_COLOR_RYUJINX="$DARKGREEN"; fi
if [ "$THEME_COLOR_RYUJINX" = "DARKYELLOW" ]; then THEME_COLOR_RYUJINX="$DARKYELLOW"; fi
if [ "$THEME_COLOR_RYUJINX" = "DARKPURPLE" ]; then THEME_COLOR_RYUJINX="$DARKPURPLE"; fi
if [ "$THEME_COLOR_RYUJINX" = "DARKCYAN" ]; then THEME_COLOR_RYUJINX="$DARKCYAN"; fi
if [ "$THEME_COLOR_RYUJINX" = "WHITE" ]; then THEME_COLOR_RYUJINX="$WHITE"; fi
if [ "$THEME_COLOR_RYUJINX" = "BLACK" ]; then THEME_COLOR_RYUJINX="$BLACK"; fi
# ---------------------------------------------------------------------------------- 
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "RED" ]; then THEME_COLOR_RYUJINXAVALONIA="$RED"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "BLUE" ]; then THEME_COLOR_RYUJINXAVALONIA="$BLUE"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "GREEN" ]; then THEME_COLOR_RYUJINXAVALONIA="$GREEN"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "YELLOW" ]; then THEME_COLOR_RYUJINXAVALONIA="$YELLOW"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "PURPLE" ]; then THEME_COLOR_RYUJINXAVALONIA="$PURPLE"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "CYAN" ]; then THEME_COLOR_RYUJINXAVALONIA="$CYAN"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKRED" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKRED"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKBLUE" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKBLUE"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKGREEN" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKGREEN"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKYELLOW" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKYELLOW"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKPURPLE" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKPURPLE"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKCYAN" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKCYAN"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "WHITE" ]; then THEME_COLOR_RYUJINXAVALONIA="$WHITE"; fi
if [ "$THEME_COLOR_RYUJINXAVALONIA" = "BLACK" ]; then THEME_COLOR_RYUJINXAVALONIA="$BLACK"; fi
# ---------------------------------------------------------------------------------- 
# REPLACE COLORS FOR CONSOLE MODE: 
   if [[ -e "/tmp/updater-mode" ]]; then 
      MODE=$(cat /tmp/updater-mode | grep MODE | cut -d "=" -f2)
   fi
      if [[ "$MODE" = "CONSOLE" ]]; then 
         TEXT_COLOR=$X 
         THEME_COLOR=$X
         THEME_COLOR_OK=$X
         THEME_COLOR_YUZUEA=$X
         THEME_COLOR_RYUJINX=$X
         THEME_COLOR_RYUJINXAVALONIA=$X
      fi
# PREPARE COOKIE FOR FUNCTIONS: 
f=/userdata/system/switch/extra/batocera-switch-updatersettings
rm -rf "$f"
echo "TEXT_SIZE=$TEXT_SIZE" >> "$f"
echo "TEXT_COLOR=$TEXT_COLOR" >> "$f"
echo "THEME_COLOR=$THEME_COLOR" >> "$f"
echo "THEME_COLOR_YUZUEA=$THEME_COLOR_YUZUEA" >> "$f"
echo "THEME_COLOR_RYUJINX=$THEME_COLOR_RYUJINX" >> "$f"
echo "THEME_COLOR_RYUJINXAVALONIA=$THEME_COLOR_RYUJINXAVALONIA" >> "$f"
echo "THEME_COLOR_OK=$THEME_COLOR_OK" >> "$f"
   # GET EMULATORS FROM CONFIG FILE -------------------------------------
   cfg=/userdata/system/switch/CONFIG.txt
   dos2unix $cfg 1>/dev/null 2>/dev/null
   if [[ -e "$cfg" ]]; then 
      EMULATORS="$(cat "$cfg" | grep "EMULATORS=" | cut -d "=" -f2 | head -n1 | cut -d \" -f2 | tr -d '\0')"
         if [[ "$EMULATORS" == *"DEFAULT"* ]] || [[ "$EMULATORS" == *"default"* ]] || [[ "$EMULATORS" == *"ALL"* ]] || [[ "$EMULATORS" == *"all"* ]]; then
            EMULATORS="YUZUEA RYUJINX RYUJINXAVALONIA"
         fi 
         if [ "$(echo $EMULATORS | grep "-")" = "" ]; then 
            EMULATORS="$EMULATORS-"
            EMULATORS="$(echo $EMULATORS | sed 's/ /-/g')"
         fi
   fi 
   # /GET EMULATORS FROM CONFIG FILE -------------------------------------
echo "EMULATORS=$EMULATORS" >> "$f"
####################################################################################
function update_emulator {
E=$1 && N=$2
link_yuzuea="$5"
link_ryujinx="$6"
link_ryujinxavalonia="$8"
# ---------------------------------------------------------------------------------- 
# pass info cookie: 
cookie=/userdata/system/switch/extra/updates.txt
   rm $cookie 2>/dev/null 
   if [[ "$updates" = "locked" ]] || [[ "$locked" = 1 ]]; then 
      echo "locked" >> $cookie 2>/dev/null
   fi 
   if [[ "$updates" = "unlocked" ]] || [[ "$locked" = 0 ]]; then 
      echo "unlocked" >> $cookie 2>/dev/null
   fi
# ----------------------------------------------------------------------------------
# PATHS: 
path_yuzuea=/userdata/system/switch/yuzuEA.AppImage
path_ryujinx=/userdata/system/switch/Ryujinx.AppImage
path_ryujinxavalonia=/userdata/system/switch/Ryujinx-Avalonia.AppImage
# ---------------------------------------------------------------------------------- 
# READ SETTINGS FROM COOKIE: 
cookie=/userdata/system/switch/extra/batocera-switch-updatersettings
TEXT_SIZE=$(cat $cookie | grep "TEXT_SIZE=" | cut -d "=" -f 2)
TEXT_COLOR=$(cat $cookie | grep "TEXT_COLOR=" | cut -d "=" -f 2)
THEME_COLOR=$(cat $cookie | grep "THEME_COLOR=" | cut -d "=" -f 2)
THEME_COLOR_YUZUEA=$(cat $cookie | grep "THEME_COLOR_YUZUEA=" | cut -d "=" -f 2)
THEME_COLOR_RYUJINX=$(cat $cookie | grep "THEME_COLOR_RYUJINX=" | cut -d "=" -f 2)
THEME_COLOR_RYUJINXAVALONIA=$(cat $cookie | grep "THEME_COLOR_RYUJINXAVALONIA=" | cut -d "=" -f 2)
THEME_COLOR_OK=$(cat $cookie | grep "THEME_COLOR_OK=" | cut -d "=" -f 2)
EMULATORS="$(cat $cookie | grep "EMULATORS=" | cut -d "=" -f 2)"
#
# --------------
# --------------
# --------------
# \\ config file
# ---------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------- 
# USE CUSTOM UPDATER SETTINGS FROM CONFIG FILE:
# /USERDATA/SYSTEM/SWITCH/CONFIG.TXT
# ---------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------- 
cfg=/userdata/system/switch/CONFIG.txt
dos2unix $cfg 1>/dev/null 2>/dev/null
if [[ ! -e "$cfg" ]]; then 
link_defaultconfig=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-config.txt
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/CONFIG.txt" "$link_defaultconfig"
###curl -sSf "$link_defaultconfig" -o "/userdata/system/switch/CONFIG.txt"
fi 
if [[ -e "$cfg" ]]; then 
   # get 
   # \\\
   ### emulators  
   EMULATORS="$(cat "$cfg" | grep "EMULATORS=" | cut -d "=" -f2 | head -n1 | cut -d \" -f2 | tr -d '\0')"
   EMULATORS=$(echo "$EMULATORS ")
      if [[ "$EMULATORS" == *"DEFAULT"* ]] || [[ "$EMULATORS" == *"default"* ]] || [[ "$EMULATORS" == *"ALL"* ]] || [[ "$EMULATORS" == *"all"* ]]; then
         EMULATORS="YUZUEA RYUJINX RYUJINXAVALONIA"
      fi
      if [ "$(echo $EMULATORS | grep "-")" = "" ]; then 
         EMULATORS="$EMULATORS-"
         EMULATORS=$(echo $EMULATORS | sed 's/ /-/g')
      fi
   ### text/colors
   TEXT_SIZE=$(cat $cfg | grep "TEXT_SIZE=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
   TEXT_COLOR=$(cat $cfg | grep "TEXT_COLOR=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
   THEME_COLOR=$(cat $cfg | grep "THEME_COLOR=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
   THEME_COLOR_YUZUEA=$(cat $cfg | grep "THEME_COLOR_YUZUEA=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
   THEME_COLOR_RYUJINX=$(cat $cfg | grep "THEME_COLOR_RYUJINX=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
   THEME_COLOR_RYUJINXAVALONIA=$(cat $cfg | grep "THEME_COLOR_RYUJINXAVALONIA=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
   THEME_COLOR_OK=$(cat $cfg | grep "THEME_COLOR_OK=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
      # TEXT & THEME COLORS: 
      ###########################
      X='\033[0m'               # / resetcolor
      RED='\033[1;31m'          # red
      BLUE='\033[1;34m'         # blue
      GREEN='\033[1;32m'        # green
      YELLOW='\033[1;33m'       # yellow
      PURPLE='\033[1;35m'       # purple
      CYAN='\033[1;36m'         # cyan
      #-------------------------#
      DARKRED='\033[0;31m'      # darkred
      DARKBLUE='\033[0;34m'     # darkblue
      DARKGREEN='\033[0;32m'    # darkgreen
      DARKYELLOW='\033[0;33m'   # darkyellow
      DARKPURPLE='\033[0;35m'   # darkpurple
      DARKCYAN='\033[0;36m'     # darkcyan
      #-------------------------#
      WHITE='\033[0;37m'        # white
      BLACK='\033[0;30m'        # black
      ###########################
      # PARSE COLORS FOR THEMING:
      # ---------------------------------------------------------------------------------- 
      if [ "$TEXT_COLOR" = "RED" ]; then TEXT_COLOR="$RED"; fi
      if [ "$TEXT_COLOR" = "BLUE" ]; then TEXT_COLOR="$BLUE"; fi
      if [ "$TEXT_COLOR" = "GREEN" ]; then TEXT_COLOR="$GREEN"; fi
      if [ "$TEXT_COLOR" = "YELLOW" ]; then TEXT_COLOR="$YELLOW"; fi
      if [ "$TEXT_COLOR" = "PURPLE" ]; then TEXT_COLOR="$PURPLE"; fi
      if [ "$TEXT_COLOR" = "CYAN" ]; then TEXT_COLOR="$CYAN"; fi
      if [ "$TEXT_COLOR" = "DARKRED" ]; then TEXT_COLOR="$DARKRED"; fi
      if [ "$TEXT_COLOR" = "DARKBLUE" ]; then TEXT_COLOR="$DARKBLUE"; fi
      if [ "$TEXT_COLOR" = "DARKGREEN" ]; then TEXT_COLOR="$DARKGREEN"; fi
      if [ "$TEXT_COLOR" = "DARKYELLOW" ]; then TEXT_COLOR="$DARKYELLOW"; fi
      if [ "$TEXT_COLOR" = "DARKPURPLE" ]; then TEXT_COLOR="$DARKPURPLE"; fi
      if [ "$TEXT_COLOR" = "DARKCYAN" ]; then TEXT_COLOR="$DARKCYAN"; fi
      if [ "$TEXT_COLOR" = "WHITE" ]; then TEXT_COLOR="$WHITE"; fi
      if [ "$TEXT_COLOR" = "BLACK" ]; then TEXT_COLOR="$BLACK"; fi
      # ---------------------------------------------------------------------------------- 
      if [ "$THEME_COLOR" = "RED" ]; then THEME_COLOR="$RED"; fi
      if [ "$THEME_COLOR" = "BLUE" ]; then THEME_COLOR="$BLUE"; fi
      if [ "$THEME_COLOR" = "GREEN" ]; then THEME_COLOR="$GREEN"; fi
      if [ "$THEME_COLOR" = "YELLOW" ]; then THEME_COLOR="$YELLOW"; fi
      if [ "$THEME_COLOR" = "PURPLE" ]; then THEME_COLOR="$PURPLE"; fi
      if [ "$THEME_COLOR" = "CYAN" ]; then THEME_COLOR="$CYAN"; fi
      if [ "$THEME_COLOR" = "DARKRED" ]; then THEME_COLOR="$DARKRED"; fi
      if [ "$THEME_COLOR" = "DARKBLUE" ]; then THEME_COLOR="$DARKBLUE"; fi
      if [ "$THEME_COLOR" = "DARKGREEN" ]; then THEME_COLOR="$DARKGREEN"; fi
      if [ "$THEME_COLOR" = "DARKYELLOW" ]; then THEME_COLOR="$DARKYELLOW"; fi
      if [ "$THEME_COLOR" = "DARKPURPLE" ]; then THEME_COLOR="$DARKPURPLE"; fi
      if [ "$THEME_COLOR" = "DARKCYAN" ]; then THEME_COLOR="$DARKCYAN"; fi
      if [ "$THEME_COLOR" = "WHITE" ]; then THEME_COLOR="$WHITE"; fi
      if [ "$THEME_COLOR" = "BLACK" ]; then THEME_COLOR="$BLACK"; fi
      # ---------------------------------------------------------------------------------- 
      if [ "$THEME_COLOR_OK" = "RED" ]; then THEME_COLOR_OK="$RED"; fi
      if [ "$THEME_COLOR_OK" = "BLUE" ]; then THEME_COLOR_OK="$BLUE"; fi
      if [ "$THEME_COLOR_OK" = "GREEN" ]; then THEME_COLOR_OK="$GREEN"; fi
      if [ "$THEME_COLOR_OK" = "YELLOW" ]; then THEME_COLOR_OK="$YELLOW"; fi
      if [ "$THEME_COLOR_OK" = "PURPLE" ]; then THEME_COLOR_OK="$PURPLE"; fi
      if [ "$THEME_COLOR_OK" = "CYAN" ]; then THEME_COLOR_OK="$CYAN"; fi
      if [ "$THEME_COLOR_OK" = "DARKRED" ]; then THEME_COLOR_OK="$DARKRED"; fi
      if [ "$THEME_COLOR_OK" = "DARKBLUE" ]; then THEME_COLOR_OK="$DARKBLUE"; fi
      if [ "$THEME_COLOR_OK" = "DARKGREEN" ]; then THEME_COLOR_OK="$DARKGREEN"; fi
      if [ "$THEME_COLOR_OK" = "DARKYELLOW" ]; then THEME_COLOR_OK="$DARKYELLOW"; fi
      if [ "$THEME_COLOR_OK" = "DARKPURPLE" ]; then THEME_COLOR_OK="$DARKPURPLE"; fi
      if [ "$THEME_COLOR_OK" = "DARKCYAN" ]; then THEME_COLOR_OK="$DARKCYAN"; fi
      if [ "$THEME_COLOR_OK" = "WHITE" ]; then THEME_COLOR_OK="$WHITE"; fi
      if [ "$THEME_COLOR_OK" = "BLACK" ]; then THEME_COLOR_OK="$BLACK"; fi
      # ---------------------------------------------------------------------------------- 
      if [ "$THEME_COLOR_YUZUEA" = "RED" ]; then THEME_COLOR_YUZUEA="$RED"; fi
      if [ "$THEME_COLOR_YUZUEA" = "BLUE" ]; then THEME_COLOR_YUZUEA="$BLUE"; fi
      if [ "$THEME_COLOR_YUZUEA" = "GREEN" ]; then THEME_COLOR_YUZUEA="$GREEN"; fi
      if [ "$THEME_COLOR_YUZUEA" = "YELLOW" ]; then THEME_COLOR_YUZUEA="$YELLOW"; fi
      if [ "$THEME_COLOR_YUZUEA" = "PURPLE" ]; then THEME_COLOR_YUZUEA="$PURPLE"; fi
      if [ "$THEME_COLOR_YUZUEA" = "CYAN" ]; then THEME_COLOR_YUZUEA="$CYAN"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKRED" ]; then THEME_COLOR_YUZUEA="$DARKRED"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKBLUE" ]; then THEME_COLOR_YUZUEA="$DARKBLUE"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKGREEN" ]; then THEME_COLOR_YUZUEA="$DARKGREEN"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKYELLOW" ]; then THEME_COLOR_YUZUEA="$DARKYELLOW"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKPURPLE" ]; then THEME_COLOR_YUZUEA="$DARKPURPLE"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKCYAN" ]; then THEME_COLOR_YUZUEA="$DARKCYAN"; fi
      if [ "$THEME_COLOR_YUZUEA" = "WHITE" ]; then THEME_COLOR_YUZUEA="$WHITE"; fi
      if [ "$THEME_COLOR_YUZUEA" = "BLACK" ]; then THEME_COLOR_YUZUEA="$BLACK"; fi
      # ---------------------------------------------------------------------------------- 
      if [ "$THEME_COLOR_RYUJINX" = "RED" ]; then THEME_COLOR_RYUJINX="$RED"; fi
      if [ "$THEME_COLOR_RYUJINX" = "BLUE" ]; then THEME_COLOR_RYUJINX="$BLUE"; fi
      if [ "$THEME_COLOR_RYUJINX" = "GREEN" ]; then THEME_COLOR_RYUJINX="$GREEN"; fi
      if [ "$THEME_COLOR_RYUJINX" = "YELLOW" ]; then THEME_COLOR_RYUJINX="$YELLOW"; fi
      if [ "$THEME_COLOR_RYUJINX" = "PURPLE" ]; then THEME_COLOR_RYUJINX="$PURPLE"; fi
      if [ "$THEME_COLOR_RYUJINX" = "CYAN" ]; then THEME_COLOR_RYUJINX="$CYAN"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKRED" ]; then THEME_COLOR_RYUJINX="$DARKRED"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKBLUE" ]; then THEME_COLOR_RYUJINX="$DARKBLUE"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKGREEN" ]; then THEME_COLOR_RYUJINX="$DARKGREEN"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKYELLOW" ]; then THEME_COLOR_RYUJINX="$DARKYELLOW"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKPURPLE" ]; then THEME_COLOR_RYUJINX="$DARKPURPLE"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKCYAN" ]; then THEME_COLOR_RYUJINX="$DARKCYAN"; fi
      if [ "$THEME_COLOR_RYUJINX" = "WHITE" ]; then THEME_COLOR_RYUJINX="$WHITE"; fi
      if [ "$THEME_COLOR_RYUJINX" = "BLACK" ]; then THEME_COLOR_RYUJINX="$BLACK"; fi
      # ---------------------------------------------------------------------------------- 
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "RED" ]; then THEME_COLOR_RYUJINXAVALONIA="$RED"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "BLUE" ]; then THEME_COLOR_RYUJINXAVALONIA="$BLUE"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "GREEN" ]; then THEME_COLOR_RYUJINXAVALONIA="$GREEN"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "YELLOW" ]; then THEME_COLOR_RYUJINXAVALONIA="$YELLOW"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "PURPLE" ]; then THEME_COLOR_RYUJINXAVALONIA="$PURPLE"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "CYAN" ]; then THEME_COLOR_RYUJINXAVALONIA="$CYAN"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKRED" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKRED"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKBLUE" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKBLUE"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKGREEN" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKGREEN"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKYELLOW" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKYELLOW"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKPURPLE" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKPURPLE"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKCYAN" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKCYAN"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "WHITE" ]; then THEME_COLOR_RYUJINXAVALONIA="$WHITE"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "BLACK" ]; then THEME_COLOR_RYUJINXAVALONIA="$BLACK"; fi
   ### yuzu
   # ///
fi
# // config file
# --------------
# --------------
# --------------
#
# OVERRIDE COLORS FOR SSH/XTERM: 
X='\033[0m' # / resetcolor
   if [[ -e "/tmp/updater-mode" ]]; then 
      MODE=$(cat /tmp/updater-mode | grep MODE | cut -d "=" -f2)
   fi
      if [[ "$MODE" = "CONSOLE" ]]; then 
         TEXT_COLOR=$X 
         THEME_COLOR=$X
         THEME_COLOR_OK=$X
         THEME_COLOR_YUZUEA=$X
         THEME_COLOR_RYUJINX=$X
         THEME_COLOR_RYUJINXAVALONIA=$X
      fi
# ---------------------------------------------------------------------------------- 
# RUN UPDATER FOR SELECTED EMULATOR:
# ----------------------------------------------------------------------------------
extra=/userdata/system/switch/extra
temp=/userdata/system/switch/extra/downloads
mkdir /userdata/system/switch 2>/dev/null
mkdir /userdata/system/switch/extra 2>/dev/null
mkdir /userdata/system/switch/extra/downloads 2>/dev/null
mkdir /userdata/system/switch/appimages 2>/dev/null
# 
#
# ---------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------- 
# EMULATORS UPDATERS:·
# ---------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------- 
#
#
##
#
#
# ---------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------- 
#
#
##
# ---------------------------------------------------------------------------------- 
# if [ "$3" = "YUZUEA" ]; then
# T=$THEME_COLOR_YUZUEA
# cd /userdata/system/switch/appimages
# yuzuE="/userdata/system/switch/appimages/yuzuea4176.AppImage"
# if [ -f "$yuzuE" ]; then
    # cp /userdata/system/switch/appimages/yuzuea4176.AppImage /userdata/system/switch/yuzuea4176.AppImage 2>/dev/null;
# else 
    # wget -q --show-progress --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/appimages/yuzuea4176.AppImage" "https://foclabroc.freeboxos.fr:55973/share/wFMuNBT3U8Wwa2x5/yuzuea4176.AppImage"
    # cp /userdata/system/switch/appimages/yuzuea4176.AppImage /userdata/system/switch/yuzuea4176.AppImage 2>/dev/null; fi
# link_yuzuEA="/userdata/system/switch/yuzuea4176.AppImage"
# version="4176"
# if [ "$N" = "1" ]; then C=""; else C="$E/$N"; fi
# if [ -f "$link_yuzuEA" ]; then	
	# checksum_file=$(md5sum $link_yuzuEA | awk '{print $1}')
	# checksum_verified="9f20b0e6bacd2eb9723637d078d463eb"
	   # if [[ "$checksum_file" != "$checksum_verified" ]]; then 
		  # echo -e "${T}YUZU-EA   [${W}!!${T}] download fail put yuzuea4176.AppImage in (/system/switch/appimages) then relaunch script"    	
		  # rm /userdata/system/switch/appimages/yuzuea4176.AppImage 2>/dev/null
	   # else
		  # echo -e "${T}YUZU-EA   ${T}❯❯   ${T}/$version/ ${GREEN}SUCCESS"
		  # rm -rf $temp/yuzuea 2>/dev/null
		  # mkdir $temp/yuzuea 2>/dev/null
		  # cd $temp/yuzuea
		  # mv $link_yuzuEA $temp/yuzuea/yuzuEA.AppImage 2>/dev/null
		  # chmod a+x "$temp/yuzuea/yuzuEA.AppImage" 2>/dev/null
		  # $temp/yuzuea/yuzuEA.AppImage --appimage-extract 1>/dev/null 2>/dev/null 
		  # mkdir /userdata/system/switch 2>/dev/null
		  # mkdir /userdata/system/switch/extra 2>/dev/null
		  # mkdir /userdata/system/switch/extra/yuzuea 2>/dev/null
		  # cp $temp/yuzuea/squashfs-root/usr/lib/libQt5* /userdata/system/switch/extra/yuzuea/ 2>/dev/null
		  # #rm /userdata/system/switch/extra/yuzuea/libQ* 2>/dev/null 
		  # cp $temp/yuzuea/squashfs-root/usr/lib/libcrypto* /userdata/system/switch/extra/yuzuea/ 2>/dev/null 
		  # cp $temp/yuzuea/squashfs-root/usr/lib/libssl* /userdata/system/switch/extra/yuzuea/ 2>/dev/null 
		  # cp $temp/yuzuea/squashfs-root/usr/lib/libicu* /userdata/system/switch/extra/yuzuea/ 2>/dev/null 
		  # cp $temp/yuzuea/squashfs-root/usr/bin/yuzu /userdata/system/switch/extra/yuzuea/yuzu 2>/dev/null
		  # cp $temp/yuzuea/squashfs-root/usr/bin/yuzu-room /userdata/system/switch/extra/yuzuea/yuzu-room 2>/dev/null
		  # cd $temp
# # fix broken libstdc++.so.6 for v37 
		  # if [[ "$(uname -a | awk '{print $3}')" > "6.2" ]]; then 
			 # link_libstdc=https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/batocera-switch-libstdc++.so.6
			 # wget -q --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/yuzuea/libstdc++.so.6" "$link_libstdc"
		  # else 
			 # rm /userdata/system/switch/extra/yuzuea/libstdc++.so.6 2>/dev/null
		  # fi
# # add yuzu's bundled 'optional' libs 
		  # cp $temp/yuzuea/squashfs-root/usr/optional/libstdc++/libstdc++.so.6 /userdata/system/switch/extra/yuzuea/libstdc++.so.6
		  # cp $temp/yuzuea/squashfs-root/usr/optional/libgcc_s/libgcc_s.so.1 /userdata/system/switch/extra/yuzuea/libgcc_s.so.1
		  # cp $temp/yuzuea/squashfs-root/usr/optional/exec.so /userdata/system/switch/extra/yuzuea/exec.so
		  # chmod a+x /userdata/system/switch/extra/yuzuea/lib* 2>/dev/null
# # make launcher
		  # f=/userdata/system/switch/yuzuEA.AppImage
		  # rm "$f" 2>/dev/null
		  # echo '#!/bin/bash' >> "$f"

		  # echo 'export XDG_MENU_PREFIX=batocera-' >> "$f"
		  # echo 'export XDG_CONFIG_DIRS=/etc/xdg' >> "$f"
		  # echo 'export XDG_CURRENT_DESKTOP=XFCE' >> "$f"
		  # echo 'export DESKTOP_SESSION=XFCE' >> "$f"

		  # echo '/userdata/system/switch/extra/batocera-switch-mousemove.sh &' >> "$f" 
		  # echo '/userdata/system/switch/extra/batocera-switch-sync-firmware.sh' >> "$f" 
		  # echo '#cp /userdata/system/switch/extra/yuzuea/lib* /lib64/ 2>/dev/null' >> "$f" 
		  # echo 'if [ ! -L /userdata/system/configs/Ryujinx/bis/user/save ]; then mkdir /userdata/system/configs/Ryujinx/bis/user/save 2>/dev/null; rsync -au /userdata/saves/Ryujinx/ /userdata/system/configs/Ryujinx/bis/user/save/ 2>/dev/null; fi' >> "$f"
		  # echo 'if [ ! -L /userdata/system/configs/yuzu/nand/user/save ]; then mkdir /userdata/system/configs/yuzu/nand/user/save 2>/dev/null; rsync -au /userdata/saves/yuzu/ /userdata/system/configs/yuzu/nand/user/save/ 2>/dev/null; fi' >> "$f"
		  # echo 'mkdir -p /userdata/system/configs/yuzu/keys 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/configs/yuzu/keys/ 2>/dev/null ' >> "$f"
		  # echo 'mkdir -p /userdata/system/.local/share/yuzu/keys 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/.local/share/yuzu/keys/ 2>/dev/null ' >> "$f"
		  # echo 'mkdir -p /userdata/system/configs/Ryujinx/system 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/configs/Ryujinx/system/ 2>/dev/null ' >> "$f"
		  # echo 'rm /usr/bin/yuzu 2>/dev/null; rm /usr/bin/yuzu-room 2>/dev/null' >> "$f"
		  # echo 'ln -s /userdata/system/switch/yuzuEA.AppImage /usr/bin/yuzu 2>/dev/null' >> "$f"
		  # echo 'cp /userdata/system/switch/extra/yuzuea/yuzu-room /usr/bin/yuzu-room 2>/dev/null' >> "$f"

		  # echo 'mkdir -p /userdata/system/switch/logs 2>/dev/null ' >> "$f"
		  # echo 'log1=/userdata/system/switch/logs/yuzuEA-out.txt 2>/dev/null ' >> "$f"
		  # echo 'log2=/userdata/system/switch/logs/yuzuEA-err.txt 2>/dev/null ' >> "$f"
		  # echo 'rm $log1 2>/dev/null && rm $log2 2>/dev/null ' >> "$f"

		  # echo 'ulimit -H -n 819200; ulimit -S -n 819200; ulimit -S -n 819200 yuzu;' >> "$f"

		  # echo 'rom="$(echo "$@" | sed '\''s,-f -g ,,g'\'')" ' >> "$f"
		  # echo 'if [[ "$rom" = "" ]]; then ' >> "$f"
		  # echo '  DRI_PRIME=1 AMD_VULKAN_ICD=RADV DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1 LC_ALL=C NO_AT_BRIDGE=1 QT_FONT_DPI=96 QT_SCALE_FACTOR=1 GDK_SCALE=1 LD_LIBRARY_PATH="/userdata/system/switch/extra/yuzuea:${LD_LIBRARY_PATH}" QT_PLUGIN_PATH=/usr/lib/qt/plugins:/userdata/system/switch/extra/lib/qt5plugins:/usr/plugins:${QT_PLUGIN_PATH} QT_QPA_PLATFORM_PLUGIN_PATH=${QT_PLUGIN_PATH} XDG_CONFIG_HOME=/userdata/system/configs XDG_CACHE_HOME=/userdata/system/.cache QT_QPA_PLATFORM=xcb /userdata/system/switch/extra/yuzuea/yuzu -f -g > >(tee "$log1") 2> >(tee "$log2" >&2) ' >> "$f" 
		  # echo 'else ' >> "$f"
		  # echo '  rm /tmp/switchromname 2>/dev/null ' >> "$f" 
		  # echo '    echo "$rom" >> /tmp/switchromname 2>/dev/null ' >> "$f" 
		  # echo '      /userdata/system/switch/extra/batocera-switch-nsz-converter.sh ' >> "$f" 
		  # echo '    rom="$(cat /tmp/switchromname)" ' >> "$f"
		  # echo '  fs=$(blkid | grep "$(df -h /userdata | awk '\''END {print $1}'\'')" | sed '\''s,^.*TYPE=,,g'\'' | sed '\''s,",,g'\'' | tr '\''a-z'\'' '\''A-Z'\'') ' >> "$f"
		  # echo '  if [[ "$fs" == *"EXT"* ]] || [[ "$fs" == *"BTR"* ]]; then ' >> "$f"
		  # echo '    rm /tmp/yuzurom 2>/dev/null; ln -sf "$rom" "/tmp/yuzurom"; ROM="/tmp/yuzurom"; ' >> "$f"
		  # echo '    DRI_PRIME=1 AMD_VULKAN_ICD=RADV DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1 QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb LC_ALL=C.utf8 NO_AT_BRIDGE=1 XDG_MENU_PREFIX=batocera- XDG_CONFIG_DIRS=/etc/xdg XDG_CURRENT_DESKTOP=XFCE DESKTOP_SESSION=XFCE QT_FONT_DPI=96 QT_SCALE_FACTOR=1 GDK_SCALE=1 LD_LIBRARY_PATH="/userdata/system/switch/extra/yuzuea:${LD_LIBRARY_PATH}" GDK_SCALE=1 QT_PLUGIN_PATH=/usr/lib/qt/plugins:/userdata/system/switch/extra/lib/qt5plugins:/usr/plugins:${QT_PLUGIN_PATH} QT_QPA_PLATFORM_PLUGIN_PATH=${QT_PLUGIN_PATH} XDG_CONFIG_HOME=/userdata/system/configs XDG_CACHE_HOME=/userdata/system/.cache QT_QPA_PLATFORM=xcb /userdata/system/switch/extra/yuzuea/yuzu -f -g "$ROM" 1>"$log1" 2>"$log2" ' >> "$f"
		  # echo '  else ' >> "$f"
		  # echo '    ROM="$rom" ' >> "$f"
		  # echo '    DRI_PRIME=1 AMD_VULKAN_ICD=RADV DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1 QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb LC_ALL=C.utf8 NO_AT_BRIDGE=1 XDG_MENU_PREFIX=batocera- XDG_CONFIG_DIRS=/etc/xdg XDG_CURRENT_DESKTOP=XFCE DESKTOP_SESSION=XFCE QT_FONT_DPI=96 QT_SCALE_FACTOR=1 GDK_SCALE=1 LD_LIBRARY_PATH="/userdata/system/switch/extra/yuzuea:${LD_LIBRARY_PATH}" GDK_SCALE=1 QT_PLUGIN_PATH=/usr/lib/qt/plugins:/userdata/system/switch/extra/lib/qt5plugins:/usr/plugins:${QT_PLUGIN_PATH} QT_QPA_PLATFORM_PLUGIN_PATH=${QT_PLUGIN_PATH} XDG_CONFIG_HOME=/userdata/system/configs XDG_CACHE_HOME=/userdata/system/.cache QT_QPA_PLATFORM=xcb /userdata/system/switch/extra/yuzuea/yuzu -f -g "$ROM" 1>"$log1" 2>"$log2" ' >> "$f"
		  # echo '  fi ' >> "$f"
		  # echo 'fi' >> "$f"

		  # dos2unix "$f" 2>/dev/null; chmod a+x "$f" 2>/dev/null
		  # chmod a+x "/userdata/system/switch/extra/yuzuea/yuzu" 2>/dev/null
		  # chmod a+x "/userdata/system/switch/extra/yuzuea/yuzu-room" 2>/dev/null
		  # size_yuzuea=$(($(wc -c $temp/yuzuea/yuzuEA.AppImage | awk '{print $1}')/1048576)) 2>/dev/null
		  # #echo -e "${T}» ~/switch/yuzuEA.AppImage · ${T}$size_yuzuea( )MB   ${T}" | sed 's/( )//g'
		  # echo
		  # cd ~/
# # send version to cookie: 
		  # #ver=$(echo "$link_yuzuea" | sed 's,^.*/EA-,,g' | cut -d "/" -f1)
		  # rm /userdata/system/switch/extra/yuzuea/version.txt 2>/dev/null
		  # echo $version >> /userdata/system/switch/extra/yuzuea/version.txt
		# fi
	# else
		# echo -e "${T}██ ${C}   ${F}YUZU-EA   [${W}!!${T}]   place yuzuEA.AppImage in /userdata/system/switch/"	
	# fi	
# fi
##
#
#
# ---------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------- 
#
#
##
if [ "$3" = "RYUJINX" ]; then
T=$THEME_COLOR_RYUJINX
cd /userdata/system/switch/appimages
# version="1.2.81"
# ryu="/userdata/system/switch/appimages/ryujinx-${version}-linux_x64.tar.gz"
# if [ -f "$ryu" ]; then
    # cp /userdata/system/switch/appimages/ryujinx-${version}-linux_x64.tar.gz /userdata/system/switch/ryujinx-${version}-linux_x64.tar.gz 2>/dev/null;
# else 
    # wget -q --show-progress --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/appimages/ryujinx-${version}-linux_x64.tar.gz" "https://foclabroc.freeboxos.fr:55973/share/auyM2KBoFrmv_yBe/ryujinx-1.2.81-linux_x64.tar.gz"
    # cp /userdata/system/switch/appimages/ryujinx-${version}-linux_x64.tar.gz /userdata/system/switch/ryujinx-${version}-linux_x64.tar.gz 2>/dev/null; fi
# link_ryujinx="/userdata/system/switch/ryujinx-${version}-linux_x64.tar.gz"
# # --------------------------------------------------------
# if [ "$N" = "1" ]; then C=""; else C="$E/$N"; fi
# if [ -f "$link_ryujinx" ]; then	
    # if [ -f "$link_ryujinx" ] && [ $(stat -c%s "$link_ryujinx") -gt 2048 ]; then
	       # echo -e "${T}RYUJINX   ${T}❯❯   ${T}/$version/ ${GREEN}SUCCESS"
          # else
	       # echo -e "${T}RYUJINX   [${W}!!${T}] download fail put ryujinx-1.2.81-linux_x64.tar.gz in (/system/switch/appimages) then relaunch script"    	
	       # rm /userdata/system/switch/appimages/ryujinx-1.2.81-linux_x64.tar.gz 2>/dev/null;
	# fi
rm /userdata/system/switch/appimages/ryujinx-1.2.81-linux_x64.tar.gz 2>/dev/null
version=$(curl -s https://api.github.com/repos/Ryubing/Canary-Releases/releases/latest | grep -oP '(?<="tag_name": ")[^"]*')
wget -q --show-progress --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/ryujinx-${version}-linux_x64.tar.gz" "https://github.com/Ryubing/Canary-Releases/releases/download/$version/ryujinx-canary-${version}-linux_x64.tar.gz"
link_ryujinx=/userdata/system/switch/ryujinx-${version}-linux_x64.tar.gz
link_tarR="/userdata/system/switch/appimages/ryujinx-canary-1.2.96-linux_x64.tar.gz"
# --------------------------------------------------------
if [ "$N" = "1" ]; then C=""; else C="$E/$N"; fi
if [ -f "$link_ryujinx" ]; then
    if [ -f "$link_ryujinx" ] && [ $(stat -c%s "$link_ryujinx") -gt 2048 ]; then
	      echo -e "${T}RYUJINX   ${T}❯❯   ${T}/$version/ ${GREEN}SUCCESS"
	        else
	          if [ -f "$link_tarR" ]; then
	            cp /userdata/system/switch/appimages/ryujinx-canary-1.2.96-linux_x64.tar.gz /userdata/system/switch/ryujinx-${version}-linux_x64.tar.gz 2>/dev/null;
			    echo -e "${T}RYUJINX   ${RED}FAIL TO DOWNLOAD LAST GREEMDEV USE 1.2.96 BACKUP INSTEAD   ${T}/1.2.96/ ${GREEN}SUCCESS";
		      else
	            wget -q --show-progress --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/appimages/ryujinx-canary-1.2.96-linux_x64.tar.gz" "https://foclabroc.freeboxos.fr:55973/share/tGbwP0xLt1KcKXYS/ryujinx-canary-1.2.96-linux_x64.tar.gz"
                cp /userdata/system/switch/appimages/ryujinx-canary-1.2.96-linux_x64.tar.gz /userdata/system/switch/ryujinx-${version}-linux_x64.tar.gz 2>/dev/null;
	            echo -e "${T}RYUJINX   ${RED}FAIL TO DOWNLOAD LAST GREEMDEV USE 1.2.96 INSTEAD   ${T}/1.2.96/ ${GREEN}SUCCESS";
			  fi
	fi

# --------------------------------------------------------
# \\ get dependencies for handling ryujinxavalonia
		  link_tar=https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/batocera-switch-tar
		  link_libselinux=https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/batocera-switch-libselinux.so.1
		  if [[ -e "$extra/batocera-switch-tar" ]]; then 
			chmod a+x "$extra/batocera-switch-tar"
		  else 
			wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$extra/batocera-switch-tar" "$link_tar"
			###curl -sSf "$link_tar" -o "$extra/batocera-switch-tar"
			chmod a+x "$extra/batocera-switch-tar"
		  fi
		  if [[ ! -e "/usr/lib/libselinux.so.1" ]]; then
			wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$extra/batocera-switch-libselinux.so.1" "$link_libselinux"
			###curl -sSf "$link_libselinux" -o "$extra/batocera-switch-libselinux.so.1"
			if [[ -f "$extra/batocera-switch-libselinux.so.1" ]]; then 
			  if [[ "$(wc -c "$extra/batocera-switch-libselinux.so.1" | awk '{print $1}')" < "100" ]]; then 
				wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$extra/batocera-switch-libselinux.so.1" "$link_libselinux"   
			  fi
			fi
		    chmod a+x "$extra/batocera-switch-libselinux.so.1"
		    cp "$extra/batocera-switch-libselinux.so.1" "/usr/lib/libselinux.so.1" 2>/dev/null
		  fi
		  if [[ -e "/userdata/system/switch/extra/batocera-switch-libselinux.so.1" ]]; then 
			cp /userdata/system/switch/extra/batocera-switch-libselinux.so.1 cp /userdata/system/switch/extra/libselinux.so.1 2>/dev/null
		  fi
# //
# /userdata/system/switch/extra/ryujinx/ will keep all ryujinx related dependencies
		  emu=ryujinx
		  mkdir $extra/$emu 2>/dev/null
		  rm -rf $temp/$emu 2>/dev/null
		  mkdir $temp/$emu 2>/dev/null
		  cd $temp/$emu
		  mv $link_ryujinx $temp/$emu/ryujinx-${version}-linux_x64.tar.gz 2>/dev/null
		  wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$extra/$emu/xdg-mime" "https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/xdg-mime"
		  # ###curl -sSf "https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/xdg-mime" -o "$extra/$emu/xdg-mime"
		  chmod a+x "$extra/$emu/xdg-mime"
		  # curl --progress-bar --remote-name --location $link_ryujinx
		  LD_LIBRARY_PATH="/userdata/system/switch/extra:/usr/lib64:/usr/lib:/lib:${LD_LIBRARY_PATH}" $extra/batocera-switch-tar -xf $temp/$emu/*.tar.gz
		  cd /userdata/system/switch/extra/
          # unzip -o -qq /userdata/system/switch/extra/extralibr.zip 2>/dev/null
		  # cp /userdata/system/switch/extra/extralibr/lib* $extra/$emu/
		  rm -rf /userdata/system/switch/extra/extralibr 2>/dev/null
		  rm /userdata/system/switch/extra/extralibr.zip 2>/dev/null
		  mkdir $extra/$emu/mime 2>/dev/null; 
		  cp -rL $temp/$emu/publish/mime/* $extra/$emu/mime/ 2>/dev/null;
		  cp -rL $temp/$emu/publish/*.config $extra/$emu/ 2>/dev/null;
		  cp -rL $temp/$emu/publish/lib* $extra/$emu/ 2>/dev/null;
		  cd $extra/$emu
		  mv $extra/$emu/libSDL2.so $extra/$emu/libSDL2-2.0.so.0 2>/dev/null;
		  #wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/libSDL2.so" "https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/libSDL2.so"
		  #rm $extra/$emu/libSDL2.so 2>/dev/null
		  #cp /userdata/system/switch/extra/libSDL2.so $extra/$emu/ 2>/dev/null;
		  rm -rf $extra/$emu/dependencies 2>/dev/null
		  ls -l ./lib* | awk '{print $9}' | cut -d "/" -f2 >> $extra/$emu/dependencies
		  cd ~/
		  f=$extra/$emu/startup
		  rm -rf "$f" 2>/dev/null
		  echo '#!/bin/bash' >> "$f"
		  echo 'cp /userdata/system/switch/extra/'$emu'/lib* /lib/ 2>/dev/null' >> "$f"
		  dos2unix "$startup" 2>/dev/null
		  chmod a+x "$startup" 2>/dev/null
		  $extra/$emu/startup 2>/dev/null
# / 
		  path_ryujinx=$extra/$emu/Ryujinx.AppImage
		  cp $temp/$emu/publish/Ryujinx $path_ryujinx 2>/dev/null
		  chmod a+x "$path_ryujinx" 2>/dev/null
# make launcher 
		  f=/userdata/system/switch/Ryujinx.AppImage
		  rm "$f" 2>/dev/null
		  echo '#!/bin/bash' >> "$f"

		  echo 'export XDG_DATA_DIRS=/userdata/saves/flatpak/data/.local/share/flatpak/exports/share:/userdata/saves/flatpak/binaries/exports/share/applications/:/userdata/system/.local/share/flatpak/exports/share:/userdata/saves/flatpak/binaries/exports/share:/usr/local/share:/usr/share' >> "$f"
		  echo 'export PATH=/userdata/system/.local/bin:/userdata/system/bin:/bin:/sbin:/usr/bin:/usr/sbin' >> "$f"
		  echo 'export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket' >> "$f"
		  echo 'export XDG_MENU_PREFIX=batocera-' >> "$f"
		  echo 'export XDG_CONFIG_DIRS=/etc/xdg' >> "$f"
		  echo 'export XDG_CURRENT_DESKTOP=XFCE' >> "$f"
		  echo 'export DESKTOP_SESSION=XFCE' >> "$f"

		  echo '/userdata/system/switch/extra/batocera-switch-ryujinx-fixes.sh' >> "$f" 
		  echo '/userdata/system/switch/extra/batocera-switch-sync-firmware.sh' >> "$f" 
		  echo '/userdata/system/switch/extra/batocera-switch-mousemove.sh &' >> "$f" 
		  echo '/userdata/system/switch/extra/batocera-switch-translator.sh &' >> "$f"

		  echo 'chmod a+x /userdata/system/switch/extra/lib/* 2>/dev/null' >> "$f"
		  echo 'chmod a+x /userdata/system/switch/extra/lib/gdk-pixbuf-2.0/* 2>/dev/null' >> "$f"
		  echo 'chmod a+x /userdata/system/switch/extra/lib/gdk-pixbuf-2.0/2.10.0/* 2>/dev/null' >> "$f"
		  echo 'chmod a+x /userdata/system/switch/extra/lib/gdk-pixbuf-2.0/2.10.0/loaders/* 2>/dev/null' >> "$f"
		  echo 'if [[ ! -e /usr/lib64/gdk-pixbuf-2.0 ]]; then cp -r /userdata/system/switch/extra/lib/gdk-pixbuf-2.0 /usr/lib64/ 2>/dev/null; fi' >> "$f"
		  #echo 'ln -sf /userdata/system/switch/extra/lib/librsvg-2.so.2 /usr/lib64/ 2>/dev/null' >> "$f"
		  #echo 'ln -sf /userdata/system/switch/extra/lib/libcairo.so.2 /usr/lib64/ 2>/dev/null' >> "$f"
		  echo 'chmod a+x /userdata/system/switch/extra/usr/bin/* 2>/dev/null' >> "$f"
		  echo 'cp -rL /userdata/system/switch/extra/usr/bin/* /usr/bin/ 2>/dev/null' >> "$f"
		  echo 'cp -rL /userdata/system/switch/extra/usr/bin/rev /userdata/system/switch/extra/batocera-switch-rev 2>/dev/null' >> "$f"
		  echo 'mkdir -p /usr/lib/x86_64-linux-gnu 2>/dev/null' >> "$f"
		  echo 'if [[ ! -e /usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0 ]]; then cp -r /userdata/system/switch/extra/lib/gdk-pixbuf-2.0 /usr/lib/x86_64-linux-gnu/ 2>/dev/null; fi' >> "$f"

		  echo 'cp /userdata/system/switch/extra/'$emu'/xdg-mime /usr/bin/ 2>/dev/null' >> "$f"
		  echo 'if [ ! -L /userdata/system/configs/Ryujinx/bis/user/save ]; then mkdir /userdata/system/configs/Ryujinx/bis/user/save 2>/dev/null; rsync -au /userdata/saves/Ryujinx/ /userdata/system/configs/Ryujinx/bis/user/save/ 2>/dev/null; fi' >> "$f"
		  echo 'if [ ! -L /userdata/system/configs/yuzu/nand/user/save ]; then mkdir /userdata/system/configs/yuzu/nand/user/save 2>/dev/null; rsync -au /userdata/saves/yuzu/ /userdata/system/configs/yuzu/nand/user/save/ 2>/dev/null; fi' >> "$f"
		  echo 'mkdir -p /userdata/system/configs/yuzu/keys 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/configs/yuzu/keys/ 2>/dev/null ' >> "$f"
		  echo 'mkdir -p /userdata/system/.local/share/yuzu/keys 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/.local/share/yuzu/keys/ 2>/dev/null ' >> "$f"
		  echo 'mkdir -p /userdata/system/configs/Ryujinx/system 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/configs/Ryujinx/system/ 2>/dev/null ' >> "$f"
		  echo 'rm /usr/bin/ryujinx 2>/dev/null; ln -s /userdata/system/switch/Ryujinx.AppImage /usr/bin/ryujinx 2>/dev/null' >> "$f"

		  echo 'mkdir -p /userdata/system/switch/logs 2>/dev/null ' >> "$f"
		  echo 'log1=/userdata/system/switch/logs/Ryujinx-out.txt 2>/dev/null ' >> "$f"
		  echo 'log2=/userdata/system/switch/logs/Ryujinx-err.txt 2>/dev/null ' >> "$f"
		  echo 'rm $log1 2>/dev/null && rm $log2 2>/dev/null ' >> "$f"

		  echo 'ulimit -H -n 819200; ulimit -S -n 819200; ulimit -S -n 819200 Ryujinx.AppImage;' >> "$f"

		  echo 'rom="$1" ' >> "$f"
		  echo 'rm /tmp/switchromname 2>/dev/null ' >> "$f"
		  echo 'echo "$rom" >> /tmp/switchromname 2>/dev/null ' >> "$f"
		  echo '/userdata/system/switch/extra/batocera-switch-nsz-converter.sh ' >> "$f"
		  echo 'rom="$(cat /tmp/switchromname)" ' >> "$f"

		  echo 'd=/userdata/system/switch/extra/lib/gdk-pixbuf-2.0/2.10.0/loaders ' >> "$f"
		  echo 'export LD_LIBRARY_PATH="/userdata/system/switch/extra/lib:/usr/lib:/lib:/usr/lib32:/lib32:$LD_LIBRARY_PATH" ' >> "$f"
		  echo 'export GDK_PIXBUF_MODULE_FILE="/userdata/system/switch/extra/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" ' >> "$f"
		  echo 'export GDK_PIXBUF_MODULEDIR="/userdata/system/switch/extra/lib/gdk-pixbuf-2.0/2.10.0/loaders" ' >> "$f"
		  echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$GDK_PIXBUF_MODULEDIR" ' >> "$f"
		  echo 'if [[ "$1" = "" ]]; then ' >> "$f"
		  echo 'DRI_PRIME=1 AMD_VULKAN_ICD=RADV DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1 XDG_MENU_PREFIX=batocera- XDG_CONFIG_DIRS=/etc/xdg XDG_CURRENT_DESKTOP=XFCE DESKTOP_SESSION=XFCE QT_FONT_DPI=96 QT_SCALE_FACTOR=1 GDK_SCALE=1 SCRIPT_DIR=/userdata/system/switch/extra/ryujinx DOTNET_EnableAlternateStackCheck=1 QT_PLUGIN_PATH=/usr/lib/qt/plugins:/userdata/system/switch/extra/lib/qt5plugins:/usr/plugins:${QT_PLUGIN_PATH} QT_QPA_PLATFORM_PLUGIN_PATH=${QT_PLUGIN_PATH} XDG_CONFIG_HOME=/userdata/system/configs XDG_CACHE_HOME=/userdata/system/.cache QT_QPA_PLATFORM=xcb LD_LIBRARY_PATH=/userdata/system/switch/extra/lib:/userdata/system/switch/extra/ryujinx:$LD_LIBRARY_PATH /userdata/system/switch/extra/ryujinx/Ryujinx.AppImage > >(tee "$log1") 2> >(tee "$log2" >&2) ' >> "$f"
		  echo 'else ' >> "$f"
		  echo 'DRI_PRIME=1 AMD_VULKAN_ICD=RADV DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1 XDG_MENU_PREFIX=batocera- XDG_CONFIG_DIRS=/etc/xdg XDG_CURRENT_DESKTOP=XFCE DESKTOP_SESSION=XFCE QT_FONT_DPI=96 QT_SCALE_FACTOR=1 GDK_SCALE=1 SCRIPT_DIR=/userdata/system/switch/extra/ryujinx DOTNET_EnableAlternateStackCheck=1 QT_PLUGIN_PATH=/usr/lib/qt/plugins:/userdata/system/switch/extra/lib/qt5plugins:/usr/plugins:${QT_PLUGIN_PATH} QT_QPA_PLATFORM_PLUGIN_PATH=${QT_PLUGIN_PATH} XDG_CONFIG_HOME=/userdata/system/configs XDG_CACHE_HOME=/userdata/system/.cache QT_QPA_PLATFORM=xcb LD_LIBRARY_PATH=/userdata/system/switch/extra/lib:/userdata/system/switch/extra/ryujinx:$LD_LIBRARY_PATH /userdata/system/switch/extra/ryujinx/Ryujinx.AppImage "$rom" > >(tee "$log1") 2> >(tee "$log2" >&2) ' >> "$f"
		  echo 'fi ' >> "$f"
		  echo ' ' >> "$f"
		  dos2unix "$f" 2>/dev/null; chmod a+x "$f" 2>/dev/null
# --------------------------------------------------------
# --------------------------------------------------------
		  size_ryujinx=$(($(wc -c $path_ryujinx | awk '{print $1}')/1048576)) 2>/dev/null
		  #echo -e "${T}» ~/switch/Ryujinx.AppImage · ${T}$size_ryujinx( )MB   ${T}" | sed 's/( )//g'
		  echo
		  cd ~/
# send version to cookie: 
#		  ver=$(echo "$link_ryujinx" | sed 's,^.*download/,,g' | cut -d "/" -f1 | sed 's,1\.1\.,,g')
#		  if [[ "$(echo "$link_ryujinx" | grep "382")" != "" ]]; then ver="382"; fi
		  rm /userdata/system/switch/extra/ryujinx/version.txt 2>/dev/null
		  echo $version >> /userdata/system/switch/extra/ryujinx/version.txt; fi
fi
#
#
# ---------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------- 
#
#
# ---------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------- 
#
#
# if [ "$3" = "RYUJINXAVALONIA" ]; then
# T=$THEME_COLOR_RYUJINXAVALONIA
# cd /userdata/system/switch/appimages
# ryuA="/userdata/system/switch/appimages/ryujinxava1403.tar.gz"
# if [ -f "$ryuA" ]; then
    # cp /userdata/system/switch/appimages/ryujinxava1403.tar.gz /userdata/system/switch/ryujinxava1403.tar.gz 2>/dev/null;
# else 
    # wget -q --show-progress --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/appimages/ryujinxava1403.tar.gz" "https://foclabroc.freeboxos.fr:55973/share/DU36Dg9YsZK-gYsr/ryujinxava1403.tar.gz"
    # cp /userdata/system/switch/appimages/ryujinxava1403.tar.gz /userdata/system/switch/ryujinxava1403.tar.gz 2>/dev/null; fi
# link_ryujinxavalonia="/userdata/system/switch/ryujinxava1403.tar.gz"
# version="1403"
# # --------------------------------------------------------
# if [ "$N" = "1" ]; then C=""; else C="$E/$N"; fi
# if [ -f "$link_ryujinxavalonia" ]; then
	# checksum_file=$(md5sum $link_ryujinxavalonia | awk '{print $1}')
	# checksum_verified="442b76511ad0f727f290d8c1e380d2d2"
		# if [[ "$checksum_file" != "$checksum_verified" ]]; then
		   # echo -e "${T}RYUJINX-AVALONIA   [${W}!!${T}] download fail put ryujinxava1403.tar.gz in (/system/switch/appimages) then relaunch script"    	
		   # rm /userdata/system/switch/appimages/ryujinxava1403.tar.gz 2>/dev/null
		# else
# #		  if [[ "$(echo "$link_ryujinxavalonia" | grep "382")" != "" ]]; then version="382"; fi
# #		  version=$(echo "$version" | sed 's,1\.1\.,,g')
		  # echo -e "${T}RYUJINX-AVALONIA   ${T}❯❯   ${T}/$version/ ${GREEN}SUCCESS"
# # --------------------------------------------------------
# # \\ get dependencies for handling ryujinxavalonia
		  # link_tar=https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/batocera-switch-tar
		  # link_libselinux=https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/batocera-switch-libselinux.so.1
		  # if [[ -e "$extra/batocera-switch-tar" ]]; then 
			# chmod a+x "$extra/batocera-switch-tar"
		  # else 
			# wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$extra/batocera-switch-tar" "$link_tar"
			# ###curl -sSf "$link_tar" -o "$extra/batocera-switch-tar"
			# chmod a+x "$extra/batocera-switch-tar"
		  # fi
		  # if [[ ! -e "/usr/lib/libselinux.so.1" ]]; then
			# wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$extra/batocera-switch-libselinux.so.1" "$link_libselinux"
			# ###curl -sSf "$link_libselinux" -o "$extra/batocera-switch-libselinux.so.1"
			# if [[ -f "$extra/batocera-switch-libselinux.so.1" ]]; then 
			  # if [[ "$(wc -c "$extra/batocera-switch-libselinux.so.1" | awk '{print $1}')" < "100" ]]; then 
				# wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$extra/batocera-switch-libselinux.so.1" "$link_libselinux"   
			  # fi
			# fi
			# chmod a+x "$extra/batocera-switch-libselinux.so.1"
			# cp "$extra/batocera-switch-libselinux.so.1" "/usr/lib/libselinux.so.1" 2>/dev/null
		  # fi
		  # if [[ -e "/userdata/system/switch/extra/batocera-switch-libselinux.so.1" ]]; then 
			# cp /userdata/system/switch/extra/batocera-switch-libselinux.so.1 cp /userdata/system/switch/extra/libselinux.so.1 2>/dev/null
		  # fi
# # //
# # /userdata/system/switch/extra/ryujinxavalonia/ will keep all ryujinxavalonia related dependencies
		  # emu=ryujinxavalonia
		  # mkdir $extra/$emu 2>/dev/null  
		  # rm -rf $temp/$emu 2>/dev/null
		  # mkdir $temp/$emu 2>/dev/null
		  # cd $temp/$emu
		  # mv $link_ryujinxavalonia $temp/$emu/test-ava-ryujinx-1.1.1403-linux_x64.tar.gz 2>/dev/null
		  # wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$extra/$emu/xdg-mime" "https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/xdg-mime"
		  # ###curl -sSf "https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/xdg-mime" -o "$extra/$emu/xdg-mime"
		  # chmod a+x "$extra/$emu/xdg-mime"
		  # #curl --progress-bar --remote-name --location $link_ryujinxavalonia
		  # LD_LIBRARY_PATH="/userdata/system/switch/extra:/usr/lib64:/usr/lib:/lib:${LD_LIBRARY_PATH}" $extra/batocera-switch-tar -xf $temp/$emu/*.tar.gz 2>/dev/null
		  # cp $temp/$emu/publish/lib* $extra/$emu/ 2>/dev/null
		  # mkdir $extra/$emu/mime 2>/dev/null; 
		  # cp -rL $temp/$emu/publish/mime/* $extra/$emu/mime/ 2>/dev/null;
		  # cp -rL $temp/$emu/publish/*.config $extra/$emu/ 2>/dev/null;
		  # rm -rf $extra/$emu/startup 2>/dev/null
		  # cd $extra/$emu
		  # rm -rf $extra/$emu/dependencies 2>/dev/null
		  # ls -l ./lib* | awk '{print $9}' | cut -d "/" -f2 >> $extra/$emu/dependencies
		  # cd ~/
		  # f=$extra/$emu/startup
		  # rm -rf "$startup" 2>/dev/null
		  # echo '#!/bin/bash' >> "$f"
		  # echo 'cp /userdata/system/switch/extra/'$emu'/lib* /lib/ 2>/dev/null' >> "$f"
		  # dos2unix "$startup" 2>/dev/null
		  # chmod a+x "$startup" 2>/dev/null
		  # $extra/$emu/startup 2>/dev/null
# # /
# # --------------------------------------------------------
		  # path_ryujinx=$extra/$emu/Ryujinx-Avalonia.AppImage
		  # cp $temp/$emu/publish/Ryujinx.Ava $path_ryujinx 2>/dev/null
		  # chmod a+x "$path_ryujinx" 2>/dev/null
# # make launcher 
		  # f=/userdata/system/switch/Ryujinx-Avalonia.AppImage
		  # rm "$f" 2>/dev/null
		  # echo '#!/bin/bash' >> "$f"

		  # echo 'export XDG_DATA_DIRS=/userdata/saves/flatpak/data/.local/share/flatpak/exports/share:/userdata/saves/flatpak/binaries/exports/share/applications/:/userdata/system/.local/share/flatpak/exports/share:/userdata/saves/flatpak/binaries/exports/share:/usr/local/share:/usr/share' >> "$f"
		  # echo 'export PATH=/userdata/system/.local/bin:/userdata/system/bin:/bin:/sbin:/usr/bin:/usr/sbin' >> "$f"
		  # echo 'export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket' >> "$f"
		  # echo 'export XDG_MENU_PREFIX=batocera-' >> "$f"
		  # echo 'export XDG_CONFIG_DIRS=/etc/xdg' >> "$f"
		  # echo 'export XDG_CURRENT_DESKTOP=XFCE' >> "$f"
		  # echo 'export DESKTOP_SESSION=XFCE' >> "$f"

		  # echo '/userdata/system/switch/extra/batocera-switch-ryujinx-fixes.sh' >> "$f" 
		  # echo '/userdata/system/switch/extra/batocera-switch-sync-firmware.sh' >> "$f" 
		  # echo '/userdata/system/switch/extra/batocera-switch-mousemove.sh &' >> "$f" 
		  # echo '/userdata/system/switch/extra/batocera-switch-translator.sh &' >> "$f"

		  # echo 'chmod a+x /userdata/system/switch/extra/lib/* 2>/dev/null' >> "$f"
		  # echo 'chmod a+x /userdata/system/switch/extra/lib/gdk-pixbuf-2.0/* 2>/dev/null' >> "$f"
		  # echo 'chmod a+x /userdata/system/switch/extra/lib/gdk-pixbuf-2.0/2.10.0/* 2>/dev/null' >> "$f"
		  # echo 'chmod a+x /userdata/system/switch/extra/lib/gdk-pixbuf-2.0/2.10.0/loaders/* 2>/dev/null' >> "$f"
		  # echo 'if [[ ! -e /usr/lib64/gdk-pixbuf-2.0 ]]; then cp -r /userdata/system/switch/extra/lib/gdk-pixbuf-2.0 /usr/lib64/ 2>/dev/null; fi' >> "$f"
		  # #echo 'ln -sf /userdata/system/switch/extra/lib/librsvg-2.so.2 /usr/lib64/ 2>/dev/null' >> "$f"
		  # #echo 'ln -sf /userdata/system/switch/extra/lib/libcairo.so.2 /usr/lib64/ 2>/dev/null' >> "$f"
		  # echo 'chmod a+x /userdata/system/switch/extra/usr/bin/* 2>/dev/null' >> "$f"
		  # echo 'cp -rL /userdata/system/switch/extra/usr/bin/* /usr/bin/ 2>/dev/null' >> "$f"
		  # echo 'cp -rL /userdata/system/switch/extra/usr/bin/rev /userdata/system/switch/extra/batocera-switch-rev 2>/dev/null' >> "$f"
		  # echo 'mkdir -p /usr/lib/x86_64-linux-gnu 2>/dev/null' >> "$f"
		  # echo 'if [[ ! -e /usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0 ]]; then cp -r /userdata/system/switch/extra/lib/gdk-pixbuf-2.0 /usr/lib/x86_64-linux-gnu/ 2>/dev/null; fi' >> "$f"

		  # echo 'cp /userdata/system/switch/extra/'$emu'/xdg-mime /usr/bin/ 2>/dev/null' >> "$f"
		  # echo 'if [ ! -L /userdata/system/configs/Ryujinx/bis/user/save ]; then mkdir /userdata/system/configs/Ryujinx/bis/user/save 2>/dev/null; rsync -au /userdata/saves/Ryujinx/ /userdata/system/configs/Ryujinx/bis/user/save/ 2>/dev/null; fi' >> "$f"
		  # echo 'if [ ! -L /userdata/system/configs/yuzu/nand/user/save ]; then mkdir /userdata/system/configs/yuzu/nand/user/save 2>/dev/null; rsync -au /userdata/saves/yuzu/ /userdata/system/configs/yuzu/nand/user/save/ 2>/dev/null; fi' >> "$f"
		  # echo 'mkdir -p /userdata/system/configs/yuzu/keys 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/configs/yuzu/keys/ 2>/dev/null ' >> "$f"
		  # echo 'mkdir -p /userdata/system/.local/share/yuzu/keys 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/.local/share/yuzu/keys/ 2>/dev/null ' >> "$f"
		  # echo 'mkdir -p /userdata/system/configs/Ryujinx/system 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/configs/Ryujinx/system/ 2>/dev/null ' >> "$f"
		  # echo 'rm /usr/bin/ryujinx 2>/dev/null; ln -s /userdata/system/switch/Ryujinx-Avalonia.AppImage /usr/bin/ryujinx 2>/dev/null' >> "$f"

		  # echo 'mkdir -p /userdata/system/switch/logs 2>/dev/null ' >> "$f"
		  # echo 'log1=/userdata/system/switch/logs/Ryujinx-Avalonia-out.txt 2>/dev/null ' >> "$f"
		  # echo 'log2=/userdata/system/switch/logs/Ryujinx-Avalonia-err.txt 2>/dev/null ' >> "$f"
		  # echo 'rm $log1 2>/dev/null && rm $log2 2>/dev/null ' >> "$f"

		  # echo 'ulimit -H -n 819200; ulimit -S -n 819200; ulimit -S -n 819200 Ryujinx-Avalonia.AppImage;' >> "$f"

		  # echo 'rom="$1" ' >> "$f"
		  # echo 'rm /tmp/switchromname 2>/dev/null ' >> "$f"
		  # echo 'echo "$rom" >> /tmp/switchromname 2>/dev/null ' >> "$f"
		  # echo '/userdata/system/switch/extra/batocera-switch-nsz-converter.sh ' >> "$f"
		  # echo 'rom="$(cat /tmp/switchromname)" ' >> "$f"

		  # echo 'd=/userdata/system/switch/extra/lib/gdk-pixbuf-2.0/2.10.0/loaders ' >> "$f"
		  # #without preload for avalonia
		  # echo 'if [[ "$1" = "" ]]; then ' >> "$f"
		  # echo 'export LD_LIBRARY_PATH="/userdata/system/switch/extra/lib:/usr/lib:/lib:/usr/lib32:/lib32:$LD_LIBRARY_PATH" ' >> "$f"
		  # echo 'export GDK_PIXBUF_MODULE_FILE="/userdata/system/switch/extra/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" ' >> "$f"
		  # echo 'export GDK_PIXBUF_MODULEDIR="/userdata/system/switch/extra/lib/gdk-pixbuf-2.0/2.10.0/loaders" ' >> "$f"
		  # echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$GDK_PIXBUF_MODULEDIR" ' >> "$f"
		  # echo 'DRI_PRIME=1 AMD_VULKAN_ICD=RADV DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1 XDG_MENU_PREFIX=batocera- XDG_CONFIG_DIRS=/etc/xdg XDG_CURRENT_DESKTOP=XFCE DESKTOP_SESSION=XFCE QT_FONT_DPI=96 QT_SCALE_FACTOR=1 GDK_SCALE=1 SCRIPT_DIR=/userdata/system/switch/extra/ryujinxavalonia DOTNET_EnableAlternateStackCheck=1 QT_PLUGIN_PATH=/usr/lib/qt/plugins:/userdata/system/switch/extra/lib/qt5plugins:/usr/plugins:${QT_PLUGIN_PATH} QT_QPA_PLATFORM_PLUGIN_PATH=${QT_PLUGIN_PATH} XDG_CONFIG_HOME=/userdata/system/configs XDG_CACHE_HOME=/userdata/system/.cache QT_QPA_PLATFORM=xcb LD_LIBRARY_PATH=/userdata/system/switch/extra/lib:/userdata/system/switch/extra/ryujinxavalonia:$LD_LIBRARY_PATH /userdata/system/switch/extra/ryujinxavalonia/Ryujinx-Avalonia.AppImage > >(tee "$log1") 2> >(tee "$log2" >&2) ' >> "$f"
		  # echo 'else ' >> "$f"
		  # echo 'DRI_PRIME=1 AMD_VULKAN_ICD=RADV DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1 XDG_MENU_PREFIX=batocera- XDG_CONFIG_DIRS=/etc/xdg XDG_CURRENT_DESKTOP=XFCE DESKTOP_SESSION=XFCE QT_FONT_DPI=96 QT_SCALE_FACTOR=1 GDK_SCALE=1 SCRIPT_DIR=/userdata/system/switch/extra/ryujinxavalonia DOTNET_EnableAlternateStackCheck=1 QT_PLUGIN_PATH=/usr/lib/qt/plugins:/userdata/system/switch/extra/lib/qt5plugins:/usr/plugins:${QT_PLUGIN_PATH} QT_QPA_PLATFORM_PLUGIN_PATH=${QT_PLUGIN_PATH} XDG_CONFIG_HOME=/userdata/system/configs XDG_CACHE_HOME=/userdata/system/.cache QT_QPA_PLATFORM=xcb LD_LIBRARY_PATH=/userdata/system/switch/extra/lib:/userdata/system/switch/extra/ryujinxavalonia:$LD_LIBRARY_PATH /userdata/system/switch/extra/ryujinxavalonia/Ryujinx-Avalonia.AppImage "$rom" > >(tee "$log1") 2> >(tee "$log2" >&2) ' >> "$f"
		  # echo 'fi ' >> "$f"
		  # echo ' ' >> "$f"

		  # dos2unix "$f" 2>/dev/null; chmod a+x "$f" 2>/dev/null
# # --------------------------------------------------------
# # --------------------------------------------------------
		  # size_ryujinx=$(($(wc -c $path_ryujinx | awk '{print $1}')/1048576)) 2>/dev/null
		  # #echo -e "${T}» ~/switch/Ryujinx-Avalonia.AppImage · ${T}$size_ryujinx( )MB   ${T}" | sed 's/( )//g'
		  # echo
		  # cd ~/
# # send version to cookie: 
# #		  ver=$(echo "$link_ryujinxavalonia" | sed 's,^.*download/,,g' | cut -d "/" -f1 | sed 's,1\.1\.,,g')
# #		  if [[ "$(echo "$link_ryujinxavalonia" | grep "382")" != "" ]]; then ver="382"; fi
		  # rm /userdata/system/switch/extra/ryujinxavalonia/version.txt 2>/dev/null
		  # echo $version >> /userdata/system/switch/extra/ryujinxavalonia/version.txt
		# fi
	# else
		# echo -e "${T}██ ${C}   ${F}RYUJINX-AVALONIA   [${W}!!${T}]   place test-ava-ryujinx-1.1.1403-linux_x64.tar.gz in /userdata/system/switch/"	
	# fi
# fi	
#
#
# ---------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------- 
#
#
}
export -f update_emulator
#
#
#
function batocera_update_switch {
######################################################################
if [[ -e "/tmp/updater-mode" ]]; then 
   MODE=$(cat /tmp/updater-mode | grep MODE | cut -d "=" -f2)
fi
cd ~/
# -------------------------------------------------------------------
# -------------------------------------------------------------------
spinner()
{
    local pid=$1
    local delay=0.2
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "LOADING EMULATORS  %c   " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    done
    printf "   \b\b\b\b"
}
# -------------------------------------------------------------------
# -------------------------------------------------------------------
resolvelinks()
{
# LINKS & RESOLVERS:
# -------------------------------------------------------------------
links=/userdata/system/switch/extra/links
rm -rf $links 2>/dev/null
#
echo "link_yuzuea@$link_yuzuea" >> $links
echo "link_ryujinx@$link_ryujinx" >> $links
echo "link_ryujinxavalonia@$link_ryujinxavalonia" >> $links
}
######################################################################
# GET EMULATORS FROM CONFIG FILE -------------------------------------
cfg=/userdata/system/switch/CONFIG.txt
dos2unix $cfg 1>/dev/null 2>/dev/null
if [[ -e "$cfg" ]]; then 
   EMULATORS=$(cat "$cfg" | grep "EMULATORS=" | cut -d "=" -f2 | head -n1 | cut -d \" -f2 | tr -d '\0')
   EMULATORS=$(echo "$EMULATORS ")
      if [[ "$EMULATORS" == *"DEFAULT"* ]] || [[ "$EMULATORS" == *"default"* ]] || [[ "$EMULATORS" == *"ALL"* ]] || [[ "$EMULATORS" == *"all"* ]]; then
         EMULATORS="YUZUEA RYUJINX RYUJINXAVALONIA"
      fi
      if [ "$(echo $EMULATORS | grep "-")" = "" ]; then 
         EMULATORS="$EMULATORS-"
         EMULATORS=$(echo $EMULATORS | sed 's/ /-/g')
      fi
fi 
# /GET EMULATORS FROM CONFIG FILE -------------------------------------
F=$TEXT_COLOR
T=$THEME_COLOR
# REREAD TEXT/THEME COLORS:
###########################
X='\033[0m'               # / resetcolor
RED='\033[1;31m'          # red
BLUE='\033[1;34m'         # blue
GREEN='\033[1;32m'        # green
YELLOW='\033[1;33m'       # yellow
PURPLE='\033[1;35m'       # purple
CYAN='\033[1;36m'         # cyan
#-------------------------#
DARKRED='\033[0;31m'      # darkred
DARKBLUE='\033[0;34m'     # darkblue
DARKGREEN='\033[0;32m'    # darkgreen
DARKYELLOW='\033[0;33m'   # darkyellow
DARKPURPLE='\033[0;35m'   # darkpurple
DARKCYAN='\033[0;36m'     # darkcyan
#-------------------------#
WHITE='\033[0;37m'        # white
BLACK='\033[0;30m'        # black
###########################
R=$RED
W=$WHITE
B=$BLACK
F=$WHITE
# -------------------------
#  override colors: 
if [[ "$MODE" = "CONSOLE" ]]; then 
   RED=$X
   R=$X
   F=$X
   W=$X
fi
# -------------------------
# -------------------------
# -------------------------
# -------------------------
clear
echo -e "${R}"
echo -e "${F}S${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}-"
echo -e "${F}SW${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}»-"
echo -e "${F}${R}s${F}WI${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}-»-"
echo -e "${F}S${R}w${F}IT${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}--»-"
echo -e "${F}SW${R}i${F}TC${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}---»-"
echo -e "${F}SWI${R}t${F}CH${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}----»-"
echo -e "${F}SWIT${R}c${F}H ${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}-----»-"
echo -e "${F}SWITC${R}h${F} U${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}------»-"
echo -e "${F}SWITCH${R}_${F}UP${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}-------»-"
echo -e "${F}SWITCH ${R}u${F}PD${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}--------»-"
echo -e "${F}SWITCH U${R}p${F}DA${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}---------»-"
echo -e "${F}SWITCH UP${R}d${F}AT${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}----------»-"
echo -e "${F}SWITCH UPD${R}aTE${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}-----------»-"
echo -e "${F}SWITCH UPDA${R}t${F}ER${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}------------»-"
echo -e "${F}SWITCH UPDAT${R}e${F}R ${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}-------------»-"
echo -e "${F}SWITCH UPDATE${R}r${F} F${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}--------------»-"
echo -e "${F}SWITCH UPDATER${R}_${F}FO${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}---------------»-"
echo -e "${F}SWITCH UPDATER ${R}f${F}OR${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}----------------»-"
echo -e "${F}SWITCH UPDATER F${R}o${F}R ${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}-----------------»-"
echo -e "${F}SWITCH UPDATER FO${R}r${F} B${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}------------------»-"
echo -e "${F}SWITCH UPDATER FOR${R}_${F}BA${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}-------------------»-"
echo -e "${F}SWITCH UPDATER FOR ${R}b${F}AT${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}--------------------»-"
echo -e "${F}SWITCH UPDATER FOR B${R}a${F}TO${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}---------------------»-"
echo -e "${F}SWITCH UPDATER FOR BA${R}t${F}OC${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}----------------------»-"
echo -e "${F}SWITCH UPDATER FOR BAT${R}o${F}CE${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}-----------------------»-"
echo -e "${F}SWITCH UPDATER FOR BATO${R}c${F}ER${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}------------------------»-"
echo -e "${F}SWITCH UPDATER FOR BATOC${R}e${F}RA${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}-------------------------»-"
echo -e "${F}SWITCH UPDATER FOR BATOCE${R}r${F}A${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}--------------------------»"
echo -e "${F}SWITCH UPDATER FOR BATOCER${R}a${R}"
echo
sleep 0.033
# -------------------------
clear
echo -e "${R}---------------------------¬"
echo -e "${F}SWITCH UPDATER FOR BATOCERA${R}"
echo
sleep 0.033
# -------------------------
# -------------------------
# -------------------------
# -------------------------
clear
echo -e "${R}---------------------------¬"
echo -e "${F}SWITCH UPDATER FOR BATOCERA${R}"
echo
resolvelinks & spinner $!
# -------------------------
clear
echo -e "${W}${R}>--------------------------¬"
echo -e "${R}.${W}/iTCH UPDATER FOR BATOCERA"
echo
echo -e "${R}LOADING EMULATORS"
sleep 0.1111
# -------------------------
clear
echo -e "${W}\^${R}/>-----------------------¬"
echo -e "${F}${R}:${W}-iTCH UPDATER FOR BATOCERA"
echo
echo -e "${R} /OADING/EMULATOR/"
sleep 0.1111
# -------------------------
clear
echo -e "${W}─<|v${R}x>---------------------¬"
echo -e "${F}s/${R}:${W}\\\cH UPDATER FOR BATOCERA"
echo
echo -e "${R} LOAD/NGEMU/A/ORS"
sleep 0.1111
# -------------------------
clear
echo -e "${W}───</^${R}\>-------------------¬"
echo -e "${F}SWi-${R}:${W}| UPDATER FOR BATOCERA"
echo
echo -e "${R}  LOA//N/EMU/AT/RS"
sleep 0.1111
# -------------------------
clear
echo -e "${W}──────<xv${R}|>----------------¬"
echo -e "${F}SWITCH 4${R}.${W}/aTER FOR BATOCERA"
echo
echo -e "${R}  LOAD//EMUL//S"
sleep 0.1111
# -------------------------
clear
echo -e "${W}─────────<\^${R}/>-------------¬"
echo -e "${F}SWITCH Up|${R}:${W}-eR FOR BATOCERA"
echo
echo -e "${R}   LOA///EMU///S"
sleep 0.1111
# -------------------------
clear
echo -e "${W}────────────<|v${R}x>----------¬"
echo -e "${F}SWITCH UPDAt/${R}. ${W}\oR BATOCERA"
echo
echo -e "${R}   /OADNEM/TRS"
sleep 0.1111
# -------------------------
clear
echo -e "${W}───────────────</^${R}\>-------¬"
echo -e "${F}SWITCH UPDATER -${R}:${W}| BATOCERA"
echo
echo -e "${R}   /OA/NEM//RS"
sleep 0.1111
# -------------------------
clear
echo -e "${W}──────────────────<xv${R}|>----¬"
echo -e "${F}SWITCH UPDATER FOR 4${R}.${W}/oCERA"
echo
echo -e "${R}   ///A/N${W}EM/${R}//S"
sleep 0.1111
# -------------------------
clear
echo -e "${W}─────────────────────<\^${R}/>-¬"
echo -e "${F}SWITCH UPDATER FOR BAt|${R}:${W}-rA"
echo
echo -e "${R}    ///${W}A/N/${R}/${W}/${R}//S"
sleep 0.1111
# -------------------------
clear
echo -e "${W}───────────────────────<|v${R}x¬"
echo -e "${W}SWITCH UPDATER FOR BATOc/${R}.${W}\\"
echo
echo -e "${R}     //${W}A${R}//${W}\/${R}/// "
sleep 0.1111
# -------------------------
clear
echo -e "${W}──────────────────────────<\\"
echo -e "${W}SWITCH UPDATER FOR BATOCe-${R}:"
echo
echo -e "${R}       /${W}\/${R}/${W}//      "
sleep 0.1111
# -------------------------
clear
echo -e "${W}────────────────────────────<"
echo -e "${W}SWITCH UPDATER FOR BATOCER\\"
echo
echo -e "${R}       ${W}/${R}/${W}\\\\${R}/      "
sleep 0.1111
# -------------------------
clear
echo -e "${W}INSTALL WITH LOCAL APPIMAGE (/system/switch/appimages/) OTHERWISE DOWNLOAD IT ONLINE WAIT 1 TO 5 MINUTES!!"
mkdir /userdata/system/switch/appimages 2>/dev/null
cd /userdata/system/switch/appimages
citronE="/userdata/system/switch/appimages/citron0.5.AppImage"
if [ -f "$citronE" ]; then
    cp /userdata/system/switch/appimages/citron0.5.AppImage /userdata/system/switch/citron.AppImage 2>/dev/null;
else 
    wget -q --show-progress --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/appimages/citron0.5.AppImage" "https://foclabroc.freeboxos.fr:55973/share/px6lEai8LZkLoHcd/citron0.5.AppImage"
    cp /userdata/system/switch/appimages/citron0.5.AppImage /userdata/system/switch/citron.AppImage 2>/dev/null; fi
        if [ -f "$citronE" ] && [ $(stat -c%s "$citronE") -gt 2048 ]; then
		   echo -e "${T}CITRON   ${T}❯❯   ${T}/V0.5 (2025.02.22)/ ${GREEN}SUCCESS";
		else
		   rm /userdata/system/switch/appimages/citron0.5.AppImage 2>/dev/null
		   echo -e "${T}CITRON   [${W}!!${T}] download fail put citron0.5.AppImage in (/system/switch/appimages) then relaunch script"; fi

chmod 777 /userdata/system/switch/*.AppImage 2>/dev/null
echo
cd /userdata/system/switch/appimages
rm /userdata/system/switch/appimages/citron.AppImage 2>/dev/null
rm /userdata/system/switch/appimages/citron0.3.AppImage 2>/dev/null
rm /userdata/system/switch/appimages/citron0.4.AppImage 2>/dev/null
rm /userdata/system/switch/appimages/citron0.4b.AppImage 2>/dev/null
rm /userdata/system/switch/appimages/sudachi.zip 2>/dev/null
rm /userdata/system/switch/appimages/sudachi1.0.12.zip 2>/dev/null
rm /userdata/system/switch/appimages/suyu.AppImage 2>/dev/null

suda="/userdata/system/switch/appimages/sudachi1.0.14.AppImage"
if [ -f "$suda" ]; then
    cp /userdata/system/switch/appimages/sudachi1.0.14.AppImage /userdata/system/switch/sudachi.AppImage 2>/dev/null;
else 
    wget -q --show-progress --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/appimages/sudachi1.0.14.AppImage" "https://foclabroc.freeboxos.fr:55973/share/EnGhjDVvv18KJGvz/sudachi1.0.14.AppImage"
    cp /userdata/system/switch/appimages/sudachi1.0.14.AppImage /userdata/system/switch/sudachi.AppImage 2>/dev/null; fi
        if [ -f "$suda" ] && [ $(stat -c%s "$suda") -gt 2048 ]; then
		   echo -e "${T}SUDACHI   ${T}❯❯   ${T}/V1.0.14/ ${GREEN}SUCCESS";
		else
		   rm /userdata/system/switch/appimages/sudachi1.0.14.AppImage 2>/dev/null
		   echo -e "${T}SUDACHI   [${W}!!${T}] download fail put sudachi1.0.14.AppImage in (/system/switch/appimages) then relaunch script"; fi

chmod 777 /userdata/system/switch/sudachi.AppImage 2>/dev/null
rm -rf /userdata/system/switch/sudachi 2>/dev/null
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/citronlaunch.AppImage" "https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/citronlaunch.AppImage"
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/sudachilaunch.AppImage" "https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/sudachilaunch.AppImage"
echo
# -------------------------
links=/userdata/system/switch/extra/links
link_yuzuea=$(cat "$links" | grep "link_yuzuea@" | cut -d "@" -f2 )
link_ryujinx=$(cat "$links" | grep "link_ryujinx@" | cut -d "@" -f2 )
link_ryujinxavalonia=$(cat "$links" | grep "link_ryujinxavalonia@" | cut -d "@" -f2 )
#
# UPDATE 5 EMULATORS -------------------------------------
if [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 5)" != "" ]]; then
update_emulator 1 5 $(echo "$EMULATORS" | cut -d "-" -f 1) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
update_emulator 2 5 $(echo "$EMULATORS" | cut -d "-" -f 2) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
update_emulator 3 5 $(echo "$EMULATORS" | cut -d "-" -f 3) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
update_emulator 4 5 $(echo "$EMULATORS" | cut -d "-" -f 4) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
update_emulator 5 5 $(echo "$EMULATORS" | cut -d "-" -f 5) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
echo -e "${TEXT_COLOR}     ${TEXT_COLOR}   ${TEXT_COLOR} SWITCH EMULATORS INSTALLED ${GREEN}OK ${THEME_COLOR} │${X}"
echo -e "${THEME_COLOR}──────────────────────────────────────┘${X}"
fi
# UPDATE 4 EMULATORS -------------------------------------
if [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 5)" = "" ]] && [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 4)" != "" ]]; then
update_emulator 1 4 $(echo "$EMULATORS" | cut -d "-" -f 1) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
update_emulator 2 4 $(echo "$EMULATORS" | cut -d "-" -f 2) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
update_emulator 3 4 $(echo "$EMULATORS" | cut -d "-" -f 3) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
update_emulator 4 4 $(echo "$EMULATORS" | cut -d "-" -f 4) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
echo -e "${TEXT_COLOR}     ${TEXT_COLOR}   ${TEXT_COLOR} SWITCH EMULATORS INSTALLED ${GREEN}OK ${THEME_COLOR} │${X}"
echo -e "${THEME_COLOR}──────────────────────────────────────┘${X}"
fi
# UPDATE 3 EMULATORS -------------------------------------
if [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 5)" = "" ]] && [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 4)" = "" ]] && [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 3)" != "" ]]; then
update_emulator 1 3 $(echo "$EMULATORS" | cut -d "-" -f 1) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
update_emulator 2 3 $(echo "$EMULATORS" | cut -d "-" -f 2) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
update_emulator 3 3 $(echo "$EMULATORS" | cut -d "-" -f 3) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
echo -e "${TEXT_COLOR}     ${TEXT_COLOR}   ${TEXT_COLOR} SWITCH EMULATORS INSTALLED ${GREEN}OK ${THEME_COLOR} │${X}"
echo -e "${THEME_COLOR}──────────────────────────────────────┘${X}"
fi
# UPDATE 2 EMULATORS -------------------------------------
if [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 5)" = "" ]] && [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 4)" = "" ]] && [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 3)" = "" ]] && [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 2)" != "" ]]; then
update_emulator 1 2 $(echo "$EMULATORS" | cut -d "-" -f 1) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
update_emulator 2 2 $(echo "$EMULATORS" | cut -d "-" -f 2) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
echo -e "${TEXT_COLOR}     ${TEXT_COLOR}   ${TEXT_COLOR} SWITCH EMULATORS INSTALLED ${GREEN}OK ${THEME_COLOR} │${X}"
echo -e "${THEME_COLOR}──────────────────────────────────────┘${X}"
fi
# UPDATE 1 EMULATOR ---------------------------------------
if [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 5)" = "" ]] && [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 4)" = "" ]] && [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 3)" = "" ]] && [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 2)" = "" ]] && [[ "$(echo $EMULATORS | cut -d "=" -f 2 | cut -d "-" -f 1)" != "" ]]; then
update_emulator 1 1 $(echo "$EMULATORS" | cut -d "-" -f 1) "$link_yuzu" "$link_yuzuea" "$link_ryujinx" "$link_ryujinxldn" "$link_ryujinxavalonia"
echo -e "${TEXT_COLOR}     ${TEXT_COLOR}   ${TEXT_COLOR} SWITCH EMULATOR INSTALLED ${GREEN}OK ${THEME_COLOR} │${X}"
echo -e "${THEME_COLOR}───────────────────────────────────────┘${X}"
fi
# 
#sleep 1.1 
# 
}
export -f batocera_update_switch
#
######################################################################
# 
function post-install() { 
#
# -------------------------------------------------------------------
# get settings from config file
#
##### text/colors
      TEXT_SIZE=$(cat $cfg | grep "TEXT_SIZE=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
      TEXT_COLOR=$(cat $cfg | grep "TEXT_COLOR=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
      THEME_COLOR=$(cat $cfg | grep "THEME_COLOR=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
      THEME_COLOR_YUZUEA=$(cat $cfg | grep "THEME_COLOR_YUZUEA=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
      THEME_COLOR_RYUJINX=$(cat $cfg | grep "THEME_COLOR_RYUJINX=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
      THEME_COLOR_RYUJINXAVALONIA=$(cat $cfg | grep "THEME_COLOR_RYUJINXAVALONIA=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
      THEME_COLOR_OK=$(cat $cfg | grep "THEME_COLOR_OK=" | cut -d "=" -f 2 | sed 's, ,,g' | head -n1 | tr -d '\0')
      # TEXT & THEME COLORS: 
      ###########################
      X='\033[0m'               # / resetcolor
      RED='\033[1;31m'          # red
      BLUE='\033[1;34m'         # blue
      GREEN='\033[1;32m'        # green
      YELLOW='\033[1;33m'       # yellow
      PURPLE='\033[1;35m'       # purple
      CYAN='\033[1;36m'         # cyan
      #-------------------------#
      DARKRED='\033[0;31m'      # darkred
      DARKBLUE='\033[0;34m'     # darkblue
      DARKGREEN='\033[0;32m'    # darkgreen
      DARKYELLOW='\033[0;33m'   # darkyellow
      DARKPURPLE='\033[0;35m'   # darkpurple
      DARKCYAN='\033[0;36m'     # darkcyan
      #-------------------------#
      WHITE='\033[0;37m'        # white
      BLACK='\033[0;30m'        # black
      ###########################
      # PARSE COLORS FOR THEMING:
      # ---------------------------------------------------------------------------------- 
      if [ "$TEXT_COLOR" = "RED" ]; then TEXT_COLOR="$RED"; fi
      if [ "$TEXT_COLOR" = "BLUE" ]; then TEXT_COLOR="$BLUE"; fi
      if [ "$TEXT_COLOR" = "GREEN" ]; then TEXT_COLOR="$GREEN"; fi
      if [ "$TEXT_COLOR" = "YELLOW" ]; then TEXT_COLOR="$YELLOW"; fi
      if [ "$TEXT_COLOR" = "PURPLE" ]; then TEXT_COLOR="$PURPLE"; fi
      if [ "$TEXT_COLOR" = "CYAN" ]; then TEXT_COLOR="$CYAN"; fi
      if [ "$TEXT_COLOR" = "DARKRED" ]; then TEXT_COLOR="$DARKRED"; fi
      if [ "$TEXT_COLOR" = "DARKBLUE" ]; then TEXT_COLOR="$DARKBLUE"; fi
      if [ "$TEXT_COLOR" = "DARKGREEN" ]; then TEXT_COLOR="$DARKGREEN"; fi
      if [ "$TEXT_COLOR" = "DARKYELLOW" ]; then TEXT_COLOR="$DARKYELLOW"; fi
      if [ "$TEXT_COLOR" = "DARKPURPLE" ]; then TEXT_COLOR="$DARKPURPLE"; fi
      if [ "$TEXT_COLOR" = "DARKCYAN" ]; then TEXT_COLOR="$DARKCYAN"; fi
      if [ "$TEXT_COLOR" = "WHITE" ]; then TEXT_COLOR="$WHITE"; fi
      if [ "$TEXT_COLOR" = "BLACK" ]; then TEXT_COLOR="$BLACK"; fi
      # ---------------------------------------------------------------------------------- 
      if [ "$THEME_COLOR" = "RED" ]; then THEME_COLOR="$RED"; fi
      if [ "$THEME_COLOR" = "BLUE" ]; then THEME_COLOR="$BLUE"; fi
      if [ "$THEME_COLOR" = "GREEN" ]; then THEME_COLOR="$GREEN"; fi
      if [ "$THEME_COLOR" = "YELLOW" ]; then THEME_COLOR="$YELLOW"; fi
      if [ "$THEME_COLOR" = "PURPLE" ]; then THEME_COLOR="$PURPLE"; fi
      if [ "$THEME_COLOR" = "CYAN" ]; then THEME_COLOR="$CYAN"; fi
      if [ "$THEME_COLOR" = "DARKRED" ]; then THEME_COLOR="$DARKRED"; fi
      if [ "$THEME_COLOR" = "DARKBLUE" ]; then THEME_COLOR="$DARKBLUE"; fi
      if [ "$THEME_COLOR" = "DARKGREEN" ]; then THEME_COLOR="$DARKGREEN"; fi
      if [ "$THEME_COLOR" = "DARKYELLOW" ]; then THEME_COLOR="$DARKYELLOW"; fi
      if [ "$THEME_COLOR" = "DARKPURPLE" ]; then THEME_COLOR="$DARKPURPLE"; fi
      if [ "$THEME_COLOR" = "DARKCYAN" ]; then THEME_COLOR="$DARKCYAN"; fi
      if [ "$THEME_COLOR" = "WHITE" ]; then THEME_COLOR="$WHITE"; fi
      if [ "$THEME_COLOR" = "BLACK" ]; then THEME_COLOR="$BLACK"; fi
      # ---------------------------------------------------------------------------------- 
      if [ "$THEME_COLOR_OK" = "RED" ]; then THEME_COLOR_OK="$RED"; fi
      if [ "$THEME_COLOR_OK" = "BLUE" ]; then THEME_COLOR_OK="$BLUE"; fi
      if [ "$THEME_COLOR_OK" = "GREEN" ]; then THEME_COLOR_OK="$GREEN"; fi
      if [ "$THEME_COLOR_OK" = "YELLOW" ]; then THEME_COLOR_OK="$YELLOW"; fi
      if [ "$THEME_COLOR_OK" = "PURPLE" ]; then THEME_COLOR_OK="$PURPLE"; fi
      if [ "$THEME_COLOR_OK" = "CYAN" ]; then THEME_COLOR_OK="$CYAN"; fi
      if [ "$THEME_COLOR_OK" = "DARKRED" ]; then THEME_COLOR_OK="$DARKRED"; fi
      if [ "$THEME_COLOR_OK" = "DARKBLUE" ]; then THEME_COLOR_OK="$DARKBLUE"; fi
      if [ "$THEME_COLOR_OK" = "DARKGREEN" ]; then THEME_COLOR_OK="$DARKGREEN"; fi
      if [ "$THEME_COLOR_OK" = "DARKYELLOW" ]; then THEME_COLOR_OK="$DARKYELLOW"; fi
      if [ "$THEME_COLOR_OK" = "DARKPURPLE" ]; then THEME_COLOR_OK="$DARKPURPLE"; fi
      if [ "$THEME_COLOR_OK" = "DARKCYAN" ]; then THEME_COLOR_OK="$DARKCYAN"; fi
      if [ "$THEME_COLOR_OK" = "WHITE" ]; then THEME_COLOR_OK="$WHITE"; fi
      if [ "$THEME_COLOR_OK" = "BLACK" ]; then THEME_COLOR_OK="$BLACK"; fi
      # ---------------------------------------------------------------------------------- 
      if [ "$THEME_COLOR_YUZUEA" = "RED" ]; then THEME_COLOR_YUZUEA="$RED"; fi
      if [ "$THEME_COLOR_YUZUEA" = "BLUE" ]; then THEME_COLOR_YUZUEA="$BLUE"; fi
      if [ "$THEME_COLOR_YUZUEA" = "GREEN" ]; then THEME_COLOR_YUZUEA="$GREEN"; fi
      if [ "$THEME_COLOR_YUZUEA" = "YELLOW" ]; then THEME_COLOR_YUZUEA="$YELLOW"; fi
      if [ "$THEME_COLOR_YUZUEA" = "PURPLE" ]; then THEME_COLOR_YUZUEA="$PURPLE"; fi
      if [ "$THEME_COLOR_YUZUEA" = "CYAN" ]; then THEME_COLOR_YUZUEA="$CYAN"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKRED" ]; then THEME_COLOR_YUZUEA="$DARKRED"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKBLUE" ]; then THEME_COLOR_YUZUEA="$DARKBLUE"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKGREEN" ]; then THEME_COLOR_YUZUEA="$DARKGREEN"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKYELLOW" ]; then THEME_COLOR_YUZUEA="$DARKYELLOW"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKPURPLE" ]; then THEME_COLOR_YUZUEA="$DARKPURPLE"; fi
      if [ "$THEME_COLOR_YUZUEA" = "DARKCYAN" ]; then THEME_COLOR_YUZUEA="$DARKCYAN"; fi
      if [ "$THEME_COLOR_YUZUEA" = "WHITE" ]; then THEME_COLOR_YUZUEA="$WHITE"; fi
      if [ "$THEME_COLOR_YUZUEA" = "BLACK" ]; then THEME_COLOR_YUZUEA="$BLACK"; fi
      # ---------------------------------------------------------------------------------- 
      if [ "$THEME_COLOR_RYUJINX" = "RED" ]; then THEME_COLOR_RYUJINX="$RED"; fi
      if [ "$THEME_COLOR_RYUJINX" = "BLUE" ]; then THEME_COLOR_RYUJINX="$BLUE"; fi
      if [ "$THEME_COLOR_RYUJINX" = "GREEN" ]; then THEME_COLOR_RYUJINX="$GREEN"; fi
      if [ "$THEME_COLOR_RYUJINX" = "YELLOW" ]; then THEME_COLOR_RYUJINX="$YELLOW"; fi
      if [ "$THEME_COLOR_RYUJINX" = "PURPLE" ]; then THEME_COLOR_RYUJINX="$PURPLE"; fi
      if [ "$THEME_COLOR_RYUJINX" = "CYAN" ]; then THEME_COLOR_RYUJINX="$CYAN"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKRED" ]; then THEME_COLOR_RYUJINX="$DARKRED"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKBLUE" ]; then THEME_COLOR_RYUJINX="$DARKBLUE"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKGREEN" ]; then THEME_COLOR_RYUJINX="$DARKGREEN"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKYELLOW" ]; then THEME_COLOR_RYUJINX="$DARKYELLOW"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKPURPLE" ]; then THEME_COLOR_RYUJINX="$DARKPURPLE"; fi
      if [ "$THEME_COLOR_RYUJINX" = "DARKCYAN" ]; then THEME_COLOR_RYUJINX="$DARKCYAN"; fi
      if [ "$THEME_COLOR_RYUJINX" = "WHITE" ]; then THEME_COLOR_RYUJINX="$WHITE"; fi
      if [ "$THEME_COLOR_RYUJINX" = "BLACK" ]; then THEME_COLOR_RYUJINX="$BLACK"; fi
      # ---------------------------------------------------------------------------------- 
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "RED" ]; then THEME_COLOR_RYUJINXAVALONIA="$RED"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "BLUE" ]; then THEME_COLOR_RYUJINXAVALONIA="$BLUE"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "GREEN" ]; then THEME_COLOR_RYUJINXAVALONIA="$GREEN"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "YELLOW" ]; then THEME_COLOR_RYUJINXAVALONIA="$YELLOW"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "PURPLE" ]; then THEME_COLOR_RYUJINXAVALONIA="$PURPLE"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "CYAN" ]; then THEME_COLOR_RYUJINXAVALONIA="$CYAN"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKRED" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKRED"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKBLUE" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKBLUE"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKGREEN" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKGREEN"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKYELLOW" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKYELLOW"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKPURPLE" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKPURPLE"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "DARKCYAN" ]; then THEME_COLOR_RYUJINXAVALONIA="$DARKCYAN"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "WHITE" ]; then THEME_COLOR_RYUJINXAVALONIA="$WHITE"; fi
      if [ "$THEME_COLOR_RYUJINXAVALONIA" = "BLACK" ]; then THEME_COLOR_RYUJINXAVALONIA="$BLACK"; fi
#
      if [[ -e "/tmp/updater-mode" ]]; then 
         MODE=$(cat /tmp/updater-mode | grep MODE | cut -d "=" -f2)
      fi
         if [[ "$MODE" = "CONSOLE" ]]; then 
            TEXT_COLOR=$X 
            THEME_COLOR=$X
            THEME_COLOR_OK=$X
            THEME_COLOR_YUZUEA=$X
            THEME_COLOR_RYUJINX=$X
            THEME_COLOR_RYUJINXAVALONIA=$X
         fi
# ------------------------------------------------------------------- 
# show info 
sleep 1
echo
echo -e "${WHITE} ${F}UPDATING ADDITIONAL FILES WAIT${T}...${T}"
# -------------------------------------------------------------------
# get additional files 
# ------------------------------------------------------------------- 
   extraurl="https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra"
# ------------------------------------------------------------------- 
# prepare xdg integration 
   if [[ ! -d /userdata/system/switch/extra/xdg ]] || [[ "$(du -Hs /userdata/system/switch/extra/xdg | awk '{print $1}')" < "50000" ]]; then 
      wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/xdg.tar.gz" "$extraurl/xdg.tar.gz"
      ###curl -sSf "$extraurl/xdg.tar.gz" -o "/userdata/system/switch/extra/xdg.tar.gz"
      cd /userdata/system/switch/extra/ 
      rm -rf /userdata/system/switch/extra/xdg 2>/dev/null
         tar -xf /userdata/system/switch/extra/xdg.tar.gz 2>/dev/null
   else 
      if [[ "$(md5sum /userdata/system/switch/extra/xdg.tar.gz | awk '{print $1}')" != "4ec8265c999a0c324f5938cb32824d34" ]]; then 
         rm /userdata/system/switch/extra/xdg.tar.gz 2>/dev/null 
         wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/xdg.tar.gz" "$extraurl/xdg.tar.gz"
         ###curl -sSf "$extraurl/xdg.tar.gz" -o "/userdata/system/switch/extra/xdg.tar.gz"
         cd /userdata/system/switch/extra/ 
         rm -rf /userdata/system/switch/extra/xdg 2>/dev/null
            tar -xf /userdata/system/switch/extra/xdg.tar.gz 2>/dev/null
      fi 
   fi
   #
      wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-xdg.sh" "$extraurl/batocera-switch-xdg.sh"
      ###curl -sSf "$extraurl/batocera-switch-xdg.sh" -o "/userdata/system/switch/extra/batocera-switch-xdg.sh"
      dos2unix /userdata/system/switch/extra/batocera-switch-xdg.sh 2>/dev/null 
      chmod a+x /userdata/system/switch/extra/batocera-switch-xdg.sh 2>/dev/null 
   cd /userdata/system/ 
# ------------------------------------------------------------------- 
# get mapping.csv file (obsolete)
#   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/configgen/mapping.csv" "https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/mapping.csv"
#   dos2unix /userdata/system/switch/configgen/mapping.csv 2>/dev/null 
   rm /userdata/system/switch/configgen/mapping.csv 2>/dev/null 
# ------------------------------------------------------------------- 
# get batocera-switch-mousemove.sh
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-mousemove.sh" "$extraurl/batocera-switch-mousemove.sh"
   ###curl -sSf "$extraurl/batocera-switch-mousemove.sh" -o "/userdata/system/switch/extra/batocera-switch-mousemove.sh"
   dos2unix /userdata/system/switch/extra/batocera-switch-mousemove.sh 2>/dev/null 
   chmod a+x /userdata/system/switch/extra/batocera-switch-mousemove.sh 2>/dev/null 
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-libxdo.so.3" "$extraurl/batocera-switch-libxdo.so.3"
   ###curl -sSf "$extraurl/batocera-switch-libxdo.so.3" -o "/userdata/system/switch/extra/batocera-switch-libxdo.so.3"
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-xdotool" "$extraurl/batocera-switch-xdotool"
   ###curl -sSf "$extraurl/batocera-switch-xdotool" -o "/userdata/system/switch/extra/batocera-switch-xdotool"
   chmod a+x /userdata/system/switch/extra/batocera-switch-lib* 2>/dev/null 
   chmod a+x /userdata/system/switch/extra/batocera-switch-xdo* 2>/dev/null 
# ------------------------------------------------------------------- 
# get batocera-switch-sync-firmware.sh
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-sync-firmware.sh" "$extraurl/batocera-switch-sync-firmware.sh"
   ###curl -sSf "$extraurl/batocera-switch-sync-firmware.sh" -o "/userdata/system/switch/extra/batocera-switch-sync-firmware.sh"
   dos2unix /userdata/system/switch/extra/batocera-switch-sync-firmware.sh 2>/dev/null 
   chmod a+x /userdata/system/switch/extra/batocera-switch-sync-firmware.sh 2>/dev/null 
# ------------------------------------------------------------------- 
# get batocera-switch-stat
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-stat" "$extraurl/batocera-switch-stat"
   ###curl -sSf "$extraurl/batocera-switch-stat" -o "/userdata/system/switch/extra/batocera-switch-stat"
   chmod a+x /userdata/system/switch/extra/batocera-switch-stat 2>/dev/null 
# ------------------------------------------------------------------- 
# prepare nsz converter 
   if [[ ! -f "/userdata/system/switch/extra/nsz.zip" ]] || [[ "$(wc -c "/userdata/system/switch/extra/nsz.zip" | awk '{print $1}')" < "1000000" ]]; then 
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/nsz.zip" "$extraurl/nsz.zip"
   ###curl -sSf "$extraurl/nsz.zip" -o "/userdata/system/switch/extra/nsz.zip"
fi 
      wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-rev" "$extraurl/batocera-switch-rev"
      ###curl -sSf "$extraurl/batocera-switch-rev" -o "/userdata/system/switch/extra/batocera-switch-rev"
      chmod a+x /userdata/system/switch/extra/batocera-switch-rev 2>/dev/null 
         wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-nsz-converter.sh" "$extraurl/batocera-switch-nsz-converter.sh"
         ###curl -sSf "$extraurl/batocera-switch-nsz-converter.sh" -o "/userdata/system/switch/extra/batocera-switch-nsz-converter.sh"
         dos2unix /userdata/system/switch/extra/batocera-switch-nsz-converter.sh 2>/dev/null 
         chmod a+x /userdata/system/switch/extra/batocera-switch-nsz-converter.sh 2>/dev/null 
   cd /userdata/system/switch/extra/ 
   rm -rf /userdata/system/switch/extra/nsz 2>/dev/null
   unzip -o -qq /userdata/system/switch/extra/nsz.zip 2>/dev/null
   cd /userdata/system/ 
# -------------------------------------------------------------------
# prepare gdk/svg libs for ryujinx / needed for gui controller config 
   if [[ ! -f "/userdata/system/switch/extra/lib.tar.gz" ]]; then 
      wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/lib.tar.gz" "$extraurl/lib.tar.gz"
      ###curl -sSf "$extraurl/lib.tar.gz" -o "/userdata/system/switch/extra/lib.tar.gz"
         cd /userdata/system/switch/extra/ 
         rm -rf /userdata/system/switch/extra/lib 2>/dev/null
         tar -xf /userdata/system/switch/extra/lib.tar.gz 
   else 
      if [[ "$(md5sum "/userdata/system/switch/extra/lib.tar.gz" | awk '{print $1}')" != "83952eb2897a61337ca10ff0e19c672f" ]]; then
      rm /userdata/system/switch/extra/lib.tar.gz 2>/dev/null
      wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/lib.tar.gz" "$extraurl/lib.tar.gz"
      ###curl -sSf "$extraurl/lib.tar.gz" -o "/userdata/system/switch/extra/lib.tar.gz"
         cd /userdata/system/switch/extra/ 
         rm -rf /userdata/system/switch/extra/lib 2>/dev/null
         tar -xf /userdata/system/switch/extra/lib.tar.gz 
      fi
   fi
#   cp -rL /userdata/system/switch/extra/lib/* /userdata/system/switch/extra/ryujinx/ 2>/dev/null
#   cp -rL /userdata/system/switch/extra/lib/* /userdata/system/switch/extra/ryujinxldn/ 2>/dev/null
#   cp -rL /userdata/system/switch/extra/lib/* /userdata/system/switch/extra/ryujinxavalonia/ 2>/dev/null
   cd /userdata/system/ 
# -------------------------------------------------------------------
# get ryujinx-controller-patcher.sh 
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/ryujinx-controller-patcher.sh" "$extraurl/ryujinx-controller-patcher.sh"
   ###curl -sSf "$extraurl/ryujinx-controller-patcher.sh" -o "/userdata/system/switch/extra/ryujinx-controller-patcher.sh"
   dos2unix /userdata/system/switch/extra/ryujinx-controller-patcher.sh 2>/dev/null 
   chmod a+x /userdata/system/switch/extra/ryujinx-controller-patcher.sh 2>/dev/null  
# -------------------------------------------------------------------
# get yuzu-controller-patcher.sh 
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/yuzu-controller-patcher.sh" "$extraurl/yuzu-controller-patcher.sh"
   ###curl -sSf "$extraurl/yuzu-controller-patcher.sh" -o "/userdata/system/switch/extra/yuzu-controller-patcher.sh"
   dos2unix /userdata/system/switch/extra/yuzu-controller-patcher.sh 2>/dev/null 
   chmod a+x /userdata/system/switch/extra/yuzu-controller-patcher.sh 2>/dev/null  
# -------------------------------------------------------------------
# prepare patcher 
url_patcher="https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-patcher.sh"
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-patcher.sh" "$url_patcher"
   ###curl -sSf "$url_patcher" -o "/userdata/system/switch/extra/batocera-switch-patcher.sh"
   dos2unix ~/switch/extra/batocera-switch-patcher.sh 2>/dev/null
   chmod a+x ~/switch/extra/batocera-switch-patcher.sh 2>/dev/null
#
# -------------------------------------------------------------------
# PREPARE BATOCERA-SWITCH-STARTUP FILE
# -------------------------------------------------------------------
#
f=/userdata/system/switch/extra/batocera-switch-startup
rm "$f" 2>/dev/null 
# 
echo '#!/bin/bash' >> "$f"
echo '#' >> "$f"
#\ check language
echo '#\ check language ' >> "$f"
echo '/userdata/system/switch/extra/batocera-switch-translator.sh 2>/dev/null &' >> "$f"
#\ prepare system 
echo '#\ prepare system ' >> "$f"
echo 'cp /userdata/system/switch/extra/batocera-switch-rev /usr/bin/rev 2>/dev/null ' >> "$f"
#echo 'rm /userdata/system/switch/logs/* 2>/dev/null ' >> "$f" 
echo 'mkdir -p /userdata/system/switch/logs 2>/dev/null ' >> "$f"
echo 'sysctl -w vm.max_map_count=2147483642 1>/dev/null' >> "$f"
echo 'extra=/userdata/system/switch/extra' >> "$f"
echo 'cp $extra/*.desktop /usr/share/applications/ 2>/dev/null' >> "$f"
echo '#' >> "$f"
#echo 'cp $extra/lib* /lib/ 2>/dev/null' >> "$f"
echo 'if [[ -e "/lib/libthai.so.0.3.1" ]] || [[ -e "/usr/lib/libthai.so.0.3.1" ]]; then echo 1>/dev/null; else cp /userdata/system/switch/extra/libthai.so.0.3.1 /usr/lib/libthai.so.0.3.1 2>/dev/null; fi' >> "$f"
echo 'if [[ -e "/lib/libthai.so.0.3" ]] || [[ -e "/usr/lib/libthai.so.0.3" ]]; then echo 1>/dev/null; else cp /userdata/system/switch/extra/batocera-switch-libthai.so.0.3 /usr/lib/libthai.so.0.3 2>/dev/null; fi' >> "$f"
echo 'if [[ -e "/lib/libselinux.so.1" ]] || [[ -e "/usr/lib/libselinux.so.1" ]]; then echo 1>/dev/null; else cp /userdata/system/switch/extra/batocera-switch-libselinux.so.1 /usr/lib/libselinux.so.1 2>/dev/null; fi' >> "$f"
echo 'if [[ -e "/lib/libtinfo.so.6" ]] || [[ -e "/usr/lib/libtinfo.so.6" ]]; then echo 1>/dev/null; else cp /userdata/system/switch/extra/batocera-switch-libtinfo.so.6 /usr/lib/libtinfo.so.6 2>/dev/null; fi' >> "$f"
echo '#' >> "$f"
#\ link ryujinx config folders 
echo '#\ link ryujinx config folders ' >> "$f"
echo 'mkdir /userdata/system/configs 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/Ryujinx 2>/dev/null' >> "$f"
echo 'mv /userdata/system/configs/Ryujinx /userdata/system/configs/Ryujinx_tmp 2>/dev/null' >> "$f"
echo 'cp -rL /userdata/system/.config/Ryujinx/* /userdata/configs/Ryujinx_tmp 2>/dev/null' >> "$f"
echo 'rm -rf /userdata/system/.config/Ryujinx' >> "$f"
echo 'mv /userdata/system/configs/Ryujinx_tmp /userdata/system/configs/Ryujinx 2>/dev/null' >> "$f"
echo 'ln -s /userdata/system/configs/Ryujinx /userdata/system/.config/Ryujinx 2>/dev/null' >> "$f"
echo 'rm /userdata/system/configs/Ryujinx/Ryujinx 2>/dev/null' >> "$f"
echo '#' >> "$f"
#
#\ link ryujinx saves folders 
echo '#\ link ryujinx saves folders ' >> "$f"
echo 'mkdir /userdata/saves 2>/dev/null' >> "$f"
echo 'mkdir /userdata/saves/Ryujinx 2>/dev/null' >> "$f"
echo 'mv /userdata/saves/Ryujinx /userdata/saves/Ryujinx_tmp 2>/dev/null' >> "$f"
echo 'cp -rL /userdata/system/configs/Ryujinx/bis/user/save/* /userdata/saves/Ryujinx_tmp/ 2>/dev/null' >> "$f"
echo 'rm -rf /userdata/system/configs/Ryujinx/bis/user/save 2>/dev/null' >> "$f"
echo 'mv /userdata/saves/Ryujinx_tmp /userdata/saves/Ryujinx 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/Ryujinx 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/Ryujinx/bis 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/Ryujinx/bis/user 2>/dev/null' >> "$f"
echo 'ln -s /userdata/saves/Ryujinx /userdata/system/configs/Ryujinx/bis/user/save 2>/dev/null' >> "$f"
echo 'rm /userdata/saves/Ryujinx/Ryujinx 2>/dev/null' >> "$f"
echo 'if [ ! -L /userdata/system/configs/Ryujinx/bis/user/save ]; then mkdir /userdata/system/configs/Ryujinx/bis/user/save 2>/dev/null; rsync -au /userdata/saves/Ryujinx/ /userdata/system/configs/Ryujinx/bis/user/save/ 2>/dev/null; fi' >> "$f"
echo '#' >> "$f"
#
#\ link yuzu config folders 
echo '#\ link yuzu config folders ' >> "$f"
echo 'mkdir /userdata/system/configs 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/yuzu 2>/dev/null' >> "$f"
echo 'mv /userdata/system/configs/yuzu /userdata/system/configs/yuzu_tmp 2>/dev/null' >> "$f"
echo 'cp -rL /userdata/system/.config/yuzu/* /userdata/configs/yuzu_tmp 2>/dev/null' >> "$f"
echo 'cp -rL /userdata/system/.local/share/yuzu/* /userdata/configs/yuzu_tmp 2>/dev/null' >> "$f"
echo 'rm -rf /userdata/system/.config/yuzu' >> "$f"
echo 'rm -rf /userdata/system/.local/share/yuzu' >> "$f"
echo 'mv /userdata/system/configs/yuzu_tmp /userdata/system/configs/yuzu 2>/dev/null' >> "$f"
echo 'ln -s /userdata/system/configs/yuzu /userdata/system/.config/yuzu 2>/dev/null' >> "$f"
echo 'ln -s /userdata/system/configs/yuzu /userdata/system/.local/share/yuzu 2>/dev/null' >> "$f"
echo 'rm /userdata/system/configs/yuzu/yuzu 2>/dev/null' >> "$f"
echo '#' >> "$f"
#
#\ link yuzu saves folders
echo '#\ link yuzu saves folders' >> "$f"
echo 'mkdir /userdata/saves 2>/dev/null' >> "$f"
echo 'mkdir /userdata/saves/yuzu 2>/dev/null' >> "$f"
echo 'mv /userdata/saves/yuzu /userdata/saves/yuzu_tmp 2>/dev/null' >> "$f"
echo 'cp -rL /userdata/system/configs/yuzu/nand/user/save/* /userdata/saves/yuzu_tmp/ 2>/dev/null' >> "$f"
echo 'rm -rf /userdata/system/configs/yuzu/nand/user/save 2>/dev/null' >> "$f"
echo 'mv /userdata/saves/yuzu_tmp /userdata/saves/yuzu 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/yuzu 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/yuzu/nand 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/yuzu/nand/user 2>/dev/null' >> "$f"
echo 'ln -s /userdata/saves/yuzu /userdata/system/configs/yuzu/nand/user/save 2>/dev/null' >> "$f"
echo 'rm /userdata/saves/yuzu/yuzu 2>/dev/null' >> "$f"
echo 'if [ ! -L /userdata/system/configs/yuzu/nand/user/save ]; then mkdir /userdata/system/configs/yuzu/nand/user/save 2>/dev/null; rsync -au /userdata/saves/yuzu/ /userdata/system/configs/yuzu/nand/user/save/ 2>/dev/null; fi' >> "$f"
echo '#' >> "$f"
#
#\ link yuzu and ryujinx keys folders to bios/switch 
echo '#\ link yuzu and ryujinx keys folders to bios/switch ' >> "$f"
echo 'cp -rL /userdata/system/configs/yuzu/keys/* /userdata/bios/switch/ 2>/dev/null' >> "$f"
echo 'cp -rL /userdata/system/configs/Ryujinx/system/* /userdata/bios/switch/ 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/yuzu 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/Ryujinx 2>/dev/null' >> "$f"
echo 'mv /userdata/bios/switch /userdata/bios/switch_tmp 2>/dev/null' >> "$f"
echo 'rm -rf /userdata/system/configs/yuzu/keys 2>/dev/null' >> "$f"
echo 'rm -rf /userdata/system/configs/Ryujinx/system 2>/dev/null' >> "$f"
echo 'mv /userdata/bios/switch_tmp /userdata/bios/switch 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/yuzu 2>/dev/null' >> "$f"
echo 'mkdir /userdata/system/configs/Ryujinx 2>/dev/null' >> "$f"
echo 'ln -s /userdata/bios/switch /userdata/system/configs/yuzu/keys 2>/dev/null' >> "$f"
echo 'ln -s /userdata/bios/switch /userdata/system/configs/Ryujinx/system 2>/dev/null' >> "$f"
echo 'if [ ! -L /userdata/system/configs/yuzu/keys ]; then mkdir /userdata/system/configs/yuzu/keys 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/configs/yuzu/keys/ 2>/dev/null; fi' >> "$f"
echo 'if [ ! -L /userdata/system/configs/Ryujinx/system ]; then mkdir /userdata/system/configs/Ryujinx/system 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/configs/Ryujinx/system/ 2>/dev/null; fi' >> "$f"
echo 'mkdir -p /userdata/system/configs/yuzu/keys 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/configs/yuzu/keys/ 2>/dev/null ' >> "$f"
echo 'mkdir -p /userdata/system/.local/share/yuzu/keys 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/.local/share/yuzu/keys/ 2>/dev/null ' >> "$f"
echo 'mkdir -p /userdata/system/configs/Ryujinx/system 2>/dev/null; cp -rL /userdata/bios/switch/*.keys /userdata/system/configs/Ryujinx/system/ 2>/dev/null ' >> "$f"
echo '#' >> "$f"
#
#\ fix batocera.linux folder issue for f1/apps menu tx to drizzt
echo "sed -i 's/inline_limit=\"20\"/inline_limit=\"256\"/' /etc/xdg/menus/batocera-applications.menu 2>/dev/null" >> "$f"
echo "sed -i 's/inline_limit=\"60\"/inline_limit=\"256\"/' /etc/xdg/menus/batocera-applications.menu 2>/dev/null" >> "$f"
echo '#' >> "$f"
#
#\ add xdg integration with pcmanfm for f1 emu configs
echo '  fs=$(blkid | grep "$(df -h /userdata | awk '\''END {print $1}'\'')" | sed '\''s,^.*TYPE=,,g'\'' | sed '\''s,",,g'\'' | tr '\''a-z'\'' '\''A-Z'\'') ' >> "$f"
echo '    if [[ "$fs" == *"EXT"* ]] || [[ "$fs" == *"BTR"* ]]; then ' >> "$f"
echo '      /userdata/system/switch/extra/batocera-switch-xdg.sh ' >> "$f"
echo '    fi' >> "$f"
echo '#' >> "$f" 
#
dos2unix "$f" 2>/dev/null
chmod a+x "$f" 2>/dev/null
# -------------------------------------------------------------------
# & run now: 
      /userdata/system/switch/extra/batocera-switch-startup 2>/dev/null & 
      echo 1>/dev/null 2>/dev/null 
# -------------------------------------------------------------------
# ADD TO BATOCERA AUTOSTART > /USERDATA/SYSTEM/CUSTOM.SH 
# -------------------------------------------------------------------
csh=/userdata/system/custom.sh; dos2unix $csh 2>/dev/null
startup="/userdata/system/switch/extra/batocera-switch-startup"
if [[ -f $csh ]];
   then
      tmp1=/tmp/tcsh1
      tmp2=/tmp/tcsh2
      remove="$startup"
      rm $tmp1 2>/dev/null; rm $tmp2 2>/dev/null
      nl=$(cat "$csh" | wc -l); nl1=$(($nl + 1))
         l=1; 
         for l in $(seq 1 $nl1); do
            ln=$(cat "$csh" | sed ""$l"q;d" );
               if [[ "$(echo "$ln" | grep "$remove")" != "" ]]; then :; 
                else 
                  if [[ "$l" = "1" ]]; then
                        if [[ "$(echo "$ln" | grep "#" | grep "/bin/" | grep "bash" )" != "" ]]; then :; else echo "$ln" >> "$tmp1"; fi
                     else 
                        echo "$ln" >> $tmp1;
                  fi
               fi            
            ((l++))
         done
          # 
          echo -e '#!/bin/bash' >> $tmp2
          echo -e "\n$startup \n" >> $tmp2          
          cat "$tmp1" | sed -e '/./b' -e :n -e 'N;s/\n$//;tn' >> "$tmp2"
          cp $tmp2 $csh 2>/dev/null; dos2unix $csh 2>/dev/null; chmod a+x $csh 2>/dev/null  
   else  #(!f csh)   
       echo -e '#!/bin/bash' >> $csh
       echo -e "\n$startup\n" >> $csh  
       dos2unix $csh 2>/dev/null; chmod a+x $csh 2>/dev/null  
fi 
dos2unix ~/custom.sh 2>/dev/null
chmod a+x ~/custom.sh 2>/dev/null
# --------------------------------------------------------------------
# CLEAR THE OLD V34- CUSTOM.SH LINE IF FOUND AND THE SYSTEM IS NOW VERSION V35+:
# THIS SHOULD HELP WITH UPGRADED VERSIONS AND 'OTHER INSTALLS' 
   if [[ "$(uname -a | grep "x86_64")" != "" ]] && [[ "$(uname -a | awk '{print $3}')" > "5.18.00" ]]; then
      remove="cat /userdata/system/configs/emulationstation/add_feat_os.cfg /userdata/system/configs/emulationstation/add_feat_switch.cfg"
      csh=/userdata/system/custom.sh
        if [[ -e "$csh" ]]; then
         tmp=/userdata/system/customsh.tmp
         rm $tmp 2>/dev/null
         nl=$(cat "$csh" | wc -l)
         l=1; while [[ "$l" -le "$nl" ]]; 
         do
            ln=$(cat "$csh" | sed ""$l"q;d")
               if [[ "$(echo "$ln" | grep "$remove")" != "" ]]; then :; else echo "$ln" >> "$tmp"; fi
            ((l++))
         done
         cp "$tmp" "$csh" 2>/dev/null
         rm "$tmp" 2>/dev/null
        fi
      es=/userdata/system/configs/emulationstation
      backup=/userdata/system/switch/extra/backup
      mkdir /userdata/system/switch 2>/dev/null
      mkdir /userdata/system/switch/extra 2>/dev/null
      mkdir /userdata/system/switch/extra/backup 2>/dev/null
      # REMOVE OLD ~/CONFIGS/EMULATIONSTATION/files if found & system is now upgraded: 
      rm "$es/add_feat_switch.cfg" 2>/dev/null
   fi
# -------------------------------------------------------------------- 
# REMOVE OLD UPDATERS 
rm /userdata/roms/ports/updateyuzu.sh 2>/dev/null 
rm /userdata/roms/ports/updateyuzuea.sh 2>/dev/null
rm /userdata/roms/ports/updateyuzuEA.sh 2>/dev/null 
rm /userdata/roms/ports/updateryujinx.sh 2>/dev/null
rm /userdata/roms/ports/updateryujinxavalonia.sh 2>/dev/null
# --------------------------------------------------------------------
# AUTOMATICALLY PULL THE LATEST EMULATORS FEATURES UPDATES / ALSO UPDATE THESE FILES: 
mkdir -p /userdata/system/switch/extra 2>/dev/null
# mkdir -p /userdata/system/switch/configgen/generators/yuzu 2>/dev/null
mkdir -p /userdata/system/switch/configgen/generators/ryujinx 2>/dev/null
mkdir -p /userdata/system/configs/emulationstation 2>/dev/null
mkdir -p /userdata/system/configs/evmapy 2>/dev/null
url_switchkeys=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/configs/evmapy/switch.keys
url_es_features_switch=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/configs/emulationstation/es_features_switch.cfg
url_es_systems_switch=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/configs/emulationstation/es_systems_switch.cfg
url_switchlauncher=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/switchlauncher.py
url_GeneratorImporter=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/GeneratorImporter.py
url_unixSettings=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/unixSettings.py
url_ryujinxMainlineGenerator=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/generators/ryujinx/ryujinxMainlineGenerator.py
# url_yuzuMainlineGenerator=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/generators/yuzu/yuzuMainlineGenerator.py
url_sshupdater=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-sshupdater.sh
url_updater=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-updater.sh
url_portsupdater=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/roms/ports/Switch%20Updater.sh
url_portsupdaterkeys=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/roms/ports/Switch%20Updater.sh.keys   
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/configs/evmapy/switch.keys" "$url_switchkeys"
   ###curl -sSf "$url_switchkeys" -o "/userdata/system/configs/evmapy/switch.keys"
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/configs/emulationstation/es_features_switch.cfg" "$url_es_features_switch"
   ###curl -sSf "$url_es_features_switch" -o "/userdata/system/configs/emulationstation/es_features_switch.cfg"
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/configs/emulationstation/es_systems_switch.cfg" "$url_es_systems_switch"
   ###curl -sSf "$url_es_systems_switch" -o "/userdata/system/configs/emulationstation/es_systems_switch.cfg"
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/configgen/switchlauncher.py" "$url_switchlauncher"
   ###curl -sSf "$url_switchlauncher" -o "/userdata/system/switch/configgen/switchlauncher.py"
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/configgen/GeneratorImporter.py" "$url_GeneratorImporter"
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/configgen/unixSettings.py" "$url_unixSettings"
   ###curl -sSf "$url_GeneratorImporter" -o "/userdata/system/switch/configgen/GeneratorImporter.py"
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/configgen/generators/ryujinx/ryujinxMainlineGenerator.py" "$url_ryujinxMainlineGenerator"
   ###curl -sSf "$url_ryujinxMainlineGenerator" -o "/userdata/system/switch/configgen/generators/ryujinx/ryujinxMainlineGenerator.py"
   # wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/configgen/generators/yuzu/yuzuMainlineGenerator.py" "$url_yuzuMainlineGenerator"
   ###curl -sSf "$url_yuzuMainlineGenerator" -o "/userdata/system/switch/configgen/generators/yuzu/yuzuMainlineGenerator.py"
      dos2unix "/userdata/system/configs/evmapy/switch.keys" 2>/dev/null
      dos2unix "/userdata/system/configs/emulationstation/es_features_switch.cfg" 2>/dev/null 
      dos2unix "/userdata/system/configs/emulationstation/es_systems_switch.cfg" 2>/dev/null
      # dos2unix "/userdata/system/switch/configgen/switchlauncher.py" 2>/dev/null
      # dos2unix "/userdata/system/switch/configgen/GeneratorImporter.py" 2>/dev/null
      # dos2unix "/userdata/system/switch/configgen/generators/ryujinx/ryujinxMainlineGenerator.py" 2>/dev/null 
      # dos2unix "/userdata/system/switch/configgen/generators/yuzu/yuzuMainlineGenerator.py" 2>/dev/null
      # dos2unix "/userdata/system/switch/configgen/generators/yuzu/yuzuMainlineGenerator.py" 2>/dev/null
   # update batocera-switch-sshupdater.sh
   # wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-sshupdater.sh" "$url_sshupdater"
   # # curl -sSf "$url_sshupdater" -o "/userdata/system/switch/extra/batocera-switch-sshupdater.sh"
   # # dos2unix "/userdata/system/switch/extra/batocera-switch-sshupdater.sh" 2>/dev/null
   # # chmod a+x "/userdata/system/switch/extra/batocera-switch-sshupdater.sh" 2>/dev/null
   # # update batocera-switch-updater.sh
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-updater.sh" "$url_updater"
   ###curl -sSf "$url_updater" -o "/userdata/system/switch/extra/batocera-switch-updater.sh"
   dos2unix "/userdata/system/switch/extra/batocera-switch-updater.sh" 2>/dev/null
   chmod a+x "/userdata/system/switch/extra/batocera-switch-updater.sh" 2>/dev/null
   # update ports Switch Updater.sh
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/roms/ports/Switch Updater.sh" "$url_portsupdater"
   ###curl -sSf "$url_portsupdater" -o "/userdata/roms/ports/Switch Updater.sh"
   dos2unix "/userdata/system/roms/ports/Switch Updater.sh" 2>/dev/null
   chmod a+x "/userdata/system/roms/ports/Switch Updater.sh" 2>/dev/null
   # update ports Switch Updater.sh.keys
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/roms/ports/Switch Updater.sh.keys" "$url_portsupdaterkeys"
   ###curl -sSf "$url_portsupdaterkeys" -o "/userdata/roms/ports/Switch Updater.sh.keys"
   dos2unix "/userdata/system/roms/ports/Switch Updater.sh.keys" 2>/dev/null
   # get batocera-switch-patcher.sh 
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/extra/batocera-switch-patcher.sh" "$url_patcher"
   ###curl -sSf "$url_patcher" -o "/userdata/system/switch/extra/batocera-switch-patcher.sh"
   dos2unix "/userdata/system/switch/extra/batocera-switch-patcher.sh" 2>/dev/null
   chmod a+x "/userdata/system/switch/extra/batocera-switch-patcher.sh" 2>/dev/null
# --------------------------------------------------------------------
# -------------------------------------------------------------------- 
# FILL /USERDATA/SYSTEM/SWITCH/CONFIGGEN/SDL2
path=/userdata/system/switch/configgen/sdl2
mkdir -p $path 2>/dev/null
cd $path
if [[ ! -f "/userdata/system/switch/configgen/sdl2/sdl2.zip" ]]; then 
rm -rf /userdata/system/switch/configgen/sdl2/sdl2.zip 2>/dev/null
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/configgen/sdl2/sdl2.zip" "$extraurl/sdl2.zip"
##curl -sSf "$extraurl/sdl2.zip" -o "/userdata/system/switch/configgen/sdl2/sdl2.zip"
unzip -oq /userdata/system/switch/configgen/sdl2/sdl2.zip
else 
   if [[ "$(wc -c "/userdata/system/switch/configgen/sdl2/sdl2.zip" | awk '{print $1}')" < "100000" ]]; then 
   rm -rf /userdata/system/switch/configgen/sdl2/sdl2.zip 2>/dev/null
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "/userdata/system/switch/configgen/sdl2/sdl2.zip" "$extraurl/sdl2.zip"
   ##curl -sSf "$extraurl/sdl2.zip" -o "/userdata/system/switch/configgen/sdl2/sdl2.zip"
   unzip -oq /userdata/system/switch/configgen/sdl2/sdl2.zip
   fi
fi 
# additional pass for folks who have issues connecting to github
   function get() {
      file="$1"
      path=/userdata/system/switch/configgen/sdl2
      url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/configgen/sdl2
         mkdir -p $path 2>/dev/null
            if [[ ! -e "$path/$file" ]]; then
               cd $path
               wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/$file" "$url/$file"
               ###curl -sSf "$url/$file" -o "$path/$file"
            else 
               if [[ "$(wc -c "$path/$file" | awk '{print $1}')" < "5" ]]; then 
               cd $path
               wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/$file" "$url/$file"
               fi
            fi
   }
      get __init__.py
      get _internal.py
      get _sdl_init.py
      get audio.py
      get blendmode.py
      get clipboard.py
      get cpuinfo.py
      get dll.py
      get endian.py
      get error.py
      get events.py
      get filesystem.py
      get gamecontroller.py
      get gesture.py
      get guid.py
      get haptic.py
      get hidapi.py
      get hints.py
      get joystick.py
      get keyboard.py
      get keycode.py
      get loadso.py
      get locale.py
      get log.py
      get messagebox.py
      get metal.py
      get misc.py
      get mouse.py
      get pixels.py
      get platform.py
      get power.py
      get rect.py
      get render.py
      get rwops.py
      get scancode.py
      get sdlgfx.py
      get sdlimage.py
      get sdlmixer.py
      get sdlttf.py
      get sensor.py
      get shape.py
      get stdinc.py
      get surface.py
      get syswm.py
      get timer.py
      get touch.py
      get version.py
      get video.py
      get vulkan.py
   chmod 777 $path/* 2>/dev/null
cd ~/
# -------------------------------------------------------------------- 
# GET RYUJINX 942 libSDL2.so for updated controllers processing 
rm /userdata/system/switch/extra/batocera-switch-libSDL2.so 2>/dev/null
mkdir -p /userdata/system/switch/extra/sdl 2>/dev/null
sdl=/userdata/system/switch/extra/sdl/libSDL2.so
sdlurl=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-libSDL2.so
   if [[ ! -e "$sdl" ]]; then 
      wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$sdl" "$sdlurl"
      ###curl -sSf "$sdlurl" -o "$sdl"
   else 
      if [[ "$(md5sum $sdl | awk '{print $1}')" != "dc4a162f60622b04813fbf1756419c89" ]] || [[ "$(wc -c $sdl | awk '{print $1}')" != "2493584" ]]; then 
         wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$sdl" "$sdlurl"
         ###curl -sSf "$sdlurl" -o "$sdl"
      fi 
   fi 
      chmod a+x "$sdl" 2>/dev/null 
# --------------------------------------------------------------------
# REMOVE NEW VER YUZU QUIT PROMPT
if [[ -e /userdata/system/configs/yuzu/qt-config.ini ]]; then 
   sed -i 's,confirmStop=0,confirmStop=2,g' /userdata/system/configs/yuzu/qt-config.ini 2>/dev/null
   sed -i 's,confirmStop\\default=true,confirmStop\\default=false,g' /userdata/system/configs/yuzu/qt-config.ini 2>/dev/null
fi
# -------------------------------------------------------------------- 
# GET TRANSLATIONS
path=/userdata/system/switch/extra/translations
url=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/translations
mkdir -p $path 2>/dev/null
mkdir -p $path/en_US 2>/dev/null
mkdir -p $path/fr_FR 2>/dev/null
   english=en_US/es_features_switch.cfg
   french=fr_FR/es_features_switch.cfg
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/$english" "$url/$english"
   wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path/$french" "$url/$french"
   dos2unix "$path/$english" 2>/dev/null
   dos2unix "$path/$french" 2>/dev/null
# GET TRANSLATOR
translator=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-translator.sh
path=/userdata/system/switch/extra/batocera-switch-translator.sh
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path" "$translator"
   dos2unix "$path" 2>/dev/null
   chmod 777 "$path" 2>/dev/null
# GET RYUJINX-FIXES.SH
file=https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-ryujinx-fixes.sh
path=/userdata/system/switch/extra/batocera-switch-ryujinx-fixes.sh
wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O "$path" "$file"
   dos2unix "$path" 2>/dev/null
   chmod 777 "$path" 2>/dev/null
# --------------------------------------------------------------------
chmod 777 /userdata/system/switch/extra/*.sh 2>/dev/null
# --------------------------------------------------------------------
# CLEAR TEMP & COOKIE:
rm -rf /userdata/system/switch/extra/downloads 2>/dev/null
rm /userdata/system/switch/extra/display.settings 2>/dev/null
rm /userdata/system/switch/extra/updater.settings 2>/dev/null
rm /usr/share/applications/yuzu.desktop 2>/dev/null
rm /usr/share/applications/Ryujinx-LDN.desktop 2>/dev/null
rm /usr/share/applications/yuzuEA.desktop 2>/dev/null
rm /usr/share/applications/Ryujinx-Avalonia.desktop 2>/dev/null
rm -rf /userdata/system/switch/extra/yuzu 2>/dev/null
rm -rf /userdata/system/switch/configgen/generators/yuzu 2>/dev/null
rm -rf /userdata/system/switch/extra/ryujinxldn 2>/dev/null
rm /userdata/system/switch/appimages/ryujinxldn313.tar.gz 2>/dev/null
rm /userdata/system/switch/appimages/yuzu1734.AppImage 2>/dev/null
rm /userdata/system/switch/yuzu.AppImage 2>/dev/null
rm /userdata/system/switch/Ryujinx-LDN.AppImage 2>/dev/null
rm /userdata/system/switch/extra/yuzu.desktop 2>/dev/null
rm /userdata/system/switch/extra/Ryujinx-LDN.desktop 2>/dev/null

echo -e "${GREEN}❯❯❯ ${F}DONE ${T}"
sleep 2

}
export -f post-install
#
######################################################################
#\
if [[ "$MODE" != "CONSOLE" ]]; then 
# include display output: 
   tput=/userdata/system/switch/extra/batocera-switch-tput
   libtinfo=/userdata/system/switch/extra/batocera-switch-libtinfo.so.6
   mkdir /userdata/system/switch 2>/dev/null; mkdir /userdata/system/switch/extra 2>/dev/null
      if [[ ( -e "$tput" && "$(wc -c "$tput" | awk '{print $1}')" < "444" ) || ( ! -e "$tput" ) ]]; then
         rm "$tput" 2>/dev/null
         wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O /userdata/system/switch/extra/batocera-switch-tput https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/batocera-switch-tput
         ##curl -sSf "https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-tput" -o "/userdata/system/switch/extra/batocera-switch-tput"
      fi
      if [[ ( -e "$libtinfo" && "$(wc -c "$libtinfo" | awk '{print $1}')" < "444" ) || ( ! -e "$libtinfo" ) ]]; then
         rm "$libtinfo" 2>/dev/null
         wget -q --tries=10 --no-check-certificate --no-cache --no-cookies -O /userdata/system/switch/extra/batocera-switch-libtinfo.so.6 https://github.com/foclabroc/batocera-switch/raw/refs/heads/42/system/switch/extra/batocera-switch-libtinfo.so.6
         ##curl -sSf "https://raw.githubusercontent.com/foclabroc/batocera-switch/refs/heads/42/system/switch/extra/batocera-switch-libtinfo.so.6" -o "/userdata/system/switch/extra/batocera-switch-libtinfo.so.6"
      fi
   chmod a+x "$tput" 2>/dev/null
   if [[ -e "/lib/libtinfo.so.6" ]] || [[ -e "/usr/lib/libtinfo.so.6" ]]; then 
   :
   else
   cp "$libtinfo" "/usr/lib/libtinfo.so.6" 2>/dev/null
   fi
# 
      function get-fontsize {
         cfg=/userdata/system/switch/extra/display.cfg
            rm /tmp/cols 2>/dev/null
            killall -9 /tmp/batocera-switch-updater 2>/dev/null
            DISPLAY=:0.0 /tmp/batocera-switch-updater -maximized -fg black -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c "unset COLUMNS & /userdata/system/switch/extra/batocera-switch-tput cols >> /tmp/cols 2>/dev/null" 2>/dev/null
            killall -9 /tmp/batocera-switch-updater 2>/dev/null
         res=$(xrandr | grep " connected " | awk '{print $3}' | cut -d x -f1)
         columns=$(cat /tmp/cols); echo "$res=$columns" >> "$cfg"
         cols=$(cat "$cfg" | tail -n 1 | cut -d "=" -f2 2>/dev/null) 2>/dev/null
         TEXT_SIZE=$(bc <<<"scale=0;$cols/11" 2>/dev/null) 2>/dev/null
      }
      export -f get-fontsize
##################################
get-fontsize 2>/dev/null
#
# ensure fontsize: 
cfg=/userdata/system/switch/extra/display.cfg
cols=$(cat "$cfg" | tail -n 1 | cut -d "=" -f2 2>/dev/null) 2>/dev/null
colres=$(cat "$cfg" | tail -n 1 | cut -d "=" -f1 2>/dev/null) 2>/dev/null
res=$(xrandr | grep " connected " | awk '{print $3}' | cut -d x -f1)
fallback=9 
#
#####
   if [[ -e "$cfg" ]] && [[ "$cols" != "80" ]]; then 
      if [[ "$colres" = "$res" ]]; then
         TEXT_SIZE=$(bc <<<"scale=0;$cols/11" 2>/dev/null) 2>/dev/null
      fi
      #|
      if [[ "$colres" != "$res" ]]; then
         rm "$cfg" 2>/dev/null
            try=1
            until [[ "$cols" != "80" ]] 
            do
            get-fontsize 2>/dev/null
            cols=$(cat "$cfg" | tail -n 1 | cut -d "=" -f2 2>/dev/null) 2>/dev/null
            try=$(($try+1)); if [[ "$try" -ge "10" ]]; then TEXT_SIZE=$fallback; cols=1; fi
            done 
            if [[ "$cols" != "1" ]]; then TEXT_SIZE=$(bc <<<"scale=0;$cols/11" 2>/dev/null) 2>/dev/null; fi
      fi
   # 
   else
   # 
      get-fontsize 2>/dev/null
      cols=$(cat "$cfg" | tail -n 1 | cut -d "=" -f2 2>/dev/null) 2>/dev/null
         try=1
         until [[ "$cols" != "80" ]] 
         do
            get-fontsize 2>/dev/null
            cols=$(cat "$cfg" | tail -n 1 | cut -d "=" -f2 2>/dev/null) 2>/dev/null
            try=$(($try+1)); if [[ "$try" -ge "10" ]]; then TEXT_SIZE=$fallback; cols=1; fi
         done 
         if [[ "$cols" != "1" ]]; then TEXT_SIZE=$(bc <<<"scale=0;$cols/11" 2>/dev/null) 2>/dev/null; fi
         if [ "$TEXT_SIZE" = "" ]; then TEXT_SIZE=$fallback; fi
   fi    #
   ##### #
         if [[ ( -e "/tmp/updater-textsize" && "$(cat "/tmp/updater-textsize" | grep "AUTO")" != "") || ( -e "/tmp/updater-textsize" && "$(cat "/tmp/updater-textsize" | grep "auto")" != "" ) ]]; then 
            TEXT_SIZE=$TEXT_SIZE
         else 
            TEXT_SIZE=$(cat "/tmp/updater-textsize")
         fi
         TEXT_SIZE=$(bc <<< "$TEXT_SIZE/1")
         # ###################################################################
         # 
         ## RUN THE UPDATER: ------------------------------------------------- 
            if [[ "$MODE" = "DISPLAY" ]]; then 
               if [[ "$ANIMATION" = "YES" ]]; then 
                  DISPLAY=:0.0 unclutter-remote -h && DISPLAY=:0.0 /tmp/batocera-switch-updater -maximized -fs "$TEXT_SIZE" -fg black -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c "DISPLAY=:0.0 cvlc -f --no-audio --no-video-title-show --no-mouse-events --no-keyboard-events --no-repeat /userdata/system/switch/extra/loader.mp4 2>/dev/null & sleep 3.69 && killall -9 vlc && DISPLAY=:0.0 batocera_update_switch && DISPLAY=:0.0 post-install"
               else 
                  DISPLAY=:0.0 unclutter-remote -h && DISPLAY=:0.0 /tmp/batocera-switch-updater -maximized -fs "$TEXT_SIZE" -fg black -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c "DISPLAY=:0.0 batocera_update_switch && post-install"
               fi 
            fi 
fi 
#/ 
#################################################################################################################################
            if [[ "$MODE" = "CONSOLE" ]]; then 
                  DISPLAY=:0.0 batocera_update_switch console && DISPLAY=:0.0 post-install
            fi 
#################################################################################################################################
rm /userdata/system/switch/extra/ryujinx/libSDL2.so 2>/dev/null
rm /userdata/system/switch/extra/ryujinxavalonia/libSDL2.so 2>/dev/null
rm "/userdata/roms/ports/Switch Updater40.sh.keys" 2>/dev/null
rm "/userdata/roms/ports/Switch Updater40.sh" 2>/dev/null
cp /userdata/system/switch/extra/sdl/libSDL2.so /userdata/system/switch/extra/ryujinxavalonia/libSDL2.so 2>/dev/null
wait
   # --- \ restore user config file for the updater if running clean install/update from the switch installer 
   if [[ -e /tmp/.userconfigfile ]]; then 
      cp /tmp/.userconfigfile /userdata/system/switch/CONFIG.txt 2>/dev/null
      rm /tmp/.userconfigfile 2>/dev/null
   fi 
   # --- / 
sysctl -w net.ipv6.conf.default.disable_ipv6=0 1>/dev/null 2>/dev/null
sysctl -w net.ipv6.conf.all.disable_ipv6=0 1>/dev/null 2>/dev/null
sleep 2 && killall -9 batocera-switch-updater 2>/dev/null && curl http://127.0.0.1:1234/reloadgames && exit 0; exit 1
#################################################################################################################################
