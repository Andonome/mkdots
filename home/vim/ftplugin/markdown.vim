colorscheme slate

setlocal laststatus=2

map ,` o```<Enter>```<Esc>kA
setlocal tabstop=4 expandtab shiftwidth=4
set suffixesadd=.md

setlocal spell

vmap <C-t> :!tr -s ' -' \|column -ts '\|' -o '\|'<Enter>j:s/ /-/g<Enter>k

vmap <C-s> :!column -ts, -o " \| "<Enter>yyp:s/[^\|:]/-/g<Enter>
