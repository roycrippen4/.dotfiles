local map = vim.keymap.set

local function load_snippets()
  require('luasnip').filetype_extend('svelte', { 'javascript' })
  require('luasnip').filetype_extend('javascriptreact', { 'javascript' })
  require('luasnip').filetype_extend('typescriptreact', { 'javascript' })
  require('luasnip').filetype_extend('typescript', { 'javascript' })

  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({ paths = { './snippets/vscode' } })

  require('luasnip.loaders.from_snipmate').load()
  require('luasnip.loaders.from_snipmate').lazy_load({ paths = vim.g.snipmate_snippets_path or '' })

  require('luasnip.loaders.from_lua').load()
  require('luasnip.loaders.from_lua').lazy_load({ paths = { './snippets' } })
end

---@type LazyPluginSpec
return {
  'L3MON4D3/LuaSnip', -- https://github.com/L3MON4D3/LuaSnip
  build = 'make install_jsregexp',
  dependencies = {
    {
      'rafamadriz/friendly-snippets',
      config = load_snippets,
    },
  },
  config = function()
    local luasnip = require('luasnip')

    local jump_backward = function()
      luasnip.jump(-1)
    end
    local jump_forward = function()
      luasnip.jump(1)
    end
    local jump__backward = function()
      return luasnip.jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
    end

    map({ 'i', 's' }, '<S-Tab>', jump_backward, { silent = true })
    map('s', '<Tab>', jump_forward, { silent = true })
    map('i', '<Tab>', jump__backward, { expr = true, silent = true })

    vim.api.nvim_create_autocmd('InsertLeave', {
      group = vim.api.nvim_create_augroup('LuaSnip', { clear = true }),
      callback = function()
        if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
          luasnip.unlink_current()
        end
      end,
    })
  end,
}