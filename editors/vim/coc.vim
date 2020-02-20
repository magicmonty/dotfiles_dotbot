" smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" always show signcolumns
set signcolumn=yes

" use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

autocmd CursorHold * silent call CocActionAsync('highlight')

" Multiple cursors support (like in VS Code)
" nmap <expr> <silent> <C-.> <SID>select_current_word()

function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunction

" Tab behavior on completion like VS Code
inoremap <silent><expr> <TAB>
      \ pumvisible()
      \   ? coc#_select_confirm()
      \   : coc#expandableOrJumpable()
      \       ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump', ''])\<CR>"
      \       : <SID>check_back_space()
      \           ? "\<TAB>"
      \           : coc#refresh()

let g:coc_snippet_next = '<tab>'

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Confirm snippet on Enter
inoremap <silent><expr> <cr>
      \ pumvisible()
      \   ? coc#_select_confirm()
      \   : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

