---@module 'blink.cmp'
---@type LazyPluginSpec
return {
  'saghen/blink.cmp',
  lazy = false,
  build = 'cargo build --release',
  dependencies = {
    'saadparwaiz1/cmp_luasnip',
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
          end,
        },
      },
      keys = {
        { mode = { 'i', 's' }, '<tab>' },
        { mode = { 'i', 's' }, '<s-tab>' },
      },
      config = function()
        -- stylua: ignore start
        vim.keymap.set({ 'i', 's' }, '<s-tab>', function() require('luasnip').jump(-1) end, { silent = true })
        vim.keymap.set('s', '<tab>', function() require('luasnip').jump(1) end, { silent = true })
        vim.keymap.set('i', '<tab>', function() return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or "<tab>" end, { expr = true, silent = true })
        -- stylua: ignore end
      end,
    },
    { 'saghen/blink.compat', opts = { impersonate_nvim_cmp = true, debug = true } },
  },
  opts = { ---@type blink.cmp.Config
    keymap = {
      ['<cr>'] = { 'accept', 'fallback' },
      ['<c-n>'] = { 'select_next', 'fallback' },
      ['<c-p>'] = { 'select_prev', 'fallback' },
      ['<C-S-N>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-S-P>'] = { 'scroll_documentation_up', 'fallback' },
      ['<esc>'] = { 'hide', 'fallback' },
    },
    trigger = {
      completion = {
        blocked_trigger_characters = { ' ', '\n', '\t', '>' },
        show_on_accept_on_trigger_character = false,
        show_on_insert_on_trigger_character = false,
        show_in_snippet = true,
      },
    },
    nerd_font_variant = 'mono',
    accept = {
      auto_brackets = { enabled = true },
      expand_snippet = function(...)
        require('luasnip').lsp_expand(...)
      end,
    },
    sources = {
      completion = {
        enabled_providers = { 'lsp', 'path', 'luasnip', 'lazydev' },
      },
      providers = {
        lsp = { name = 'LSP', fallback_for = { 'lazydev' } },
        lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
        luasnip = {
          name = 'luasnip',
          module = 'blink.compat.source',
          score_offset = -3,
          opts = { use_show_condition = false, show_autosnippets = true },
        },
      },
    },
    windows = {
      autocomplete = {
        border = 'rounded',
        ---@diagnostic disable-next-line
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon' },
            { 'source', gap = 1 },
          },
          components = {
            source = {
              text = function(ctx)
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
              end,

              highlight = function()
                return 'BlinkCmpSource'
              end,
            },
          },
        },
      },
      documentation = {
        border = 'rounded',
        auto_show = true,
        auto_show_delay_ms = 250,
        update_delay_ms = 25,
      },
    },
    kind_icons = require('core.icons').cmp,
  },
  config = function(_, opts)
    require('blink.cmp').setup(opts)
    require('blink.cmp').get_lsp_capabilities(U.capabilities)
  end,
}
