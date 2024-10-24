local api = vim.api
local b = vim.b
local cmd = vim.cmd
local g = vim.g
local user_command = vim.api.nvim_create_user_command

---@param args { bang: boolean }
user_command('FormatDisable', function(args)
  if args.bang then
    b.disable_autoformat = true
  else
    g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

user_command('FormatEnable', function()
  b.disable_autoformat = false
  g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

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
        if not g.disable_autoformat then
          cmd.FormatDisable()
          g.disable_autoformat = true
          print('Autoformat disabled')
        else
          cmd.FormatEnable()
          g.disable_autoformat = false
          print('Autoformat enabled')
        end
      end,
      desc = '  Toggle autoformat-on-save',
    },
  },
  ---@module "conform"
  --- @type conform.setupOpts
  opts = {
    notify_on_error = false,
    quiet = false,
    formatters_by_ft = {
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      css = { 'prettierd', 'prettier', 'biome' },
      html = { 'prettierd', 'prettier', 'biome' },
      javascript = { 'prettierd', 'prettier', 'biome' },
      javascriptreact = { 'prettierd', 'prettier', 'biome' },
      json = { 'prettierd', 'prettier', 'biome' },
      lua = { 'stylua' },
      markdown = { 'prettierd', 'prettier', 'biome' },
      ocaml = { 'ocamlformat' },
      proto = { 'clang-format' },
      python = { 'black' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      svelte = { 'prettierd', 'prettier', 'biome' },
      typescript = { 'prettierd', 'prettier', 'biome' },
      typescriptreact = { 'prettierd', 'prettier', 'biome' },
      yaml = { 'yamlfmt' },
    },

    formatters = {
      biome = {
        condition = function()
          return require('core.utils').has_file('biome.json')
        end,
      },
      prettier = {
        condition = function()
          return not require('core.utils').has_file('biome.json')
        end,
      },
    },

    ---@param bufnr integer
    ---@return { timeout_ms: number, lsp_fallback: boolean }|nil
    format_on_save = function(bufnr)
      if vim.tbl_contains({ 'sql', 'java' }, vim.bo[bufnr].filetype) then
        return
      end

      if g.disable_autoformat or b[bufnr].disable_autoformat then
        return
      end

      local bufname = api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') then
        return
      end

      return { timeout_ms = 500, lsp_fallback = true }
    end,
  },
}
