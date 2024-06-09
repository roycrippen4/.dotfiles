local opt = vim.opt
local g = vim.g

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
opt.completeopt   = { 'menu', 'menuone', 'noselect' } -- Sets the completion options
opt.mouse         = 'a'                               -- Enables mouse support
opt.scrolloff     = 14                                -- Show x lines above and below the cursor
opt.signcolumn    = 'yes'                             -- Show signs in the signcolumn
opt.ignorecase    = true                              -- Ignores case in search
opt.smartcase     = true                              -- Override the 'ignorecase' option if the search pattern contains upper case characters
opt.splitbelow    = true                              -- Split below instead of above
opt.splitright    = true                              -- Split right instead of left
opt.termguicolors = true                              -- Enable true color support
opt.timeout       = true                              -- Faster wait time
opt.timeoutlen    = 300                               -- Timeout wait time
opt.undofile      = true                              -- Save undo history to file
opt.updatetime    = 250                               -- interval for writing swap file to disk, also used by gitsigns
opt.cmdheight     = 1                                 -- Height of the command bar
opt.formatoptions = ''                                -- Don't use vim for formatting
opt.laststatus    = 3                                 -- global statusline
opt.showmode      = false                             -- Don't display mode
opt.title         = true                              -- Show the title in the window titlebar
opt.wrap          = false                             -- Display long lines as just one line
opt.whichwrap:append('<>[]hl')                        -- go to previous/next line with h,l,left arrow and right arrow
opt.clipboard = 'unnamedplus'                         -- Use system clipboard
opt.cursorline = true                                 -- Enable highlighting of the current line
opt.hlsearch = true
opt.swapfile = false

-----------------------------------------------------------
-- Fold settings
-----------------------------------------------------------
opt.foldexpr       = 'nvim_treesitter#foldexpr()' -- Treesitter folding
opt.foldcolumn     = '1' -- Enable fold column
opt.foldlevel      = 99  -- This is just a default level, it will be changed by ufo 
opt.foldlevelstart = 99  -- This is just a default level, it will be changed by ufo
opt.foldenable     = true
-- opt.foldnestmax    = 0   -- Deepest fold is 20 levels

-----------------------------------------------------------
-- Indent settings
-----------------------------------------------------------
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = false
opt.autoindent = false
opt.tabstop = 2
opt.softtabstop = 2

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
opt.shortmess:append('qWcsI')

vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH -- add binaries installed by mason.nvim to path
