## Key commands: [Cheat Sheet](notes/cheatsheet.md)

# Setup My Development Environment

## Link config files
```bash
ln -s ~/.chillDevEnv/nvim/ ~/.config/nvim
ln -s ~/.chillDevEnv/tmux.conf ~/.tmux.conf
ln -s ~/.chillDevEnv/bash_aliases ~/.bash_aliases
ln -s ~/.chillDevEnv/notes ~/notes
```

## Install Tmux package mangager
```
sudo apt install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf
```
Run tmux, update using `\<leader\> I`, then restart tmux


## Install Neovim
```
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
```
Add this line to `~/.bashrc`:
```
export PATH="$PATH:/opt/nvim-linux64/bin"
```

## Random Suport files
### Clipboard Stuff
```
sudo apt install xsel
```

### Nerd Font: [Pick a font (Agave)](https://www.nerdfonts.com/font-downloads)
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Agave.zip
unzip Agave.zip
fc-cache .local/share/fonts
```

### Telescope.nvim requirmemts
```sh
sudo apt-get install ripgrep
sudo apt install fd-find
```

### Mason-LSP packages
```
sudo apt install python3.10-venv  # for pylsp
sudo apt install npm  # for bashls, jsonls, priettier
```

# About
### C++ Diagnostics
* Install gcc, g++, cmake, clang, clangd, clang-tidy, llvm, ccls
* `clangd`: c/c++ LSP

