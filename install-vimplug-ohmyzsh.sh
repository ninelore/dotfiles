echo "Installing vim-plug..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "Installed vim-plug!"

echo "Installing Oh-my-Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Installed Oh-my-Zsh!"
echo "Done!"
echo 
echo "IMPORTANT: Run ':PlugInstall' in vim!"
