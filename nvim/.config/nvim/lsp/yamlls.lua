---@type vim.lsp.Config
return {
  cmd = { 'bun', '--bun', 'run', 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
  settings = {
    yaml = {
      schemaStore = { enable = false, url = '' },
      scehmas = require('schemastore').yaml.schemas(),
    },
  },
}
