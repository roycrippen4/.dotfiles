---@diagnostic disable: undefined-global

return {
  s('dnl', { t('---@diagnostic disable-next-line') }),

  s({
    trig = 'defer',
    name = 'defer_fn',
    dscr = {
      'defer_fn(…, …)',
    },
  }, {
    t({ 'vim.defer_fn(function()', '\t' }),
    -- function name
    i(1),
    t({ '\t', 'end, ' }),
    i(2, '0'),
    t(')'),
  }),
}

-- vim.defer_fn(function()
--   |
-- end, |)
