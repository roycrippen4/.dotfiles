---@module 'blink.cmp'
---@type LazyPluginSpec
return {
  'saghen/blink.cmp',
  lazy = false,
  build = 'cargo build --release',
  dependencies = 'rafamadriz/friendly-snippets',
  opts = { ---@type blink.cmp.Config
    keymap = {
      ['<cr>'] = { 'accept', 'fallback' },
      ['<tab>'] = { 'snippet_forward', 'fallback' },
      ['<s-tab>'] = { 'snippet_backward', 'fallback' },
      ['<c-n>'] = { 'select_next', 'fallback' },
      ['<c-p>'] = { 'select_prev', 'fallback' },
      ['<C-S-N>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-S-P>'] = { 'scroll_documentation_up', 'fallback' },
      ['<esc>'] = { 'hide', 'fallback' },
    },
    trigger = {
      completion = {
        blocked_trigger_characters = { ' ', '\n', '\t', '>', '/' },
        show_on_accept_on_trigger_character = false,
        show_on_insert_on_trigger_character = false,
        show_in_snippet = true,
      },
    },
    nerd_font_variant = 'mono',
    accept = { auto_brackets = { enabled = true } },
    sources = {
      completion = {
        enabled_providers = { 'lsp', 'path', 'snippets', 'lazydev' },
      },
      providers = {
        lsp = { fallback_for = { 'lazydev' } },
        lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
        snippets = { score_offset = -4 },
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
    require('blink.cmp').get_lsp_capabilities(require('core.utils').capabilities)
  end,
}
