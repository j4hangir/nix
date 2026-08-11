vim.g.mapleader = "j"
vim.g.maplocalleader = "j"
vim.opt.timeoutlen = 300

local o = vim.opt

o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.smartindent = true
o.shiftround = false

o.ignorecase = true
o.smartcase = true

o.scrolloff = 3
o.encoding = "utf-8"
o.hidden = true
o.wrap = true
o.textwidth = 79
o.formatoptions = "cqrn1"

o.ruler = true
o.laststatus = 2
o.showmode = true
o.showcmd = true

o.hlsearch = true
o.incsearch = true

o.modelines = 0
o.number = false

-- nvim already keeps swap under stdpath("state"), but 'backupdir' still starts
-- with "." — an interrupted write leaves a backup beside the file. Drop it.
o.backupdir:remove(".")

o.visualbell = true
o.termguicolors = true
o.background = "dark"

o.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "cb",
  copy = { ["+"] = "cb", ["*"] = "cb" },
  paste = { ["+"] = "cbp", ["*"] = "cbp" },
  cache_enabled = 0,
}

o.backspace = "indent,eol,start"
o.matchpairs:append("<:>")
o.listchars = { tab = "▸ ", eol = "¬" }
o.whichwrap:append("<,>,h,l,[,]")

o.guicursor = "n-v-c:block-blinkon0,i-ci-ve:ver25-blinkon0,r-cr:hor20-blinkon0,o:hor50-blinkon0"
o.guifont = "JetBrains Mono:h16"
o.linespace = 2
