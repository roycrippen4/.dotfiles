---@module "snacks"

---@type LazyPluginSpec
return {
  'folke/snacks.nvim',
  dev = false,
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    notifier = { timeout = 5000 },
    statuscolumn = { enabled = false },
    words = { enabled = false },
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
