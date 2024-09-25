---@type LazyPluginSpec
return {
  'roycrippen4/package-info.nvim', -- https://github.com/vuki656/package-info.nvim
  dependencies = 'MunifTanjim/nui.nvim',
  event = 'VeryLazy',
  -- cond = function()
  --   local cwd = vim.fn.getcwd()
  --   if vim.fn.filereadable(cwd .. '/package.json') == 1 then
  --     return true
  --   end
  --   return false
  -- end,
  opts = {},
}
