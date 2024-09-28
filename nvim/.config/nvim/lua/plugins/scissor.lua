local add_new_snippet = function()
  require('scissors').addNewSnippet()
end
local edit_snippet = function()
  require('scissors').editSnippet()
end

---@type LazyPluginSpec
return {
  'chrisgrieser/nvim-scissors',
  dependencies = { 'nvim-telescope/telescope.nvim', 'garymjr/nvim-snippets' },
  opts = { snippetDir = vim.fn.stdpath('config') .. '/snippets/vscode' },
  keys = {
    { mode = { 'n', 'x' }, '<leader>sa', add_new_snippet, desc = '[S]cissors [a]dd new snippet' },
    { '<leader>se', edit_snippet, desc = '[S]cissors [e]dit snippet' },
  },
}
