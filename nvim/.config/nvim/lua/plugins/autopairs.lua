---@type LazyPluginSpec
return {
  'windwp/nvim-autopairs', -- https://github.com/windwp/nvim-autopairs
  lazy = false,
  config = function()
    local _, npairs = pcall(require, 'nvim-autopairs')
    local _, rule = pcall(require, 'nvim-autopairs.rule')
    local _, cond = pcall(require, 'nvim-autopairs.conds')
    npairs.setup({})

    require('nvim-autopairs').get_rules("'")[1].not_filetypes = { 'ocamlinterface' }

    -- stylua: ignore
    npairs.add_rule(
      rule('<', '>', { '-html', '-javascriptreact', '-typescriptreact', '-svelte', '-lua' })
        :with_pair(cond.before_regex('%a+:?:?$', 3))
        :with_move(function(opts) return opts.char == '>' end)
    )

    -- stylua: ignore
    npairs.add_rule(rule('|', '|', { 'rust' }):with_move(function(opts) return opts.char == '|' end))

    -- stylua: ignore
    vim.iter({ ',', ';' }):each(function(punct)
      npairs.add_rule(rule('', punct)
        :with_move(function(opts) return opts.char == punct end)
        :with_pair(function() return false end)
        :with_del(function() return false end)
        :with_cr(function() return false end)
        :use_key(punct))
    end)

    -- evens the space between brackets
    -- {|} -> `press space` -> { | }
    local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
    npairs.add_rule(rule(' ', ' ')
      :with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({
          brackets[1][1] .. brackets[1][2],
          brackets[2][1] .. brackets[2][2],
          brackets[3][1] .. brackets[3][2],
        }, pair)
      end)
      :with_move(cond.none())
      :with_cr(cond.none())
      :with_del(function(opts)
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local context = opts.line:sub(col - 1, col + 2)
        return vim.tbl_contains({
          brackets[1][1] .. '  ' .. brackets[1][2],
          brackets[2][1] .. '  ' .. brackets[2][2],
          brackets[3][1] .. '  ' .. brackets[3][2],
        }, context)
      end))

    -- stylua: ignore
    vim.iter(brackets):each(function(bracket)
      npairs.add_rule(rule(bracket[1] .. ' ', ' ' .. bracket[2])
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == bracket[2] end)
        :with_del(cond.none())
        :use_key(bracket[2])
        :replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end))
    end)
  end,
}
