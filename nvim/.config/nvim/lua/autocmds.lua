local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local pattern = { 'DressingInput', 'help', 'logger', 'man', 'qf', 'query', 'scratch', 'undotree', 'telescope', 'TelescopePrompt' }
local general = augroup('general', { clear = true })

autocmd('CursorMoved', {
  group = augroup('auto-hlsearch', { clear = true }),
  callback = function()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
      vim.schedule(function()
        vim.cmd.nohlsearch()
      end)
    end
  end,
})

autocmd('FileType', {
  pattern = 'neotest*',
  callback = function(args)
    local winnr = vim.fn.bufwinid(args.buf)
    vim.wo[winnr].winhighlight = 'Normal:HelpNormal'
    vim.cmd('set nocul')
    vim.cmd('norm G')
  end,
})

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
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
    vim.api.nvim_win_set_width(0, 110)
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

autocmd('BufWritePre', {
  desc = 'Adds missing commas to lua files',
  group = general,
  pattern = '*',
  callback = function()
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    vim.iter(diagnostics):each(function(diag)
      if diag.message == 'Miss symbol `,` or `;` .' or diag.message == 'Missed symbol `,`.' then
        vim.api.nvim_buf_set_text(0, diag.lnum, diag.col, diag.lnum, diag.col, { ',' })
      end
    end)
  end,
})

autocmd('FileType', {
  desc = "Start gitcommit files in 'insert' mode",
  group = general,
  pattern = 'gitcommit',
  callback = function()
    feed('i', 'n')
  end,
})

autocmd('FileType', {
  desc = 'Creates a backdrop effect for large windows',
  pattern = { 'TelescopePrompt', 'mason', 'lazy' },
  callback = require('utils').create_backdrop,
})

local plug_types = {
  NvimTree = true,
  TelescopePrompt = true,
  Trouble = true,
  poon = true,
  help = true,
  logger = true,
  noice = true,
  prompt = true,
  terminal = true,
  toggleterm = true,
  fidget = true,
  notify = true,
  snacks_notif = true,
  ['neotest-summary'] = true,
  ['neotest-output-panel'] = true,
}

local function quit_vim()
  local wins = vim.api.nvim_list_wins()
  local file_win_count = 0

  for _, w in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(w)
    local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
    if not plug_types[ft] then
      file_win_count = file_win_count + 1
    end
  end

  if file_win_count == 0 then
    vim.cmd('qa')
  end
end

-- autoquit vim if only plugin windows are open
vim.api.nvim_create_autocmd('QuitPre', {
  callback = function()
    vim.defer_fn(quit_vim, 100)
  end,
})
