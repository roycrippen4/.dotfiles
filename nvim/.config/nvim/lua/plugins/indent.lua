---@type LazyPluginSpec
return {
  'saghen/blink.indent',
  --- @module 'blink.indent'
  --- @type blink.indent.Config
  opts = {
    static = { char = '▏' },
    scope = {
      enabled = false,
    },
  },
}
