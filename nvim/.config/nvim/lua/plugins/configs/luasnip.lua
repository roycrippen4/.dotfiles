local map = vim.keymap.set

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load({ paths = vim.g.vscode_snippets_path or '' })

require('luasnip.loaders.from_snipmate').load()
require('luasnip.loaders.from_snipmate').lazy_load({ paths = vim.g.snipmate_snippets_path or '' })

require('luasnip.loaders.from_lua').load()
---@diagnostic disable-next-line
require('luasnip.loaders.from_lua').lazy_load({ paths = './snippets' })

map('i', '<Tab>', function()
  return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
end, { expr = true, silent = true })

map('s', '<Tab>', function()
  require('luasnip').jump(1)
end, { silent = true })

map({ 'i', 's' }, '<S-Tab>', function()
  require('luasnip').jump(-1)
end, { silent = true })

vim.api.nvim_create_autocmd('InsertLeave', {
  group = vim.api.nvim_create_augroup('LuaSnip', { clear = true }),
  callback = function()
    if require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()] and not require('luasnip').session.jump_active then
      require('luasnip').unlink_current()
    end
  end,
})
