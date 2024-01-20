local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local ns_id = vim.api.nvim_create_namespace('HarpoonExtmarks')
autocmd('FileType', {
  group = augroup('TablineHarpoonMarker', { clear = true }),
  pattern = 'harpoon',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    require('core.utils').highlight_marked_files(bufnr, ns_id)
  end,
})

autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    ---@diagnostic disable-next-line
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

local CloseWithQ = vim.api.nvim_create_augroup('CloseWithQ', { clear = true })
autocmd('FileType', {
  group = CloseWithQ,
  pattern = {
    'help',
    'man',
    'qf',
    'query',
    'scratch',
    'undotree',
    'logger',
  },
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
  end,
})

-- Autocommand to restore the cursor position when the buffer is read
autocmd('BufReadPost', {
  pattern = '*',
  group = augroup('RestoreCursor', { clear = true }),
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
  callback = function()
    vim.api.nvim_set_option_value('bufhidden', 'unload', { scope = 'local' })
    vim.cmd('wincmd L')
    vim.api.nvim_win_set_width(0, 100)
  end,
})

-- Disable diagnostics in node_modules (0 is current buffer only)
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup('NodeModulesDiagnostics', { clear = true }),
  pattern = '*/node_modules/*',
  callback = function(args)
    vim.diagnostic.disable(args.buf)
  end,
})

local CursorLineToggle = augroup('CursorLineToggle', { clear = true })
-- Turns on the cursorline
autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = CursorLineToggle,
  callback = function()
    vim.o.cursorline = true
    vim.api.nvim_set_hl(0, 'CursorLine', { link = 'NvimTreeCursorLine' })
  end,
})

-- Turns off the cursorline
autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = CursorLineToggle,
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
    set_titlestring(vim.fn.getcwd())
  end,
})

local AddComma = augroup('AddComma', { clear = true })
autocmd('BufWritePre', {
  group = AddComma,
  callback = function()
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    if #diagnostics > 0 then
      require('core.utils').add_missing_commas(diagnostics)
    end
  end,
})

-- Close Dressing inputs with q in normal mode
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'DressingInput',
  callback = function()
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_close(0, true)
    end, { buffer = 0 })
  end,
})
