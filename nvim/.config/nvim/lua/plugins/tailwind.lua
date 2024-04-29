return {
  'luckasRanarison/tailwind-tools.nvim', -- https://github.com/luckasRanarison/tailwind-tools.nvim
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'svelte' },
  opts = { conceal = { enabled = true, min_length = 40 } },
}
