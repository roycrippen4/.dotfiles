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

return {
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>ft',
      mode = 'n',
      function()
        if not vim.g.disable_autoformat then
          vim.cmd('FormatDisable')
          vim.g.disable_autoformat = true
          vim.notify('Autoformat disabled', vim.log.levels.INFO, { title = 'Conform' })
        else
          vim.cmd('FormatEnable')
          vim.g.disable_autoformat = false
          vim.notify('Autoformat enabled', vim.log.levels.INFO, { title = 'Conform' })
        end
      end,
      desc = '  Toggle autoformat-on-save',
    },
  },
  opts = { --- @type conform.setupOpts
    notify_on_error = false,
    quiet = false,
    formatters_by_ft = {
      css = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'prettierd', 'prettier', stop_after_first = true },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },
      svelte = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      lua = { 'stylua' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      yaml = { 'yamlfmt' },
    },

    ---@param bufnr integer
    ---@return { timeout_ms: number, lsp_fallback: boolean }|nil
    format_on_save = function(bufnr)
      if vim.tbl_contains({ 'sql', 'java' }, vim.bo[bufnr].filetype) then
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
