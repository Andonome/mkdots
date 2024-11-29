vim9script

# Bracket Autocompletion
def ConditionalPairMap(open: string, close: string): string
  var line = getline('.')
  var col  = col('.')
  if col < col('$') || stridx(line, close, col + 1) != -1
    return open
  else
    return open .. close .. repeat("\<left>", len(close))
  endif
enddef
inoremap <expr> ( ConditionalPairMap('(', ')')
inoremap <expr> { ConditionalPairMap('{', '}')
inoremap <expr> [ ConditionalPairMap('[', ']')
