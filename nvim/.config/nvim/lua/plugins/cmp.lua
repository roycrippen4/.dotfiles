---@module 'blink.cmp'
---@type LazyPluginSpec
return {
  'saghen/blink.cmp',
  lazy = false,
  build = 'cargo build --release',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_vscode').load({ paths = { vim.fn.expand('~/.config/nvim/snippets') } })
          end,
        },
      },
      keys = {
        { mode = { 'i', 's' }, '<tab>' },
        { mode = { 'i', 's' }, '<s-tab>' },
      },
      config = function()
        -- stylua: ignore start
        vim.keymap.set({ 'i', 's' }, '<s-tab>', function() require('luasnip').jump(-1) end, { silent = true })
        vim.keymap.set('s', '<tab>', function() require('luasnip').jump(1) end, { silent = true })
        vim.keymap.set('i', '<tab>', function() return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or "<tab>" end, { expr = true, silent = true })
        -- stylua: ignore end
      end,
    },
    -- { 'saghen/blink.compat', opts = { impersonate_nvim_cmp = true } },
  },
  opts = { ---@type blink.cmp.Config
    keymap = {
      ['<cr>'] = { 'accept', 'fallback' },
      ['<c-n>'] = { 'select_next', 'fallback' },
      ['<c-p>'] = { 'select_prev', 'fallback' },
      ['<C-S-N>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-S-P>'] = { 'scroll_documentation_up', 'fallback' },
      ['<esc>'] = { 'hide', 'fallback' },
    },
    snippets = {
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },
    completion = {
      keyword = {
        range = 'prefix',
        regex = '[%w_\\-]',
        exclude_from_prefix_regex = '[\\-]',
      },
      trigger = {
        show_in_snippet = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_blocked_trigger_characters = { ' ', '\n', '\t', '>' },
        show_on_accept_on_trigger_character = true,
        show_on_insert_on_trigger_character = true,
        show_on_x_blocked_trigger_characters = { "'", '"', '(' },
      },
      list = {
        max_items = 200,
        selection = 'preselect',
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },
      accept = {
        create_undo_point = true,
        ---@diagnostic disable-next-line
        auto_brackets = {
          enabled = true,
          semantic_token_resolution = { enabled = true, blocked_filetypes = {}, timeout_ms = 400 },
          default_brackets = { '(', ')' },
          override_brackets_for_filetypes = {},
          kind_resolution = { enabled = true, blocked_filetypes = { 'typescriptreact', 'javascriptreact', 'vue', 'svelte' } },
        },
      },

      ---@diagnostic disable-next-line
      menu = {
        enabled = true,
        min_width = 15,
        max_height = 10,
        border = 'rounded',
        winblend = 0,
        winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        scrolloff = 2,
        scrollbar = true,
        direction_priority = { 's', 'n' },
        draw = {
          align_to_component = 'label',
          padding = 1,
          gap = 1,
          columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon' }, { 'source_name', gap = 1 } },
          components = {

            kind_icons = {
              ellipsis = false,
              text = function(ctx)
                return ctx.kind_icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or ('BlinkCmpKind' .. ctx.kind)
              end,
            },

            kind = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx)
                return ctx.kind
              end,
              highlight = function(ctx)
                return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or ('BlinkCmpKind' .. ctx.kind)
              end,
            },

            label = {
              width = { fill = true, max = 60 },
              highlight = function(ctx)
                -- label and label details
                local highlights = {
                  { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                }
                if ctx.label_detail then
                  table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
                end

                -- characters matched on the label by the fuzzy matcher
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                end

                return highlights
              end,
            },

            label_description = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.label_description
              end,
              highlight = 'BlinkCmpLabelDescription',
            },

            source_name = {
              width = { max = 30 },
              text = function(ctx)
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

                return source
              end,
              highlight = function()
                return 'BlinkCmpSource'
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        update_delay_ms = 25,
        treesitter_highlighting = true,
        ---@diagnostic disable-next-line
        window = {
          min_width = 20,
          max_width = 80,
          max_height = 20,
          border = 'rounded',
          winblend = 0,
          winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
          scrollbar = true,
          direction_priority = {
            menu_north = { 'e', 'w', 'n', 's' },
            menu_south = { 'e', 'w', 's', 'n' },
          },
        },
      },
      ghost_text = { enabled = false },
    },
    signature = {
      enabled = false,
      trigger = {
        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
        show_on_insert_on_trigger_character = true,
      },
      window = {
        min_width = 1,
        max_width = 100,
        max_height = 10,
        border = 'padded',
        winblend = 0,
        winhighlight = 'Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder',
        scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
        direction_priority = { 'n', 's' },
        treesitter_highlighting = true,
      },
    },
    fuzzy = {
      use_typo_resistance = true,
      use_frecency = true,
      use_proximity = true,
      max_items = 200,
      sorts = { 'label', 'kind', 'score' },
      prebuilt_binaries = { download = true, force_version = nil, force_system_triple = nil },
    },
    sources = {
      completion = {
        enabled_providers = { 'lsp', 'path', 'luasnip', 'lazydev' },
      },
      providers = {
        lsp = { name = 'LSP', fallback_for = { 'lazydev' } },
        lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
        -- luasnip = {
        --   name = 'luasnip',
        --   module = 'blink.compat.source',
        --   score_offset = -3,
        --   opts = { use_show_condition = false, show_autosnippets = true },
        -- },
      },
    },
  },
  config = function(_, opts)
    require('blink.cmp').setup(opts)
    require('blink.cmp').get_lsp_capabilities(U.capabilities)
  end,
}
