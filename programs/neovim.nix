{ pkgs, ... }:

{
    programs = {
        neovim = {
            enable = true;
            extraConfig = ''
" Basic config
set autoread        " Automatically reload modified buffer
set autowriteall    " Automatically write files when some commands occur
set backupcopy=yes  " Fix Hot Module Reloading for parcel js
set colorcolumn=80  " Colour column 80
set cursorcolumn    " Highlight the column currently under cursor
set cursorline      " Highlight the line currently under cursor
set expandtab       " Use spaces instead of tabs
set foldlevel=20    " Folds with a higher level will be closed
set foldmethod=indent
set nofoldenable    " All folds opened by default

set hidden          " Hide buffer when abandoned
set ignorecase      " Case insensitive search
set list            " Show trailing white characters
set noshowmode      " Hide legacy status bar at the bottom
set number
set relativenumber
set scrolloff=3     " The number of lines to keep above and below the cursor
set shiftwidth=2    " Indent by 4 spaces when auto-indenting
set smartcase       " Search case sensitive when using capital letters
set tabstop=2       " Show existing tab with 4 spaces width
set termguicolors   " 24-bit RGB color
set undofile        " Saves undo history to a file

let g:seoul256_background = 234 "233-239 Light: 252-256
colorscheme one

" Remove all trailing spaces on file write
autocmd BufWritePre * %s/\s\+$//e

let g:lightline = {
\ 'colorscheme': 'one',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
\ },
\ 'component_function': {
\   'gitbranch': 'fugitive#head'
\ }
\ }

let g:fzf_command_prefix = 'FZ'
let mapleader=" "
imap <A-Tab> <Esc><C-^>
nmap <A-Tab> <C-^>
nmap <Leader>e :Ex<CR>
nmap <Leader>o :noh<CR>
nmap <Leader>f :FZGFiles<CR>
nmap <Leader>F :FZFiles<CR>
nmap <Leader>b :FZBuffers<CR>
nmap <Leader>h :FZHistory<CR>
nmap <Leader>: :FZHistory:<CR>
nmap <Leader>l :FZBLines<CR>
nmap <Leader>L :FZLines<CR>
nmap <Leader>' :FZMarks<CR>
nmap <Leader>/ :FZRg<Space>
nmap <Leader>H :FZHelptags!<CR>
map <Esc><Esc> :up<CR>
map <A-w> "+y

" netrw
let g:netrw_altfile = 1
let g:netrw_banner = 0
let g:netrw_liststyle = 1

" nnn
let g:nnn#command = 'nnn -d'
let g:nnn#layout = { 'window': { 'width': 0.5, 'height': 0.7, 'highlight': 'Debug' } }

" ELM
" let g:elm_setup_keybindings = 0
'';
            plugins = with pkgs.vimPlugins; [
                lightline-vim
                rust-vim
                #skim
                #skim-vim
                typescript-vim
                vim-fugitive
                vim-nix

                # Colorschemes
                gruvbox
                seoul256-vim
                vim-one
            ];
        };
    };
}
