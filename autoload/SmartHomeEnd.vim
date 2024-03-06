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

  " Jump after last column if cursor on the last screen row of buffer line.
  if a:mode ==# 'i'
    let winid = bufwinid(bufname())
    let line = line('.')
    " Get the cursor's current screen row and column
    let cursor_screenpos = screenpos(winid, line, col('.'))
    let cursor_screenrow = cursor_screenpos.row

    " Get the screen row of the end of the current line
    let end_of_line_screenpos = screenpos(winid, line, col('$'))
    let end_of_line_screenrow = end_of_line_screenpos.row

    " Check if the cursor is on the same screen row as the end of the line
    if cursor_screenrow == end_of_line_screenrow
      return "\<right>"
    endif
  endif

  return ''
endfunction

