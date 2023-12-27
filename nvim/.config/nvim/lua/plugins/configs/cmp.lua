local cmp = require('cmp')
local copilot_cmp_comparators = require('copilot_cmp.comparators')

dofile(vim.g.base46_cache .. 'cmp')

local function border(hl_name)
  return {
    { '╭', hl_name },
    { '─', hl_name },
    { '╮', hl_name },
    { '│', hl_name },
    { '╯', hl_name },
    { '─', hl_name },
    { '╰', hl_name },
    { '│', hl_name },
  }
end

local options = {
  sources = {
    { name = 'copilot' },
    {
      name = 'nvim_lsp',
      trigger_characters = { '.', ':' },
      entry_filter = function(entry)
        return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
      end,
    },
    {
      name = 'luasnip',
      entry_filter = function()
        local context = require('cmp.config.context')
        return not context.in_treesitter_capture('string') and not context.in_treesitter_capture('comment')
      end,
    },
    {
      name = 'nvim_lua',
      entry_filter = function()
        local context = require('cmp.config.context')
        return not context.in_treesitter_capture('string') and not context.in_syntax_group('String')
      end,
    },
    { name = 'path' },
  },
  experimental = {
    ghost_text = true,
  },
  completion = {
    completeopt = 'menu,menuone,noselect',
    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
  },
  performance = {
    max_view_entries = 20,
  },
  window = {
    completion = {
      winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel',
      scrollbar = false,
      border = border('CmpBorder'),
    },
    documentation = {
      border = border('CmpDocBorder'),
      winhighlight = 'Normal:CmpDoc',
    },
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  matching = {
    disallow_fuzzy_matching = true,
    disallow_fullfuzzy_matching = true,
    disallow_partial_fuzzy_matching = true,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = true,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      -- Definitions of compare function https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
      copilot_cmp_comparators.prioritize or function() end,
      cmp.config.compare.exact,
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      cmp.config.compare.score,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,
      cmp.config.compare.sort_text,
    },
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
}

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

-- `:` cmdline setup.
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

return options
