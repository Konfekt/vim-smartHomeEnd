" Headless tests for vim-smartHomeEnd.
" Run with test/run.sh, or:
"   vim -N -u NONE -i NONE --not-a-term -S test/test.vim
"   nvim --headless -u NONE -i NONE -S test/test.vim
" Results are written to the file in $SMARTHOMEEND_TEST_OUT (default:
" test/result.txt); Vim exits with status 1 if any test fails.

let s:root = fnamemodify(expand('<sfile>:p'), ':h:h')
let s:out = empty($SMARTHOMEEND_TEST_OUT) ? s:root . '/test/result.txt' : $SMARTHOMEEND_TEST_OUT

let &runtimepath = s:root . ',' . &runtimepath
execute 'source' fnameescape(s:root . '/plugin/SmartHomeEnd.vim')
set columns=80 lines=24 noswapfile hidden

let s:log = []
let s:failed = 0

function! s:Reset(lines) abort
  silent! only!
  enew!
  setlocal wrap noexpandtab
  call setline(1, a:lines)
  redraw
endfunction

" Type {keys} in Insert mode and return the cursor column seen while still in
" Insert mode.
function! s:InsertCol(keys) abort
  let g:shp_col = -1
  call feedkeys(a:keys . "\<C-r>=execute('let g:shp_col = col(\".\")')\<CR>\<Esc>", 'xt')
  return g:shp_col
endfunction

function! s:Check(name, got, want) abort
  if a:got ==# a:want
    call add(s:log, 'ok   ' . a:name)
  else
    let s:failed += 1
    call add(s:log, 'FAIL ' . a:name . ': got ' . string(a:got) . ', want ' . string(a:want))
  endif
endfunction

" Normal mode <Home> cycles between first non-blank and column 1.
function! s:TestHomeSpaces() abort
  call s:Reset(['    foo bar'])
  call cursor(1, 9)
  call feedkeys("\<Home>", 'xt')
  call s:Check('home spaces: to first non-blank', col('.'), 5)
  call feedkeys("\<Home>", 'xt')
  call s:Check('home spaces: to column 1', col('.'), 1)
  call feedkeys("\<Home>", 'xt')
  call s:Check('home spaces: back to first non-blank', col('.'), 5)
endfunction

" Tab indentation: indent() is a display width, not a byte column.
function! s:TestHomeTabs() abort
  call s:Reset(["\tfoo bar"])
  call cursor(1, 6)
  call feedkeys("\<Home>", 'xt')
  call s:Check('home tabs: to first non-blank', col('.'), 2)
  call feedkeys("\<Home>", 'xt')
  call s:Check('home tabs: to column 1', col('.'), 1)
  call cursor(1, 6)
  call s:Check('insert <C-a> tabs: to first non-blank', s:InsertCol("i\<C-a>"), 2)
endfunction

function! s:TestEnd() abort
  call s:Reset(['foo bar baz'])
  setlocal nowrap
  call cursor(1, 1)
  call feedkeys("\<End>", 'xt')
  call s:Check('end nowrap: to last char', col('.'), 11)
  call cursor(1, 1)
  call s:Check('insert <C-e>: after last char', s:InsertCol("i\<C-e>"), 12)
endfunction

" Insert-mode <C-e> on a wrapped line stops at the end of the screen row and
" only moves past the last character on the last screen row.
function! s:TestInsertEndWrapped() abort
  call s:Reset([repeat('abcd ', 30)])
  call cursor(1, 1)
  call s:Check('insert <C-e> wrapped: end of first screen row', s:InsertCol("i\<C-e>"), 80)
endfunction

" The same buffer in two windows of different widths: the screen row must be
" taken from the current window, not the first window showing the buffer.
function! s:TestInsertEndSplit() abort
  call s:Reset([repeat('x', 50)])
  rightbelow vsplit
  vertical resize 20
  setlocal wrap
  redraw
  call cursor(1, 1)
  call s:Check('insert <C-e> split: end of screen row in current window', s:InsertCol("i\<C-e>"), 20)
  only!
endfunction

" Buffer names with wildcard characters are treated as patterns by
" bufwinid(); the current window must still be found.
function! s:TestInsertEndSpecialName() abort
  call s:Reset([repeat('x', 100)])
  silent file foo[1].txt
  redraw
  call cursor(1, 1)
  call s:Check('insert <C-e> special name: end of first screen row', s:InsertCol("i\<C-e>"), 80)
  bwipeout!
endfunction

" <C-e> at the end of the line keeps its built-in meaning (copy char below).
function! s:TestCtrlEFallback() abort
  call s:Reset(['ab', 'abc'])
  call cursor(1, 2)
  call feedkeys("A\<C-e>\<Esc>", 'xt')
  call s:Check('insert <C-e> at end of line: built-in', getline(1), 'abc')
endfunction

" Visual mode keeps the selection and extends it.
function! s:TestVisual() abort
  call s:Reset(['    foo bar'])
  call cursor(1, 9)
  call feedkeys("v\<Home>\<Esc>", 'xt')
  call s:Check('visual home: start', getpos("'<")[2], 5)
  call s:Check('visual home: end', getpos("'>")[2], 9)
  call cursor(1, 5)
  call feedkeys("v\<End>\<Esc>", 'xt')
  call s:Check('visual end: end', getpos("'>")[2], 11)
endfunction

for s:t in ['HomeSpaces', 'HomeTabs', 'End', 'InsertEndWrapped',
      \ 'InsertEndSplit', 'InsertEndSpecialName', 'CtrlEFallback', 'Visual']
  try
    call call('s:Test' . s:t, [])
  catch
    let s:failed += 1
    call add(s:log, 'FAIL ' . s:t . ': ' . v:exception . ' @ ' . v:throwpoint)
  endtry
endfor

call add(s:log, s:failed ? s:failed . ' failed' : 'all passed')
call writefile(s:log, s:out)
execute s:failed ? 'cquit!' : 'qall!'
