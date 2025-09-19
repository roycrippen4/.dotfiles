---@type vim.lsp.Config
return {
  cmd = { 'bun', '--bun', 'run', 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' },
  root_markers = { 'Dockerfile' },
}
