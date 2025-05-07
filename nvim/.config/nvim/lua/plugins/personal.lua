---@type LazyPluginSpec[]
return {
  {
    --- Harpoon clone
    'roycrippen4/poon.nvim', -- https://github.com/roycrippen4/poon.nvim
    cmd = { 'PoonJump', 'PoonRemoveMark', 'PoonAddMark', 'PoonToggle' },
    keys = {
      { '<c-f>', '<cmd> PoonAdd <cr>' },
      { 'B', '<cmd> PoonAdd! <cr>' },
      { '<c-e>', '<cmd> PoonToggle <cr>' },
      { '<c-x>', '<cmd> PoonRemove <cr>' },
      { '<c-1>', '<cmd> PoonJump 1 <cr>' },
      { '<c-2>', '<cmd> PoonJump 2 <cr>' },
      { '<c-3>', '<cmd> PoonJump 3 <cr>' },
      { '<c-4>', '<cmd> PoonJump 4 <cr>' },
      { '<c-5>', '<cmd> PoonJump 5 <cr>' },
      { '<c-6>', '<cmd> PoonJump 6 <cr>' },
      { '<c-7>', '<cmd> PoonJump 7 <cr>' },
      { '<c-8>', '<cmd> PoonJump 8 <cr>' },
      { '<c-9>', '<cmd> PoonJump 9 <cr>' },
    },
    opts = {},
  },
  {
    --- Statusline and bufferline
    'roycrippen4/beeline.nvim', -- https://github.com/roycrippen4/beeline.nvim
    lazy = false,
    keys = {
      { '<leader>x', '<cmd> BeelineBufClose <cr>', { desc = 'Close buffer' } },
      { 'H', '<cmd> BeelineBufPrev <cr>', { desc = 'Go to previous beeline buffer' } },
      { 'L', '<cmd> BeelineBufNext <cr>', { desc = 'Go to next beeline buffer' } },
    },
    opts = {},
  },
  {
    --- Highlight group inspection tools
    'roycrippen4/inspector.nvim', -- https://github.com/roycrippen4/inspector.nvim
    cmd = { 'InspectFloat', 'InspectSplit' },
    keys = {
      { '<leader>if', '<cmd> InspectFloat <cr>', desc = '[I]nspect in float' },
      { '<leader>iw', '<cmd> InspectSplit <cr>', desc = '[I]nspect in split' },
    },
    opts = {},
  },
  {
    --- Fork of PackageInfo.nvim
    'roycrippen4/package-info.nvim', -- https://github.com/roycrippen4/package-info.nvim
    event = { 'BufRead package.json' },
    keys = { { '<leader>nr', '<cmd> PackageInfoRunScript <cr>', desc = 'Run script under the cursor' } },
    opts = {},
  },
}
