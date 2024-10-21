--- @type LazyPluginSpec
return {
  'iamcco/markdown-preview.nvim',
  keys = { { '<f7>', '<cmd> MarkdownPreviewToggle <CR>' } },
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = 'markdown',
  build = '~/.bin/install_awrit.sh && cd app && npm install',
  config = function()
    vim.api.nvim_exec2(
      [[
        function MkdpBrowserFn(url)
          execute 'silent ! kitty @ launch --dont-take-focus --bias 40 awrit ' . a:url
        endfunction
      ]],
      { output = true }
    )

    vim.g.mkdp_theme = 'dark'
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_browserfunc = 'MkdpBrowserFn'
  end,
}
