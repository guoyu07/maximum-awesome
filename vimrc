" don't bother with vi compatibility
set nocompatible

" enable syntax highlighting
syntax enable

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
	source ~/.vimrc.bundles.local
endif

" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set ignorecase                                               " case-insensitive search
set hlsearch                                                 " Highlight search terms
set incsearch                                                " search as you type
set cursorline                                               " Highlight current line
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.               " Highlight problematic whitespace
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=4                                             " normal mode indentation commands use 2 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=4                                            " insert mode tab and backspace use 2 spaces
set tabstop=4                                                " actual tabs occupy 8 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc,*.class,*.so,*.zip
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full

" set CursorLine backgroud color
hi CursorLine ctermbg=237 cterm=none guibg=#3A3A3A gui=none

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
	set ttymouse=xterm2
endif

" keyboard shortcuts
let mapleader = ','
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nmap <leader>c <Plug>Kwbd
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" bind K to grep word under cursor
" nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" plugin settings
let g:EasyGrepFilesToExclude=".svn,.git"
let g:EasyGrepRecursive=1
let g:EasyGrepCommand=1

let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
	let g:ackprg = 'ag --nogroup --column'

	" Use Ag over Grep
	set grepprg=ag\ --nogroup\ --nocolor

	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
endif

" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
" extra rails.vim help
autocmd User Rails silent! Rnavcommand decorator      app/decorators            -glob=**/* -suffix=_decorator.rb
autocmd User Rails silent! Rnavcommand observer       app/observers             -glob=**/* -suffix=_observer.rb
autocmd User Rails silent! Rnavcommand feature        features                  -glob=**/* -suffix=.feature
autocmd User Rails silent! Rnavcommand job            app/jobs                  -glob=**/* -suffix=_job.rb
autocmd User Rails silent! Rnavcommand mediator       app/mediators             -glob=**/* -suffix=_mediator.rb
autocmd User Rails silent! Rnavcommand stepdefinition features/step_definitions -glob=**/* -suffix=_steps.rb
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" General {

	set backup                    " backups are nice ...
	set history=1000              " store a ton of history (default is 20)
	set undofile                  " so is persistent undo ...
	set undolevels=1000           " maximum number of changes that can be undone
	set undoreload=10000          " maximum number lines to save for undo on a buffer reload
	scriptencoding utf-8

	" Add exclusions to mkview and loadview
	" eg: *.*, svn-commit.tmp
	let g:skipview_files = [
			\ '\[example pattern\]'
			\ ]

	autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
	" Instead of reverting the cursor to the last position in the buffer, we
	" set it to the first line when editing a git commit message
	au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

	" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
	" Restore cursor to file position in previous editing session
	" To disable this, add the following to your .vimrc.before.local file:
	"   let g:spf13_no_restore_cursor = 1
	function! ResCur()
		if line("'\"") <= line("$")
			normal! g`"
			return 1
		endif
	endfunction

	augroup resCur
		autocmd!
		autocmd BufWinEnter * call ResCur()
	augroup END
" }

" Fix Cursor in TMUX
if exists('$TMUX')
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Allow using the repeat operator with a visual selection (!)
" PIV {//stackoverflow.com/a/8064607/127816
	let g:DisableAutoPHPFolding = 0
	let g:PIVAutoClose = 0
" } fix home and end keybindings for screen, particularly on mac
" - for some reason this fixes the arrow keys too. huh.
" Misc {
	let g:NERDShutUp=1
	let b:match_ignorecase = 1
" }

" Key (re)Mappings {
	" Yank from the cursor to the end of the line, to be consistent with C and D.
	nnoremap Y y$
	" Find merge conflict markers
	map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

	" Shortcuts
	" Change Working Directory to that of the current file
	cmap cwd lcd %:p:h
	cmap cd. lcd %:p:h

	" Visual shifting (does not exit Visual mode)
	vnoremap < <gv
	vnoremap > >gv

	" Allow using the repeat operator with a visual selection (!)
	" http://stackoverflow.com/a/8064607/127816
	vnoremap . :normal .<CR>

	" Fix home and end keybindings for screen, particularly on mac
	" - for some reason this fixes the arrow keys too. huh.
	map [F $
	imap [F $
	map [H g0
	imap [H g0

	" For when you forget to sudo.. Really Write the file.
	cmap w!! w !sudo tee % >/dev/null

	" Some helpers to edit mode
	" http://vimcasts.org/e/14
	cnoremap %% <C-R>=expand('%:h').'/'<cr>
	map <leader>ew :e %%
	map <leader>es :sp %%
	map <leader>ev :vsp %%
	map <leader>et :tabe %%

	" Adjust viewports to the same size
	map <Leader>= <C-w>=

	" Map <Leader>ff to display all lines with keyword under cursor
	" and ask which one to jump to
	nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

	" Easier horizontal scrolling
	map zl zL
	map zh zH
"}

" OmniComplete {
	if has("autocmd") && exists("+omnifunc")
		autocmd Filetype *
			\if &omnifunc == "" |
			\setlocal omnifunc=syntaxcomplete#Complete |
			\endif
	endif

	hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
	hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
	hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

	" Some convenient mappings
	inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
	inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
	inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
	inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
	inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
	inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

	" Automatically open and close the popup menu / preview window
	au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
	set completeopt=menu,preview,longest
" }

" Ctags {
	set tags=./tags;/,~/.vimtags

	" Make tags placed in .git/tags file available in all levels of a repository
	let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
	if gitroot != ''
		let &tags = &tags . ',' . gitroot . '/.git/tags'
	endif
" }

" AutoCloseTag {
	" Make it so AutoCloseTag works for xml and xhtml files as well
	au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
	nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }

" UndoTree {
	nnoremap <Leader>u :UndotreeToggle<CR>
	" If undotree is opened, it is likely one wants to interact with it.
	let g:undotree_SetFocusWhenToggle=1
" }

" Tabularize {
	nmap <Leader>a& :Tabularize /&<CR>
	vmap <Leader>a& :Tabularize /&<CR>
	nmap <Leader>a= :Tabularize /=<CR>
	vmap <Leader>a= :Tabularize /=<CR>
	nmap <Leader>a: :Tabularize /:<CR>
	vmap <Leader>a: :Tabularize /:<CR>
	nmap <Leader>a:: :Tabularize /:\zs<CR>
	vmap <Leader>a:: :Tabularize /:\zs<CR>
	nmap <Leader>a, :Tabularize /,<CR>
	vmap <Leader>a, :Tabularize /,<CR>
	nmap <Leader>a,, :Tabularize /,\zs<CR>
	vmap <Leader>a,, :Tabularize /,\zs<CR>
	nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
	vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
" }

" ctrlp {
	let g:ctrlp_working_path_mode = 'ra'
	nnoremap <silent> <D-t> :CtrlP<CR>
	nnoremap <silent> <D-r> :CtrlPMRU<CR>
	let g:ctrlp_custom_ignore = {
		\ 'dir':  '\.git$\|\.hg$\|\.svn$',
		\ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

"}

" TagBar {
	nnoremap <silent> <leader>tt :TagbarToggle<CR>

	" If using go please install the gotags program using the following
	" go install github.com/jstemmer/gotags
	" And make sure gotags is in your path
	let g:tagbar_type_go = {
		\ 'ctagstype' : 'go',
		\ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
			\ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
			\ 'r:constructor', 'f:functions' ],
		\ 'sro' : '.',
		\ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
		\ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
		\ 'ctagsbin'  : 'gotags',
		\ 'ctagsargs' : '-sort -silent'
		\ }
"}

" Fugitive {
	nnoremap <silent> <leader>gs :Gstatus<CR>
	nnoremap <silent> <leader>gd :Gdiff<CR>
	nnoremap <silent> <leader>gc :Gcommit<CR>
	nnoremap <silent> <leader>gb :Gblame<CR>
	nnoremap <silent> <leader>gl :Glog<CR>
	nnoremap <silent> <leader>gp :Git push<CR>
	nnoremap <silent> <leader>gr :Gread<CR>
	nnoremap <silent> <leader>gw :Gwrite<CR>
	nnoremap <silent> <leader>ge :Gedit<CR>
	nnoremap <silent> <leader>gg :SignifyToggle<CR>
"}

" neocomplcache {
	let g:acp_enableAtStartup = 0
	let g:neocomplcache_enable_at_startup = 1
	let g:neocomplcache_enable_camel_case_completion = 1
	let g:neocomplcache_enable_smart_case = 1
	let g:neocomplcache_enable_underbar_completion = 1
	let g:neocomplcache_enable_auto_delimiter = 1
	let g:neocomplcache_max_list = 15
	let g:neocomplcache_force_overwrite_completefunc = 1
	let g:neocomplcache_disable_auto_complete = 1

	" SuperTab like snippets behavior.
	imap <silent><expr><TAB> neosnippet#expandable() ?
				\ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
				\ "\<C-e>" : "\<TAB>")
	smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

	" Define dictionary.
	let g:neocomplcache_dictionary_filetype_lists = {
				\ 'default' : '',
				\ 'vimshell' : $HOME.'/.vimshell_hist',
				\ 'scheme' : $HOME.'/.gosh_completions'
				\ }

	" Define keyword.
	if !exists('g:neocomplcache_keyword_patterns')
		let g:neocomplcache_keyword_patterns = {}
	endif
	let g:neocomplcache_keyword_patterns._ = '\h\w*'

	" Plugin key-mappings {
	inoremap <expr><C-g> neocomplcache#undo_completion()
	inoremap <expr><C-l> neocomplcache#complete_common_string()
	inoremap <expr><CR> neocomplcache#complete_common_string()

	" <TAB>: completion.
	inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

	" <CR>: close popup
	" <s-CR>: close popup and save indent.
	inoremap <expr><s-CR> pumvisible() ? neocomplcache#close_popup()"\<CR>" : "\<CR>"
	" inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

	" <C-h>, <BS>: close popup and delete backword char.
	inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
	inoremap <expr><C-y> neocomplcache#close_popup()
	" }

	" Enable omni completion.
	autocmd FileType php set omnifunc=phpcomplete#CompletePHP
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
	autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
	autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

	" Haskell post write lint and check with ghcmod
	" $ `cabal install ghcmod` if missing and ensure
	" ~/.cabal/bin is in your $PATH.
	if !executable("ghcmod")
		autocmd BufWritePost *.hs GhcModCheckAndLintAsync
	endif

	" Enable heavy omni completion.
	if !exists('g:neocomplcache_omni_patterns')
		let g:neocomplcache_omni_patterns = {}
	endif
	let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
	let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
	let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
	let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
	let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

	" Use honza's snippets.
	let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

	" Enable neosnippet snipmate compatibility mode
	let g:neosnippet#enable_snipmate_compatibility = 1

	" For snippet_complete marker.
	if has('conceal')
		set conceallevel=2 concealcursor=i
	endif

	" Disable the neosnippet preview candidate window
	" When enabled, there can be too much visual noise
	" especially when splits are used.
	set completeopt-=preview
" }

" NerdTree {
	map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
	map <leader>e :NERDTreeFind<CR>
	nmap <leader>nt :NERDTreeFind<CR>

	let NERDTreeShowBookmarks=1
	let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
	let NERDTreeChDirMode=0
	let NERDTreeQuitOnOpen=1
	let NERDTreeMouseMode=2
	let NERDTreeShowHidden=1
	let NERDTreeKeepTreeInNewTab=1
	let g:nerdtree_tabs_open_on_gui_startup=0
" }

" Functions {

	" UnBundle {
	function! UnBundle(arg, ...)
	  let bundle = vundle#config#init_bundle(a:arg, a:000)
	  call filter(g:bundles, 'v:val["name_spec"] != "' . a:arg . '"')
	endfunction

	com! -nargs=+         UnBundle
	\ call UnBundle(<args>)
	" }

	" Initialize directories {
	function! InitializeDirectories()
		let parent = $HOME
		let prefix = 'vim'
		let dir_list = {
					\ 'backup': 'backupdir',
					\ 'views': 'viewdir',
					\ 'swap': 'directory' }

		if has('persistent_undo')
			let dir_list['undo'] = 'undodir'
		endif

		let common_dir = parent . '/.' . prefix
		for [dirname, settingname] in items(dir_list)
			let directory = common_dir . dirname . '/'
			if exists("*mkdir")
				if !isdirectory(directory)
					call mkdir(directory)
				endif
			endif
			if !isdirectory(directory)
				echo "Warning: Unable to create backup directory: " . directory
				echo "Try: mkdir -p " . directory
			else
				let directory = substitute(directory, " ", "\\\\ ", "g")
				exec "set " . settingname . "=" . directory
			endif
		endfor
	endfunction
	call InitializeDirectories()
	" }

	" Initialize NERDTree as needed {
	function! NERDTreeInitAsNeeded()
		redir => bufoutput
		buffers!
		redir END
		let idx = stridx(bufoutput, "NERD_tree")
		if idx > -1
			NERDTreeMirror
			NERDTreeFind
			wincmd l
		endif
	endfunction
	" }

	" Strip whitespace {
	function! StripTrailingWhitespace()
		" Preparation: save last search, and cursor position.
		let _s=@/
		let l = line(".")
		let c = col(".")
		" do the business:
		%s/\s\+$//e
		" clean up: restore previous search history, and cursor position
		let @/=_s
		call cursor(l, c)
	endfunction
	" }
" }

"let g:syntastic_python_checker="flake8, pyflakes, pep8, pylint"
let g:syntastic_python_checkers=['pyflakes']

let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
" let g:syntastic_quiet_messages = { "type": "style" }

" Go crazy!
if filereadable(expand("~/.vimrc.local"))
	" In your .vimrc.local, you might like:
	"
	" set autowrite
	" set nocursorline
	" set nowritebackup
	" set whichwrap+=<,>,h,l,[,] " Wrap arrow keys between lines
	"
	" autocmd! bufwritepost .vimrc source ~/.vimrc
	" noremap! jj <ESC>
	source ~/.vimrc.local
endif

set imactivatekey=C-space
inoremap <ESC> <ESC>:set iminsert=0<CR>

