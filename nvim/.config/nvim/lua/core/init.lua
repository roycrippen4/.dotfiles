local opt = vim.opt
local g = vim.g
require('core.autocommands')
-- require('core.mappings')
require('plugins.local')
vim.treesitter.language.register('markdown', 'mdx')
vim.treesitter.language.register('markdown', 'LspDocFloat')

-----------------------------------------------------------
-- Global
-----------------------------------------------------------
g.autosave = false
g.base46_cache = vim.fn.stdpath('data') .. '/base46/'
g.NvimTreeOverlayTitle = ''
g.skip_ts_context_commentstring_module = true
g.markdown_fenced_languages = {
  'ts=typescript',
}
g.mapleader = ' '

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
opt.timeoutlen    = 300                               -- Faster timeout wait time
opt.undofile      = true                              -- Save undo history to file
opt.updatetime    = 250                               -- interval for writing swap file to disk, also used by gitsigns
opt.cmdheight     = 1                                 -- Height of the command bar
opt.formatoptions = ''                                -- Don't use vim for formatting
opt.laststatus    = 3                                 -- global statusline
opt.showmode      = false                             -- Don't display mode
opt.title         = true                              -- Show the title in the window titlebar
opt.whichwrap:append('<>[]hl')                        -- go to previous/next line with h,l,left arrow and right arrow
opt.clipboard = 'unnamedplus'                         -- Use system clipboard
opt.cursorline = true                                 -- Enable highlighting of the current line

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

-- disable some default providers
for _, provider in ipairs({ 'node', 'perl', 'python3', 'ruby' }) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

vim.g.node_host_prog = '~/.nvm/versions/node/v21.6.2/bin/node'
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH -- add binaries installed by mason.nvim to path

vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '❓', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '📝', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '➡️', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '❌', texthl = '', linehl = '', numhl = '' })

-- Configuration for diagnostics
local diagnostic_signs = {
  { name = 'DiagnosticSignError', text = '💀' },
  { name = 'DiagnosticSignWarn', text = ' ' },
  { name = 'DiagnosticSignHint', text = '󱡴 ' },
  { name = 'DiagnosticSignInfo', text = ' ' },
}

for _, sign in ipairs(diagnostic_signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

vim.diagnostic.config({
  signs = {
    active = diagnostic_signs, -- show signs
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    border = 'rounded',
    style = 'minimal',
    source = true,
    header = 'Diagnostic',
    prefix = '',
  },
})
