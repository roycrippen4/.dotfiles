---@module "scissors"
---@type LazyPluginSpec
return {
  'chrisgrieser/nvim-scissors', -- https://github.com/chrisgrieser/nvim-scissors
  ---@type Scissors.Config
  opts = {
    snippetDir = vim.fn.stdpath('config') .. '/snippets',
    editSnippetPopup = { border = 'rounded' },
  },
  keys = {
    { mode = { 'n', 'x' }, '<leader>sa', '<cmd> ScissorsAddNewSnippet <cr>', desc = '[A]dd snippet' },
    { mode = 'n', '<leader>se', '<cmd> ScissorsEditSnippet <cr>', desc = '[E]dit snippet' },
  },
}
