vim
  .iter({
    DapBreakpoint = { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' },
    DapBreakpointCondition = { text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' },
    DapLogPoint = { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' },
    DapStopped = { text = '', texthl = 'DapStopped', linehl = '', numhl = '' },
    DapBreakpointRejected = { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' },
  })
  :each(vim.fn.sign_define)

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
  virtual_text = true,
  float = {
    style = 'minimal',
    source = 'if_many',
    header = 'Diagnostic',
    prefix = '',
  },
})

vim.api.nvim_create_user_command('LspOrganizeImports', function()
  vim.lsp.buf.code_action({
    apply = true,
    ---@diagnostic disable-next-line: missing-fields
    context = { only = { 'source.organizeImports' } },
  })
end, { desc = 'Organize imports via LSP' })

vim.api.nvim_create_user_command('LspToggleInlayHints', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
  local msg = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) and 'Lsp inlay hints enabled' or 'Lsp inlay hints disabled'
  vim.notify(msg, vim.log.levels.INFO)
end, { desc = 'Toggle LSP Inaly Hints' })

vim.api.nvim_create_user_command('LspToggleDiagnostics', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle LSP diagnostics' })

local M = {}

---@param client vim.lsp.Client
---@param bufnr integer,
---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  vim.keymap.set('n', '<leader>lo', '<cmd> LspOrganizeImports <cr>', { desc = '[L]SP Organize Imports' })
  vim.keymap.set('n', '<leader>lh', '<cmd> LspToggleInlayHints <cr>', { desc = '[L]SP Inlay Hints' })
  vim.keymap.set('n', '<leader>ld', '<cmd> LspToggleDiagnostics <cr>', { desc = '[L]SP Diagnostics' })
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'Refactor' })
  vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = '[L]SP Code Action' })
  vim.keymap.set('n', '<leader>lf', vim.diagnostic.open_float, { desc = '[L]SP Floating Diagnostics' })
  vim.keymap.set('n', '<leader>li', '<cmd> LspInfo <cr>', { desc = '[L]SP Server Info' })
  vim.keymap.set('n', '<leader>lR', '<cmd> LspRestart <cr>', { desc = '[L]SP Restart Servers' })

  -- vim.lsp.document_color.enable(true, bufnr)
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP keymaps',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    M.on_attach(client, args.buf)
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, { callback = vim.lsp.codelens.refresh })

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  M.on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local configs = vim
      .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
      :map(function(file)
        return vim.fn.fnamemodify(file, ':t:r')
      end)
      :totable()

    vim.lsp.enable(configs)
  end,
})

local function lsp_restart()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    vim.api.nvim_exec_autocmds('FileType', {
      group = 'nvim.lsp.enable',
      buffer = bufnr,
    })
    return
  end

  for _, c in ipairs(clients) do
    local attached_buffers = vim.tbl_keys(c.attached_buffers) ---@type integer[]
    local config = c.config
    vim.lsp.stop_client(c.id, true)

    vim.defer_fn(function()
      local id = vim.lsp.start(config)
      if id then
        for _, b in ipairs(attached_buffers) do
          vim.lsp.buf_attach_client(b, id)
        end
        local msg = string.format('Lsp `%s` has been restarted.', config.name)
        vim.notify(msg)
      else
        local msg = string.format('Error restarting `%s`.', config.name)
        vim.notify(msg, vim.log.levels.ERROR)
      end
    end, 600)
  end
end

vim.api.nvim_create_user_command('LspRestart', lsp_restart, { desc = 'Restart all Lsp clients' })

return M
