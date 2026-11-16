" Based on https://vim.fandom.com/wiki/SmartHome_and_SmartEnd_over_wrapped_lines
"
" {mode} is 'n' (Normal), 'v' (Visual, called after leaving Visual mode) or
" 'i' (Insert, called from <C-r>=).

" Restore the Visual selection with the cursor at its new position, without
" setting a mark.
function! s:Reselect(mode) abort
  if a:mode is# 'v'
    let pos = [line('.'), col('.')]
    normal! gv
    call cursor(pos)
  endif
endfunction

" Run a screen-row motion if 'wrap' is set, else the buffer-line motion.
function! s:Motion(wrapped, unwrapped) abort
  execute 'normal!' (&wrap ? a:wrapped : a:unwrapped)
endfunction

function! SmartHomeEnd#Home(mode) abort
  let line = getline('.')
  let curcol = col('.')
  " Byte columns of the first non-blank and of the previous character.
  let firstcol = matchend(line, '^\s*') + 1
  let prevcol = curcol - strlen(matchstr(strpart(line, 0, curcol - 1), '.$'))

  " Gravitate towards the beginning for wrapped lines.
  if prevcol > firstcol
    call cursor(0, prevcol)
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
  let line = getline('.')
  let curcol = col('.')
  " Byte columns of the next character and of the last one (in Insert mode,
  " of the position after it).
  let nextcol = curcol + strlen(matchstr(line, '\%' . curcol . 'c.'))
  let lastcol = col('$') - (a:mode is# 'i' ? 0 : strlen(matchstr(line, '.$')))

  " Gravitate towards the end for wrapped lines.
  if nextcol < lastcol
    call cursor(0, nextcol)
  endif

  if curcol < lastcol
    call s:Motion('g$', '$')
  else
    normal! g_
  endif

  call s:Reselect(a:mode)

  " In Insert mode, move past the last character if the cursor is on the
  " last screen row of the buffer line.
  if a:mode is# 'i'
    let winid = win_getid()
    let lnum = line('.')
    if screenpos(winid, lnum, col('.')).row == screenpos(winid, lnum, col('$')).row
      return "\<Right>"
    endif
  endif

  return ''
endfunction
