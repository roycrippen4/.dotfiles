---@type LazyPluginSpec
return {
  'chrisgrieser/nvim-scissors',
  dependencies = { 'nvim-telescope/telescope.nvim', 'garymjr/nvim-snippets' },
  opts = { snippetDir = vim.fn.stdpath('config') .. '/snippets/vscode' },
  config = function(_, opts)
    local scissors = require('scissors')
    scissors.setup(opts)

    local wk = require('which-key')
    wk.add({
      {
        mode = { 'n', 'x' },
        { '<leader>sa', scissors.addNewSnippet, desc = '[S]cissors add new snippet', icon = '' },
      },
      {
        mode = 'n',
        { '<leader>se', scissors.editSnippet, desc = '[S]cissors edit snippet', icon = '' },
      },
    })
  end,
}
