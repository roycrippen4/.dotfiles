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
    { name = 'nvim_lsp', trigger_characters = { '.', ':' } },
    {
      name = 'buffer',
      keyword_length = 5,
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
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
  experimental = {
    ghost_text = true,
  },
  preselect = cmp.PreselectMode.None,
  formatting = format,
  completion = {
    completeopt = 'menu,menuone,noselect',
    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
  },
  window = {
    completion = {
      winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel',
      scrollbar = true,
      border = 'rounded',
    },
    documentation = {
      border = 'rounded',
      winhighlight = 'Normal:CmpDoc',
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
    ['<C-j>'] = cmp.mapping.scroll_docs(-4),
    ['<C-k>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-t>'] = cmp.mapping.complete(),
    ['<Esc>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if require('luasnip').expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if require('luasnip').jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<BS>'] = cmp.mapping(function(fallback)
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))

      if row == 1 and col == 0 then
        return
      end

      cmp.close()

      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]

      local ts = require('nvim-treesitter.indent')
      local indent = ts.get_indent(row) or 0

      if vim.fn.strcharpart(line, indent - 1, col - indent + 1):gsub('%s+', '') == '' then
        if indent > 0 and col > indent then
          local new_line = vim.fn.strcharpart(line, 0, indent) .. vim.fn.strcharpart(line, col)
          vim.api.nvim_buf_set_lines(0, row - 1, row, true, {
            new_line,
          })
          vim.api.nvim_win_set_cursor(0, { row, math.min(indent, vim.fn.strcharlen(new_line)) })
        elseif row > 1 and (indent > 0 and col + 1 > indent) then
          local prev_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, true)[1]
          if vim.trim(prev_line) == '' then
            local prev_indent = ts.get_indent(row - 1) or 0
            local new_line = vim.fn.strcharpart(line, 0, prev_indent) .. vim.fn.strcharpart(line, col)
            vim.api.nvim_buf_set_lines(0, row - 2, row, true, {
              new_line,
            })

            vim.api.nvim_win_set_cursor(0, {
              row - 1,
              math.max(0, math.min(prev_indent, vim.fn.strcharlen(new_line))),
            })
          else
            local len = vim.fn.strcharlen(prev_line)
            local new_line = prev_line .. vim.fn.strcharpart(line, col)
            vim.api.nvim_buf_set_lines(0, row - 2, row, true, {
              new_line,
            })
            vim.api.nvim_win_set_cursor(0, { row - 1, math.max(0, len) })
          end
        else
          fallback()
        end
      else
        fallback()
      end
    end, { 'i' }),
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

-- Override the documentation handler to remove the redundant detail section.
---@diagnostic disable-next-line: duplicate-set-field
require('cmp.entry').get_documentation = function(self)
  local item = self:get_completion_item()

  if item.documentation then
    return vim.lsp.util.convert_input_to_markdown_lines(item.documentation)
  end

  if item.detail then
    local ft = self.context.filetype
    local dot_idx = string.find(ft, '%.')
    if dot_idx ~= nil then
      ft = string.sub(ft, 0, dot_idx - 1)
    end
    return (vim.split(('```%s\n%s```'):format(ft, vim.trim(item.detail)), '\n'))
  end

  return {}
end
