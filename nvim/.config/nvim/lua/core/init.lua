local opt = vim.opt
local g = vim.g
require('core.autocommands')
require('core.diagnostic')
require('plugins.local_plugs')

-------------------------------------- globals -----------------------------------------
g.autosave = false
g.base46_cache = vim.fn.stdpath('data') .. '/nvchad/base46/'
g.toggle_theme_icon = '   '
g.NvimTreeOverlayTitle = ''
g.skip_ts_context_commentstring_module = true
g.markdown_fenced_languages = {
  'ts=typescript',
}

vim.treesitter.language.register('markdown', 'mdx')

-- Fold
opt.foldenable = true
opt.foldcolumn = 'auto'
opt.foldnestmax = 0
opt.foldlevel = 99
opt.foldlevelstart = 99

-- General Options
opt.cmdheight = 1
opt.formatoptions = ''
opt.laststatus = 3 -- global statusline
opt.showmode = false
opt.title = true

opt.clipboard = 'unnamedplus'
opt.cursorline = true

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = false
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = {
  eob = ' ',
  vert = ' ',
  vertright = ' ',
  vertleft = ' ',
  horizup = ' ',
  verthoriz = ' ',
  horizdown = '/',
  horiz = ' ',
  foldopen = '',
  foldclose = '',
  foldsep = ' ',
  stl = ' ',
}

opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = 'a'

-- Numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.ruler = false

-- FoOCItTsl
-- disable nvim intro
opt.shortmess:append('WcsI')

opt.signcolumn = 'yes'
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.scrolloff = 14

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append('<>[]hl')

g.mapleader = ' '

-- disable some default providers
for _, provider in ipairs({ 'node', 'perl', 'python3', 'ruby' }) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- add binaries installed by mason.nvim to path
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

-------------------------------------- autocmds ------------------------------------------
local autocmd = vim.api.nvim_create_autocmd

-- dont list quickfix buffers
autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.opt_local.buflisted = false
  end,
})
