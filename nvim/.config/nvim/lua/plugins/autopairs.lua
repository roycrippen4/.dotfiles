---@type LazyPluginSpec
return {
  'windwp/nvim-autopairs', -- https://github.com/windwp/nvim-autopairs
  event = 'InsertEnter',
  config = function()
    local _, cmp = pcall(require, 'cmp')
    local _, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
    local _, npairs = pcall(require, 'nvim-autopairs')
    local _, rule = pcall(require, 'nvim-autopairs.rule')
    local _, cond = pcall(require, 'nvim-autopairs.conds')
    npairs.setup({})

    -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    cmp.event:on('confirm_done', function(args)
      local pos = vim.api.nvim_win_get_cursor(0)
      local current_node = vim.treesitter.get_node({ pos = { pos[1] - 1, pos[2] } })

      if not current_node then
        cmp_autopairs.on_confirm_done(args)
        return
      end

      local skip = vim.iter({ 'use_list', 'use_declaration', 'token_tree' }):any(
        ---@param node_name string
        function(node_name)
          return current_node:type() == node_name
        end
      )

      log('should skip?', skip)

      if skip then
        log('skip')
        return
      end

      cmp_autopairs.on_confirm_done(args)
    end)

    -- stylua: ignore
    npairs.add_rule(
      rule('<', '>', { '-html', '-javascriptreact', '-typescriptreact', '-svelte' })
        :with_pair(cond.before_regex('%a+:?:?$', 3))
        :with_move(function(opts) return opts.char == '>' end)
    )


    -- stylua: ignore
    for _, punct in pairs({ ',', ';' }) do
      npairs.add_rule(rule('', punct)
        :with_move(function(opts) return opts.char == punct end)
        :with_pair(function() return false end)
        :with_del(function() return false end)
        :with_cr(function() return false end)
        :use_key(punct))
    end

    -- evens the space between brackets
    -- {|} -> `press space` -> { | }
    local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
    npairs.add_rules({
      rule(' ', ' ')
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
        end),
    })

    -- stylua: ignore
    for _, bracket in pairs(brackets) do
      npairs.add_rule(rule(bracket[1] .. ' ', ' ' .. bracket[2])
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == bracket[2] end)
        :with_del(cond.none())
        :use_key(bracket[2])
        :replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end))
    end
  end,
}
