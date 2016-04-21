" https://github.com/sontek/dotfiles/
" ==========================================================
" Dependencies - Libraries/Applications outside of vim
" ==========================================================
" Pep8 - http://pypi.python.org/pypi/pep8
" Pyflakes
" Ack
" Rake & Ruby for command-t
" nose, django-nose

" ==========================================================
" Plugins included
" ==========================================================
" Pytest
"     Runs your Python tests in Vim.
"
" PyFlakes
"     Underlines and displays errors with Python on-the-fly
"
" Fugitive
"    Interface with git from vim
"
" Git
"    Syntax highlighting for git config files
"
" Minibufexpl
"    Visually display what buffers are currently opened
"
" Surround
"    Allows you to surround text with open/close tags
"
" Python-mode
"   Allows you to use the pylint, rope, pydoc, pyflakes, pep8, mccabe libraries in vim.
"   To provide features like python code looking for bugs, refactoring and some other useful things.
"
" Py.test
"    Run py.test test's from within vim
"
"
let g:python_host_prog = '/usr/local/bin/python'
" functions {{{
  function! StrTrim(txt)
    return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
  endfunction

  function! Preserve(command) "{{{
    " preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction "}}}

  function! StripTrailingWhitespace() "{{{
    call Preserve("%s/\\s\\+$//e")
  endfunction "}}}

  function! EnsureExists(path) "{{{
    if !isdirectory(expand(a:path))
      call mkdir(expand(a:path))
    endif
  endfunction "}}}

  function! CloseWindowOrKillBuffer() "{{{
    let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

    " never bdelete a nerd tree
    if matchstr(expand("%"), 'NERD') == 'NERD'
      wincmd c
      return
    endif

    if number_of_windows_to_this_buffer > 1
      wincmd c
    else
      bdelete
    endif
  endfunction "}}}
"}}}


" detect OS {{{
  let s:is_windows = has('win32') || has('win64')
  let s:is_cygwin = has('win32unix')
  let s:is_macvim = has('gui_macvim')
"}}}
"
filetype off
set nocompatible              " Don't be compatible with vi
let mapleader=","
let g:mapleader=","             " change the leader to be a comma vs slash

"Ever notice a slight lag after typing the leader key + command? This lowers
"the timeout.
set timeoutlen=1500

"initialize default settings
  let s:settings = {}
  let s:settings.default_indent = 2
  let s:settings.max_column = 120
  "let s:settings.autocomplete_method = 'neocomplcache'
  let s:settings.enable_cursorcolumn = 0
  "let s:settings.colorscheme = 'jellybeans'
  "if filereadable(expand("~/.vim/bundle/YouCompleteMe/python/ycm_core.*"))
  "  let s:settings.autocomplete_method = 'ycm'
  "endif

