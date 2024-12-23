local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local pattern = { 'DressingInput', 'help', 'logger', 'man', 'qf', 'query', 'scratch', 'undotree', 'telescope', 'TelescopePrompt' }
local general = augroup('general', { clear = true })

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    if vim.fn.has('nvim-0.11') == 1 then
      vim.hl.on_yank()
    else
      vim.highlight.on_yank()
    end
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

autocmd('FileType', {
  desc = "don't list quickfix buffers",
  pattern = 'qf',
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

autocmd('FileType', {
  group = general,
  pattern = 'hypr',
  callback = function(args)
    vim.bo[args.buf].commentstring = '# %s'
  end,
})

autocmd('ExitPre', {
  desc = 'Stops all lsp daemons when exiting neovim',
  group = augroup('StopDaemons', { clear = true }),
  callback = function()
    vim.fn.jobstart(vim.fn.expand('$HOME') .. '/.bin/stop-nvim-daemons.sh', { detach = true })
  end,
})

autocmd('FileType', {
  desc = 'Forces help pages to be in a vertical split',
  pattern = 'help',
  group = general,
  callback = function()
    vim.api.nvim_set_option_value('bufhidden', 'unload', { scope = 'local' })
    vim.cmd('wincmd L')
    vim.api.nvim_win_set_width(0, 100)
    vim.cmd('set winhighlight=Normal:HelpNormal')
  end,
})

autocmd('FileType', {
  desc = 'Sets many plugin windows to close on `q`',
  group = general,
  pattern = pattern,
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>q!<cr>', { buffer = args.buf })
  end,
})

--
autocmd('VimEnter', {
  desc = 'Sets terminal titlestring to the current working directory',
  group = general,
  once = true,
  callback = function()
    local cwd = vim.fn.getcwd()
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
  end,
})

autocmd('BufReadPost', {
  desc = 'Restore the cursor position when the buffer is read',
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Disable diagnostics in node_modules (0 is current buffer only)',
  group = general,
  pattern = '*/node_modules/*',
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

autocmd('BufWritePre', {
  desc = 'Adds missing commas to lua files',
  group = general,
  pattern = '*',
  callback = function()
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    if #diagnostics > 0 then
      U.add_missing_commas(diagnostics)
    end
  end,
})

autocmd('CmdwinEnter', {
  desc = 'Fixes highlighting in the cmdwin',
  callback = function()
    vim.bo.ft = 'python'
    vim.bo.ft = 'vim'
  end,
})

autocmd('FileType', {
  group = general,
  pattern = 'gitcommit',
  callback = function()
    feed('i', 'n')
  end,
})

autocmd('FileType', {
  desc = 'Creates a backdrop effect for large windows',
  pattern = { 'TelescopePrompt', 'mason', 'lazy' },
  callback = U.create_backdrop,
})
