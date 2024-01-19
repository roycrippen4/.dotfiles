local M = {}

function M.config()
  local execs = {
    { nil, '<A-h>', 'Horizontal Terminal', 'horizontal', 0.3 },
    { nil, '<A-v>', 'Vertical Terminal', 'vertical', 0.4 },
    { nil, '<A-f>', 'Float Terminal', 'float', nil },
  }

  local function get_buf_size()
    local cbuf = vim.api.nvim_get_current_buf()
    local bufinfo = vim.tbl_filter(function(buf)
      return buf.bufnr == cbuf
      ---@diagnostic disable-next-line
    end, vim.fn.getwininfo(vim.api.nvim_get_current_win()))[1]
    if bufinfo == nil then
      return { width = -1, height = -1 }
    end
    return { width = bufinfo.width, height = bufinfo.height }
  end

  local function get_dynamic_terminal_size(direction, size)
    size = size
    if direction ~= 'float' and tostring(size):find('.', 1, true) then
      size = math.min(size, 1.0)
      local buf_sizes = get_buf_size()
      local buf_size = direction == 'horizontal' and buf_sizes.height or buf_sizes.width
      return buf_size * size
    else
      return size
    end
  end

  local exec_toggle = function(opts)
    local Terminal = require('toggleterm.terminal').Terminal
    local term = Terminal:new({ cmd = opts.cmd, count = opts.count, direction = opts.direction })
    term:toggle(opts.size, opts.direction)
  end

  local add_exec = function(opts)
    local binary = opts.cmd:match('(%S+)')
    if vim.fn.executable(binary) ~= 1 then
      vim.notify('Skipping configuring executable ' .. binary .. '. Please make sure it is installed properly.')
      return
    end

    vim.keymap.set({ 'n', 't' }, opts.keymap, function()
      exec_toggle({ cmd = opts.cmd, count = opts.count, direction = opts.direction, size = opts.size() })
    end, { desc = opts.label, noremap = true, silent = true })
  end

  for i, exec in pairs(execs) do
    local direction = exec[4]

    local opts = {
      cmd = exec[1] or vim.o.shell,
      keymap = exec[2],
      label = exec[3],
      count = i + 100,
      direction = direction,
      size = function()
        return get_dynamic_terminal_size(direction, exec[5])
      end,
    }

    add_exec(opts)
  end
end

local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { buffer = 0 })
  -- vim.keymap.set('t', 'jk', [[<C-w><C-x>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    set_terminal_keymaps()
  end,
})

return M
