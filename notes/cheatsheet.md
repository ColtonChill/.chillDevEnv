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
|Panes||
|Split horizontal | \<leader\> s |
|Split vertical | \<leader\> S |
|Resize pane | Ctrl+Alt+j/k/h/l |
|Zoom pane (toggle) | \<leader\> z|
|Preset Layout | \<leader\> Alt+1-5 |
|Rotate Present Layout | \<leader\> SPACE |

## Neovim
|Function|Command|
|-|-|
|**Navigation** ||
|single char move| j/k/h/l |
|top of file| gg |
|Bottom of file| G |
|Center on line | zz |
|||
|**Windows** ||
|Split horizontal | :sp |
|Split vertical | :vs |
|Swap windows| Ctrl+w J/K/H/L |
|||
|**Telescope** ||
|Find filename | \<leader\> ff|
|Grep files  | \<leader\> fg|
|||
|**Neo-tree** ||
|Toggle file tree | \<leader\> e |
|Preview files | (focus Neo-tree) P |
|Add new file/dir | (focus Neo-tree) a |
|Delete file | (focus Neo-tree) d |
|Rename file | (focus Neo-tree) r |
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
|**LSP** ||
|See this diagnostic error| \<leader\>do |
|Toggle inline error text| \<leader\>dt |
|Kill all diagnostics | \<leader\>dk |
|Resume diagnostics | \<leader\>dr |
|View All diagnostics | \<leader\>dd |
|||
|**Cool Stuff** ||
| See the tresSitter tree | :InspectTree |
