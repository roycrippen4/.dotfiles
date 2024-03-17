local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local namespace = vim.api.nvim_create_namespace
local general = augroup('General', { clear = true })
local pattern = { 'DressingInput', 'help', 'logger', 'man', 'qf', 'query', 'scratch', 'undotree' }

if vim.fn.has('wsl') == 1 then
  autocmd('TextYankPost', {
    group = augroup('WSLYank', { clear = true }),
    callback = function()
      vim.schedule(function()
        vim.fn.system('clip.exe', vim.fn.getreg('0'))
      end)
    end,
  })
end

autocmd('FileType', {
  group = general,
  pattern = 'hypr',
  callback = function(event)
    vim.bo[event.buf].commentstring = '# %s'
  end,
})

autocmd('ExitPre', {
  group = augroup('StopDaemons', { clear = true }),
  callback = function()
    vim.fn.jobstart(vim.fn.expand('$HOME') .. '/.bin/stop-nvim-daemons.sh', { detach = true })
  end,
})

autocmd('TextYankPost', {
  group = general,
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = '*',
})

autocmd('FileType', {
  group = general,
  pattern = 'harpoon',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    require('core.utils').highlight_marked_files(bufnr, namespace('HarpoonExtmarks'))
    vim.keymap.set('n', 'K', '', { silent = true, buffer = bufnr })
  end,
})

-- Forces help pages to be in a vertical split
autocmd('FileType', {
  pattern = 'help',
  group = general,
  callback = function()
    print('help')
    vim.api.nvim_set_option_value('bufhidden', 'unload', { scope = 'local' })
    vim.cmd('wincmd L')
    vim.api.nvim_win_set_width(0, 100)
  end,
})

-- Sets many plugin windows to close on `q`
autocmd('FileType', {
  group = general,
  pattern = pattern,
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
  end,
})

-- Opens up all marked files. Also opens the logger buffer if -d gets passed in
autocmd('VimEnter', {
  group = general,
  pattern = 'NvimTree_1',
  once = true,
  callback = function()
    require('core.utils').set_titlestring(vim.fn.getcwd())

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
        require('plugins.local.logger'):show()
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
        vim.cmd("echo ' '")
      end
    end)
  end,
})

-- Autocommand to restore the cursor position when the buffer is read
autocmd('BufReadPost', {
  pattern = '*',
  group = general,
  callback = function()
    if vim.fn.line('\'"') > 0 and vim.fn.line('\'"') <= vim.fn.line('$') then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Disable diagnostics in node_modules (0 is current buffer only)
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = general,
  pattern = '*/node_modules/*',
  callback = function(args)
    vim.diagnostic.disable(args.buf)
  end,
})

-- Turns on the cursorline
autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = general,
  callback = function()
    if vim.bo.ft ~= 'terminal' then
      vim.o.cursorline = true
      vim.api.nvim_set_hl(0, 'CursorLine', { link = 'NvimTreeCursorLine' })
    end
  end,
})

-- Turns off the cursorline
autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = general,
  callback = function()
    vim.o.cursorline = false
  end,
})

-- Adds missing commas to lua files
autocmd('BufWritePre', {
  group = general,
  pattern = '*',
  callback = function()
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    if #diagnostics > 0 then
      require('core.utils').add_missing_commas(diagnostics)
    end
  end,
})

autocmd('CmdWinEnter', {
  group = augroup('_fix_ts_cmdwin', { clear = false }),
  callback = function()
    vim.cmd('setfiletype python')
    vim.schedule(function()
      vim.cmd('setfiletype vim')
    end)
  end,
})
