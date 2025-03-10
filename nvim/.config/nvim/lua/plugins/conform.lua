---@param args { bang: boolean }
vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = 'Disable autoformat-on-save', bang = true })

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = 'Re-enable autoformat-on-save' })

---@param files string|string[]
---@return fun(self: conform.FormatterConfig, ctx: conform.Context): nil|string
local function root_file(files)
  return function(_, ctx)
    return vim.fs.root(ctx.dirname, files)
  end
end

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
          vim.notify('Autoformat disabled')
        else
          vim.cmd.FormatEnable()
          vim.g.disable_autoformat = false
          vim.notify('Autoformat enabled')
        end
      end,
      desc = '  Toggle autoformat-on-save',
    },
  },
  ---@type conform.setupOpts
  opts = {
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'prettierd', 'prettier', stop_after_first = true },
      lua = { 'stylua' },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },
      ocaml = { 'ocamlformat' },
      ocamlinterface = { 'ocamlformat' },
      proto = { 'clang-format' },
      python = { 'black' },
      sh = { 'shfmt' },
      svelte = { 'prettierd', 'prettier', stop_after_first = true },
      toml = { 'taplo' },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'yamlfmt' },
      rust = { 'rustfmt' },
    },
    formatters = {
      stylua = {
        cwd = root_file({ '.editorconfig', '.stylua.toml', 'stylua.toml' }),
      },
      prettierd = { command = 'bun --bun run prettierd' },
      prettier = { command = 'bun --bun run prettier' },
    },
  },
}
