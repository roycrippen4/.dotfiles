return {
  'windwp/nvim-ts-autotag', -- https://github.com/windwp/nvim-ts-autotag -- waiting for PR
  branch = 'main',
  dependencies = 'nvim-treesitter/nvim-treesitter', -- https://github.com/nvim-treesitter/nvim-treesitter
  ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'html', 'svelte', 'jsx', 'tsx', 'markdown' },
  opts = {},
}
