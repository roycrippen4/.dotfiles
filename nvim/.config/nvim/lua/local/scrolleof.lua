local blacklist = {
  'NvimTree',
  'Trouble',
  'TelescopePrompt',
  'poon',
  'toggleterm',
  'logger',
}

local function check_eof_scrolloff()
  local win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(win).relative ~= '' then
    return
  end
  for _, item in ipairs(blacklist) do
    if item == vim.bo.ft then
      return
    end
  end

  local win_height = vim.fn.winheight(0)
  local last_line = vim.fn.line('$')
  local win_last_line = vim.fn.line('w$')

  -- PERF avoid calculations when far away from the end of file
  if win_last_line + win_height < last_line then
    return
  end

  local win_view = vim.fn.winsaveview()
  local scrolloff = math.min(vim.o.scrolloff, math.floor(win_height / 2))
  if win_view then
    local cur_line = win_view.lnum
    local win_top_line = win_view.topline
    local visual_distance_to_eof = last_line - cur_line
    local visual_last_line_in_win = win_last_line
    local scrolloff_line_count = win_height - (visual_last_line_in_win - win_top_line + 1)

    if visual_distance_to_eof < scrolloff and scrolloff_line_count + visual_distance_to_eof < scrolloff then
      vim.fn.winrestview({ topline = win_view.topline + scrolloff - (scrolloff_line_count + visual_distance_to_eof) })
    end
  end
end

local skip_ft = {
  'NvimTree',
  'Trouble',
  'alpha',
  'dap-repl',
  'dapui_breakpoints',
  'dapui_console',
  'dapui_scopes',
  'dapui_stacks',
  'dapui_watches',
  'dashboard',
  'fidget',
  'help',
  'poon',
  'lazy',
  'logger',
  'noice',
  'nvcheatsheet',
  'nvdash',
  'terminal',
  'toggleterm',
  'vim',
}

vim.api.nvim_create_autocmd({ 'CursorMoved', 'WinScrolled' }, {
  group = vim.api.nvim_create_augroup('ScrollEOF', { clear = true }),
  pattern = '*',
  callback = function()
    if vim.tbl_contains(skip_ft, vim.bo.ft) then
      return
    end
    check_eof_scrolloff()
  end,
})
