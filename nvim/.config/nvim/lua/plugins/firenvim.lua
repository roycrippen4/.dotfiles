local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

---@type LazyPluginSpec
return {
  'glacambre/firenvim', -- https://github.com/glacambre/firenvim
  build = ':call firenvim#install(0)',
  -- lazy = true,
  config = function()
    if not vim.g.started_by_firenvim then
      return
    end

    vim.g.firenvim_config = {
      localSettings = {
        ['https?://www.google.com*'] = { takeover = 'never', priority = 1 },
      },
    }

    local group = augroup('firenvim', { clear = true })
    vim.o.laststatus = 0
    vim.o.guifont = 'JetBrainsMono Nerd Font:h12'

    autocmd('BufEnter', {
      group = group,
      pattern = 'github.com_*.txt',
      command = 'set filetype=markdown',
    })

    autocmd('BufEnter', {
      group = group,
      pattern = 'svelte.dev_*.txt',
      callback = function()
        vim.bo.filetype = 'svelte'
      end,
    })

    local max_height = 20
    vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
      group = group,
      callback = function()
        local height = vim.api.nvim_win_text_height(0, {}).all
        if height > vim.o.lines and height < max_height then
          vim.o.lines = height
          vim.cmd('norm! zb')
        end
      end,
    })

    -- Sync input with buffer
    local timer_started = false
    autocmd({ 'TextChanged', 'TextChangedI' }, {
      group = group,
      callback = function()
        if timer_started == true then
          return
        end
        timer_started = true
        vim.fn.timer_start(10000, function()
          timer_started = false
          vim.cmd('silent write')
        end)
      end,
    })
  end,
}
