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
    i(1),
    t({ '\t', 'end, ' }),
    i(0, '0'),
    t(')'),
  }),

  s({
    trig = 'schedule',
    name = 'schedule_fn',
    dscr = {
      'schedule(…)',
    },
  }, {
    t({ 'vim.schedule(function()', '\t' }),
    i(0),
    t({ '\t', 'end' }),
    t(')'),
  }),

  s({
    trig = 'callback',
    name = 'callback',
    dscr = {
      'callback = function() … end',
    },
  }, {
    t({ 'callback = function()', '\t' }),
    i(0),
    t({ '\t', 'end,' }),
  }),
}
