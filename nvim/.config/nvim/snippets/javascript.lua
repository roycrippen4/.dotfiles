---@diagnostic disable: undefined-global

return {
  postfix({
    trig = '.log',
    name = 'Postfix log',
    dscr = 'console.log(…);',
  }, {
    l('console.log(' .. l.POSTFIX_MATCH .. ');'),
  }),

  postfix({
    trig = '.log-verbose',
    name = 'Verbose postfix log',
    dscr = { 'console.log("var:", var)' },
  }, {
    l('console.log("' .. l.POSTFIX_MATCH .. ':", ' .. l.POSTFIX_MATCH .. ');'),
  }),

  s({
    trig = '/**',
    name = 'JSDoc',
    dscr = {
      '/**',
      ' * |',
      ' */',
    },
  }, {
    t({ '/**', ' * ' }),
    i(0),
    t({ '', ' */' }),
  }),

  s({
    trig = 'jsdoc',
    name = 'JSDoc',
    dscr = {
      '/**',
      ' * |',
      ' */',
    },
  }, {
    t({ '/**', ' * ' }),
    i(0),
    t({ '', ' */' }),
  }),

  s({
    trig = 'afn',
    name = 'async function',
    dscr = { 'async function …(…) { … }' },
  }, {
    t('async function '),
    i(1, 'name'),
    t('('),
    i(2, 'arg'),
    t(': '),
    i(3, 'type'),
    t('): Promise<'),
    i(4, 'type'),
    t('>'),
    t({ ' {', '\t' }),
    i(0, ''),
    t({ '', '}' }),
  }),

  s({
    trig = 'arfn',
    name = 'Anonymous function',
    dscr = { '(…) => { … }' },
  }, {
    t('('),
    i(1),
    t(') => {'),
    i(0),
    t('}'),
  }),

  s({
    trig = 'aarfn',
    name = 'Async anonymous function',
    dscr = { 'async (…) => { … }' },
  }, {
    t('async ('),
    i(1),
    t(') => {'),
    i(0),
    t('}'),
  }),

  s({
    trig = 'ftch',
    name = 'Fetch',
    dscr = { 'Async fetch helper' },
  }, {
    t('async function '),
    i(1, 'name'),
    t('('),
    i(2, 'arg'),
    t(': '),
    i(3, 'type'),
    t('): Promise<'),
    i(4, 'type'),
    t('>'),
    t({ ' {', '\t' }),
    t('try {'),
    t({ '', '\t\t' }),
    t("const res = await fetch('/api/"),
    i(5, 'endpoint'),
    t("', {"),
    t({ '', '\t\t\t' }),
    t("method: '"),
    i(6, 'GET'),
    t({ "',", '\t\t\t' }),
    t("headers: { 'Content-Type': 'application/json' },"),
    t({ '', '\t\t\t' }),
    t('body: JSON.stringify({ '),
    i(7, 'key'),
    t(': '),
    i(8, 'value'),
    t({ ' }),', '\t\t' }),
    t({ '});', '\t\t' }),
    t('const data = (await res.json()) as '),
    rep(4),
    t({ ';', '\t\t' }),
    t({ 'return data;', '\t' }),
    t('} catch ('),
    i(9, 'err'),
    t({ ') {', '\t\t' }),
    t('console.error('),
    rep(9),
    t({ ');', '\t' }),
    t('}'),
    t({ '', '}' }),
  }),
}