" setup & neobundle {{{

  set nocompatible
  set all& "reset everything to their defaults
  set runtimepath+=~/.vim,/Applications/MacVim.app/Contents/Resources/vim/
  if s:is_windows
    set runtimepath+=~/.vim
  endif
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'
"}}}

    NeoBundleLazy 'cakebaker/scss-syntax.vim', {'autoload':{'filetypes':['scss','sass']}} "{{{
        autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
        autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
    "}}}
    NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload':{'filetypes':['css','scss','sass']}}
    NeoBundleLazy 'ap/vim-css-color', {'autoload':{'filetypes':['css','scss','sass','less','styl']}}
    NeoBundle 'othree/html5.vim', {'autoload':{'filetypes':['html']}}
    NeoBundleLazy 'wavded/vim-stylus', {'autoload':{'filetypes':['styl']}}
    NeoBundle 'mattn/emmet-vim', {'autoload':{'filetypes':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache']}} "{{{
      function! s:zen_html_tab()
        let line = getline('.')
        if match(line, '<.*>') < 0
          return "\<c-y>,"
        endif
        return "\<c-y>n"
      endfunction
      autocmd FileType xml,xsl,xslt,xsd,css,sass,scss,less,mustache imap <buffer><tab> <c-y>,
      autocmd FileType html imap <buffer><expr><tab> <sid>zen_html_tab()
    "}}}

    NeoBundle 'marijnh/tern_for_vim', {
      \ 'autoload': { 'filetypes': ['javascript'] },
      \ 'build': {
        \ 'mac': 'npm install',
        \ 'unix': 'npm install',
        \ 'cygwin': 'npm install',
        \ 'windows': 'npm install',
      \ },
    \ } "{{{
      set omnifunc=syntaxcomplete#Complete
      let g:tern_map_keys=1
      let g:tern_show_argument_hints = 'on_hold'
    "}}}
    NeoBundle 'pangloss/vim-javascript', {'autoload':{'filetypes':['javascript']}}
    NeoBundle 'tpope/vim-jdaddy' "{{{}}}
    NeoBundle 'scrooloose/nerdtree', {'autoload':{'commands':['NERDTreeToggle','NERDTreeFind']}} "{{{
      let NERDTreeShowHidden=1
      let NERDTreeQuitOnOpen=0
      let NERDTreeShowLineNumbers=1
      let NERDTreeChDirMode=0
      let NERDTreeShowBookmarks=1
      let NERDTreeIgnore=['\.git','\.hg', 'CVS']
      let NERDTreeBookmarksFile='~/.vim/.cache/NERDTreeBookmarks'
      let NERDTreeHijackNetrw=1
      nnoremap <leader>n :NERDTreeToggle<CR>
      nnoremap <leader>f :NERDTreeFind<CR>
    "}}}
    
    NeoBundle 'tpope/vim-vinegar' "{{{
    "}}}
    "
    NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
    \     'windows' : 'tools\\update-dll-mingw',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make',
    \     'linux' : 'make',
    \     'unix' : 'gmake',
    \    },
    \ }

    NeoBundle 'Shougo/unite.vim', {'depends': ['Shougo/neomru.vim', 'Shougo/neoyank.vim']} "{{{
      let bundle = neobundle#get('unite.vim')
      function! bundle.hooks.on_source(bundle)
      endfunction
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        call unite#filters#sorter_default#use(['sorter_rank'])
        call unite#set_profile('files', 'context.smartcase', 1)
        call unite#custom#source('file_rec,file_rec/async,buffer,file,buffer,grep',
            \ 'ignore_pattern', join(['\.grunt/','node_modules/', '.git', '.idea', 'build'], '\|'))

      let g:unite_data_directory='~/.vim/.cache/unite'
      let g:unite_enable_start_insert=1
      let g:unite_source_history_yank_enable=1
      let g:unite_source_rec_max_cache_files=5000
      let g:unite_prompt='» '

      if executable('ag')
        let g:unite_source_grep_command='ag'
        let g:unite_source_grep_default_opts='--nocolor --nogroup -S -C4'
        let g:unite_source_grep_recursive_opt=''
      elseif executable('ack')
        let g:unite_source_grep_command='ack'
        let g:unite_source_grep_default_opts='--no-heading --no-color -a -C4'
        let g:unite_source_grep_recursive_opt=''
      endif

      function! s:unite_settings()
        let b:SuperTabDisabled=1
        imap <buffer> <C-j> <Plug>(unite_select_next_line)
        imap <buffer> <C-k> <Plug>(unite_select_previous_line)
        imap <silent><buffer><expr> <C-x> unite#do_action('split')
        imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
        imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

        nmap <buffer> Q <plug>(unite_exit)
        nmap <buffer> <esc> <plug>(unite_exit)
      endfunction
      autocmd FileType unite call s:unite_settings()

      nmap <space> [unite]
      nnoremap [unite] <nop>
      nnoremap <C-P> :<C-u>Unite -buffer-name=files -start-insert buffer file_rec/async!<cr><cr>
     " if s:is_windows
     "   nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec buffer file_mru bookmark<cr><c-u>
     "   nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec<cr><c-u>
     " else
        nnoremap <silent> [unite]p :<C-u>Unite -toggle -auto-resize -start-insert  -buffer-name=mixed file_rec/async buffer tab file_mru bookmark<cr><cr>
        nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async<cr><c-u>
     " endif
      nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
      nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
      nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
      nnoremap <silent> [unite]/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
      nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
      nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>
      nnoremap <silent> [unite]g :<C-u>Unite -no-split grep:.<cr>

      "For unite-menu
      let g:unite_source_menu_menus = {}

      let g:unite_source_menu_menus.git={
        \ 'description': 'manage git repositories'
        \ }
      let g:unite_source_menu_menus.ff ={
        \'description': 'change fileformat option.'
        \}
      let g:unite_source_menu_menus.ff.command_candidates={
        \'unix':'WUnix',
        \'dos':'Wdos',
        \'mac':'WMac'
      \}
      nnoremap <silent>;w :<C-u>Unite menu:ff<CR><CR>

      let g:unite_source_menu_menus.unite={
        \'description':'Start unite sources'
    \}
      let g:unite_source_menu_menus.unite.command_candidates={
        \'history':'Unite history/command',
        \'quickfix':'Unite qflist -no-quit',
        \'resume':'Unite -buffer-name=resume resume',
        \'directory':'Unite -buffer-name=files '.
        \       '-default-action=lcd directory_mru',
        \'mapping':'Unite mapping',
        \'message':'Unite output:message',
    \}
      nnoremap <silent>;u :<C-u>Unite menu:unite -resume<CR><CR>
      
    "}}}

    NeoBundle 'fholgado/minibufexpl.vim' "{{{
    "}}}
    NeoBundle 'pangloss/vim-javascript', {'autoload':{'filetypes':['javascript']}}
    NeoBundleLazy 'maksimr/vim-jsbeautify', {'autoload':{'filetypes':['javascript']}} "{{{
        nnoremap <leader>fjs :call JsBeautify()<cr>
        autocmd FileType js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    "}}}
    NeoBundle "slava/vim-spacebars"
    NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':['coffee']}}
    NeoBundle 'mmalecki/vim-node.js', {'autoload':{'filetypes':['javascript']}}
    NeoBundle 'leshill/vim-json', {'autoload':{'filetypes':['javascript','json']}}
    NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload':{'filetypes':['javascript','coffee','ls']}}
    NeoBundleLazy 'klen/python-mode', {'autoload':{'filetypes':['python']}} "{{{
      let g:pymode_rope=0
        autocmd FileType python setlocal foldmethod=indent
    "}}}
    NeoBundleLazy 'davidhalter/jedi-vim', {'autoload':{'filetypes':['python']}} "{{{
      let g:jedi#popup_on_dot=0
    "}}}

    NeoBundle 'alfredodeza/pytest.vim'

    if executable('hg')
      NeoBundle 'bitbucket:ludovicchabant/vim-lawrencium'
    endif

    NeoBundle 'tpope/vim-fugitive' "{{{
      nnoremap <silent> <leader>gs :Gstatus<CR>
      nnoremap <silent> <leader>gd :Gdiff<CR>
      nnoremap <silent> <leader>gc :Gcommit<CR>
      nnoremap <silent> <leader>gb :Gblame<CR>
      nnoremap <silent> <leader>gl :Glog<CR>
      nnoremap <silent> <leader>gp :Git push<CR>
      nnoremap <silent> <leader>gw :Gwrite<CR>
      nnoremap <silent> <leader>gr :Gremove<CR>
      autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
      autocmd BufReadPost fugitive://* set bufhidden=delete
    "}}}
    
    NeoBundle 'vim-scripts/vcscommand.vim' "{{{
        nnoremap <leader>sa :VCSAdd
        nnoremap <leader>sc :VCSCommit
    "}}}

    NeoBundleLazy 'gregsexton/gitv', {'depends':['tpope/vim-fugitive'], 'autoload':{'commands':'Gitv'}} "{{{
      nnoremap <silent> <leader>gv :Gitv<CR>
      nnoremap <silent> <leader>gV :Gitv!<CR>
    "}}}
    NeoBundle 'honza/vim-snippets' "{{{
    "}}}


    NeoBundle 'Valloric/YouCompleteMe', {'vim_version':'7.3.584'} "{{{
        let g:ycm_complete_in_comments=1
        let g:ycm_complete_in_strings=1
        let g:ycm_collect_identifiers_from_comments_and_strings=1
        let g:ycm_key_list_select_completion=['<C-n>']
        let g:ycm_key_list_previous_completion=['<C-p>']
        let g:ycm_filetype_blacklist={'unite': 1}
        let g:ycm_semantic_triggers =  {
          \   'c' : ['->', '.'],
          \   'objc' : ['->', '.'],
          \   'ocaml' : ['.', '#'],
          \   'cpp,objcpp' : ['->', '.', '::'],
          \   'perl' : ['->'],
          \   'php' : ['->', '::'],
          \   'cs,java,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
          \   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
          \   'ruby' : ['.', '::'],
          \   'lua' : ['.', ':'],
          \   'erlang' : [':'],
          \ }

    "}}}
    NeoBundle 'ervandew/supertab' "{{{
        let g:SuperTabDefaultCompletionType ='<C-n>'
    "}}}
    NeoBundle 'SirVer/ultisnips' "{{{
       "function! g:UltiSnips_Complete()
       "    call UltiSnips#ExpandSnippet()
       "    if g:ulti_expand_res == 0
       "        if pumvisible()
       "            return "\<C-n>"
       "        else
       "            call UltiSnips#JumpForwards()
       "            if g:ulti_jump_forwards_res == 0
       "                return "\<TAB>"
       "            endif
       "        endif
       "    endif
       "    return ""
       "endfunction
       "au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
        let g:UltiSnipsExpandTrigger="<Tab>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
        let g:UltiSnipsListSnippets="<C-e>"
        " This maps Enter key to <C-y> to chose the current highlight item
        " an close the selection list, same as other IDEs.
        " Conflict with some plugins like tpope/endwise
        " inoremap <expr> <CR> pumvisible() ? "\<C-y>" ; "\<C-g>u\<CR>"
        "let g:UltiSnipsSnippetDirectories=["ultisnipssnippets", "Ultisnips"]
        "let g:UltiSnipsSnippetsDir='~/.vim/ultisnipsnippets'
        function! UltiSnipsCallUnite()
            Unite -start-insert -winheight=100 -immediately -no-empty ultisnips
            return ''
        endfunction

        inoremap <silent> <F12> <C-R>=(pumvisible()? "\<LT>C-E>":"")<CR><C-R>=UltiSnipsCallUnite()<CR>
        nnoremap <silent> <F12> a<C-R>=(pumvisible()? "\<LT>C-E>":"")<CR><C-R>=UltiSnipsCallUnite()<CR>
    "}}}
    "NeoBundle 'mileszs/ack.vim' "{{{
    "  if executable('ag')
    "    let g:ackprg = "ag --nogroup --column --smart-case --follow"
    "  endif
    ""}}}
    NeoBundle 'wincent/ferret', { 'depends': 'tpope/vim-dispatch'} "{{{
    "}}}
    NeoBundle 'wincent/vim-clipper'
    NeoBundle 'vim-ctrlspace/vim-ctrlspace' "{{{
      if executable("ag")
        let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
      endif
    "}}}
    "
    NeoBundle 'vim-airline/vim-airline', { 'depends': ['vim-airline/vim-airline-themes', 'edkolev/tmuxline.vim']} "{{{
      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tmuxline#enabled = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline_theme = 'powerlineish'
      let g:airline#extensions#syntastic#enabled = 1
      let g:airline#extensions#branch#enabled = 1
      let g:airline#extensions#tagbar#enabled = 1
    "}}}

    NeoBundle 'mbbill/undotree', {'autoload':{'commands':'UndotreeToggle'}} "{{{
      let g:undotree_WindowLayout ='botright'
      let g:undotree_SetFocusWhenToggle=1
      nnoremap <silent> <F5> :UndotreeToggle<CR>
    "}}}
    NeoBundle 'kien/ctrlp.vim', { 'depends': 'tacahiroy/ctrlp-funky' } "{{{
      let g:ctrlp_clear_cache_on_exit=1
      let g:ctrlp_max_height=40
      let g:ctrlp_show_hidden=0
      let g:ctrlp_follow_symlinks=1
      let g:ctrlp_working_path_mode=0
      let g:ctrlp_max_files=20000
      let g:ctrlp_cache_dir='~/.vim/.cache/ctrlp'
      let g:ctrlp_reuse_window='startify'
      let g:ctrlp_map = '\p'
      let g:ctrlp_cmd = 'CtrlP'
      let g:ctrlp_extensions=['funky']
      if executable('ag')
        let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
      endif

      nmap \ [ctrlp]
      nnoremap [ctrlp] <nop>

      nnoremap [ctrlp]t :CtrlPBufTag<cr>
      nnoremap [ctrlp]T :CtrlPTag<cr>
      nnoremap [ctrlp]l :CtrlPLine<cr>
      nnoremap [ctrlp]o :CtrlPFunky<cr>
      nnoremap [ctrlp]b :CtrlPBuffer<cr>

    let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/](\.(git|hg|svn)$|(install|CPAN)$)',
        \ 'file': '\v\.(exe|so|dll)$',
        \ }


    " allows opening a split from ctrlp with <c-i>, since using 'i' from NERDTree
    " is how to open a horizontal split there. Keep em the same.
    let g:ctrlp_prompt_mappings = {
        \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>', '<c-i>']
        \ }

    "}}}
    NeoBundle 'scrooloose/nerdtree', {'autoload':{'commands':['NERDTreeToggle','NERDTreeFind']}} "{{{
      let NERDTreeShowHidden=1
      let NERDTreeQuitOnOpen=0
      let NERDTreeShowLineNumbers=1
      let NERDTreeChDirMode=0
      let NERDTreeShowBookmarks=1
      let NERDTreeIgnore=['\.git','\.hg', 'CVS']
      let NERDTreeBookmarksFile='~/.vim/.cache/NERDTreeBookmarks'
      let NERDTreeHijackNetrw=1
      nnoremap <leader>n :NERDTreeToggle<CR>
      nnoremap <leader>f :NERDTreeFind<CR>
    "}}}
    
    NeoBundle 'tpope/vim-vinegar' "{{{
    "}}}

    NeoBundleLazy 'ujihisa/unite-colorscheme', {'autoload':{'unite_sources':'colorscheme'}} "{{{
      nnoremap <silent> [unite]c :<C-u>Unite -winheight=10 -auto-preview -buffer-name=colorschemes colorscheme<cr>
    "}}}
    NeoBundleLazy 'tsukkee/unite-tag', {'autoload':{'unite_sources':['tag','tag/file']}} "{{{
      nnoremap <silent> [unite]t :<C-u>Unite -auto-resize -buffer-name=tag tag tag/file<cr>
    "}}}
    NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}} "{{{
      nnoremap <silent> [unite]o :<C-u>Unite -auto-resize -buffer-name=outline outline<cr>
    "}}}
    NeoBundleLazy 'Shougo/unite-help', {'autoload':{'unite_sources':'help'}} "{{{
      nnoremap <silent> [unite]h :<C-u>Unite -auto-resize -buffer-name=help help<cr>
    "}}}
    NeoBundleLazy 'Shougo/junkfile.vim', {'autoload':{'commands':'JunkfileOpen','unite_sources':['junkfile','junkfile/new']}} "{{{
      let g:junkfile#directory=expand("~/.vim/.cache/junk")
      nnoremap <silent> [unite]j :<C-u>Unite -auto-resize -buffer-name=junk junkfile junkfile/new<cr>
    "}}}
    if exists('$TMUX')
      NeoBundle 'christoomey/vim-tmux-navigator'
      NeoBundle 'wincent/terminus'
    endif
    NeoBundleLazy 'guns/xterm-color-table.vim', {'autoload':{'commands':'XtermColorTable'}}
    NeoBundle 'bufkill.vim'
    NeoBundle 'scrooloose/syntastic' "{{{
      let g:syntastic_error_symbol = '✗'
      let g:syntastic_style_error_symbol = '✠'
      let g:syntastic_warning_symbol = '∆'
      let g:syntastic_style_warning_symbol = '≈'
      let g:syntastic_always_populate_loc_list = 1
      let g:syntastic_loc_list_height = 5
      let g:syntastic_auto_loc_list = 0
      let g:syntastic_check_on_open = 1
      let g:syntastic_check_on_wq = 1
      let g:syntastic_enable_signs = 1
      let b:syntastic_javascript_eslint_exec= StrTrim(system('npm-which eslint'))
      let g:syntastic_javascript_checkers = ['eslint']
      "let g:syntastic_mode_map = {'mode': 'active',
      "      \ 'active_filetypes': ['javascript']}
    "}}}
    NeoBundleLazy 'Shougo/vimshell.vim', {'autoload':{'commands':[ 'VimShell', 'VimShellInteractive' ]}} "{{{
      if s:is_macvim
        let g:vimshell_editor_command='mvim'
      else
        let g:vimshell_editor_command='vim'
      endif
      let g:vimshell_right_prompt='getcwd()'
      let g:vimshell_temporary_directory='~/.vim/.cache/vimshell'
      let g:vimshell_vimshrc_path='~/.vim/vimshrc'

      nnoremap <leader>v :VimShell -split<cr>
      nnoremap <leader>vc :VimShell -split<cr>
      nnoremap <leader>vn :VimShellInteractive node<cr>
      nnoremap <leader>vl :VimShellInteractive lua<cr>
      nnoremap <leader>vr :VimShellInteractive irb<cr>
      nnoremap <leader>vp :VimShellInteractive python<cr>
    "}}}

    NeoBundle 'fholgado/minibufexpl.vim' "{{{
    "}}}

    "NeoBundle 'Lokaltog/powerline' "{{{
    "    set runtimepath+=~/.vim/bundle/powerline/powerline/bindings/vim
    "    set encoding=utf-8
    ""}}}
    NeoBundle 'MarcWeber/vim-addon-mw-utils'
    NeoBundle 'altercation/vim-colors-solarized' "{{{
        set gfn=Inconsolata\ 12
        set shell=/bin/bash
        let g:solarized_termtrans=1
        let g:solarized_degrade=0
        let g:solarized_bold=0
        let g:solarized_underline=0
        let g:solarized_italic=0
        let g:solarized_visibility="normal"
        let solarized_temcolors=256
        colorscheme solarized
    "}}}
    NeoBundle 'joonty/vdebug'
    NeoBundle 'mattboehm/vim-unstack' "{{{
      let g:unstack_mapkey='<leader>us'
    "}}}
    NeoBundle 'nathanaelkane/vim-indent-guides'
    NeoBundle 'terryma/vim-multiple-cursors' "{{{
        " Default mapping
        let g:multi_cursor_use_default_mapping=0
        " Multiple cursor
        let g:multi_cursor_next_key='<C-i>'
        let g:multi_cursor_prev_key='<C-h>'
        let g:multi_cursor_skip_key='<C-x>'
        let g:multi_cursor_quit_key='<Esc>'
    "}}}
    NeoBundle 'tomtom/tcomment_vim'
    NeoBundle 'tomtom/tlib_vim'
    NeoBundle 'tpope/vim-surround'
    NeoBundle 't9md/vim-surround_custom_mapping' "{{{
        let g:surround_custom_mapping = {}
        let g:surround_custom_mapping._={
                    \'p':"<pre> \r <pre>",
                    \'w': "%w(\r)",
                    \}
        let g:surround_custom_mapping.help={
                    \'p': "> \r <",
                    \}
        let g:surround_custom_mapping.javascript={
                    \'f': "function() { \r }"
                    \}
        let g:surround_custom_mapping.vim={
                    \'f': "function! \r endfunction"
                    \}
    "}}}

    NeoBundleDepends 'kana/vim-textobj-user'
    NeoBundle 'kana/vim-textobj-indent'
    NeoBundle 'kana/vim-textobj-entire'
    NeoBundle 'lucapette/vim-textobj-underscore'

    NeoBundleLazy 'tpope/vim-fireplace', { 'depends' : ['tpope/vim-salve'] } "{{{}}}

    nnoremap <leader>nbu :Unite neobundle/update -vertical -no-start-insert<cr>

