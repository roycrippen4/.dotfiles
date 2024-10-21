---@class UI
---@field winnr integer|nil
---@field bufnr integer|nil
---@field prev_winnr integer|nil
local UI = {}

---@param self UI
function UI:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function UI:set_focus()
  -- do nothing if already focused
  if vim.api.nvim_get_current_win() == self.winnr then
    return
  end

  -- check if the window is valid before attempting to focus
  if vim.api.nvim_win_is_valid(self.winnr) then
    self.prev_winnr = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(self.winnr)
  end
end

function UI:is_visible()
  return vim.tbl_contains(vim.api.nvim_list_wins(), self.winnr)
end

function UI:close()
  if self:is_visible() then
    vim.api.nvim_win_close(self.winnr, true)

    if self.prev_winnr then
      vim.api.nvim_set_current_win(self.prev_winnr)
      self.prev_winnr = nil
    end

    self.winnr = nil
    self.bufnr = nil
  end
end

-- TODO:
-- Configure keymap settings
function UI:set_keymaps() end

return UI
