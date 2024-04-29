local icon = '│'

return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = icon },
      change = { text = icon },
      delete = { text = icon },
      topdelete = { text = icon },
      changedelete = { text = icon },
      untracked = { text = icon },
    },
  },
}
