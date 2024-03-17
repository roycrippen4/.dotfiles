local cmp = require('cmp')

-- dofile(vim.g.base46_cache .. 'cmp')

-- local cmp_ui = require('plugins.configs.ui').ui.cmp
-- local cmp_style = cmp_ui.style
local icons = {
  Namespace = '󰌗',
  Text = '󰉿',
  Method = '󰆧',
  Function = '󰆧',
  Constructor = '',
  Field = '󰜢',
  Variable = '󰀫',
  Class = '󰠱',
  Interface = '',
  Module = '',
  Property = '󰜢',
  Unit = '󰑭',
  Value = '󰎠',
  Enum = '',
  Keyword = '󰌋',
  Snippet = '',
  Color = '󰏘',
  File = '󰈚',
  Reference = '󰈇',
  Folder = '󰉋',
  EnumMember = '',
  Constant = '󰏿',
  Struct = '󰙅',
  Event = '',
  Operator = '󰆕',
  TypeParameter = '󰊄',
  Table = '',
  Object = '󰅩',
  Tag = '',
  Array = '[]',
  Boolean = '',
  Number = '',
  Null = '󰟢',
  String = '󰉿',
  Calendar = '',
  Watch = '󰥔',
  Package = '',
  Copilot = '',
  Codeium = '',
  TabNine = '',
}

local field_arrangement = {
  atom = { 'kind', 'abbr', 'menu' },
  atom_colored = { 'kind', 'abbr', 'menu' },
}

-- local format = {
--   fields = field_arrangement[cmp_style] or { 'abbr', 'kind', 'menu' },

--   format = function(_, item)
--     local icon = (cmp_ui.icons and icons[item.kind]) or ''

--     if cmp_style == 'atom' or cmp_style == 'atom_colored' then
--       icon = ' ' .. icon .. ' '
--       item.menu = cmp_ui.lspkind_text and '   (' .. item.kind .. ')' or ''
--       item.kind = icon
--     else
--       icon = cmp_ui.lspkind_text and (' ' .. icon .. ' ') or icon
--       item.kind = string.format('%s %s', icon, cmp_ui.lspkind_text and item.kind or '')
--     end

--     return item
--   end,
-- }

cmp.setup({
  sources = {
    { name = 'nvim_lsp', trigger_characters = { '.', ':', '@' } },
    { name = 'luasnip', keyword_length = 2 },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'crates' },
  },
  preselect = cmp.PreselectMode.Insert,
  -- formatting = format,
  completion = {
    completeopt = 'menu,menuone,noselect',
    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
  },
  window = {
    completion = {
      winhighlight = 'Normal:NormalFloat,CursorLine:CmpSel,Search:PmenuSel',
      scrollbar = true,
      border = 'rounded',
    },
    documentation = {
      border = 'rounded',
      winhighlight = 'Normal:NormalFloat',
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    },
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<ESC>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-S-N>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-S-P>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<Esc>'] = cmp.mapping(cmp.mapping.close(), { 'i', 'c' }),
    ['<CR>'] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      { 'i' }
    ),
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline', option = { ignore_cmds = { 'w', 'wq', 'c', 'cq' } } },
  }),
})
