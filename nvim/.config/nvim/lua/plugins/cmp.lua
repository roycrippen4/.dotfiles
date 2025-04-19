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
            local snippet_path = vim.fn.stdpath('config') .. '/snippets'
            require('luasnip').filetype_extend('ts', { 'js' })
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_vscode').load({ paths = { snippet_path } })
            require('luasnip.loaders.from_lua').load({ paths = { snippet_path .. '/lua-snippets' } })
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
      window = { min_width = 20, max_width = 80, max_height = 20 },
    },
    completion = {
      trigger = { show_on_blocked_trigger_characters = { ' ', '\n', '\t', '>' } },
      menu = {
        draw = {
          columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon' }, { 'source_name', gap = 1 } },
          components = { source_name = { text = source_name } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        update_delay_ms = 50,
        window = { min_width = 20, max_width = 80, max_height = 20 },
      },
    },
    cmdline = { enabled = false },
    fuzzy = {
      sorts = {
        function(a, b)
          if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
            return
          end
          return b.client_name == 'zls'
        end,
        'score',
        'sort_text',
      },
    },
    sources = {
      default = { 'lazydev', 'lsp', 'snippets', 'path' },
      providers = {
        lsp = {
          score_offset = function(ctx, _)
            local client = vim.lsp.get_client_by_id(ctx.id)
            return (client and client.name == 'zls') and -3 or 1
          end,
        },
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
