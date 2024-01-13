local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  desc = 'Close with <q>',
  pattern = {
    'help',
    'man',
    'qf',
    'query',
    'scratch',
  },
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
  end,
})

-- Autocommand to restore the cursor position when the buffer is read
autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.fn.line('\'"') > 0 and vim.fn.line('\'"') <= vim.fn.line('$') then
      vim.cmd('normal! g`"')
    end
  end,
})

local vert_help = augroup('VertHelp', {})
autocmd('FileType', {
  pattern = 'help',
  group = vert_help,
  callback = function(event)
    vim.api.nvim_set_option_value('bufhidden', 'unload', { scope = 'local' })
    vim.cmd('wincmd L')
    vim.api.nvim_win_set_width(0, 100)
    vim.keymap.set('n', 'q', '<cmd>q<CR>', { buffer = event.buf, silent = true })

    ---@type string hello
    local test = 'test'
  end,
})

-- Disable diagnostics in node_modules (0 is current buffer only)
autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*/node_modules/*',
  command = 'lua vim.diagnostic.disable(0)',
})

-- Turns off the cursorline
autocmd({ 'InsertLeave', 'WinEnter', 'BufEnter' }, {
  callback = function()
    vim.o.cursorline = true
    vim.api.nvim_set_hl(0, 'CursorLine', { link = 'NvimTreeCursorLine' })
  end,
})

-- Turns on the cursorline
autocmd({ 'InsertEnter', 'WinLeave' }, {
  callback = function()
    vim.o.cursorline = false
  end,
})

---@param cwd string|nil
local function set_titlestring(cwd)
  local env = os.getenv('HOME')

  if cwd == env then
    vim.o.titlestring = '~/' .. '  '
    return
  end

  if cwd and type(env) == 'string' then
    local match = string.match(cwd, env)
    if match then
      vim.o.titlestring = cwd:gsub(match, '~') .. '  '
      return
    end
    vim.o.titlestring = cwd
  end
end

-- Checks to see if a .nvmrc exists and sets node version if one is found.
-- Also sets the title string for the kitty tabs
autocmd('VimEnter', {
  callback = function()
    if os.getenv('DEBUG') == '1' then
      vim.cmd('Log')
    end

    local cwd = vim.fn.getcwd()
    set_titlestring(cwd)
  end,
})
