---@type LazyPluginSpec
return {
  'chrisgrieser/nvim-scissors',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  opts = { snippetDir = vim.fn.stdpath('config') .. '/snippets' },
  keys = {
    {
      mode = { 'n', 'x' },
      '<leader>sa',
      function()
        require('scissors').addNewSnippet()
      end,
      desc = '[S]cissors [a]dd new snippet',
    },
    {
      '<leader>se',
      function()
        require('scissors').editSnippet()
      end,
      desc = '[S]cissors [e]dit snippet',
    },
  },
}
