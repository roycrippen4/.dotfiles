return {
  'iamcco/markdown-preview.nvim', -- https://github.com/iamcco/markdown-preview.nvim
  ft = 'markdown',
  keys = { '<leader>mp', '<cmd> MarkdownPreview <cr>' },
  build = function()
    vim.fn['mkdp#util#install']()
  end,
  config = function()
    require('which-key').add({
      { mode = 'n', { '<leader>mp', '<cmd> MarkdownPreview <cr>', icon = '', desc = 'Preview Markdown' } },
    })
  end,
}
