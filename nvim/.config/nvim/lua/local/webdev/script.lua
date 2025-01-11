local Script = {}

---@param scripts table<string, string>
---@return string?
function Script.get(scripts)
  local line_text = vim.api.nvim_get_current_line()
  local script_name = line_text:match('^%s*"([^"]+)":%s*"([^"]+)"')

  if script_name == {} or not scripts then
    return
  end

  local script = scripts[script_name]
  if not script then
    return
  end

  return script
end

-- local function can_run_script()
--   if not is_package_json() then
--     vim.notify('Not a package.json file', 3)
--     return false
--   end

--   if not get_script() then
--     vim.notify('Cursor not on a script', 3)
--     return false
--   end

--   vim.notify('Running ' .. match_script(), 1)
--   return true
-- end

-- function M.run_script()
--   if not can_run_script() then
--     return
--   end

--   local runner = (has_bun_lock() and 'bun run ') or 'npm run '
--   local script = runner .. match_script()

--   vim.cmd('TermExec cmd="' .. script .. '"')
-- end

return Script
