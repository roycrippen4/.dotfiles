---@module 'rustaceanvim'
---@type LazyPluginSpec
return {
  'mrcjkb/rustaceanvim', -- https://github.com/mrcjkb/rustaceanvim
  version = '^5',
  lazy = true,
  ft = 'rust',
  config = function()
    ---@type rustaceanvim.Opts
    vim.g.rustaceanvim = {
      server = { on_attach = require('core.utils').on_attach },
      tools = { float_win_config = { border = 'rounded' } },
    }

    require('which-key').add({
      {
        '<leader>lt',
        function()
          vim.cmd.RustLsp({ 'testables', bang = true })
        end,
        desc = '[L]sp Rerun Last Test',
      },
      -- {
      --   'K',
      --   function()
      --     if vim.bo.ft == 'rust' then
      --       vim.cmd('RustLsp! hover actions')
      --     else
      --       vim.lsp.buf.hover()
      --     end
      --   end,
      --   buffer = true,
      -- },
      -- stylua: ignore
      -- {
      --   '<leader>lD',
      --   function() vim.cmd('RustLsp! debuggables') end,
      --   desc = 'Rerun last debug',
      --   icon = '',
      -- },
    })
  end,
}
