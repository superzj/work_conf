set nocompatible

syntax on
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set smartindent
set nocp
set incsearch " do incremental searching
set helplang=cn
"set scrolloff=3
set ambiwidth=double
set hlsearch

"set fileencoding=cp936
"set encoding=utf-8
"set termencoding=cp936
"set enc=cp936
set fencs=utf8,cp936,gbk,gb2312,gb18030
filetype indent plugin on
"set magic
"runtime ftplugin/man.vim
map <C-X><C-X> :!ctags -R --C++-kinds=+p --fields=+iaS --extra=+q .<CR>

set pastetoggle=<F11>
set nu

au BufRead,BufNewFile *.c       if (getcwd() =~ 'logic' && &ft == 'c') | set ft=lpc | let lpc_pre_v21=1 | endif
au BufRead,BufNewFile *.h       if (getcwd() =~ 'logic' && &ft == 'h') | set ft=lpc | let lpc_pre_v22=1 | endif
au BufRead,BufNewFile *.go      set ft=go
set backspace=indent,eol,start

set list
set lcs=tab:>\ ,trail:-,nbsp:-
set list noexpandtab shiftwidth=4 softtabstop=4 tabstop=4

set tabstop=4
set shiftwidth=4
set noexpandtab

inoremap <C-l> <Right>
:imap jj <Esc>

set fdm=marker

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  "filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  autocmd filetype python setlocal list noexpandtab shiftwidth=4 softtabstop=4 tabstop=4

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
set autoindent " always set autoindenting on

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	\ | wincmd p | diffthis
endif


cs add cscope.out

let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1

map <F8> :Tlist <CR>
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>i :cs find i <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

map <F7> :NERDTree<CR>
imap <F7> <ESC> :NERDTree<CR>

"For comment
function AddTitle()
	call setline(1, "//////////////////////////////////////////////////////////////////////////////////")
	call append(1, "//File          :  " . expand("%"))
	call append(2, "//Description   :  ")
	call append(3, "//By            :   - ")
	call append(4, "//Created       :  " . strftime("%F %R"))
	call append(5, "///////////////////////////////////////////////////////////////////////////////////")
endf

func SetTitle()
	if expand("%:e") == 'h'
		call AddTitle()
		call append(line("$"), "#ifndef _".toupper(expand("%:r"))."_H")
		call append(line("$"), "#define _".toupper(expand("%:r"))."_H")
		call append(line("$"), "")
		call append(line("$"), "#endif")
		return
	endif

	if &filetype == 'sh'
		call setline(1,"#!/usr/local/bin/bash")
		call append(1, "")
	elseif &filetype == 'python'
		call setline(1, "# -*- coding: gbk -*-")
		call append(1, "")
	elseif &filetype == 'ruby'
		call setline(1, "# encoding: utf-8")
		call append(1, "")
	elseif &filetype == 'c'
		call setline(1, "#include <stdio.h>")
		call append(1, "")
	elseif &filetype == 'java'
		call setline(1, "public class ".expand("%:r"))
		call append(1, "")
	elseif &filetype == 'cpp'
		call setline(1, "#include <iostream>")
		call append(1, "")
		call append(2, "using namespace std;")
		call append(3, "")
		call append(4, "")
	else
		call AddTitle()
	endif
endf

map <F6> :AddTitle<CR>

autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()"

" 状态栏
set laststatus=2      " 总是显示状态栏
highlight StatusLine cterm=bold ctermfg=yellow ctermbg=blue
" 获取当前路径，将$HOME转化为~
function! CurDir()
	let curdir = substitute(getcwd(), $HOME, "~", "g")
	return curdir
endfunction
set statusline=%f%m%r%h\ \|\ %{CurDir()}\ %=\|\ %l,%c\ %p%%\ \|\ ascii=%b,hex=%b%{((&fenc==\"\")?\"\":\"\ \|\ \".&fenc)}
