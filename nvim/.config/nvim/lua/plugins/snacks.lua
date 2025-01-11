---@module "snacks"
---@type LazyPluginSpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = { {
    '<leader>z',
    function()
      Snacks.zen()
    end,
  } },
  ---@type snacks.Config
  opts = {
    styles = {
      notification = { wo = { wrap = true } },
      zen = {
        max_height = 63,
        width = 160,
        backdrop = { blend = 20 },
      },
    },
    notifier = { timeout = 5000, enabled = true },
    bigfile = { enabled = true },
    zen = {
      toggles = { dim = false },
      show = { statusline = true, tabline = true },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        _G.log = function(...)
          Snacks.debug.inspect(...)
        end
        _G.trace = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.log
      end,
    })
  end,
}
