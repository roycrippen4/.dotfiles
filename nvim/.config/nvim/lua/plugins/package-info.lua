---@module "package-info"
---@type LazyPluginSpec
return {
  'roycrippen4/package-info.nvim', -- https://github.com/roycrippen4/package-info.nvim
  event = { 'BufRead package.json' },
  keys = { { '<leader>nr', '<cmd> PackageInfoRunScript <cr>', desc = 'Run script under the cursor' } },
  opts = {},
}
