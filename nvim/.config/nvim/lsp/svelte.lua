---@type vim.lsp.Config
return {
  cmd = { 'svelteserver', '--stdio' },
  filetypes = { 'svelte' },
  capabilities = {
    workspace = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      didChangeWatchedFiles = false,
    },
  },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if vim.uv.fs_stat(fname) ~= nil then
      local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', 'deno.lock' }
      root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } } or vim.list_extend(root_markers, { '.git' })
      local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
      on_dir(project_root)
    end
  end,
  on_attach = function(client, _)
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = { '*.js', '*.ts' },
      callback = function(ctx)
        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
      end,
    })
  end,
}
