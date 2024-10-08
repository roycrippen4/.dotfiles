local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local M = {}

---@return boolean
local function is_package_json()
  return vim.fn.expand('%:t') == 'package.json'
end

---@param lines string[]
---@return integer, integer
local function find_script_range(lines)
  local start_line = 0
  local end_line = 0

  for i, line in ipairs(lines) do
    if line:find('scripts') then
      start_line = i
      break
    end
  end

  for i = start_line + 1, #lines do
    if lines[i]:find('}') then
      end_line = i
      break
    end
  end

  return start_line, end_line
end

local function get_script_table()
  M.scripts = {}
  local lines = vim.fn.readfile(vim.fn.expand('%')) ---@type string[]
  local start_line, end_line = find_script_range(lines)

  if start_line == 0 or end_line == 0 then
    return {}
  end

  for i = start_line + 1, end_line do
    local script = lines[i]:match('"[%s]*(.-)[%s]*":')
    if script then
      script = script:gsub('%-', '%%-')
      table.insert(M.scripts, { line = i, script = script })
    end
  end

  return M.scripts
end

---@return boolean
local function cursor_on_script()
  local cursor = vim.fn.line('.')

  for _, script in ipairs(M.scripts) do
    if cursor == script.line then
      return true
    end
  end

  return false
end

local function match_script()
  local cursor = vim.fn.line('.')

  for _, script in ipairs(M.scripts) do
    if cursor == script.line then
      return script.script
    end
  end
end

local function can_run_script()
  if not is_package_json() then
    vim.notify('Not a package.json file', 3)
    return false
  end

  if not cursor_on_script() then
    vim.notify('Cursor not on a script', 3)
    return false
  end

  vim.notify('Running ' .. match_script(), 1)
  return true
end

local function has_bun_lock()
  return vim.fn.filereadable('bun.lockb') == 1
end

function M.run_script()
  if not can_run_script() then
    return
  end

  local runner = (has_bun_lock() and 'bun run ') or 'npm run '
  local script = runner .. match_script()

  vim.cmd('TermExec cmd="' .. script .. '"')
end

local function set_keymaps()
  vim.keymap.set('n', '<leader>nr', function()
    M.run_script()
  end)
end

local function create_highlights()
  vim.api.nvim_set_hl(0, 'RunScript', { fg = '#08F000' })
end

local function set_virtual_text()
  if not is_package_json() then
    return
  end

  if not M.ns_id then
    M.ns_id = vim.api.nvim_create_namespace('package_json_runner')
  end

  for _, script in ipairs(M.scripts) do
    vim.api.nvim_buf_set_extmark(0, M.ns_id, script.line - 1, 0, {
      virt_text = { { '  ', 'RunScript' } },
      hl_mode = 'combine',
      virt_text_win_col = 1,
    })
  end
end

function M.setup()
  M.scripts = get_script_table()
  set_keymaps()
  create_highlights()
  set_virtual_text()
end

autocmd('BufEnter', {
  pattern = 'package.json',
  group = augroup('PackageCheck', { clear = true }),
  callback = function()
    M.setup()
  end,
})

return M
