---@diagnostic disable: undefined-global

return {
  -- s({
  --   trig = 'log',
  --   name = 'console.log',
  --   dscr = {
  --     'console.log(…)',
  --   },
  -- }, {
  --   t('console.log('),
  --   i(1),
  --   t(')'),
  -- }),

  s({
    trig = 'afn',
    name = 'Anon func',
    dscr = {
      '(…) => { … }',
    },
  }, {
    t('('),
    i(1),
    t(') => {'),
    -- first method argument
    i(0),
    t('}'),
  }),
}
