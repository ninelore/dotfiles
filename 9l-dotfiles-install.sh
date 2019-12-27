echo "ninelore's dotfiles installation script 0v1"
echo
echo "Installing Dependencies"
yay -S --needed picom dmenu2 feh firefox firefox-tridactyl htop gnome-screenshot i3-gaps i3blocks i3lock i3status lxappearance networkmanager networkmanager-dmenu-git neofetch nitrogen noto-fonts noto-fonts-emoji numlockx qt5ct ranger rxvt-unicode ttf-font-awesome ttf-font-icons vim xautolock xcursor-breeze xfce4-power-manager xorg-xinit zsh zsh-lovers polkit-gnome unachiever jack qjackctl ttf-oswald ttf-ms-fonts w3m 
echo
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp agnoster-short.zsh-theme ~/.oh-my-ssh/themes/agnoster-short.zsh.theme
echo
echo "Installing dotfiles..."
echo "Warning: this will overwrite existing Dotfiles!! Do you want to continue? (y/n)"
read dotask
if [[dotask == "y"]]; then
	echo "Replacing dotfiles..."
	rm -r ~/.i3
	rm -r ~/.config/i3
	rm -r ~/.config/dunst
	rm -r ~/.config/blurlocksh
	rm -r ~/.config/ranger
	rm ~/.config/compton.*
	rm ~/.zshrc
	rm ~/.profile
	cp zshrc ~/.zshrc
	cp profile ~/.profile
	cp config/i3 ~/.config/i3
	cp config/blurlocksh ~/.config/blurlocksh
	cp config/dunst ~/.config/dunst
	cp config/ranger ~/.config/ranger
	cp config/compton.sh ~/.config/compton.sh
	cp config/compton.conf ~/.config/compton.conf
	echo "done"
elif [[dotask == "n"]]; then
	echo "Not installing dotfiles. Endex"
	exit
elif [[dotask != "n"]] && [[dotask != "y"]]; then
	echo "(y)es or (n)o?"
fi
