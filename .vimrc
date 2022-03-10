""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Base setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" Plugin 'morhetz/gruvbox.vim'
Plugin 'scrooloose/nerdtree'
" Plugin 'ycm-core/YouCompleteMe'
call vundle#end()

" Plugin settings
nmap ga :Ag<CR>
nmap <silent> <Tab> :NERDTreeToggle<CR>

" Import
if filereadable($HOME.'/.vimlib/cscope.vim')
    so $HOME/.vimlib/cscope.vim
endif

if filereadable($HOME.'/.vimlib/gitblame.vim')
    so $HOME/.vimlib/gitblame.vim
endif

" cwd
" autocmd BufEnter * lcd %:p:h

" Colorscheme
" Plugin 'octol/vim-cpp-enhanced-highlight'
set background=dark
color gruvbox

" Syntax highlighting
if has ("syntax")
    syntax on
endif

" find returns multiple files
set wildmenu
set wildmode=list:full

" Indentation
set autoindent
set cindent
set smartindent
set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set nopaste

" Backspace
set backspace=indent,eol,start

" C++ indentation
set cindent
"set cino=:0p0t0(0g1

" Show line number & curr position
set nu
set ru

" Vertical indentation line

" Search
set hlsearch    " highlight result
set ic          " ignore case
set incsearch   " show result w/o <Enter>

" Encoding
set fileencodings=ucs-bom,utf-8,euc-kr,latin1

" Column limitation
" set cc=

" Set ColorColumn color
highlight ColorColumn ctermbg=8


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ExtraWhitespace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" match ExtraWhitespace /\s\+$/  " Show trailing whitespace
" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" " After a buffer is displayed in a window
" autocmd InsertEnter * match ExtraWhitespace /\s\+\$#\@<!$/
" " When starting Insert mode
" autocmd InsertLeave * match ExtraWhitespace /\s\+$/
" " When leaving Insert mode
" autocmd BufWinLeave * call clearmatches()
" " Before a buffer is removed from a window

" To whow trailing whitespace after some text, use the following;
" /\S\zs\s\+$/


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" modification
map W diw
map E diwi
noremap S D
noremap D C

" ctags-style stack pop
noremap <c-e> <c-]>

" Move between panes
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" Pane size
noremap <silent> <C-S-Left> :vertical resize -1<CR>
noremap <silent> <C-S-Right> :vertical resize +1<CR>

" switch to last file
map <c-@> <c-^>

" To the start of the line
" nmap @ ^

" half page up/down
" noremap <c-y> <c-b><c-d>
" noremap <c-]> <c-f><c-u>

" show full path from $HOME
noremap <c-g> 1<c-g>

" OS buffer copy
xnoremap <S-c> "+y
nnoremap <C-S-c> gg<S-v><S-g>"+y

" Comment out
nmap <C-]> :s/^/\/\/ <CR>:noh<CR>
" imap <C-]> <ESC>:s/^/\/\/ <CR>:noh<CR>
vmap <C-]> :s/^/\/\/ <CR>:noh<CR>
nmap <C-S-]> :s/^\/\/ /<CR>:noh<CR>
" imap <C-[> <ESC>:s/^\/\/ /<CR>:noh<CR>
vmap <C-S-]> :'<,'>s/^\/\/ /<CR>:noh<CR>

" scroll one line
nnoremap <C-w> <C-e>

