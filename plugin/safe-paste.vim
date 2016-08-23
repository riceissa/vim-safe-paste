if exists('g:loaded_safe_paste')
  finish
endif
let g:loaded_safe_paste = 1

" Modified from
" http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste
function! PasteCharacterwise(regname)
  let reg_type = getregtype(a:regname)
  call setreg(a:regname, getreg(a:regname), "c")
  " There is an annoying edge case when trying to paste at the end of the
  " line: normally, <C-\><C-o> wouldn't move the cursor (say, if you do "+gP
  " next), but in the case of executing :normal!, the cursor somehow moves
  " back anyway. In that case, we give up and use gp instead.
  if col(".") >= col("$")
    exe 'normal! "' . a:regname . 'gp'
  else
    exe 'normal! "' . a:regname . 'gP'
  endif
  call setreg(a:regname, getreg(a:regname), reg_type)
endfunction

" In insert mode, it doesn't make sense to do linewise paste when pasting from
" the system clipboard, so we force characterwise paste.
if has('clipboard')
  inoremap <expr> <C-r>+ col(".") >= col("$") ?
    \ '<C-g>u<C-\><C-o>:call PasteCharacterwise("+")<CR><Right>' :
    \ '<C-g>u<C-\><C-o>:call PasteCharacterwise("+")<CR>'
  inoremap <expr> <C-r>* col(".") >= col("$") ?
    \ '<C-g>u<C-\><C-o>:call PasteCharacterwise("*")<CR><Right>' :
    \ '<C-g>u<C-\><C-o>:call PasteCharacterwise("*")<CR>'
endif
