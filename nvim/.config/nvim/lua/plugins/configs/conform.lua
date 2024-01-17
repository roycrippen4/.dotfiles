local options = {
  notify_on_error = false,
  quiet = true,
  formatters_by_ft = {
    lua = { 'stylua' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    json = { 'pretter' },
    html = { 'prettier' },
    css = { 'prettier' },
    markdown = { 'prettier' },
    rust = { 'rustfmt' },
    sh = { 'shfmt' },
    yaml = { 'prettier' },
  },
  format_on_save = {
    timeout_ms = 500,
    async = false,
    lsp_fallback = true,
  },
  formatters = {
    shfmt = {
      prepend_args = { '-i', '2' },
    },
  },
}

return options
