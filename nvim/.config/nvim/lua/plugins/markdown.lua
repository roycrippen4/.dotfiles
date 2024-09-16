--- @type LazyPluginSpec
return {
  'OXY2DEV/markview.nvim', -- https://github.com/OXY2DEV/markview.nvim
  lazy = false,
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  opts = {
    modes = { 'n', 'no', 'c' },
    hybrid_modes = { 'n' },
    callbacks = {
      on_enable = function(_, win)
        vim.wo[win].conceallevel = 2
        vim.wo[win].concealcursor = 'c'
      end,
    },
  },
}
