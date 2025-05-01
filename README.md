# SLHernandes's Dotfiles
## Download

```sh
git clone https://github.com/slhernandes/dotfiles.git --depth=1 --recurse-submodules
```

## Usage

To use the config, either manually copy/link the files one by one to \$XDG_CONFIG_HOME or \$HOME/.config,
or use the ```deploy.sh``` script.

### deploy.sh Script

Usage:
```
./deploy.sh [-y|--noconfirm|-h|--help] <manifest_file> [target_dir]
    -h / --help      : show this message
    -y / --noconfirm : skip all [y/N] questions
    manifest_file    : location of the manifest file
    target_dir       : link target location (default: $XDG_CONFIG_HOME or $HOME/.config)
```

### Manifest File

Each line of the manifest file consists of mode (c/d), and source directory name, separated by '|'.
'c' mode links all the content in the file to the target_dir, whereas 'd' mode links the directory
to the target_dir
example:
```
# test.manifest
c|zsh
c|emacs
d|nvim
```
