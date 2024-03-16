local opt = vim.opt
local g = vim.g
require('core.autocommands')
require('core.diagnostic')
require('plugins.local')
vim.treesitter.language.register('markdown', 'mdx')

-----------------------------------------------------------
-- Global
-----------------------------------------------------------
g.autosave = false
g.base46_cache = vim.fn.stdpath('data') .. '/nvchad/base46/'
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

-- add binaries installed by mason.nvim to path
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

-------------------------------------- autocmds ------------------------------------------
local autocmd = vim.api.nvim_create_autocmd

-- don't list quickfix buffers
autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- reload some chadrc options on-save
autocmd('BufWritePost', {
  pattern = vim.tbl_map(function(path)
    ---@diagnostic disable-next-line
    local realpath = vim.uv.fs_realpath(path)
    if realpath then
      return vim.fs.normalize(realpath)
    end
  end, vim.fn.glob(vim.fn.stdpath('config') .. '/lua/custom/**/*.lua', true, true, true)),
  group = vim.api.nvim_create_augroup('ReloadNvChad', {}),

  callback = function(opts)
    local fp = vim.fn.fnamemodify(vim.fs.normalize(vim.api.nvim_buf_get_name(opts.buf)), ':r') --[[@as string]]
    local app_name = vim.env.NVIM_APPNAME and vim.env.NVIM_APPNAME or 'nvim'
    local module = string.gsub(fp, '^.*/' .. app_name .. '/lua/', ''):gsub('/', '.')

    require('plenary.reload').reload_module('nvconfig')
    require('plenary.reload').reload_module('base46')
    require('plenary.reload').reload_module(module)

    local config = require('nvconfig')

    -- statusline
    if config.ui.statusline.theme ~= 'custom' then
      require('plenary.reload').reload_module('nvchad.statusline.' .. config.ui.statusline.theme)
      vim.opt.statusline = "%!v:lua.require('nvchad.statusline." .. config.ui.statusline.theme .. "').run()"
    end

    -- tabufline
    require('plenary.reload').reload_module('plugins.local.tabufline.modules')
    vim.opt.tabline = "%!v:lua.require('plugins.local.tabufline.modules').run()"

    require('base46').load_all_highlights()
    -- vim.cmd("redraw!")
  end,
})
