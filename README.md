# ninelore's dotfiles
My dotfiles  
I'm using awesomewm with LightDM, but this may either change or get some additions in the future.

## To-Do
- nothing atm :)

## Installation (cli only)

#### Copy configs

Copy the nvim and ranger folders form config to `$HOME/.config/`  
Copy the zshrc to your home dir and add the dot 

#### Install the depedencies:
- golang (for vim plugin)
- nodejs (for vim plugin)
- neovim (duh)
- ranger (best file manager)
- zsh (best shell)

#### Install oh-my-zsh and vim-plug
```
./install-vimplug-ohmyzsh.sh
```

Now open nvim and run
```
:PlugInstall
:CocInstall coc-json coc-tsserver
```

## Installation (awesomewm desktop)

#### Copy config files

Everything in the config folder belongs inside `$HOME/.config/`.    
Everything in the etc folder belongs inside `/etc/`.   
Everything inside the home folder goes into your `$HOME` and need to have they filenames prefixed with a dot.   

#### Install packages, oh-my-zsh and vim-plug

To install all requirements on Arch Linux run this: **requires paru** or manual sourcing of AUR Package   
```
cd dotfiles 
paru -Syu --needed $(cat requirements-full-arch.txt)
./install-vimplug-ohmyzsh.sh
```

#### Initialize Neovim Plugins
Run:  
```
:Pluginstall
:CocInstall coc-json coc-tsserver
```

## FAQ and other Info
- The win folder contains stuff for wsl 

## Credits
Various people from the [ArmaOnUnix Discord](https://discord.gg/p28Ra36) for all sorts of tips and help
