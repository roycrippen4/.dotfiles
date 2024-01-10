local cmp = require('cmp')

dofile(vim.g.base46_cache .. 'cmp')

local kind = cmp.lsp.CompletionItemKind
local cmp_ui = require('nvconfig').ui.cmp
local cmp_style = cmp_ui.style

local field_arrangement = {
  atom = { 'kind', 'abbr', 'menu' },
  atom_colored = { 'kind', 'abbr', 'menu' },
}

local formatting_style = {
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

  if vim.tbl_contains({ kind.Function, kind.Method }, completion_kind) then
    local left = vim.api.nvim_replace_termcodes('<Left>', true, true, true)
    vim.api.nvim_feedkeys('()' .. left, 'n', false)
  end
end)

cmp.setup({
  sources = {
    { name = 'nvim_lsp', trigger_characters = { '.', ':' } },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'path' },
  },
  experimental = {
    ghost_text = true,
  },
  formatting = formatting_style,
  completion = {
    completeopt = 'menu,menuone,noselect',
    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
  },
  window = {
    completion = {
      winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel',
      scrollbar = false,
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
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-t>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require('luasnip').jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end, {
      'i',
      's',
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
