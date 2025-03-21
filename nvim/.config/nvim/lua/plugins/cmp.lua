---Gets the lsp's name
---@param ctx blink.cmp.DrawItemContext
---@return string
local function source_name(ctx)
  local source, client_id = ctx.item.source_name, ctx.item.client_id
  if source == 'LSP' and client_id then
    local client = vim.lsp.get_client_by_id(client_id)
    if client then
      source = client.name
    end
  end

  if source == 'Snippets' then
    source = 'Snippet'
  end

  return source
end

---@module 'blink.cmp'
---@type LazyPluginSpec
return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  build = 'cargo build --release',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_vscode').load({ paths = { vim.fn.expand('~/.config/nvim/snippets') } })
            require('luasnip.loaders.from_lua').load({ paths = { vim.fn.expand('~/.config/nvim/snippets/lua-snippets') } })
          end,
        },
      },
    },
  },

  ---@type blink.cmp.Config
  opts = {
    keymap = {
      ['<cr>'] = { 'accept', 'fallback' },
      ['<C-S-N>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-S-P>'] = { 'scroll_documentation_up', 'fallback' },
      ['<esc>'] = { 'hide', 'fallback' },
    },
    snippets = { preset = 'luasnip' },
    signature = {
      enabled = true,
      window = { border = 'rounded', min_width = 20, max_width = 80, max_height = 20 },
    },
    completion = {
      trigger = { show_on_blocked_trigger_characters = { ' ', '\n', '\t', '>' } },
      menu = {
        border = 'rounded',
        draw = {
          columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon' }, { 'source_name', gap = 1 } },
          components = { source_name = { text = source_name } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        update_delay_ms = 50,
        window = { min_width = 20, max_width = 80, max_height = 20, border = 'rounded' },
      },
    },
    cmdline = { enabled = false },
    sources = {
      default = { 'lazydev', 'lsp', 'snippets', 'path' },
      providers = {
        lsp = { score_offset = 1 },
        lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
        snippets = { score_offset = 0 },
        path = {
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
      },
    },
  },
}
