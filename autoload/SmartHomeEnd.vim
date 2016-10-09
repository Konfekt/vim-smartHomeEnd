" See http://vim.wikia.com/wiki/SmartHome_and_SmartEnd_over_wrapped_lines
function! SmartHomeEnd#Home(mode) abort
  let curcol = col('.')
  "gravitate towards beginning for wrapped lines
  if curcol > indent('.') + 2
    call cursor(0, curcol - 1)
  endif
  if curcol == 1 || curcol > indent('.') + 1
    if &wrap
      normal! g^
    else
      normal! ^
    endif
  else
    if &wrap
      normal! g0
    else
      normal! 0
    endif
  endif

  if a:mode is# 'v'
    normal! m`gvg``
  endif
  return ''
endfunction

function! SmartHomeEnd#End(mode) abort
  let curcol = col('.')
  let lastcol = a:mode ==# 'i' ? col('$') : col('$') - 1

  " Gravitate towards ending for wrapped lines
  if curcol < lastcol - 1
    call cursor(0, curcol + 1)
  endif

  if curcol < lastcol
    if &wrap
      normal! g$
    else
      normal! $
    endif
  else
    normal! g_
  endif

  if a:mode is# 'v'
    normal! m`gvg``
  endif

  return ''
endfunction

