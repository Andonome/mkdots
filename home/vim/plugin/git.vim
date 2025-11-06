set statusline+=<<\ %f\ >>
set statusline+=%1* " Remove colour
set statusline+=%=
set statusline+=%3*\%h%m%r
set statusline+=%4*\%{b:gitbranch}
set statusline+=%3*\%.25f
set statusline+=%3*\:\ 
set statusline+=%3*\%c-\%l/%L\ 
set statusline+=%3*\%y

function! StatuslineMode()
    let l:mode=mode()
    if l:mode==#"n"
        return "NORMAL"
    elseif l:mode==?"v"
        return "VISUAL"
    elseif l:mode==#"i"
        return "INSERT"
    elseif l:mode==#"R"
        return "REPLACE"
    endif
endfunction

function! StatuslineGitBranch()
  let b:gitbranch=""
  if &modifiable
    try
      lcd %:p:h
    catch
      return
    endtry
    let l:gitrevparse=system("git rev-parse --abbrev-ref @")
    lcd -
    if l:gitrevparse!~"fatal: not a git repository"
      let b:gitbranch="(".substitute(l:gitrevparse, '\n', '', 'g').") "
    endif
  endif
endfunction

augroup GetGitBranch
  autocmd!
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END
