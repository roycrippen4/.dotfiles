---@type LazyPluginSpec
return {
  'folke/todo-comments.nvim', -- https://github.com/folke/todo-comments.nvim
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  -- stylua: ignore
  keys = {
    ---@diagnostic disable-next-line
    { '<leader>ft', function() Snacks.picker.todo_comments() end, desc = 'Find todos', },
  },
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
