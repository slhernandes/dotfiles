# SLHernandes's Dotfiles
## Download

```sh
git clone https://github.com/slhernandes/dotfiles.git --depth=1
```

## Usage

To use the config, either manually copy/link the files one by one to \$XDG_CONFIG_HOME or \$HOME/.config,
or use the ```deploy.sh``` script.

### deploy.sh Script

#### Usage
```console
 ./deploy.sh [-y|--noconfirm|-h|--help|-r|--replace] <manifest_file> [target_dir]
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
