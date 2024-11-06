-- local name_map = {
--   inline = 'Fg',
--   foreground = 'Fg',
--   background = 'Bg',
-- }

-- ---@param red number
-- ---@param green number
-- ---@param blue number
-- ---@param kind TailwindTools.ColorHint
-- local function set_hl_from(red, green, blue, kind)
--   local color = string.format('%02x%02x%02x', red, green, blue)
--   local group = 'TailwindColor' .. name_map[kind] .. color
--   local opts

--   if kind == 'background' then
--     local luminance = red * 0.299 + green * 0.587 + blue * 0.114
--     local fg = luminance > 186 and '#000000' or '#FFFFFF'
--     opts = { fg = fg, bg = '#' .. color }
--   else
--     opts = { fg = '#' .. color }
--   end

--   if vim.fn.hlID(group) < 1 then
--     vim.api.nvim_set_hl(0, group, opts)
--   end

--   return group
-- end

-- ---@param text string
-- ---@param max_width number
-- local function truncate(text, max_width)
--   if #text > max_width then
--     return string.sub(text, 1, max_width) .. '…'
--   else
--     return text
--   end
-- end

-- local function get_lsp_detail_txt(cmp_item, lspserver_name)
--   if not cmp_item.detail then
--     return nil
--   end

--   if cmp_item.detail == 'Auto-import' then
--     local label = (cmp_item.labelDetails or {}).description

--     if not label or label == '' then
--       return nil
--     end

--     local logo = ({ pyright = '', basedpyright = '' })[lspserver_name] or '󰋺'
--     return logo .. ' ' .. truncate(label, 20)
--   else
--     return truncate(cmp_item.detail, 50)
--   end
-- end

-- ---@param entry cmp.Entry
-- ---@param vim_item vim.CompletedItem
-- local function format(entry, vim_item)
--   vim_item.abbr = truncate(vim_item.abbr, 80)
--   pcall(function() -- protect the call against potential API breakage (lspkind GH-45).
--     local lspkind = require('lspkind')
--     ---@diagnostic disable-next-line
--     vim_item.kind_symbol = (lspkind.symbolic or lspkind.get_symbol)(vim_item.kind)
--     vim_item.kind = ' ' .. vim_item.kind_symbol .. ' ' .. vim_item.kind
--   end)

--   -- The 'menu' section: source, detail information (lsp, snippet), etc.
--   -- set a name for each source (see the sources section below)
--   vim_item.menu = ({
--     buffer = 'Buffer',
--     nvim_lsp = 'LSP',
--     ultisnips = '',
--     nvim_lua = 'Lua',
--     latex_symbols = 'Latex',
--   })[entry.source.name] or string.format('%s', entry.source.name)

--   -- highlight groups for item.menu
--   vim_item.menu_hl_group = ({
--     buffer = 'CmpItemMenuBuffer',
--     nvim_lsp = 'CmpItemMenuLSP',
--     path = 'CmpItemMenuPath',
--     ultisnips = 'CmpItemMenuSnippet',
--   })[entry.source.name] -- default is CmpItemMenu

--   local cmp_item = entry.completion_item --- @type lsp.CompletionItem

--   if entry.source.name == 'nvim_lsp' then
--     local lspserver_name = nil
--     pcall(function()
--       lspserver_name = entry.source.source.client.name
--       vim_item.menu = lspserver_name
--     end)

--     if lspserver_name == 'tailwindcss' then
--       local doc = entry.completion_item.documentation

--       if vim_item.kind:match('Color') and doc then
--         vim_item.kind = ' '
--         local content = type(doc) == 'string' and doc or doc.value

--         local base, _, _, _r, _g, _b = 10, content:find('rgba?%((%d+), (%d+), (%d+)')

--         if not _r then
--           base, _, _, _r, _g, _b = 16, content:find('#(%x%x)(%x%x)(%x%x)')
--         end

--         if _r then
--           local r, g, b = tonumber(_r, base), tonumber(_g, base), tonumber(_b, base)
--           ---@diagnostic disable-next-line
--           vim_item.kind_hl_group = set_hl_from(r, g, b, 'foreground')
--         end
--       end

--       return vim_item
--     end

--     local detail_txt = get_lsp_detail_txt(cmp_item, lspserver_name)

--     if detail_txt then
--       vim_item.menu = detail_txt
--       vim_item.menu_hl_group = 'CmpItemMenuDetail'
--     end
--   elseif entry.source.name == 'zsh' then
--     local detail = tostring(cmp_item.documentation)
--     if detail then
--       vim_item.menu = detail
--       vim_item.menu_hl_group = 'CmpItemMenuZsh'
--       vim_item.kind = '  ' .. 'zsh'
--     end
--   end

--   -- Add a little bit more padding
--   vim_item.menu = ' ' .. vim_item.menu
--   return vim_item
-- end

-- fun(ctx: ):blink.cmp.Component[])

---@param ctx blink.cmp.CompletionRenderContext
---@return blink.cmp.Component[]
local function draw(ctx)
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

  -- local source, client = ctx.item.source_id, ctx.item.client_id
  -- if client and vim.lsp.get_client_by_id(client).name == 'emmet_language_server' then
  --   source = 'emmet'
  -- end

  -- local sourceIcons = { snippets = '󰩫', buffer = '󰦨', emmet = '' }
  -- local icon = sourceIcons[source] or ctx.kind_icon

  return {
    {
      ' ' .. ctx.item.label,
      hl_group = ctx.deprecated and 'CmpItemDeprecated' or 'BlinkCmpLabel',
      fill = true,
    },
    {
      ' ' .. ctx.kind_icon,
      hl_group = 'BlinkCmpKind' .. ctx.kind,
      fill = true,
    },
    {
      ' ' .. source .. ' ',
      hl_group = 'BlinkCmpSource',
      fill = true,
    },
    -- {
    --   'source',
    --   hl_group = 'TestSource',
    -- },
    -- {
    --   ' ' .. ctx.item.label .. ' ',
    --   hl_group = ctx.deprecated and 'CmpItemDeprecated' or 'BlinkCmpLabel',
    -- },
    -- { icon .. ' ', hl_group = 'BlinkCmpKind' .. ctx.kind },
  }
end

return {
  'saghen/blink.cmp',
  lazy = false,
  -- dependencies = 'rafamadriz/friendly-snippets',
  version = 'v0.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
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
        draw = draw,
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
