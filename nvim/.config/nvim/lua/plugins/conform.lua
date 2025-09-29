vim.api.nvim_create_user_command('FormatDisable', function()
  vim.g.disable_format_on_save = true
  vim.notify('Format on save disabled')
end, { desc = 'Disable format on save' })

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.g.disable_format_on_save = false
  vim.notify('Format on save enabled')
end, { desc = 'Enable format on save' })

vim.api.nvim_create_user_command('FormatToggle', function()
  (vim.g.disable_format_on_save and vim.cmd.FormatEnable or vim.cmd.FormatDisable)()
end, { desc = 'Toggle format on save' })

local function format_on_save()
  if vim.g.disable_format_on_save then
    return
  end
  return { timeout_ms = 1000, lsp_format = 'fallback' }
end

---@module "conform"
---@type LazyPluginSpec
return {
  'stevearc/conform.nvim', -- https://github.com/stevearc/conform.nvim
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  keys = { { '<leader>tf', '<cmd> FormatToggle <cr>', desc = '  Toggle autoformat-on-save' } },
  ---@type conform.setupOpts
  opts = {
    format_on_save = format_on_save,
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'prettierd', 'prettier', stop_after_first = true },
      jsonc = { 'prettierd', 'prettier', stop_after_first = true },
      lua = { 'stylua' },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },
      ocaml = { 'ocamlformat' },
      ocamlinterface = { 'ocamlformat' },
      proto = { 'clang-format' },
      python = { 'black' },
      sh = { 'shfmt' },
      svelte = { 'prettierd' },
      toml = { 'taplo' },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'yamlfmt' },
      rust = { 'rustfmt' },
      fish = {},
    },
    formatters = {
      stylua = {
        cwd = function(_, ctx)
          return vim.fs.root(ctx.dirname, { '.editorconfig', '.stylua.toml', 'stylua.toml' })
        end,
      },
    },
  },
}
