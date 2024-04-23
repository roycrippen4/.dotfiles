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

  s({
    trig = 'script',
    name = 'svelte-script',
    dscr = {
      '<script>',
      '  …',
      '</script>',
    },
  }, {
    t('<script lang="ts">'),
    t({ '', '' }),
    t({ '\t' }),
    i(0),
    t({ '', '' }),
    t('</script>'),
  }),
}
