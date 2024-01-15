return {
  Lua = {
    format = { enable = false },
    semantic = { enable = false },
    diagnostics = {
      globals = { 'vim' },
    },
    telemetry = {
      enable = false,
    },
    hint = {
      enable = true,
      arrayIndex = 'Disable',
    },
    workspace = {
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
      maxPreload = 100000,
      preloadFileSize = 10000,
    },
  },
}
