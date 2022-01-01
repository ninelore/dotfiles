# ninelore's dotfiles
My dotfiles    
I'm using LightDM and awesomewm atm

## To-Do

- nvim: config overhaul (wip)

## Installation

#### Copy config files

Everything in the config folder belongs inside `$HOME/.config/`.    
Everything in the etc folder belongs inside `/etc/`.   
Everything inside the home folder goes into your `$HOME` and need to have they filenames prefixed with a dot.   

#### Install packages, oh-my-zsh and VimPlug

To install all requirements on Arch Linux run this: **requires paru** or manual sourcing of AUR Package   
```
cd dotfiles 
paru -Syu --needed $(cat requirements.txt)
./install-vimplug-ohmyzsh.sh
```

#### Initialize Neovim Plugins
Run:  
```
:Pluginstall
:CocInstall coc-json coc-tsserver
```

## FAQ
nothing atm

## Credits
tbd
