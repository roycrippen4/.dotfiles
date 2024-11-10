-- ---@param ctx blink.cmp.CompletionRenderContext
-- ---@return blink.cmp.Component[]
-- local function draw(ctx)
--   local source, client_id = ctx.item.source_name, ctx.item.client_id

--   if source == 'LSP' and client_id then
--     local client = vim.lsp.get_client_by_id(client_id)

--     if client then
--       source = client.name
--     end
--   end

--   if source == 'Snippets' then
--     source = 'Snippet'
--   end

--   return {
--     {
--       ' ' .. ctx.item.label,
--       hl_group = ctx.deprecated and 'CmpItemDeprecated' or 'BlinkCmpLabel',
--       fill = true,
--     },
--     {
--       ' ' .. ctx.kind_icon,
--       hl_group = 'BlinkCmpKind' .. ctx.kind,
--       fill = true,
--     },
--     {
--       ' ' .. source .. ' ',
--       hl_group = 'BlinkCmpSource',
--       fill = true,
--     },
--   }
-- end

return {
  'saghen/blink.cmp',
  lazy = false,
  build = 'cargo build --release',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config,
  opts = {
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
        -- draw = draw,
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
