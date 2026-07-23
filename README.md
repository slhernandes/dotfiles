# SLHernandes's Dotfiles

## Currently Used Apps 

- [dunst](https://github.com/dunst-project/dunst)
- [ghostty](https://github.com/ghostty-org/ghostty)
- [hyprland](https://github.com/hyprwm/Hyprland) (lua config)
- [mpd](https://github.com/MusicPlayerDaemon/MPD) & [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp)
- [neovim](https://github.com/neovim/neovim)
- [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh)
- [quickshell](https://github.com/quickshell-mirror/quickshell)
- [rofi](https://github.com/davatorium/rofi)
- [tmux](https://github.com/tmux/tmux)
- [yazi](https://github.com/sxyazi/yazi)
- [zsh](https://www.zsh.org/)
- [dragon-drop](https://github.com/mwh/dragon)

## Download

```sh
git clone https://github.com/slhernandes/dotfiles.git --depth=1
```

## Dependencies
### Hyprland & Quickshell
```sh
sudo pacman -S hyprland rofi quickshell ttf-material-symbols-variable tmux
pikaur -S dragon-drop
```

## Usage

To use the config, either manually copy/link the files one by one to \$XDG_CONFIG_HOME or \$HOME/.config,
or use the ```deploy.sh``` script.

### Hyprland Commonly Used Keybind
|Key|Action|
|---|------|
|`SUPER+H`|Focus left workspace (cyclic)|
|`SUPER+L`|Focus right workspace (cyclic)|
|`SUPER+J`|Focus window below (cyclic)|
|`SUPER+K`|Focus window above (cyclic)
|`SUPER+[1-9]`|Focus workspace \[1-9\]|
|`SUPER+0`|Focus scratchpad|
|`SUPER+SHIFT+H`|Move active window to left workspace (cyclic)|
|`SUPER+SHIFT+L`|Move active window to right workspace (cyclic)|
|`SUPER+SHIFT+J`|Swap active window with window below (cyclic)|
|`SUPER+SHIFT+K`|Swap active window with window above (cyclic)|
|`SUPER+P`|Open app launcher|
|`SUPER+F`|Launch Firefox|
|`SUPER+T`|Launch Ghostty|
|`SUPER+ENTER`|Toggle tiled/tabbed layout|
|`SUPER+SHIFT+ENTER`|Toggle fullscreen|
|`SUPER+S`|Screenshot|
|`SUPER+SHIFT+C`|Close active window|
|`SUPER+SHIFT+Q`|Open control centre|
|`SUPER+SHIFT+S`|Toggle floating|
|`SUPER+ALT+S`|Toggle focus floating/tiled|


### deploy.sh Script

#### Usage
```console
 ./deploy.sh [-y|--noconfirm|-h|--help|-r|--replace|-u|--update] <manifest_file> [target_dir]
     -h / --help      : show this message
     -r / --replace   : do not skip when config exists in target_dir
     -u / --update    : Sync the plugins
     -y / --noconfirm : skip all [y/N] questions
     manifest_file    : location of the manifest file
     target_dir       : link target location (default: $XDG_CONFIG_HOME or $HOME/.config)
```

#### Examples
Automatically deploy and update:
```bash
./deploy.sh -r -u -y linux.manifest
```

Deploy (and ask for confirmation for every existing file) and update:
```bash
./deploy.sh -r -u linux.manifest
```

Update all the plugins:
```bash
./deploy.sh -u linux.manifest
```

### Manifest File

Each line of the manifest file consists of mode (c/d/cp), and source directory name, separated by '|'.
'c' mode links all the content in the file to the target_dir, 'd' mode links the directory
to the target_dir, and 'cp' mode copies all the files to the target_dir
example:
```
# test.manifest
c|zsh
c|emacs
d|nvim
cp|vim
```

## Caveats

### tmux

To install all the tpm plugins, do ```prefix+I```.

### yazi

To install all the yazi plugins, enter ```ya pkg -u``` command.

### emacs

After opening emacs for the first time, do:
```
M-x package-initialize RET
M-x load-file <init-file> RET
M-x tree-sit-install-language-grammar RET cpp RET RET
```
, where ```<init-file>``` is the location of init.el (default: ~/.config/emacs/init.el)

### neovim

If nvim is not cloned yet, do:
```sh
rmdir nvim
git clone https://github.com/slhernandes/nvim_config ./nvim
```

### Quickshell

- Copy `data_example/` as `data/`, and fill in the api_keys.json to fully use all of the features.
- The layout is only tested in 1080p
