local lspconfig = require('lspconfig')
local M = require('plugins.configs.lsp.lspconfig')

local cwd = vim.fn.getcwd(-1, -1)
if cwd ~= nil then
  if string.sub(cwd, -4) then
    require('neodev').setup({})
  end
end

lspconfig['clangd'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['cssls'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['docker_compose_language_service'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['dockerls'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['emmet_language_server'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'svelte' },
})

lspconfig['eslint'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'mjs', 'vue', 'svelte' },
  settings = require('plugins.configs.lsp.lang.eslint'),
})

lspconfig['gopls'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['hls'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['html'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['htmx'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['jsonls'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  settings = require('plugins.configs.lsp.lang.json'),
})

lspconfig['lua_ls'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  settings = require('plugins.configs.lsp.lang.lua'),
})

lspconfig['marksman'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['mdx_analyzer'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['pyright'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['svelte'].setup({
  capabilities = M.capabilities,
  on_attach = function(client, bufnr)
    M.on_attach(client, bufnr)

    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = { '*.js', '*.ts' },
      callback = function(ctx)
        if client.name == 'svelte' then
          client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.file })
        end
      end,
    })
  end,
})

-- lspconfig['tailwindcss'].setup({
-- capabilities = M.capabilities,
--   on_attach = M.on_attach,
-- })
lspconfig['taplo'].setup({
  keys = {
    {
      'K',
      function()
        if vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
          require('crates').show_popup()
        else
          vim.lsp.buf.hover()
        end
      end,
      desc = 'Show Crate Documentation',
    },
  },
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})

lspconfig['yamlls'].setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})
