return {
  'numToStr/Comment.nvim', -- https://github.com/numToStr/Comment.nvim
  keys = { { 'gc', mode = { 'n', 'v' }, 'gcc' } },
  config = function()
    ---@diagnostic disable-next-line
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      ignore = '^$',
    })
  end,
}
