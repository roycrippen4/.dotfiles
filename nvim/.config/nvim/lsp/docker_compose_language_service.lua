---@type vim.lsp.Config
return {
  cmd = { 'bun', '--bun', 'run', 'docker-compose-langserver', '--stdio' },
  filetypes = { 'yaml.docker-compose' },
  root_markers = { 'docker-compose.yaml', 'docker-compose.yml', 'compose.yaml', 'compose.yml' },
}
