local methods = vim.lsp.protocol.Methods

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
  virtual_text = true,
  float = {
    focusable = false,
    border = 'rounded',
    style = 'minimal',
    source = true,
    header = 'Diagnostic',
    prefix = '',
  },
})

local M = {}

local function set_lsp_mappings()
  require('which-key').add({
    {
      mode = 'n',
      {
        '<leader>lo',
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = { only = { 'source.organizeImports' }, diagnostics = {} },
          })
        end,
        desc = '[L]SP Organize Imports',
        icon = '󰶘',
      },
      {
        '<leader>lh',
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
          local msg = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) and 'Lsp inlay hints enabled' or 'Lsp inlay hints disabled'
          vim.notify(msg, vim.log.levels.INFO)
        end,
        desc = '[L]SP Inlay Hints',
        icon = '󰊠',
      },
      {
        '<leader>ld',
        function()
          vim.diagnostic.enable(not vim.diagnostic.is_enabled())
        end,
        desc = '[L]SP Diagnostics',
        icon = '',
      },
      { '<leader>r', vim.lsp.buf.rename, desc = 'Refactor', icon = '' },
      { '<leader>la', vim.lsp.buf.code_action, desc = '[L]SP Code Action', icon = '' },
      { '<leader>lf', vim.diagnostic.open_float, desc = '[L]SP Floating Diagnostics', icon = '󰉪' },
      { '<leader>li', '<cmd> LspInfo <cr>', desc = '[L]SP Server Info', icon = '' },
      { '<leader>lR', '<cmd> LspRestart <cr>', desc = '[L]SP Restart Servers', icon = '' },
    },
  })
end

---@param client vim.lsp.Client
---@param bufnr integer,
function M.on_attach(client, bufnr)
  if client.name == 'rust-analyzer' then
    vim.keymap.set('n', 'K', '<cmd>RustLsp hover actions<cr>', { buffer = bufnr })
  end
  -- if client.name == 'svelte' then
  --   vim.api.nvim_create_autocmd('BufWritePost', {
  --     pattern = { '*.js', '*.ts' },
  --     group = vim.api.nvim_create_augroup('svelte_ondidchangetsorjsfile', { clear = true }),
  --     callback = function(ctx)
  --       client:notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
  --     end,
  --   })
  -- end
  set_lsp_mappings()
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

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover({
    border = 'rounded',
    max_height = math.floor(vim.o.lines * 0.5),
    max_width = math.floor(vim.o.columns * 0.4),
  })
end

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  vim.treesitter.start(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  return contents
end

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  M.on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP keymaps',
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    M.on_attach(client, args.buf)
  end,
})

--- Configures the given server with its settings and applying the regular
--- client capabilities (+ the completion ones from blink.cmp).
---@param server string
---@param settings? table
function M.configure_server(server, settings)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

  if server == 'svelte' then
    ---@diagnostic disable-next-line: assign-type-mismatch see https://github.com/sveltejs/language-tools/issues/2008
    capabilities.workspace.didChangeWatchedFiles = false
  end

  require('lspconfig')[server].setup(vim.tbl_deep_extend('error', { capabilities = capabilities, silent = true }, settings or {}))
end

return M
