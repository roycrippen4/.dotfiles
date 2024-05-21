local signs = {
  dap = { --- @type { name: string, opts: vim.fn.sign_define.dict }[]
    { name = 'DapBreakpoint', opts = { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' } },
    { name = 'DapBreakpointCondition', opts = { text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' } },
    { name = 'DapLogPoint', opts = { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' } },
    { name = 'DapStopped', opts = { text = '', texthl = 'DapStopped', linehl = '', numhl = '' } },
    { name = 'DapBreakpointRejected', opts = { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' } },
  },
  diagnostic = { --- @type { name: string, opts: vim.fn.sign_define.dict }[]
    { name = 'DiagnosticSignError', opts = { text = '💀', texthl = 'DiagnosticSignError', linehl = '', numhl = '' } },
    { name = 'DiagnosticSignWarn', opts = { text = '', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' } },
    { name = 'DiagnosticSignHint', opts = { text = '󱡴', texthl = 'DiagnosticSignHint', linehl = '', numhl = '' } },
    { name = 'DiagnosticSignInfo', opts = { text = '', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' } },
  },
}

for _, sign in ipairs(signs.diagnostic) do
  vim.fn.sign_define(sign.name, { text = sign.opts.text, texthl = sign.opts.texthl, linehl = sign.opts.linehl, numhl = sign.opts.numhl })
end

for _, sign in ipairs(signs.dap) do
  vim.fn.sign_define(sign.name, { text = sign.opts.text, texthl = sign.opts.texthl, linehl = sign.opts.linehl, numhl = sign.opts.numhl })
end

vim.diagnostic.config({
  signs = { active = signs.diagnostic },
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
