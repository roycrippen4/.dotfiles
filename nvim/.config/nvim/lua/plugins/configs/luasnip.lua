require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load({ paths = vim.g.vscode_snippets_path or '' })

require('luasnip.loaders.from_snipmate').load()
require('luasnip.loaders.from_snipmate').lazy_load({ paths = vim.g.snipmate_snippets_path or '' })

require('luasnip.loaders.from_lua').load()
---@diagnostic disable-next-line
require('luasnip.loaders.from_lua').lazy_load({ paths = './snippets' })

vim.api.nvim_create_autocmd('InsertLeave', {
  group = vim.api.nvim_create_augroup('LuaSnip', { clear = true }),
  callback = function()
    if require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()] and not require('luasnip').session.jump_active then
      require('luasnip').unlink_current()
    end
  end,
})
