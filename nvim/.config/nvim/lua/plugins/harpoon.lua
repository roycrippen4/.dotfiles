local function add_file()
  require('harpoon.mark').add_file()
  vim.cmd('redrawtabline')
end

local function show_menu()
  require('harpoon.ui').toggle_quick_menu()
  vim.wo.cursorline = true
end

---@type LazyPluginSpec
return {
  'roycrippen4/harpoon',
  keys = {
    { '<c-f>', add_file },
    { '<c-e>', show_menu },
    { 'B', require('core.utils').set_as_first_mark },
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
