--- @type LazyPluginSpec
return {
  'iamcco/markdown-preview.nvim',
  keys = { { '<f7>', '<cmd> MarkdownPreviewToggle <CR>' } },
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = 'markdown',
  build = function()
    -- load the plugin
    vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy/markdown-preview.nvim')
    -- build the plugin
    vim.fn['mkdp#util#install']()
    -- run the installer for awrit
    vim.system(
      { vim.fn.expand('$HOME/.bin/install_awrit.sh') },
      { text = true },
      vim.schedule_wrap(function(out)
        if out.code == 0 then
          vim.notify(out.stdout, vim.log.levels.INFO)
        else
          vim.notify(out.stderr, vim.log.levels.ERROR)
        end
      end)
    )
  end,
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
