colorscheme  nelf
set tabstop=2 expandtab shiftwidth=2
set indentexpr=

set spell

map ,r  :w<Enter> :!pdflatex "%" <Enter>
map ,m  :wa<Enter> :!make <Enter>
map ,M  :wa<Enter> :!make
nnoremap ,lat :-1read $HOME/.vim/skel/lat.tex<CR>7j
nnoremap ,char :-1read $HOME/.vim/skel/bindCharacter.tex<CR>2f{a
nnoremap ,anim :-1read $HOME/.vim/skel/bindAnimal.tex<CR>2f{a
nnoremap ,art :-1read $HOME/.vim/skel/bindTalisman.tex<CR>2f{a
nnoremap ,vc :-1read $HOME/.vim/skel/wod_character.tex<CR>2f{a
nnoremap ,va :-1read $HOME/.vim/skel/wod_animal.tex<CR>2f{a
nnoremap ,vv :-1read $HOME/.vim/skel/wod_vampire.tex<CR>2f{a

map ,t Bi\textit{<Esc>ea}<Esc>
noremap ,c I\chapter{<Esc>A}<Esc>
noremap ,s I\section{<Esc>A}<Esc>
noremap ,u I\subsection{<Esc>A}<Esc>
noremap ,b I\subsubsection{<Esc>A}<Esc>
noremap ,p I\paragraph{<Esc>A}<Esc>
noremap ,I o\begin{itemize}<Return>\end{itemize}<Esc>O<Tab>\item<Return>
noremap ,E o\begin{enumerate}<Return>\end{enumerate}<Esc>O<Tab>\item<Return>
noremap ,D o\begin{description}<Return>\end{description}<Esc>O<Tab>\item[]<Esc>i
noremap ,i o\item<Return>
noremap ,d o\item[]<Esc>i
