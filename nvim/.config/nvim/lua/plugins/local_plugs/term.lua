require('base46.term')
local api = vim.api
local get_win = api.nvim_get_current_win
local set_win = api.nvim_set_current_win
local close_win = api.nvim_win_close
local valid_win = api.nvim_win_is_valid
local autocmd = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local g = vim.g

local origin_win = nil
local M = {}

g.hterm = false
g.vterm = false
g.terms = {}

local pos_data = {
  sp = { resize = 'height', area = 'lines' },
  vsp = { resize = 'width', area = 'columns' },
}

---@type TermConfig
local config = {
  behavior = {
    auto_insert = true,
  },
  sizes = {
    sp = 0.3,
    vsp = 0.4,
  },
  float = {
    relative = 'editor',
    row = 0.3,
    col = 0.25,
    width = 0.5,
    height = 0.4,
    border = 'single',
  },
}

-------------------------- util funcs -----------------------------
---@param opts TermOpts
function M.resize(opts)
  local val = pos_data[opts.pos]
  local size = vim.o[val.area] * config.sizes[opts.pos]
  api['nvim_win_set_' .. val.resize](0, math.floor(size))
end

function M.prettify(winnr, bufnr, hl)
  vim.wo[winnr].number = false
  vim.wo[winnr].relativenumber = false
  vim.wo[winnr].foldcolumn = '0'
  vim.wo[winnr].signcolumn = 'no'
  vim.bo[bufnr].buflisted = false
  vim.bo[bufnr].ft = 'terminal'

  -- custom highlight
  vim.wo[winnr].winhl = hl or 'Normal:NormalFloat,WinSeparator:WinSeparator'
  vim.cmd('startinsert')
end

function M.save_term_info(opts, bufnr)
  local terms_list = g.terms
  terms_list[tostring(bufnr)] = opts

  -- store ids for toggledterms instead of bufnr
  if opts.id then
    opts.bufnr = bufnr
    terms_list[opts.id] = opts
  end

  g.terms = terms_list
end

function M.create_float(buffer, float_opts)
  local opts = vim.tbl_deep_extend('force', {}, config.float)
  opts = vim.tbl_deep_extend('force', opts, float_opts or {})

  opts.width = math.ceil(opts.width * vim.o.columns)
  opts.height = math.ceil(opts.height * vim.o.lines)
  opts.row = math.ceil(opts.row * vim.o.lines)
  opts.col = math.ceil(opts.col * vim.o.columns)

  api.nvim_open_win(buffer, true, opts)
end

------------------------- user api -------------------------------
function M.new(opts, existing_buf, toggleStatus)
  origin_win = get_win()
  local buf = existing_buf or api.nvim_create_buf(false, true)

  -- create window
  if opts.pos == 'float' then
    M.create_float(buf, opts.float_opts)
  else
    if opts.pos == 'sp' then
      vim.cmd(opts.pos)
      vim.cmd('wincmd J')
    else
      vim.cmd(opts.pos)
      vim.cmd('wincmd L')
    end
  end

  local win = api.nvim_get_current_win()
  opts.win = win

  M.prettify(win, buf, opts.hl)

  -- resize non floating wins initially + or only when they're toggleable
  if (opts.pos == 'sp' and not g.hterm) or (opts.pos == 'vsp' and not g.vterm) or (toggleStatus and opts.pos ~= 'float') then
    M.resize(opts)
  end

  api.nvim_win_set_buf(win, buf)

  -- handle cmd opt
  local shell = vim.o.shell
  local cmd = shell

  if opts.cmd and (not opts.id or toggleStatus == 'notToggle') then
    ---@diagnostic disable-next-line
    cmd = { shell, '-c', opts.cmd .. '; ' .. shell }
  end

  M.save_term_info(opts, buf)

  -- use termopen only for non toggled terms
  if (not opts.id) or (toggleStatus == 'notToggle') then
    vim.fn.termopen(cmd)
  end

  if opts.pos == 'sp' then
    g.hterm = true
  elseif opts.pos == 'vsp' then
    g.vterm = true
  end
end

function M.toggle(opts)
  local term = g.terms[opts.id]

  if term == nil or not api.nvim_buf_is_valid(term.bufnr) then
    M.new(opts, nil, 'notToggle')
  end

  if term ~= nil and vim.fn.bufwinid(term.bufnr) == -1 then
    M.new(opts, term.bufnr, 'isToggle')
  end

  if term ~= nil and valid_win(term.win) then
    close_win(term.win, true)

    if origin_win then
      set_win(origin_win)
      origin_win = nil
    end
  end
end

-- spawns term with *cmd & runs the *cmd if the keybind is run again
function M.refresh_cmd(opts)
  if not opts.cmd then
    print('cmd opt is needed!')
    return
  end

  local x = g.terms[opts.id]

  if x == nil then
    M.new(opts, nil, true)
  elseif vim.fn.bufwinid(x.bufnr) == -1 then
    M.new(opts, x.bufnr)
    -- ensure that the buf is displayed on a window i.e visible to neovim!
  elseif vim.fn.bufwinid(x.bufnr) ~= -1 then
    local job_id = vim.b[x.bufnr].terminal_job_id
    api.nvim_chan_send(job_id, 'clear; ' .. opts.cmd .. ' \n')
  end
end

local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { buffer = 0 })
  vim.keymap.set('t', '<C-h>', [[<cmd> wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<cmd> wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<cmd> wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<cmd> wincmd l<CR>]], opts)
end

local TermGroup = augroup('TermGroup', { clear = true })

-- autoinsert when entering term buffers
if config.behavior.auto_insert then
  autocmd({ 'BufEnter' }, {
    pattern = 'term://*',
    group = TermGroup,
    callback = function()
      set_terminal_keymaps()
      vim.cmd('startinsert')
    end,
  })
end

return M
