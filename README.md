# ninelore's dotfiles
My dotfiles  
I'm using awesomewm with LightDM, but this may either change or get some additions in the future.

## To-Do
- nothing atm :)

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
Various people from the [ArmaOnUnix Discord](https://discord.gg/p28Ra36) for all sorts of tips and help
