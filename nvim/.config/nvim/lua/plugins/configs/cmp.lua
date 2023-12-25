local cmp = require('cmp')
local copilot_cmp_comparators = require('copilot_cmp.comparators')
local lspkind = require('lspkind')

dofile(vim.g.base46_cache .. 'cmp')

local function deprioritize_snippet(entry1, entry2)
  local types = require('cmp.types')

  if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then
    return false
  end
  if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then
    return true
  end
end

local function under(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find('^_+')
  local _, entry2_under = entry2.completion_item.label:find('^_+')
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

local cmp_ui = require('core.utils').load_config().ui.cmp
local cmp_style = cmp_ui.style

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

local source_icons = {
  copilot = ' ',
  nvim_lsp = '󰒠',
  luasnip = '󰏿',
  nvim_lua = '󰔷 ',
  path = '󰘧',
}

local options = {
  enabled = function()
    local in_prompt = vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt'
    if in_prompt then -- this will disable cmp in the Telescope window (taken from the default config)
      return false
    end
    local context = require('cmp.config.context')
    return not (context.in_treesitter_capture('comment') == true)
  end,

  sources = {
    { name = 'copilot', group_index = 2 },
    {
      name = 'nvim_lsp',
      trigger_characters = { '.' },
      entry_filter = function(entry)
        return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
      end,
    },
    {
      name = 'luasnip',
      entry_filter = function()
        local context = require('cmp.config.context')
        return not context.in_treesitter_capture('string') and not context.in_syntax_group('String')
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
    keyword_length = 2,
  },

  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 80,
      ellipsis_char = '...',

      before = function(entry, vim_item)
        vim_item.menu = source_icons[entry.source.name]
        return vim_item
      end,
    }),
  },

  performance = {
    max_view_entries = 20,
  },
  window = {
    completion = {
      side_padding = (cmp_style ~= 'atom' and cmp_style ~= 'atom_colored') and 1 or 0,
      winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel',
      scrollbar = false,
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
      deprioritize_snippet,
      cmp.config.compare.exact,
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      under,
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
    { name = 'cmdline', option = {
      ignore_cmds = { 'Man', '!' },
    } },
  }),
})

if cmp_style ~= 'atom' and cmp_style ~= 'atom_colored' then
  options.window.completion.border = border('CmpBorder')
end

return options
