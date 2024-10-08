---@type LazyPluginSpec
return {
  'folke/todo-comments.nvim', -- https://github.com/folke/todo-comments.nvim
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    keywords = {
      TODO = { icon = '', color = 'info' },
      DONE = { icon = '', color = 'done' },
      SECTION = { icon = ' ', color = 'section' },
    },
    colors = {
      done = { '#53bf00' },
      section = { '#00F0F0' },
    },
  },
}
