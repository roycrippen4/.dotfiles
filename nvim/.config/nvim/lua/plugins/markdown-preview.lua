return {
  'iamcco/markdown-preview.nvim', -- https://github.com/iamcco/markdown-preview.nvim
  ft = 'markdown',
  keys = {
    {
      '<leader>mp',
      '<cmd> MarkdownPreview<CR>',
      mode = { 'n' },
      desc = '  Markdown Preview',
    },
  },
  build = function()
    vim.fn['mkdp#util#install']()
  end,
}
