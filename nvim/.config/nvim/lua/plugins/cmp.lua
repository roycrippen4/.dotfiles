local map = vim.keymap.set

local name_map = {
  inline = 'Fg',
  foreground = 'Fg',
  background = 'Bg',
}

---@param red number
---@param green number
---@param blue number
---@param kind TailwindTools.ColorHint
local function set_hl_from(red, green, blue, kind)
  local color = string.format('%02x%02x%02x', red, green, blue)
  local group = 'TailwindColor' .. name_map[kind] .. color
  local opts

  if kind == 'background' then
    local luminance = red * 0.299 + green * 0.587 + blue * 0.114
    local fg = luminance > 186 and '#000000' or '#FFFFFF'
    opts = { fg = fg, bg = '#' .. color }
  else
    opts = { fg = '#' .. color }
  end

  if vim.fn.hlID(group) < 1 then
    vim.api.nvim_set_hl(0, group, opts)
  end

  return group
end

---@param text string
---@param max_width number
local function truncate(text, max_width)
  if #text > max_width then
    return string.sub(text, 1, max_width) .. '…'
  else
    return text
  end
end

local function get_lsp_detail_txt(cmp_item, lspserver_name)
  if not cmp_item.detail then
    return nil
  end

  if cmp_item.detail == 'Auto-import' then
    local label = (cmp_item.labelDetails or {}).description

    if not label or label == '' then
      return nil
    end

    local logo = ({ pyright = '', basedpyright = '' })[lspserver_name] or '󰋺'
    return logo .. ' ' .. truncate(label, 20)
  else
    return truncate(cmp_item.detail, 50)
  end
end

---@param entry cmp.Entry
---@param vim_item vim.CompletedItem
local function format(entry, vim_item)
  vim_item.abbr = truncate(vim_item.abbr, 80)
  pcall(function() -- protect the call against potential API breakage (lspkind GH-45).
    local lspkind = require('lspkind')
    ---@diagnostic disable-next-line
    vim_item.kind_symbol = (lspkind.symbolic or lspkind.get_symbol)(vim_item.kind)
    vim_item.kind = ' ' .. vim_item.kind_symbol .. ' ' .. vim_item.kind
  end)

  -- The 'menu' section: source, detail information (lsp, snippet), etc.
  -- set a name for each source (see the sources section below)
  vim_item.menu = ({
    buffer = 'Buffer',
    nvim_lsp = 'LSP',
    ultisnips = '',
    nvim_lua = 'Lua',
    latex_symbols = 'Latex',
  })[entry.source.name] or string.format('%s', entry.source.name)

  -- highlight groups for item.menu
  vim_item.menu_hl_group = ({
    buffer = 'CmpItemMenuBuffer',
    nvim_lsp = 'CmpItemMenuLSP',
    path = 'CmpItemMenuPath',
    ultisnips = 'CmpItemMenuSnippet',
  })[entry.source.name] -- default is CmpItemMenu

  local cmp_item = entry:get_completion_item() --- @type lsp.CompletionItem

  if entry.source.name == 'nvim_lsp' then
    local lspserver_name = nil
    pcall(function()
      lspserver_name = entry.source.source.client.name
      vim_item.menu = lspserver_name
    end)

    if lspserver_name == 'tailwindcss' then
      local doc = entry.completion_item.documentation

      if vim_item.kind:match('Color') and doc then
        vim_item.kind = ' '
        local content = type(doc) == 'string' and doc or doc.value

        local base, _, _, _r, _g, _b = 10, content:find('rgba?%((%d+), (%d+), (%d+)')

        if not _r then
          base, _, _, _r, _g, _b = 16, content:find('#(%x%x)(%x%x)(%x%x)')
        end

        if _r then
          local r, g, b = tonumber(_r, base), tonumber(_g, base), tonumber(_b, base)
          vim_item.kind_hl_group = set_hl_from(r, g, b, 'foreground')
        end
      end

      return vim_item
    end

    local detail_txt = get_lsp_detail_txt(cmp_item, lspserver_name)

    if detail_txt then
      vim_item.menu = detail_txt
      vim_item.menu_hl_group = 'CmpItemMenuDetail'
    end
  elseif entry.source.name == 'zsh' then
    local detail = tostring(cmp_item.documentation)
    if detail then
      vim_item.menu = detail
      vim_item.menu_hl_group = 'CmpItemMenuZsh'
      vim_item.kind = '  ' .. 'zsh'
    end
  end

  -- Add a little bit more padding
  vim_item.menu = ' ' .. vim_item.menu
  return vim_item
end

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    { ---@type LazyPluginSpec
      'L3MON4D3/LuaSnip',
      build = 'make install_jsregexp',
      config = function()
        local luasnip = require('luasnip')

        -- stylua: ignore start
        map({ 'i', 's' }, '<S-Tab>', function() luasnip.jump(-1) end, { silent = true })
        map('s', '<Tab>', function() luasnip.jump(1) end, { silent = true })
        map('i', '<Tab>', function() return luasnip.jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>' end, { expr = true, silent = true })
        -- stylua: ignore end

        vim.api.nvim_create_autocmd('InsertLeave', {
          group = vim.api.nvim_create_augroup('LuaSnip', { clear = true }),
          callback = function()
            if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
              luasnip.unlink_current()
            end
          end,
        })
      end,
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip').filetype_extend('svelte', { 'javascript' })
            require('luasnip').filetype_extend('javascriptreact', { 'javascript' })
            require('luasnip').filetype_extend('typescriptreact', { 'javascript' })
            require('luasnip').filetype_extend('typescript', { 'javascript' })

            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_vscode').lazy_load({ paths = vim.g.vscode_snippets_path or '' })

            require('luasnip.loaders.from_snipmate').load()
            require('luasnip.loaders.from_snipmate').lazy_load({ paths = vim.g.snipmate_snippets_path or '' })

            require('luasnip.loaders.from_lua').load()
            require('luasnip.loaders.from_lua').lazy_load({ paths = { './snippets' } })
          end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip', -- https://github.com/saadparwaiz1/cmp_luasnip
    'hrsh7th/cmp-nvim-lsp', -- https://github.com/hrsh7th/cmp-nvim-lsp
    'hrsh7th/cmp-path', -- https://github.com/hrsh7th/cmp-path
    'hrsh7th/cmp-cmdline', -- https://github.com/hrsh7th/cmp-cmdline
    'onsails/lspkind.nvim', -- https://github.com/onsails/lspkind.nvim
  },
  config = function()
    local cmp = require('cmp')
    -- local luasnip = require('luasnip')
    -- luasnip.config.setup({})

    cmp.setup({
      formatting = {
        format = function(...)
          return format(...)
        end,
        expandable_indicator = true,
        fields = { 'abbr', 'kind', 'menu' },
      },
      sources = {
        { name = 'lazydev', group_index = 0 },
        {
          name = 'nvim_lsp',
          trigger_characters = { '.', ':', '@', '-' },

          ---@param entry function|cmp.Entry
          entry_filter = function(entry, _)
            if entry:get_completion_item().label == 'script' and vim.bo.ft == 'svelte' then
              return false
            end

            return not entry:is_deprecated()
          end,
        },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'crates' },
      },
      preselect = cmp.PreselectMode.None,
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
        end, { 'i', 's', 'c' }),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        ['<C-S-N>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-S-P>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
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
  end,
}
