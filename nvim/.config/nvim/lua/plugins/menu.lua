local default_menu = {
  {
    name = 'Format Buffer',
    cmd = function()
      local ok, conform = pcall(require, 'conform')

      if ok then
        conform.format({ lsp_fallback = true })
      else
        vim.lsp.buf.format()
      end
    end,
    rtxt = '<leader>fm',
  },

  {
    name = 'Code Actions',
    cmd = vim.lsp.buf.code_action,
    rtxt = '<leader>ca',
  },

  { name = 'separator' },

  {
    name = '  Lsp Actions',
    hl = 'Exblue',
    items = 'lsp',
  },

  { name = 'separator' },

  {
    name = 'Edit Config',
    cmd = function()
      vim.cmd('tabnew')
      local conf = vim.fn.stdpath('config')
      vim.cmd('tcd ' .. conf .. ' | e init.lua')
    end,
    rtxt = 'ed',
  },

  {
    name = 'Copy Content',
    cmd = '<cmd> yank <cr>',
    rtxt = '<C-c>',
  },

  {
    name = 'Delete Content',
    cmd = '%d',
    rtxt = 'dc',
  },

  { name = 'separator' },

  {
    name = '  Color Picker',
    cmd = function()
      require('minty.huefy').open()
    end,
  },
}

local function open_default()
  require('menu.utils').delete_old_menus()
  local options = vim.bo.ft == 'NvimTree' and 'nvimtree' or default_menu
  require('menu').open(options)
end

local function right_click()
  require('menu.utils').delete_old_menus()

  vim.cmd.exec('"normal! \\<RightMouse>"')

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == 'NvimTree' and 'nvimtree' or default_menu

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
