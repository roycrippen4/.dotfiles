local cmp = require('cmp')

dofile(vim.g.base46_cache .. 'cmp')

local kind = cmp.lsp.CompletionItemKind
local cmp_ui = require('nvconfig').ui.cmp
local cmp_style = cmp_ui.style

local field_arrangement = {
  atom = { 'kind', 'abbr', 'menu' },
  atom_colored = { 'kind', 'abbr', 'menu' },
}

local format = {
  fields = field_arrangement[cmp_style] or { 'abbr', 'kind', 'menu' },

  format = function(_, item)
    local icons = require('nvchad.icons.lspkind')
    local icon = (cmp_ui.icons and icons[item.kind]) or ''

    if cmp_style == 'atom' or cmp_style == 'atom_colored' then
      icon = ' ' .. icon .. ' '
      item.menu = cmp_ui.lspkind_text and '   (' .. item.kind .. ')' or ''
      item.kind = icon
    else
      icon = cmp_ui.lspkind_text and (' ' .. icon .. ' ') or icon
      item.kind = string.format('%s %s', icon, cmp_ui.lspkind_text and item.kind or '')
    end

    return item
  end,
}

cmp.event:on('confirm_done', function(event)
  local completion_kind = event.entry:get_completion_item().kind

  if vim.tbl_contains({ kind.Function, kind.Method }, completion_kind) and vim.bo.ft ~= 'rust' then
    local left = vim.api.nvim_replace_termcodes('<Left>', true, true, true)
    vim.api.nvim_feedkeys('()' .. left, 'n', false)
  end
end)

cmp.setup({
  sources = {
    { name = 'luasnip', keyword_length = 2 },
    { name = 'nvim_lsp', trigger_characters = { '.', ':', '@' } },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
    { name = 'crates' },
  },
  sorting = {
    priority_weight = 10,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.scopes,
      cmp.config.compare.kind,
      cmp.config.compare.locality,
      cmp.config.compare.order,
    },
  },
  preselect = cmp.PreselectMode.Insert,
  formatting = format,
  completion = {
    completeopt = 'menu,menuone,noselect',
    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
  },
  window = {
    completion = {
      winhighlight = 'Normal:NormalFloat,CursorLine:CmpSel,Search:PmenuSel',
      scrollbar = true,
      -- border = 'rounded',
    },
    documentation = {
      -- border = 'rounded',
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
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-S-N>'] = cmp.mapping.scroll_docs(4),
    ['<C-S-P>'] = cmp.mapping.scroll_docs(-4),
    ['<Esc>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' },
      },
    },
  }),
})
