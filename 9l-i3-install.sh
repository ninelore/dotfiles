echo "ninelore's dotfiles installation script 0v1"
echo
echo "Installing Dependencies"
yay -S --needed arc-gtk-theme arc-kde calc compton dmenu2 feh firefox firefox-tridactyl htop i3-gaps i3blocks i3lock i3status lxappearance network-manager-applet networkmanager neofetch nitrogen noto-fonts noto-fonts-emoji numlockx qt5ct ranger rxvt-unicode tamzen-font ttf-font-awesome ttf-font-icons vim volumeicon xautolock xcursor-breeze xfce4-power-manager xorg-xinit zsh zsh-lovers 
echo
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "FATAL ERROR: SCRIPT IS WIP AND NOT COMPLETE"
echo
echo "You still need to manually copy the dotfiles and -folder in their right places!"
