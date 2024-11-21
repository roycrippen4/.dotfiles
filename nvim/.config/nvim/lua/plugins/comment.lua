---@type LazyPluginSpec
return {
  'numToStr/Comment.nvim', -- https://github.com/roycrippen4/Comment.nvim
  event = 'BufEnter',
  dependencies = {
    {
      'JoosepAlviste/nvim-ts-context-commentstring', -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
      opts = { enable_autocmd = false },
    },
  },
  config = function()
    ---@diagnostic disable-next-line
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      ignore = '^$',
    })
  end,
}
