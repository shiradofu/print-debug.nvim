if exists('g:loaded_print_debug_nvim')
  finish
endif

let g:loaded_print_debug_nvim = 1

nnoremap <Plug>(print-debug-add)   <Cmd>lua require('print-debug').add()<CR>
nnoremap <Plug>(print-debug-clear) <Cmd>lua require('print-debug').clear()<CR>

command! PrintDebugAdd   lua require('print-debug').add()
command! PrintDebugClear lua require('print-debug').clear()

