---@type LazyPluginSpec
return {
  'roycrippen4/beeline.nvim', -- https://github.com/roycrippen4/beeline.nvim
  event = 'VimEnter',
  keys = {
    { '<leader>x', '<cmd>BeelineBufClose<cr>', { desc = 'Close buffer' } },
    { 'H', '<cmd>BeelineBufPrev<cr>', { desc = 'Go to previous beeline buffer' } },
    { 'L', '<cmd>BeelineBufNext<cr>', { desc = 'Go to next beeline buffer' } },
  },
  opts = {},
}
