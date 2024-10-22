# Cheat Sheet
https://tmuxcheatsheet.com/
TODO: 
* Nested Tmux
  - [article](https://www.freecodecamp.org/news/tmux-in-practice-local-and-nested-remote-tmux-sessions-4f7ba5db8795/)
* Buffers, window, and tabs
* Toggle folding
* spell checking

## Tmux
|Function|Command|
|-|-|
|Install Plugins|\<leader\> I|
|Update Plugins |\<leader\> U|
|Uninstall Plugins |\<leader\> alt-u|
|||
|Sessions||
|New Window| \<leader\> c|
|Rename Window|\<leader\> ,|
|Swap Window| \<leader\> w|
|||
|**Panes**||
|Split horizontal | \<leader\> s |
|Split vertical | \<leader\> S |
|Resize pane | Ctrl+Alt+j/k/h/l |
|Zoom pane (toggle) | \<leader\> z|
|Preset Layout | \<leader\> Alt+1-5 |
|Rotate Present Layout | \<leader\> SPACE |

## Neovim
[](https://vim.rtorr.com/)
[neovim](https://www.shortcutfoo.com/app/dojos/neovim/cheatsheet)
[neovim](https://github.com/mattmc3/neovim-cheatsheet)
|Function|Command|
|-|-|
|**Navigation** ||
|single character move| j/k/h/l |
|go forwards to start of word| w |
|go forwards to start of word (with punctuation) | W |
|go forwards to end of word| e |
|go forwards to end of word (wth punctuation)| E |
|go backwards to start of word| b |
|go backwards to start of word (with punctuation)| B |
|go backwards to start of word| ge |
|go backwards to start of word (with punctuation)| gE |
|top of file| gg |
|Bottom of file| G |
|Center screen on line | zz |
|Jump to closing (/{/[| % |
|||
|**Text Editing** ||
|delete| d |
|delete| d |
|change| d |
|insert mode| i |
|Newline under| o |
|Newline over| O |
|||
|**File Management**||
|save buffer to disk| :w |
|save all buffers| :wa |
|save and exit| :qw |
|save all and | :qwa |
|||
|**Windows** ||
|Split horizontal | \<leaderr\>sh |
|Split vertical | \<leaderr\>sv |
|Swap windows| Ctrl+w J/K/H/L |
|Close cur window| :q |
|Close all windows| :qa |
|Create Tab| \<leader\> tc |
|Close Tab| \<leader\> tq |
|||
|**Telescope** ||
|Find filename | \<leader\> ff|
|Grep files  | \<leader\> fg|
|||
|**Neo-tree** ||
|Open file tree | \<leader\> e |
|Preview files | (focus Neo-tree) P |
|Add new file/dir | (focus Neo-tree) a |
|Delete file | (focus Neo-tree) d |
|Rename file | (focus Neo-tree) r |
|Open buffer tree | \<leader\> b |
|Close buffer | bd |
|||
|**TreeSitter** ||
|make Fold column| set foldcolumn=1|
|Manual Fold| zf |
|Open Fold| zo |
|Close Fold| zc |
|Toggle Fold| za |
|Reveal all| zR |
|Fold all| zM |
|Delete Fold| zd |
|Delete(recursive) Fold| zD |
|||
|**TreeSitter** ||
|||
|**LSP** ||
|See this diagnostic error| \<leader\>do |
|Toggle inline error text| \<leader\>dt |
|Kill all diagnostics | \<leader\>dk |
|Resume diagnostics | \<leader\>dr |
|View All diagnostics | \<leader\>dd |
|||
|**Cool Stuff** ||
| See the tresSitter tree | :InspectTree |
