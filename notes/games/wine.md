# How to set up wine games
## Pokemon Uranium
```bash
# Set up fresh win prefix
export WINEPREFIX=~/.local/share/wineprefixes/pokemon-uranium
export WINEARCH=win32
# Create the prefix (be patient, first time can take 5-15 min)
wineboot -u
winetricks -q corefonts
# Run the game
WINEPREFIX=~/.local/share/wineprefixes/pokemon-uranium \
wine ~/games/pokemon_uranium/Uranium.exe
# set up save file cache
mkdir -p ~/games/pokemon_uranium/saves/cached_saves
ln -sfn ~/.local/share/wineprefixes/pokemon-uranium/drive_c/users/chill/Saved\ Games/Pokemon\ Uranium ~/games/pokemon_uranium/saves/game_saves
```

## Pokemon Xenoverse
```bash
# Set up fresh win64 prefix
export WINEPREFIX=~/.local/share/wineprefixes/pokemon-xenoverse
export WINEARCH=win64
# Create the prefix (be patient, first time can take 5-15 min)
wineboot -u
# Install the exact deps from the script (ignore the OLE spam)
winetricks -q dotnet472 d3dcompiler_47
# Run the game
WINE_LARGE_ADDRESS_AWARE=1 \
WINEPREFIX=~/.local/share/wineprefixes/pokemon-xenoverse \
wine ~/games/pokemon_xenoverse/snGame_n.exe
# set up save file cache
mkdir -p ~/games/pokemon_xenoverse/saves/cached_saves
ln -sfn ~/.local/share/wineprefixes/pokemon-xenoverse/drive_c/users/chill/Saved\ Games/Xenoverse/ ~/games/pokemon_xenoverse/saves/game_saves
```
