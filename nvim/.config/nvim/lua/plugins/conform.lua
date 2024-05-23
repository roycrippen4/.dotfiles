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

local format_enabled = true

return {
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>ft',
      mode = 'n',
      function()
        if format_enabled then
          vim.cmd('FormatDisable')
          format_enabled = false
        else
          vim.cmd('FormatEnable')
          format_enabled = true
        end
      end,
      desc = '  Toggle autoformat-on-save',
    },
  },
  opts = {
    notify_on_error = false,
    quiet = false,
    formatters_by_ft = {
      css = { { 'prettierd', 'prettier' } },
      html = { { 'prettierd', 'prettier' } },
      javascript = { { 'prettierd', 'prettier' } },
      javascriptreact = { { 'prettierd', 'prettier' } },
      json = { { 'prettierd', 'prettier' } },
      lua = { 'stylua' },
      markdown = { { 'prettierd', 'prettier' } },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      svelte = { { 'prettierd', 'prettier' } },
      typescript = { { 'prettierd', 'prettier' } },
      typescriptreact = { { 'prettierd', 'prettier' } },
      yaml = { { 'yamlfmt' } },
    },

    -- stupid

    ---@param bufnr integer
    ---@return { timeout_ms: number, lsp_fallback: boolean }|nil
    format_on_save = function(bufnr)
      local ignore_filetypes = { 'sql', 'java' }

      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end

      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') then
        return
      end

      return { timeout_ms = 500, lsp_fallback = true }
    end,
  },
}
