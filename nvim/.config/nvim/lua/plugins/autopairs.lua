---@type LazyPluginSpec
return {
  'windwp/nvim-autopairs', -- https://github.com/windwp/nvim-autopairs
  event = 'InsertEnter',
  config = function()
    local cmp_ok, cmp = pcall(require, 'cmp')
    local cmp_pairs_ok, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
    local pairs_ok, npairs = pcall(require, 'nvim-autopairs')
    local rule_ok, rule = pcall(require, 'nvim-autopairs.rule')
    local conds_ok, conds = pcall(require, 'nvim-autopairs.conds')

    if not pairs_ok then
      return
    end

    npairs.setup({})

    if not rule_ok then
      return
    end

    if not conds_ok then
      return
    end

    if not cmp_pairs_ok then
      return
    end

    if not cmp_ok then
      return
    end

    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

    for _, punct in pairs({ ',', ';' }) do
      npairs.add_rules({
        rule('', punct)
          :with_move(function(opts)
            return opts.char == punct
          end)
          :with_pair(function()
            return false
          end)
          :with_del(function()
            return false
          end)
          :with_cr(function()
            return false
          end)
          :use_key(punct),
      })
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
        :with_move(conds.none())
        :with_cr(conds.none())
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

    for _, bracket in pairs(brackets) do
      npairs.add_rules({
        rule(bracket[1] .. ' ', ' ' .. bracket[2])
          :with_pair(conds.none())
          :with_move(function(opts)
            return opts.char == bracket[2]
          end)
          :with_del(conds.none())
          :use_key(bracket[2])
          :replace_map_cr(function(_)
            return '<C-c>2xi<CR><C-c>O'
          end),
      })
    end
  end,
}
