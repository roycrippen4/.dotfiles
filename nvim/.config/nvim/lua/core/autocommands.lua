local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('FileType', {
  group = augroup('TablineHarpoonMarker', { clear = true }),
  pattern = 'harpoon',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    require('core.utils').highlight_marked_files(bufnr, vim.api.nvim_create_namespace('HarpoonExtmarks'))
  end,
})

autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    ---@diagnostic disable-next-line
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

autocmd('FileType', {
  group = vim.api.nvim_create_augroup('CloseWithQ', { clear = true }),
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

-- Opens up all marked files. Also opens the logger buffer if -d gets passed in
autocmd('VimEnter', {
  group = augroup('FakeSession', { clear = true }),
  pattern = 'NvimTree_1',
  callback = function()
    vim.schedule(function()
      local ui = require('harpoon.ui')
      local mark = require('harpoon.mark')
      local length = mark.get_length()

      if length == 0 then
        return
      end

      for i = 1, mark.get_length() do
        ui.nav_file(i)
      end

      if os.getenv('DEBUG') == '1' then
        require('plugins.local_plugs.logger'):show()
        vim.defer_fn(function()
          vim.cmd([[
          vsplit 
          vertical resize 80
          wincmd h
        ]])
          ui.nav_file(1)
        end, 0)
      else
        ui.nav_file(1)
      end
    end)
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

-- Forces help pages to be in a vertical split
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

-- Also sets the title string for the kitty tabs
autocmd('VimEnter', {
  callback = function()
    require('core.utils').set_titlestring(vim.fn.getcwd())
  end,
})

-- Adds missing commas to lua files
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
autocmd('FileType', {
  pattern = 'DressingInput',
  callback = function()
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_close(0, true)
    end, { buffer = 0 })
  end,
})

-- Highlights a url if cursor is on it
autocmd('CursorMoved', {
  callback = function()
    require('core.utils').highlight_url()
  end,
})
