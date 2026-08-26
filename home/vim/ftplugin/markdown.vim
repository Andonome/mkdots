colorscheme slate

setlocal laststatus=2

map ,` o```<Enter>```<Esc>kA
setlocal tabstop=4 expandtab shiftwidth=4
set suffixesadd=.md

autocmd BufWinEnter,BufNewFile * setlocal formatoptions=watcqlnro


setlocal spell

vmap <C-t> :!tr -s ' -' \|column -ts '\|' -o '\|'<Enter>j:s/ /-/g<Enter>k

vmap <C-s> :!column -ts, -o " \| "<Enter>yyp:s/[^\|:]/-/g<Enter>


ab PR pull request
ab PRs pull requests
ab MR merge request
ab MRs merge requests
ab SP small potatoes
ab pkm personal knowledge management
ab gm Game Master
ab dm Dungeon Master
ab ng night guard
ab ngs night guards
ab pc player character
ab pcs player characters
ab npc non-player character
ab npcs non-player characters
ab xp experience point
ab xps experience points
