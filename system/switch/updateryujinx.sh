wget -q --show-progress -O Ryujinx.AppImage $(curl -s https://api.github.com/repos/qurious-pixel/Ryujinx/releases/latest | grep "browser_download_url.*AppImage" | cut -d : -f 2,3 | tr -d \")