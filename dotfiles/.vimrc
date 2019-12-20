""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
Plugin 'octol/vim-cpp-enhanced-highlight'
set background=dark
color gruvbox

" Syntax highlighting
if has ("syntax")
    syntax on
endif

" Indentation
set autoindent
set cindent
set smartindent
set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set nopaste

" C++ indentation
set cindent
set cino=:0p0t0(0g1

" Show line number & curr position
set nu
set ru

" Vertical indentation line

" Search
set hlsearch    " highlight result
set ic          " ignore case
set incsearch   " show result w/o <Enter>

" Auto braket completion
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
" inoremap {<Space> {<Space>}<left>
inoremap {<CR> {<CR>}<ESC>O
" inoremap {;<CR> {<CR>};<ESC>O

" Encoding
set fileencodings=ucs-bom,utf-8,euc-kr,latin1

" Column limitation
" set cc=

" Set ColorColumn color
highlight ColorColumn ctermbg=8


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ExtraWhitespace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/  " Show trailing whitespace
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" After a buffer is displayed in a window
autocmd InsertEnter * match ExtraWhitespace /\s\+\$#\@<!$/
" When starting Insert mode
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
" When leaving Insert mode
autocmd BufWinLeave * call clearmatches()
" Before a buffer is removed from a window

" To whow trailing whitespace after some text, use the following;
" /\S\zs\s\+$/


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <F3> - Add comment
" map <F3> a/*<Space><Space>*/<Left><Left><Left>
map <F3> I// <ESC>
imap <F3> /*<Space><Space>*/<Left><Left><Left>

" <F4> - Trim Whitespace
"autocmd BufWritePre *.* %s/\s\+$//ge
" When starting to write the whole buffer to a file
map <F4> :%s/\s\+$//ge<CR>:noh<CR>
imap <F4> <ESC>:%s/\s\+$//ge<CR>:noh<CR>

" Map key to toggle opt
function MapToggle(key, opt)
    let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
    exec 'nnoremap '.a:key.' '.cmd
    exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

" MapToggle <F9> wrap
MapToggle <F5> number
MapToggle <F6> paste

map W diw
map E diwi
noremap S D
noremap D C

" ctags stack pop
noremap <c-e> <c-]>

" indentation remap
inoremap <c-f> <c-t>

" Move between panes
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Comment out
" map <C-.> :s/\/\/ //<CR>:noh<CR>
" imap <C-.> <ESC>:s/\/\/ //<CR>:noh<CR>$i
" map <S-Right> <S-i>// <ESC>$
" imap <S-Right> <ESC><S-i>// <ESC>$i

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mouse Toggle
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ToggleMouse()
    " check if mouse is enabled
    if &mouse == 'a'
        " disable mouse
        set mouse=
    else
        " enable mouse everywhere
        set mouse=a
    endif
endfunc
map vv :call ToggleMouse()<CR>
" default : ToggleMouse on()
set mouse=a
