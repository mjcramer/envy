set nocompatible " must be vimproved

filetype off " required

if !filereadable(expand('~/.vim/bundle/vundle/README.md'))
    echo "Installing Vundle..."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" git functionality
Plugin 'tpope/vim-fugitive'
" status line
Plugin 'bling/vim-airline'
" display buffer on status line
Bundle 'bling/vim-bufferline'
" file opening tool 
Plugin 'git://git.wincent.com/command-t.git'
" tree view
Plugin 'scrooloose/nerdtree'
" nice commenting
Plugin 'scrooloose/nerdcommenter'
" source code completion
"Plugin 'Valloric/YouCompleteMe'
" vagrant support
Plugin 'markcornick/vim-vagrant'
" salt support 
Plugin 'saltstack/salt-vim'
" gradle support
Plugin 'tfnico/vim-gradle'
" scala support
Plugin 'derekwyatt/vim-scala'
" php coloring
Plugin 'vim-scripts/cleanphp'

" all of your Plugins must be added before the following line
call vundle#end() " required

filetype plugin indent on " required

if has('gui_running')
    set guioptions=cM
    set cursorline
endif

" key behavior
""""""""""""""""""""""""""""""""""""""""
" backspace should delete
set backspace=indent,eol,start
set modelines=0
" get rid of ex
nnoremap Q <nop>

" tabs and indents
""""""""""""""""""""""""""""""""""""""""
" size of a hard tabstop
set tabstop=4
" size of an indent
set shiftwidth=4
" a combination of spaces and tabs are used to simulate tab stops at a width other than the (hard) tabstop
set softtabstop=4
" make tab insert indents instead of tabs at the beginning of a line
"set smarttab
" always uses spaces instead of tab characters
"set expandtab
" automatically indent based on previous line
"set noautoindent
" copy the same indent characters as the line before
"set copyindent
" preserve as much of previous indent characters as possible
"set preserveindent

" history and backups
""""""""""""""""""""""""""""""""""""""""
" remember commands and search history
set history=1000
" remember lots of undo
set undolevels=1000
" disable unnecessary backups
set nobackup
" no annoying swp files
set noswapfile 

" searching
""""""""""""""""""""""""""""""""""""""""
" highlight search terms
set hlsearch
" show matches as you type
set incsearch
" never ignore case
set noignorecase
let hlstate=0
nnoremap <C-k> :if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<CR>

" buffer management
""""""""""""""""""""""""""""""""""""""""
map <Leader>bv :bprevious<CR>
map <Leader>bn :bnext<CR>
map <Leader>bg :bdelete<CR>

" splits
""""""""""""""""""""""""""""""""""""""""
" open new splits below current
set splitbelow
" open new splits to the right of current
set splitright

" airline configuration
""""""""""""""""""""""""""""""
" enable powerline fonts (requires font installation and setting the prompt in
" terminal profile!)
let g:airline_powerline_fonts = 1 
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_theme             = 'dark'

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':.'

" nerdtree configuration
""""""""""""""""""""""""""""""""""""""""
" Enable nerdtree with <ctrl> + t
map <Leader>t :NERDTreeToggle<CR>

" always display the status bar
set laststatus=2

" Turn on syntax highlighting if it exists
if has("syntax")
  syntax on
endif
set background=dark
colorscheme industry

" display and characters
set fillchars+=vert:\| 
highlight VertSplit cterm=none ctermfg=none ctermbg=none

" autocommands
augroup source_files 
    autocmd!
    autocmd BufNewFile,BufRead *.java,*.scala,*.php,*.rb,*.py,*.xml,*.yml,*.json set number 
augroup END

" maps
" control + l = toggle line numbers
nmap <Leader>n :set invnumber<CR>
nmap <Leader>q :qall<CR>
nmap <Leader><M-q> :qall!<CR>
nmap <Leader>w :wall<CR>
nmap <Leader>p :set paste
let pastestate=0
nnoremap <Leader>p :if (pastestate == 0) \| set paste \| else \| set paste! \| endif \| let pastestate=1-pastestate<CR>
