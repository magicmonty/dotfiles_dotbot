" Lightline
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active' : {
      \   'left':  [ [ 'mode', 'paste' ],
      \              [ 'readonly', 'filename', 'modified' ],
      \              [ 'fugitive' ],
      \              [ 'cocstatus', 'currentfunction' ] ],
      \ },
      \ 'inactive': {
      \   'left':  [ [ 'filename' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component': {
		  \   'lineinfo': ' %3l:%-2v'
      \ },
      \ 'component_function': {
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive',
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction'
      \ },
      \ 'separator': { 'left': '', 'right':'' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

" Shows a lock symbol if readonly (needs a powerline font)
function! LightlineReadonly()
	return &readonly ? '' : ''
endfunction

" shows a nice representation of the current branch (needs a powerline font)
function! LightlineFugitive()
  if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

function! CocCurrentFunction()
  if exists('*coc#status')
    return get(b:, 'coc_current_function', '')
  endif
  return ''
endfunction

