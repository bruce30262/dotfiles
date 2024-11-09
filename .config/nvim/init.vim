" Plugins Settings
"vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' } "NerdTree. On-demand loading
Plug 'arcticicestudio/nord-vim' "Nord Theme
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
" Copy to system clipboard
set clipboard+=unnamedplus
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
  set termencoding=utf-8
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
map <F2> :set spell!<CR><Bar>:echo "Spell check: " . strpart("OffOn", 3 * &spell, 3)<CR>
imap <F2> <esc>:set spell!<CR><Bar>:echo "Spell check: " . strpart("OffOn", 3 * &spell, 3)<CR>
nnoremap <silent> <F5> :NERDTreeToggle<CR>
nmap <F6> :set number! number?<cr>
nmap <F7> gT
nmap <F8> gt
nnoremap <F9> :call TogglePaste()<CR>i
nmap <silent> <F10> <esc>:set list! listchars=tab:>\ ,trail:-,eol:$<CR>
imap <silent> <F10> <esc>:set list! listchars=tab:>\ ,trail:-,eol:$<CR>
nnoremap <F12> gg=G
inoremap <F12> <C-O>gg<C-O>=G
" pastetoggle ( work in normal mode )
function! TogglePaste()
    if(&paste == 0)
        set paste
        echo "(paste)"
    else
        set nopaste
        echo "(no paste)"
    endif
endfunction


" Color & Theme Settings
colorscheme nord
highlight Comment ctermfg=darkgray
if (has("termguicolors"))
    set notermguicolors
endif

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
"pwning script for CTF
command PPP execute ":0r ~/CTF-master/script/exp_template.py"
"force write with sudo tee trick
command ForceWrite execute ":w !sudo tee %"
"Use :ww instead of ForceWrite
cnoreabbrev ww ForceWrite
":W == :w cause computer is too dumb to know I'm typing :w instead of :W
command W execute ":w"
command Wq execute ":wq"
command Q execute ":q"
"vim-plug shortcuts
command! PU PlugUpdate | PlugUpgrade
command! PI PlugInstall

