local autocmd = vim.api.nvim_create_autocmd
local user_command = vim.api.nvim_create_user_command

---@param args { bang: boolean }
user_command('FormatDisable', function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

---@module "conform"
---@type LazyPluginSpec
return {
  'stevearc/conform.nvim', -- https://github.com/stevearc/conform.nvim
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  keys = {
    {
      '<leader>tf',
      mode = 'n',
      function()
        if not vim.g.disable_autoformat then
          vim.cmd.FormatDisable()
          vim.g.disable_autoformat = true
          print('Autoformat disabled')
        else
          vim.cmd.FormatEnable()
          vim.g.disable_autoformat = false
          print('Autoformat enabled')
        end
      end,
      desc = '  Toggle autoformat-on-save',
    },
  },
  ---@type conform.setupOpts
  opts = {
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      css = { 'prettier', 'prettierd', stop_after_first = true },
      html = { 'prettier', 'prettierd', stop_after_first = true },
      javascript = { 'prettier', 'prettierd', stop_after_first = true },
      javascriptreact = { 'prettier', 'prettierd', stop_after_first = true },
      json = { 'prettier', 'prettierd', stop_after_first = true },
      lua = { 'stylua' },
      markdown = { 'prettier', 'prettierd', stop_after_first = true },
      ocaml = { 'ocamlformat' },
      proto = { 'clang-format' },
      python = { 'black' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      svelte = { 'prettier', 'prettierd', stop_after_first = true },
      toml = { 'taplo' },
      typescript = { 'prettier', 'prettierd', stop_after_first = true },
      typescriptreact = { 'prettier', 'prettierd', stop_after_first = true },
      yaml = { 'yamlfmt' },
    },
  },
  config = function(_, opts)
    require('conform').setup(opts)
    autocmd('BufWritePre', {
      pattern = '*',
      callback = function(args)
        require('conform').format({ bufnr = args.buf })
      end,
    })
  end,
}
