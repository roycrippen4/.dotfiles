---@type table<string, vim.fn.sign_define.dict>
local dap_signs = {
  DapBreakpoint = { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' },
  DapBreakpointCondition = { text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' },
  DapLogPoint = { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' },
  DapStopped = { text = '', texthl = 'DapStopped', linehl = '', numhl = '' },
  DapBreakpointRejected = { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' },
}

vim.iter(dap_signs):each(vim.fn.sign_define)

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
