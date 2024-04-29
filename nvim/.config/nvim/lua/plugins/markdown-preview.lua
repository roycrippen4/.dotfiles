return {
  'iamcco/markdown-preview.nvim', -- https://github.com/iamcco/markdown-preview.nvim
  keys = { { '<leader>mp', '<cmd> MarkdownPreview<CR>', mode = { 'n' } } },
  build = function()
    vim.fn['mkdp#util#install']()
  end,
  opts = {},
}
