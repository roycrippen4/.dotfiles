---@diagnostic disable: undefined-global

return {
  postfix('.log', {
    f(function(_, parent)
      return 'console.log(' .. parent.snippet.env.POSTFIX_MATCH .. ')'
    end, {}),
  }),

  s({
    trig = 'arr',
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
