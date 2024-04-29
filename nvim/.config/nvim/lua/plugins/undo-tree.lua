return {
  'mbbill/undotree', -- https://github.com/mbbill/undotree
  keys = {
    {
      '<Leader>ut',
      function()
        require('nvim-tree.api').tree.toggle()
        vim.cmd.UndotreeToggle()
      end,
      desc = 'Toggle UndoTree 󰕍 ',
    },
  },
}
