---@type LazyPluginSpec
return {
  'mrcjkb/rustaceanvim', -- https://github.com/mrcjkb/rustaceanvim
  version = '^5',
  lazy = true,
  ft = 'rust',
  config = function()
    ---@module 'rustaceanvim'
    ---@type rustaceanvim.Opts
    vim.g.rustaceanvim = {
      server = { on_attach = require('core.utils').on_attach },
      tools = {
        float_win_config = { border = 'rounded' },
        executor = 'toggleterm',
        test_executor = 'toggleterm',
      },
    }

    require('which-key').add({
      { '<leader>lc', '<cmd> RustLsp openCargo    <cr>', desc = '[L]SP Open Cargo' },
      { '<leader>lC', '<cmd> RustLsp flyCheck     <cr>', desc = '[L]SP Run FlyCheck' },
      { '<leader>lD', '<cmd> RustLsp debuggables  <cr>', desc = '[L]SP Debug Rust' },
      { '<leader>lE', '<cmd> RustLsp externalDocs <cr>', desc = '[L]SP Open External Docs' },
      { '<leader>le', '<cmd> RustLsp explainError <cr>', desc = '[L]SP Explain Error' },
      {
        '<leader>lt',
        function()
          vim.cmd.RustLsp({ 'testables', bang = true })
        end,
        desc = '[L]sp Rerun Last Test',
      },
      {
        'K',
        function()
          if vim.bo.ft == 'rust' then
            vim.cmd.RustLsp({ 'hover', bang = true })
          else
            vim.lsp.buf.hover()
          end
          -- '<cmd>RustLsp hover actions<cr>'
        end,
        buffer = true,
      },
    })
  end,
}
