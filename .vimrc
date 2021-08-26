set bs=2
syntax on
color murphy
set tabstop=2
set expandtab
set shiftwidth=2
"set autoindent
set smartindent
"set cindent
set whichwrap+=<,>,h,l,[,]

" These two should come together
set ignorecase
set smartcase

" Reopen the last edited position in files
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
