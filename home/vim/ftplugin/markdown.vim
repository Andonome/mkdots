colorscheme slate

set nowrap

setlocal laststatus=2

map ,` o```<Enter>```<Esc>kA
setlocal tabstop=4 expandtab shiftwidth=4
set suffixesadd=.md

autocmd BufWinEnter,BufNewFile * setlocal formatoptions=watcqlnro


setlocal spell

vmap <C-t> :!tr -s ' -' \|column -ts '\|' -o '\|'<Enter>j:s/ /-/g<Enter>k

vmap <C-s> :!column -ts, -o " \| "<Enter>yyp:s/[^\|:]/-/g<Enter>


noreab PR pull request
noreab PRs pull requests
noreab MR merge request
noreab MRs merge requests
noreab SP small potatoes
noreab pkm personal knowledge management
noreab gm Game Master
noreab dm Dungeon Master
noreab ng night guard
noreab ngs night guards
noreab pc player character
noreab pcs player characters
noreab npc non-player character
noreab npcs non-player characters
noreab xp experience point
noreab xps experience points
