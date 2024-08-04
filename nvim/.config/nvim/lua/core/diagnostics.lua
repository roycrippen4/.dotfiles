local dap_signs = {
  { name = 'DapBreakpoint', opts = { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' } },
  { name = 'DapBreakpointCondition', opts = { text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' } },
  { name = 'DapLogPoint', opts = { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' } },
  { name = 'DapStopped', opts = { text = '', texthl = 'DapStopped', linehl = '', numhl = '' } },
  { name = 'DapBreakpointRejected', opts = { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' } },
}

for _, sign in ipairs(dap_signs) do
  vim.fn.sign_define(sign.name, { text = sign.opts.text, texthl = sign.opts.texthl, linehl = sign.opts.linehl, numhl = sign.opts.numhl })
end

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '󱡴',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    border = 'rounded',
    style = 'minimal',
    source = true,
    header = 'Diagnostic',
    prefix = '',
  },
})
