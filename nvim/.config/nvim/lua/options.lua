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

if os.getenv('WSL_DISTRO_NAME') then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'ripboard',
      ['*'] = 'ripboard',
    },
    cache_enabled = 0,
  }
end

vim.g.have_nerd_font = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.markdown_fenced_languages = { 'ts=typescript' }
vim.g.skip_ts_context_commentstring_module = true

vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.cmdheight = 1 -- Height of the command bar
vim.opt.cursorline = true -- Enable cursorline
vim.opt.cursorlineopt = 'number' -- Only highlight the line number in the statuscolumn
vim.opt.expandtab = true
vim.opt.formatoptions = 'j' -- Don't use vim for formatting
vim.opt.hlsearch = true -- Enable highlight search
vim.opt.ignorecase = true -- Ignores case in search
vim.opt.laststatus = 3 -- global statusline
vim.opt.scrolloff = 14 -- Show x lines above and below the cursor
vim.opt.shiftwidth = 2
vim.opt.showmode = false -- Don't display mode
vim.opt.signcolumn = 'yes' -- Show signs in the signcolumn
vim.opt.smartcase = true -- Override the 'ignorecase' option if the search pattern contains upper case characters
vim.opt.smoothscroll = true -- Enable smooth scrolling
vim.opt.splitbelow = true -- Split below instead of above
vim.opt.splitright = true -- Split right instead of left
vim.opt.swapfile = false -- Disable swap file
vim.opt.tabstop = 2
vim.opt.termguicolors = true -- Enable true color support
vim.opt.title = true -- Show the title in the window titlebar
vim.opt.undofile = true -- Save undo history to file
vim.opt.updatetime = 250 -- interval for writing swap file to disk, also used by gitsigns
vim.opt.whichwrap:append('<>[]hl') -- go to previous/next line with h,l,left arrow and right arrow
vim.opt.wrap = false -- Display long lines as just one line
-- vim.opt.smartindent = true
-- vim.opt.autoindent = true
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.fillchars = {
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

vim.o.winborder = 'rounded'
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
