" Based on https://vim.fandom.com/wiki/SmartHome_and_SmartEnd_over_wrapped_lines

" Run a screen-row motion if 'wrap' is set, else the buffer-line motion.
function! s:Motion(wrapped, unwrapped) abort
  execute 'normal!' (&wrap ? a:wrapped : a:unwrapped)
endfunction

" Restore the Visual selection with the cursor at its new position.
function! s:Reselect(mode) abort
  if a:mode is# 'v'
    normal! m`gvg``
  endif
endfunction

function! SmartHomeEnd#Home(mode) abort
  let curcol = col('.')
  " Byte column of the first non-blank character.
  let firstcol = matchend(getline('.'), '^\s*') + 1

  " Gravitate towards the beginning for wrapped lines.
  if curcol > firstcol + 1
    call cursor(0, curcol - 1)
  endif

  if curcol == 1 || curcol > firstcol
    call s:Motion('g^', '^')
  else
    call s:Motion('g0', '0')
  endif

  call s:Reselect(a:mode)
  return ''
endfunction

function! SmartHomeEnd#End(mode) abort
  let curcol = col('.')
  let lastcol = a:mode ==# 'i' ? col('$') : col('$') - 1

  " Gravitate towards the end for wrapped lines.
  if curcol < lastcol - 1
    call cursor(0, curcol + 1)
  endif

  if curcol < lastcol
    call s:Motion('g$', '$')
  else
    normal! g_
  endif

  call s:Reselect(a:mode)

  " In Insert mode, move past the last character if the cursor is on the
  " last screen row of the buffer line.
  if a:mode ==# 'i'
    let winid = win_getid()
    let lnum = line('.')
    if screenpos(winid, lnum, col('.')).row == screenpos(winid, lnum, col('$')).row
      return "\<Right>"
    endif
  endif

  return ''
endfunction
