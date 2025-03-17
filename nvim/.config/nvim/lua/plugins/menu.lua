local function open_default()
  require('menu.utils').delete_old_menus()
  local options = vim.bo.ft == 'NvimTree' and 'nvimtree' or 'default'
  require('menu').open(options)
end

local function right_click()
  require('menu.utils').delete_old_menus()

  vim.cmd.exec('"normal! \\<RightMouse>"')

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == 'NvimTree' and 'nvimtree' or 'default'

  require('menu').open(options, { mouse = true })
end

---@type LazyPluginSpec[]
return {
  { 'nvzone/volt', lazy = true },
  { 'nvzone/minty', lazy = true },
  {
    'nvzone/menu',
    lazy = true,
    keys = {
      { '<c-t>', open_default, desc = 'Open Menu' },
      { mode = { 'n', 'v' }, '<RightMouse>', right_click, desc = 'OpenMenu' },
    },
  },
}
