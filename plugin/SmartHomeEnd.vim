if exists('g:loaded_SmartHomeEnd')
  finish
endif
let g:loaded_SmartHomeEnd = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

nnoremap <silent> <Plug>(SmartHomeEnd-Home) :<C-u>call SmartHomeEnd#Home('n')<CR>
nnoremap <silent> <Plug>(SmartHomeEnd-End)  :<C-u>call SmartHomeEnd#End('n')<CR>
xnoremap <silent> <Plug>(SmartHomeEnd-Home) <Esc>:call SmartHomeEnd#Home('v')<CR>
xnoremap <silent> <Plug>(SmartHomeEnd-End)  <Esc>:call SmartHomeEnd#End('v')<CR>
inoremap <silent> <Plug>(SmartHomeEnd-Home) <C-r>=SmartHomeEnd#Home('i')<CR>
inoremap <silent> <Plug>(SmartHomeEnd-End)  <C-r>=SmartHomeEnd#End('i')<CR>

silent! nmap <unique> <Home> <Plug>(SmartHomeEnd-Home)
silent! nmap <unique> <End>  <Plug>(SmartHomeEnd-End)
silent! xmap <unique> <Home> <Plug>(SmartHomeEnd-Home)
silent! xmap <unique> <End>  <Plug>(SmartHomeEnd-End)
silent! imap <unique> <C-a>  <Plug>(SmartHomeEnd-Home)

" At the end of the line or with the popup menu open, <C-e> keeps its
" built-in meaning.
inoremap <SID>(CtrlE) <C-e>
silent! imap <unique><expr> <C-e> col('.') > strlen(getline('.')) \|\| pumvisible() ? "<SID>(CtrlE)" : "<Plug>(SmartHomeEnd-End)"

let &cpoptions = s:save_cpo
unlet s:save_cpo