" set backupdir=$VIMRUNTIME/swap/
" set directory=$VIMRUNTIME/swap/
" silent execute '!rm "'.$VIMRUNTIME.'/temp/*~"'

let g:Powerline_symbols="fancy"
set history=700
syntax on                     " syntax highlighing
filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading plugin file for filetype
filetype indent on     " enable loading indent file for filetype
set number                    " Display line numbers
set numberwidth=1             " using only 1 column (and 1 space) while possible
set background=dark          " We are using dark background in vim
set title                     " show title in console title bar
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.
set hid "Change buffer -without saving"

" ==========================================================
" Shortcuts
" ==========================================================

" don't bell or blink
set noerrorbells
set novisualbell
set vb t_vb=
set tm=500
set hidden

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

"""" Messages, Info, Status
set ls=2                    " allways show status line
set vb t_vb=                " Disable all bells.  I hate ringing/flashing.
set confirm                 " Y-N-C prompt if closing with unsaved changes.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler                   " Show some info, even without statuslines.
set laststatus=2            " Always show statusline, even if only 1 window.
"set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
    "              | | | | |  |   |      |  |     |    |
    "              | | | | |  |   |      |  |     |    + current
    "              | | | | |  |   |      |  |     |       column
    "              | | | | |  |   |      |  |     +-- current line
    "              | | | | |  |   |      |  +-- current % into file
    "              | | | | |  |   |      +-- current syntax in
    "              | | | | |  |   |          square brackets
    "              | | | | |  |   +-- current fileformat
    "              | | | | |  +-- number of lines
    "              | | | | +-- preview flag in square brackets
    "              | | | +-- help flag in square brackets
    "              | | +-- readonly flag in square brackets
    "              | +-- modified flag in square brackets
    "              +-- full path to file in the buffer

" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc
set grepprg=ack-grep          " replace the default grep program with ack

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Disable the colorcolumn when switching modes.  Make sure this is the
" first autocmd for the filetype here
autocmd FileType * setlocal colorcolumn=0

""" Moving Around/Editing
set cursorline              " have a line indicate the cursor location
set ruler                   " show the cursor position all the time
set nostartofline           " Avoid moving cursor to BOL when jumping around
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=3             " Keep 3 context lines above and below the cursor
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set showmatch               " Briefly jump to a paren once it's balanced
set wrap                    " wrap text
set linebreak               " don't wrap textin the middle of a word
set autoindent              " always set autoindenting on
set smartindent             " use smart indent if there is no indent file
set tabstop=2               " <tab> inserts 4 spaces 
set shiftwidth=2            " but an indent level is 2 spaces wide.
set softtabstop=2           " <BS> over an autoindent deletes both spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set shiftround              " rounds indent to a multiple of shiftwidth
set matchpairs+=<:>         " show matching <> (html mainly) as well
set foldmethod=indent       " allow us to fold on indents
set foldlevel=99            " don't fold by default
set foldcolumn=1            " show the fold column

" don't outdent hashes
inoremap # #

"""" Reading/Writing
set noautowrite             " Never write a file unless I request it.
set noautowriteall          " NEVER.
set noautoread              " Don't automatically re-read changed files.
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.
set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.
" displays tabs with :set list & displays when a line runs off-screen
set listchars=tab:>-,trail:-,precedes:<,extends:>
set list

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set smarttab                " Handle tabs more intelligently 
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

command! C let @/=""

" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w

" Toggle the tasklist
map <leader>td <Plug>TaskList
" ,v brings up my .vimrc
" ,V reloads it -- making all changes active (have to save first)

" open/close the quickfix window
nmap <leader>co :copen<CR>
nmap <leader>ccl :cclose<CR>

" for when we forget to use sudo to open/edit a file
cmap w!! w !sudo tee % >/dev/null

" ctrl-jklm  changes to that split
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

noremap <A-j> :m+<CR>
noremap <A-k> :m-2<CR>
inoremap <A-j> <Esc>:m+<CR>
inoremap <A-k> <Esc>:m-2<CR>
vnoremap <A-j> :m'>+<CR>gv
vnoremap <A-k> :m-2<CR>gv
imap { {}<left>
imap [ []<left>
imap ( ()<left>
vnoremap > ><CR>gv
vnoremap < <<CR>gv
" and lets make these all work in insert mode too ( <C-O> makes next cmd
"  happen as if in command mode )
imap <C-W> <C-O><C-W>

" Ack searching
"nmap <leader>ag <Esc>:Ag
"  if executable('ack')
"    set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
"    set grepformat=%f:%l:%c:%m
"  endif
"  if executable('ag')
"    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
"    set grepformat=%f:%l:%c:%m
"  endif

"""" Display
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl
if &term =~ '256color'
    " Disable background color Erase (BCE) so that color schemes 
    " work properly when Vim is used inside tmux and GNU screen
    "See also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif


" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Quit window on <leader>q
nnoremap <leader>q :q<CR>
"
" hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>

" Remove trailing whitespace on <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Select the item in the list with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>


function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It's super useful!
    map <leader>cc :botright cope<cr>
    map <leader>cp :cn<cr>
    map <leader>p :cp<cr>
" ===========================================================
set secure
NeoBundleCheck
