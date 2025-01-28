---@module "snacks"
---@type LazyPluginSpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    {
      '<leader>z',
      function()
        Snacks.zen()
      end,
    },
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      { desc = 'Goto Definition' },
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      { desc = 'Goto References' },
    },
  },
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
    picker = {
      win = {
        input = {
          keys = {
            ['K'] = { 'preview_scroll_up', mode = { 'n' } },
            ['J'] = { 'preview_scroll_down', mode = { 'n' } },
          },
        },
      },
      layout = {
        layout = {
          box = 'horizontal',
          width = 0.87,
          height = 0.8,
          {
            box = 'vertical',
            { win = 'input', height = 1, border = 'rounded', title = '{title} {live} {flags}' },
            { win = 'list', border = 'solid', width = 0.8 },
          },
          { win = 'preview', title = '{title} Preview', border = 'rounded', width = 0.55 },
        },
      },
    },
    zen = {
      toggles = { dim = false },
      show = { statusline = true, tabline = true },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
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
