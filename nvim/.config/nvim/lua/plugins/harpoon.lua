local function add_file()
  require('harpoon.mark').add_file()
  vim.cmd('redrawtabline')
end

local function show_menu()
  require('harpoon.ui').toggle_quick_menu()
  vim.wo.cursorline = true
end

--- Sets the currently opened file to the first entry in the marks list
local function set_as_first_mark()
  local mark = require('harpoon.mark')
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = require('plenary.path'):new(bufname):make_relative(vim.uv.cwd())

  ---@type string[]
  local marked = {}
  for idx = 1, require('harpoon.mark').get_length() do
    table.insert(marked, require('harpoon.mark').get_marked_file_name(idx))
  end

  ---@type integer|nil
  local file_idx

  if vim.tbl_contains(marked, path) then
    file_idx = mark.get_current_index()
  else
    mark.add_file()
    file_idx = mark.get_length()
  end

  ---@type string[]
  local new_marks = {}
  table.insert(new_marks, mark.get_marked_file_name(file_idx))

  for _, filepath in pairs(marked) do
    if not vim.tbl_contains(new_marks, filepath) then
      table.insert(new_marks, filepath)
    end
  end

  mark.set_mark_list(new_marks)
  vim.cmd('redrawtabline')
end

---@type LazyPluginSpec
return {
  'roycrippen4/harpoon',
  keys = {
    { '<c-f>', add_file },
    { '<c-e>', show_menu },
    { 'B', set_as_first_mark },
    -- stylua: ignore start
    { '<c-0>', function() require('harpoon.ui').nav_file(0) end },
    { '<c-1>', function() require('harpoon.ui').nav_file(1) end },
    { '<c-2>', function() require('harpoon.ui').nav_file(2) end },
    { '<c-3>', function() require('harpoon.ui').nav_file(3) end },
    { '<c-4>', function() require('harpoon.ui').nav_file(4) end },
    { '<c-5>', function() require('harpoon.ui').nav_file(5) end },
    { '<c-6>', function() require('harpoon.ui').nav_file(6) end },
    { '<c-7>', function() require('harpoon.ui').nav_file(7) end },
    { '<c-8>', function() require('harpoon.ui').nav_file(8) end },
    { '<c-9>', function() require('harpoon.ui').nav_file(9) end },
    -- stylua: ignore end
  },
  opts = { menu = { width = 80 } },
}
