" Plugins Settings
"vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' } "NerdTree. On-demand loading
Plug 'catppuccin/nvim', { 'as': 'catppuccin' } " Theme catppuccin
Plug 'nvim-lualine/lualine.nvim' "lualine (for showing status line)
"vim-snipmate plugins
"snipmate depends on vim-addon-mw-utils & tlib_vim
"vim-snippets: vim-snipmate default snippets 
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'bruce30262/vim-snippets-custom' "My own custom vim-snippets
Plug 'Vimjas/vim-python-pep8-indent' "Python PEP8 indent
Plug 'roxma/vim-tmux-clipboard' "Tmux vim clipboard
call plug#end()
"override with custom snippets
let g:snipMate = { 'override' : 1 }
"Eliminate SnipMate-deprecate warning message
let g:snipMate = { 'snippet_version' : 1 }

" General Settings
"Disable nvim changing cursor shape in Insert mode
set guicursor=
"tab and indent related settings
set shiftwidth=4 tabstop=4 expandtab autoindent smartindent
filetype plugin indent on "Detect file type, load their plugins and indent settings
syntax on
"wild mode (auto complete the vim cmd)
set wildmenu wildmode=list:longest,full
"utf-8 encoding ( http://vim.wikia.com/wiki/Working_with_Unicode )
if has("multi_byte")
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,latin1
endif
"Misc
set nu hls cursorline noswapfile splitbelow splitright sidescroll=1

" Key mappings
":map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
":nmap  :nnoremap :nunmap    Normal
":vmap  :vnoremap :vunmap    Visual and Select
":smap  :snoremap :sunmap    Select
":xmap  :xnoremap :xunmap    Visual
":omap  :onoremap :ounmap    Operator-pending
":map!  :noremap! :unmap!    Insert and Command-line
":imap  :inoremap :iunmap    Insert
":lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
":cmap  :cnoremap :cunmap    Command-line
":tmap  :tnoremap :tunmap    Terminal-Job

" Function keys
map <F2> :set spell!<CR><Bar>:echo "Spell check: " . strpart("OffOn", 3 * &spell, 3)<CR>
imap <F2> <esc>:set spell!<CR><Bar>:echo "Spell check: " . strpart("OffOn", 3 * &spell, 3)<CR>
nnoremap <silent> <F5> :NERDTreeToggle<CR>
nmap <F6> :set number! number?<cr>
nmap <F7> gT
nmap <F8> gt
nmap <silent> <F10> <esc>:set list! listchars=tab:>\ ,trail:-,eol:$<CR>
imap <silent> <F10> <esc>:set list! listchars=tab:>\ ,trail:-,eol:$<CR>
nmap <F12> mtgg=G`th 
imap <F12> <ESC><F12>

" For copy/paste/cut from system clipboard
map ,y "+y
map ,yy "+yy
map ,p "+p
map ,P "+P
map ,d "+d
map ,dd "+dd
map ,D "+D

" Misc
nnoremap ,s :w<CR>
nnoremap ,, :so $MYVIMRC<CR>

" Color & Theme Settings
colorscheme catppuccin " catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

"spell check color setting
hi clear SpellBad
hi SpellBad term=underline cterm=underline ctermfg=red
"lualine settings
lua << END
require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = "powerline",
        globalstatus = false,
        refresh = {
            statusline = 500,
            tabline = 500,
            winbar = 500,
        }
    }
})
END

" Custom command Settings
"vim-plug shortcuts
command! PU PlugUpdate | PlugUpgrade
command! PI PlugInstall
command! PC PlugClean


