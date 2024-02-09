local M = {}

M.open = function()
  local currName = vim.fn.expand('<cword>')

  vim.ui.input({
    prompt = ' Refactor: ' .. currName .. ' ',
    default = currName,
  }, function(newName)
    require('plugins.local_plugs.renamer').rename(newName, currName)
  end)
end

---@param newName string
---@param currName string
M.rename = function(newName, currName)
  if not newName then
    return
  end

  newName = vim.trim(newName)
  if #newName > 0 and newName ~= currName then
    local params = vim.lsp.util.make_position_params()
    params.newName = newName
    vim.lsp.buf_request(0, 'textDocument/rename', params)
  end
end

return M
