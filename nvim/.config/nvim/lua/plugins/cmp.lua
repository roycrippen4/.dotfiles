local map = vim.keymap.set
return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        return 'make install_jsregexp'
      end)(),
      config = function()
        map('i', '<Tab>', function()
          return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
        end, { expr = true, silent = true })

        map('s', '<Tab>', function()
          require('luasnip').jump(1)
        end, { silent = true })

        map({ 'i', 's' }, '<S-Tab>', function()
          require('luasnip').jump(-1)
        end, { silent = true })

        vim.api.nvim_create_autocmd('InsertLeave', {
          group = vim.api.nvim_create_augroup('LuaSnip', { clear = true }),
          callback = function()
            if require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()] and not require('luasnip').session.jump_active then
              require('luasnip').unlink_current()
            end
          end,
        })
      end,
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
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
    'luckasRanarison/tailwind-tools.nvim', -- https://github.com/luckasRanarison/tailwind-tools.nvim
    'saadparwaiz1/cmp_luasnip', -- https://github.com/saadparwaiz1/cmp_luasnip
    'hrsh7th/cmp-nvim-lsp', -- https://github.com/hrsh7th/cmp-nvim-lsp
    'hrsh7th/cmp-path', -- https://github.com/hrsh7th/cmp-path
    'hrsh7th/cmp-cmdline', -- https://github.com/hrsh7th/cmp-cmdline
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    luasnip.config.setup({})

    cmp.setup({
      sources = {
        {
          name = 'nvim_lsp',
          trigger_characters = { '.', ':', '@', '-' },
          entry_filter = function(entry, _) ---@param entry function|cmp.Entry
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
