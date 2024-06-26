local api = vim.api
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local clear_autocmds = api.nvim_clear_autocmds
local map = vim.keymap.set

local M = {}

--- Toggles diagnostics
local function toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

local function toggle_inlay_hints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
  print('inlay hints: ' .. tostring(vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })))
end

---@param chars string[]
local function check_trigger_chars(chars)
  local cur_line = api.nvim_get_current_line()
  local pos = api.nvim_win_get_cursor(0)[2]

  for _, char in ipairs(chars) do
    if cur_line:sub(pos, pos) == char or cur_line:sub(pos - 1, pos) == ', ' then
      return true
    end
  end
end

---@param bufnr integer
---@param client table
local function setup_signature_helper(bufnr, client)
  if client.server_capabilities.signatureHelpProvider then
    local group = augroup('LspSignature', { clear = false })
    clear_autocmds({ group = group, buffer = bufnr })

    autocmd({ 'TextChangedI', 'TextChangedP', 'InsertEnter' }, {
      group = group,
      buffer = bufnr,
      callback = function()
        if check_trigger_chars(client.server_capabilities.signatureHelpProvider.triggerCharacters) then
          vim.lsp.buf.signature_help()
        end
      end,
    })
  end
end

---@param client table
local function svelte_change_check(client)
  if client.name == 'svelte' then
    autocmd('BufWritePost', {
      group = augroup('svelte_ondidchangetsorjsfile', { clear = true }),
      pattern = { '*.js', '*.ts' },
      callback = function(ctx)
        client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
      end,
    })
  end
end

local function organize_imports()
  ---@diagnostic disable-next-line
  vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
end

-- stylua: ignore start
---@param additional_keymaps? KeyPair[]
function M.set_lsp_mappings(additional_keymaps)
  map('n', 'gr',         require('telescope.builtin').lsp_references,      { desc = '  Goto References'                 })
  map('n', 'gi',         require('telescope.builtin').lsp_implementations, { desc = '󰡱  Goto Implementation'             })
  map('n', 'gd',         require('telescope.builtin').lsp_definitions,     { desc = '󰼭  Goto Definition'                 })
  map('n', '<leader>r',  vim.lsp.buf.rename,                               { desc = '  LSP Rename'                      })
  map('n', '<leader>la', vim.lsp.buf.code_action,                          { desc = '  Code Action'                     })
  map('n', '<leader>lf', vim.diagnostic.open_float,                        { desc = '󰉪 Open floating diagnostic message' })
  map('n', '<leader>ld', toggle_diagnostics,                               { desc = '󰨚  Toggle Diagnostics '             })
  map('n', '<leader>lh', toggle_inlay_hints,                               { desc = '󰊠  Toggle lsp inlay hints'          })
  map('n', '<leader>li', '<cmd> LspInfo    <CR>',                          { desc = '  Show Lsp Info'                   })
  map('n', '<leader>lR', '<cmd> LspRestart <CR>',                          { desc = '  Restart language servers'        })
  map('n', '<leader>lo', organize_imports,                                 { desc = '󰶘  Organize Imports'                })

  if additional_keymaps then
    require('core.utils').create_keymaps(additional_keymaps)
  end
end
-- stylua: ignore end

---@param client table
---@param bufnr integer
function M.on_attach(client, bufnr)
  M.set_lsp_mappings()
  svelte_change_check(client)
  setup_signature_helper(bufnr, client)
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { 'markdown', 'plaintext' },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  },
}

return M
