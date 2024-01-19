local M = {}

M.luasnip = function(opts)
  require('luasnip').config.set_config(opts)

  -- vscode format
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({ paths = vim.g.vscode_snippets_path or '' })

  -- snipmate format
  require('luasnip.loaders.from_snipmate').load()
  require('luasnip.loaders.from_snipmate').lazy_load({ paths = vim.g.snipmate_snippets_path or '' })

  -- lua format
  require('luasnip.loaders.from_lua').load()
  ---@diagnostic disable-next-line
  require('luasnip.loaders.from_lua').lazy_load({ paths = './snippets' })

  vim.api.nvim_create_autocmd('InsertLeave', {
    group = vim.api.nvim_create_augroup('LuaSnip', { clear = true }),
    callback = function()
      if
        require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
      then
        require('luasnip').unlink_current()
      end
    end,
  })
end

-- local icon = '┃'
local icon = '│'
M.gitsigns = {
  _extmark_signs = true,
  signs = {
    add = { text = icon },
    change = { text = icon },
    delete = { text = icon },
    topdelete = { text = icon },
    changedelete = { text = icon },
    untracked = { text = icon },
  },
}

return M
