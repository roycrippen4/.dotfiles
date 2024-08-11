---@type LazyPluginSpec
return {
  'mbbill/undotree', -- https://github.com/mbbill/undotree
  keys = {
    {
      '<leader>ut',
      function()
        require('nvim-tree.api').tree.toggle()
        vim.cmd.UndotreeToggle()
      end,
      desc = 'UndoTree',
      -- icon = '󰕍',
    },
  },
}
