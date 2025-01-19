return {
  'roycrippen4/inspector.nvim', -- https://github.com/roycrippen4/inspector.nvim
  keys = {
    {
      '<leader>if',
      function()
        require('inspector').inspect_in_float()
      end,
    },
    {
      '<leader>iw',
      function()
        require('inspector').inspect_in_split()
      end,
    },
  },
  opts = {},
}
