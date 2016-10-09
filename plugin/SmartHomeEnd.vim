if exists('g:loaded_SmartHomeEnd')
  finish
endif

nnoremap     <silent> <Plug>(SmartHomeEnd-Home) :<c-u>call SmartHomeEnd#Home("n")<CR>
nnoremap     <silent> <Plug>(SmartHomeEnd-End)  :<c-u>call SmartHomeEnd#End("n")<CR>
xnoremap     <silent> <Plug>(SmartHomeEnd-Home) <ESC>:call SmartHomeEnd#Home("v")<CR>
xnoremap     <silent> <Plug>(SmartHomeEnd-End)  <ESC>:call SmartHomeEnd#End("v")<CR>
inoremap     <silent> <Plug>(SmartHomeEnd-Home) <C-r>=SmartHomeEnd#Home("i")<CR>
inoremap     <silent> <Plug>(SmartHomeEnd-End)  <C-r>=SmartHomeEnd#End("i")<CR>

silent! nmap <unique> <Home>                    <Plug>(SmartHomeEnd-Home)
silent! nmap <unique> <End>                     <Plug>(SmartHomeEnd-End)
silent! xmap <unique> <Home>                    <Plug>(SmartHomeEnd-Home)
silent! xmap <unique> <End>                     <Plug>(SmartHomeEnd-End)
silent! imap <unique> <Home>                    <Plug>(SmartHomeEnd-Home)
silent! imap <unique> <End>                     <Plug>(SmartHomeEnd-End)

let g:loaded_SmartHomeEnd = 1
