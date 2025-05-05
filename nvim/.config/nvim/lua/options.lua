local opt = vim.opt
local g = vim.g

if os.getenv('SSH_TTY') ~= nil or os.getenv('SSH_CONNECTION') ~= nil then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

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
opt.scrolloff     = 14         -- Show x lines above and below the cursor
opt.signcolumn    = 'yes'      -- Show signs in the signcolumn
opt.ignorecase    = true       -- Ignores case in search
opt.smartcase     = true       -- Override the 'ignorecase' option if the search pattern contains upper case characters
opt.splitbelow    = true       -- Split below instead of above
opt.splitright    = true       -- Split right instead of left
opt.termguicolors = true       -- Enable true color support
opt.undofile      = true       -- Save undo history to file
opt.updatetime    = 250        -- interval for writing swap file to disk, also used by gitsigns
opt.cmdheight     = 1          -- Height of the command bar
opt.formatoptions = 'j'        -- Don't use vim for formatting
opt.laststatus    = 3          -- global statusline
opt.showmode      = false      -- Don't display mode
opt.title         = true       -- Show the title in the window titlebar
opt.wrap          = false      -- Display long lines as just one line
opt.whichwrap:append('<>[]hl') -- go to previous/next line with h,l,left arrow and right arrow
opt.clipboard = 'unnamedplus'  -- Use system clipboard
opt.cursorline = true          -- Enable highlighting of the current line
opt.hlsearch = true            -- Enable highlight search
opt.swapfile = false           -- Disable swap file
opt.smoothscroll = true        -- Enable smooth scrolling

vim.o.winborder = "rounded"

-----------------------------------------------------------
-- Indent settings
-----------------------------------------------------------
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
-- opt.smartindent = true
-- opt.autoindent = true

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
opt.shortmess:append('qWcCsIS')
opt.formatexpr = "v:lua.require'conform'.formatexpr()"

---@param result table
---@param s string
---@param lnum integer
---@param coloff integer?
local function fold_virt_text(result, s, lnum, coloff)
  coloff = coloff or 0

  local text = ''
  local hl

  for i = 1, #s do
    local char = s:sub(i, i)
    local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
    local _hl = hls[#hls]
    if _hl then
      local new_hl = '@' .. _hl.capture
      if new_hl ~= hl then
        table.insert(result, { text, hl })
        text = ''
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end

function _G.custom_foldtext()
  local start = vim.fn.getline(vim.v.foldstart):gsub('\t', string.rep(' ', vim.o.tabstop))
  local end_str = vim.fn.getline(vim.v.foldend)
  local end_ = vim.trim(end_str)
  local result = {}
  fold_virt_text(result, start, vim.v.foldstart - 1)
  local delim = ' ... ' .. vim.v.foldend - vim.v.foldstart - 1 .. ' lines ... '
  table.insert(result, { delim, 'Delimiter' })
  fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match('^(%s+)') or ''))
  return result
end

vim.opt.foldtext = 'v:lua.custom_foldtext()'
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'

vim.o.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon1,i:ver25-Cursor/lCursor-blinkon1,r-cr:hor20-Cursor/lCursor-blinkon1'
vim.o.mouse = 'a' -- Enables mouse support
vim.o.mousescroll = 'ver:3,hor:0' -- Dont horizontal scroll with mouse
vim.o.timeout = true -- Faster wait time
vim.o.timeoutlen = 500 -- Timeout wait time
vim.o.ttimeoutlen = 10 -- Timeout wait time

vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH -- add binaries installed by mason.nvim to path

vim.cmd('set complete=') -- disable vim's built-in completion

vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.amenu([[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]])