"파일을 열었을 때, 예전에 편집하던 위치로 커서이동
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" Auto braket completion
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
" inoremap {<Space> {<Space>}<left>
inoremap {<CR> {<CR>}<ESC>O
" inoremap {;<CR> {<CR>};<ESC>O


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Advanced Key Mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <F3> - Add comment
" map <F3> a/*<Space><Space>*/<Left><Left><Left>
" map <F3> I// <ESC>
" imap <F3> /*<Space><Space>*/<Left><Left><Left>

" <F4> - Trim Whitespace
"autocmd BufWritePre *.* %s/\s\+$//ge
" When starting to write the whole buffer to a file
" map <F4> :%s/\s\+$//ge<CR>:noh<CR>
" imap <F4> <ESC>:%s/\s\+$//ge<CR>:noh<CR>

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File Traversal
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" list-up last open files, open next/prev file
" key: ,,
"      ,n
"      ,p
"      ,f
" buffer traversal
nmap ;a :ls<CR>:e #
nmap ,n :bnext<CR>
nmap ,p :bprev<CR>
nmap ,f :sf<SPACE>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Advanced Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"선택영역 위아래로 입력 문자열로 #if 0
"#if 0
"      ..... 선택영역
"      ..... 선택영역
"#endif
autocmd FileType c,cpp,yacc,lex map <buffer> ,ci :'<,'>call InsertBlockString("#if 0","#endif")<CR>$a<ESC>
" ifdef 중간에서 위쪽아래쪽
"#if 0          ->    <제거됨>
"      .....    ->    .....
"      .....    ->    .....
"#endif         ->    <제거됨>
autocmd FileType c,cpp,yacc,lex map  <buffer> ,xi :call RemoveBlockString("^#if 0","^#endif")<CR>

"visual block으로 설정된 범위 위 아래로, string를 삽입한다
" str1
" ... selected block ...
" ... selected block ...
" str2
function! InsertBlockString(str1,str2) range
    call append(a:lastline, a:str2)
    call append(a:firstline -1, a:str1)
    call cursor(a:firstline,0)
endfunction

" 아래와 같은 패턴 중간 block에서 이 함수를 부를 경우, str1, str2 라인을 지워준다
" 어느하나라도 존재하지 않는 경우 지우지 않는다
"str1
"   In the Middle of Pattern
"str2
function! RemoveBlockString(str1,str2)
    let nr_cur=line(".")

    let nr_e = searchpair(a:str1,"",a:str2,"W")
    let nr_s = searchpair(a:str1,"",a:str2,"bW")

    "pair로 pattern이 존재하지 않으면 그냥 return
    if nr_e == 0 || nr_s == 0
        return
    endif

    call cursor(nr_e,0)
    exe "normal dd"
    call cursor(nr_s,0)
    exe "normal dd"

    call cursor(nr_cur,0)
endfunction

" .cc <-> .h 자동 이동
" key: A
autocmd FileType c,cpp,yacc,lex nmap <buffer> <M-o> :call AlternateFile(0)<CR>
command! -nargs=0 A call AlternateFile(0)

autocmd FileType c,cpp,yacc,lex nmap <buffer> ^[p :call AlternateFile(1)<CR>

"a:toggle_template
let s:alternate_file_name=''
function! AlternateFile(toggle_template)
    let filename_sans_extension = expand("%:t:r")
    let filename_extension = expand("%:e")
    let filename = ''

    if a:toggle_template == 0
        if filename_extension == "c"        " c->
            let filename = filename_sans_extension . ".h"
            execute ":find " . filename

        elseif filename_extension == "cc"   " cc->
            let filename = filename_sans_extension . ".h"
            execute ":find " . filename

        elseif filename_extension == "h"    " h->
            if $PROJ == "deneb"
                let filename = filename_sans_extension . ".cpp"
                execute ":find " . filename
            else
                let filename = filename_sans_extension . ".cc"
                execute ":find " . filename
            endif

        elseif filename_extension == "cpp"  " cpp->
            if $PROJ == "osrm"
                let filename = filename_sans_extension . ".hpp"
                execute ":find " . filename
            else
                let filename = filename_sans_extension . ".h"
                execute ":find " . filename
            endif

        elseif filename_extension == "hpp"  " hpp->
            let filename = filename_sans_extension . ".cpp"
            execute ":find " . filename
        endif

    else
        if strlen(s:alternate_file_name) != 0 &&
            \filename_extension == 'template'
            execute ":e ".s:alternate_file_name
            "reset
            let s:alternate_file_name=''
            return
        endif
        let pat='^ \* Template : '
        let line_num = search(pat,'n')
        if line_num <= 0
            return
        endif
        let s:alternate_file_name=expand("%")
        execute ":e ". substitute(getline(line_num), pat, '','')
    endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map gdi :call GitDiff()<CR>

function! GitDiff()
    let commit = expand("<cword>")
    execute "!clear && git log -c " . commit
endfunction

