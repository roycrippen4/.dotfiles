local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local namespace = vim.api.nvim_create_namespace
local pattern = { 'DressingInput', 'help', 'logger', 'man', 'qf', 'query', 'scratch', 'undotree', 'telescope', 'TelescopePrompt' }
local general = augroup('general', { clear = true })

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd('InsertEnter', {
  desc = 'Disable cursorline in insert mode',
  group = general,
  callback = function(args)
    if not vim.tbl_contains(pattern, vim.bo[args.buf].ft) then
      vim.cmd('set nocul')
    end
  end,
})

autocmd('InsertLeave', {
  desc = 'Enable cursorline after leaving insert mode',
  group = general,
  callback = function(args)
    if not vim.tbl_contains(pattern, vim.bo[args.buf].ft) then
      vim.cmd('set cul')
    end
  end,
})

autocmd('BufWritePost', {
  desc = 'Reload kitty config on save',
  pattern = 'kitty.conf',
  callback = function()
    os.execute('pkill -USR1 kitty')
  end,
})

-- don't list quickfix buffers
autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

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
    vim.cmd('set winhighlight=Normal:HelpNormal')
  end,
})

-- Sets many plugin windows to close on `q`
autocmd('FileType', {
  group = general,
  pattern = pattern,
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>q!<cr>', { buffer = args.buf })
  end,
})

-- Sets terminal titlestring to the current working directory
autocmd('VimEnter', {
  group = general,
  pattern = 'NvimTree_1',
  once = true,
  callback = function()
    require('core.utils').set_titlestring(vim.fn.getcwd())
  end,
})

-- Autocommand to restore the cursor position when the buffer is read
autocmd('BufReadPost', {
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- Disable diagnostics in node_modules (0 is current buffer only)
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = general,
  pattern = '*/node_modules/*',
  callback = function()
    vim.diagnostic.enable(false)
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

autocmd('FileType', {
  group = general,
  pattern = 'gitcommit',
  callback = function()
    feed('i', 'n')
  end,
})
