## Key commands --> [Cheat Sheet](notes/cheatsheet.md)

# Setup My Development Environment
```bash
ln -s ~/.chillDevEnv/nvim/ ~/.config/nvim
ln -s ~/.chillDevEnv/tmux.conf ~/.tmux.conf
ln -s ~/.chillDevEnv/bash_aliases ~/.bash_aliases
ln -s ~/.chillDevEnv/notes ~/notes
```


* nvim
  * lazynvim (package manager)
* tmux
  * plugins
  ```
  [C-b] U,I
  ```
## Set up Steps

### Install tmux & neovim >= 9.0

### C++ Diagnostics
* Install gcc, g++, cmake, clang, clangd, clang-tidy, llvm, ccls
* `clangd`: c/c++ LSP

### Clipboard Stuff
```
sudo apt install xsel
```

### Install lazy nvim package manager
#### Requirements: [Lazynvim](https://www.lazyvim.org/)
* Nerd Font: [Pick a font (Agave)](https://www.nerdfonts.com/font-downloads)
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Agave.zip
unzip Agave.zip
```

* Tree-sitter: [syntax highlighter](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
* Telescope.nvim: []()
```sh
# install live grep (ripgrep)
sudo apt-get install ripgrep
# install find files (fd)
sudo apt install fd-find
# check true color
echo $COLORTERM
```

### Bashrc alias
```vimrc
# Use Neovim instead of Vim" >> ~/.bashrc
export PATH="$PATH:/opt/nvim-linux64/bin"
alias vim='nvim'
alias vi='nvim'
```
