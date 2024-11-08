---@module "snacks"

---@type LazyPluginSpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    notifier = { timeout = 5000 },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    lazygit = {
      configure = true,
      theme_path = vim.fs.normalize(vim.fn.stdpath('cache') .. '/lazygit-theme.yml'),
      theme = {
        [241] = { fg = 'Special' },
        activeBorderColor = { fg = 'MatchParen', bold = true },
        cherryPickedCommitBgColor = { fg = 'Identifier' },
        cherryPickedCommitFgColor = { fg = 'Function' },
        defaultFgColor = { fg = 'Normal' },
        inactiveBorderColor = { fg = 'FloatBorder' },
        optionsTextColor = { fg = 'Function' },
        searchingActiveBorderColor = { fg = 'MatchParen', bold = true },
        selectedLineBgColor = { bg = 'Visual' }, -- set to `default` to have no background colour
        unstagedChangesColor = { fg = 'DiagnosticError' },
      },
      win = {
        style = 'lazygit',
      },
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
        print = _G.log

        vim.keymap.set('n', '<F11>', Snacks.lazygit.open)
      end,
    })
  end,
}
