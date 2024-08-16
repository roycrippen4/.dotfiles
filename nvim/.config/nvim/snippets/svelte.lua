---@diagnostic disable: undefined-global

return {
  s({
    trig = 'script-ts',
    name = 'svelte-ts-script',
    dscr = {
      '<script lang="ts">',
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
