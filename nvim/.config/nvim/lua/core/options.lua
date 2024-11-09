local opt = vim.opt
local g = vim.g

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.mapleader = ' '
g.maplocalleader = ' '
g.have_nerd_font = true
g.skip_ts_context_commentstring_module = true
g.markdown_fenced_languages = { 'ts=typescript' }
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-----------------------------------------------------------
-- General
-----------------------------------------------------------
-- stylua: ignore start
-- opt.completeopt   = { 'menu', 'menuone', 'noselect' } -- Sets the completion options
opt.scrolloff     = 14                                -- Show x lines above and below the cursor
opt.signcolumn    = 'yes'                             -- Show signs in the signcolumn
opt.ignorecase    = true                              -- Ignores case in search
opt.smartcase     = true                              -- Override the 'ignorecase' option if the search pattern contains upper case characters
opt.splitbelow    = true                              -- Split below instead of above
opt.splitright    = true                              -- Split right instead of left
opt.termguicolors = true                              -- Enable true color support
opt.undofile      = true                              -- Save undo history to file
opt.updatetime    = 250                               -- interval for writing swap file to disk, also used by gitsigns
opt.cmdheight     = 1                                 -- Height of the command bar
opt.formatoptions = 'j'                               -- Don't use vim for formatting
opt.laststatus    = 3                                 -- global statusline
opt.showmode      = false                             -- Don't display mode
opt.title         = true                              -- Show the title in the window titlebar
opt.wrap          = false                             -- Display long lines as just one line
opt.whichwrap:append('<>[]hl')                        -- go to previous/next line with h,l,left arrow and right arrow
opt.clipboard = 'unnamedplus'                         -- Use system clipboard
opt.cursorline = true                                 -- Enable highlighting of the current line
opt.hlsearch = true
opt.swapfile = false
opt.smoothscroll = true
--stylua: ignore end

-----------------------------------------------------------
-- Fold settings
-----------------------------------------------------------
-- stylua: ignore start
-- opt.foldexpr       = 'v:lua.vim.treesitter.foldexpr()' -- Treesitter folding
-- opt.foldmethod     = 'expr' -- Treesitter folding
-- opt.foldcolumn     = '1' -- Enable fold column
-- opt.foldlevel      = 99  -- This is just a default level, it will be changed by ufo 
-- opt.foldlevelstart = 99  -- This is just a default level, it will be changed by ufo
opt.foldenable     = false
--stylua: ignore end

-----------------------------------------------------------
-- Indent settings
-----------------------------------------------------------
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.autoindent = true
opt.tabstop = 2

opt.fillchars = {
  vert = ' ',
  vertright = ' ',
  vertleft = ' ',
  horizup = ' ',
  verthoriz = ' ',
  horizdown = '/',
  horiz = ' ',
  eob = ' ',
  fold = ' ',
  foldopen = '',
  foldclose = '',
  foldsep = ' ',
  stl = ' ',
}

-----------------------------------------------------------
-- Numbers
-----------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.ruler = false

-- FoOCItTsl
-- disable nvim intro
opt.shortmess:append('qWcCsIS')

vim.o.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon1,i:ver25-Cursor/lCursor-blinkon1,r-cr:hor20-Cursor/lCursor-blinkon1'
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Enables mouse support
vim.o.mouse = 'a'
-- Dont horizontal scroll with mouse
vim.o.mousescroll = 'ver:3,hor:0'

vim.o.timeout = true -- Faster wait time
vim.o.timeoutlen = 500 -- Timeout wait time
vim.o.ttimeoutlen = 10 -- Timeout wait time

vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH -- add binaries installed by mason.nvim to path

vim.cmd('set complete=') -- disable vim's built-in completion
