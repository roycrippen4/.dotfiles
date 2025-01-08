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
          end,
        },
      },
    },
  },

  ---@type blink.cmp.Config
  opts = {
    keymap = {
      ['<cr>'] = { 'accept', 'fallback' },
      ['<c-n>'] = { 'select_next', 'fallback' },
      ['<c-p>'] = { 'select_prev', 'fallback' },
      ['<C-S-N>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-S-P>'] = { 'scroll_documentation_up', 'fallback' },
      ['<esc>'] = { 'hide', 'fallback' },
    },
    enabled = function()
      local disabled = { 'DressingInput', 'TelescopePrompt' }
      return not vim.tbl_contains(disabled, vim.bo.ft) and vim.bo.buftype ~= 'prompt' and vim.api.nvim_get_mode().mode ~= 'c'
    end,
    snippets = { preset = 'luasnip' },
    completion = {
      trigger = { show_on_blocked_trigger_characters = { ' ', '\n', '\t', '>' } },
      menu = {
        border = 'rounded',
        draw = {
          columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon' }, { 'source_name', gap = 1 } },
          components = {
            kind_icons = {
              ellipsis = false,
              text = function(ctx)
                return ctx.kind_icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or ('BlinkCmpKind' .. ctx.kind)
              end,
            },
            kind = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx)
                return ctx.kind
              end,
              highlight = function(ctx)
                return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or ('BlinkCmpKind' .. ctx.kind)
              end,
            },
            label = {
              width = { fill = true, max = 60 },
              highlight = function(ctx)
                -- label and label details
                local highlights = {
                  { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                }
                if ctx.label_detail then
                  table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
                end

                -- characters matched on the label by the fuzzy matcher
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                end

                return highlights
              end,
            },
            label_description = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.label_description
              end,
              highlight = 'BlinkCmpLabelDescription',
            },
            source_name = {
              width = { max = 30 },
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
        auto_show = true,
        auto_show_delay_ms = 250,
        update_delay_ms = 25,
        window = {
          min_width = 20,
          max_width = 80,
          max_height = 20,
          border = 'rounded',
        },
      },
    },
    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets' },
      providers = {
        lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
      },
      cmdline = {},
    },
  },
  config = function(_, opts)
    require('blink.cmp').setup(opts)
    require('blink.cmp').get_lsp_capabilities(U.capabilities)
  end,
}
