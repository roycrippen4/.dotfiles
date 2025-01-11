local M = {}

---@return boolean
function M.is_package_json()
  return vim.fn.expand('%:t') == 'package.json'
end

---@param str string
---@return string
local function trim(str)
  str = str:gsub('^%s+', ''):gsub('%s+$', '')
  return str
end

---@return table?
function M.parse_json()
  local path = vim.fn.expand('%:p')
  local json_str = trim(table.concat(vim.fn.readfile(path), ''))
  local ok, tbl = pcall(vim.json.decode, json_str)

  if not ok then
    return nil
  end

  return tbl
end

return M
