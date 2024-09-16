---@type LazyPluginSpec
return {
  'roycrippen4/package-info.nvim', -- https://github.com/vuki656/package-info.nvim
  dependencies = 'MunifTanjim/nui.nvim',
  cond = function()
    local cwd = vim.fn.getcwd()
    if vim.fn.filereadable(cwd .. '/package.json') == 1 then
      return true
    end
    return false
  end,
  opts = {},
  config = function()
    require('which-key').add({
      { '<leader>pu', require('package-info').update, desc = '[P]ackage Update', icon = '󰚰' },
    })
  end,
}
