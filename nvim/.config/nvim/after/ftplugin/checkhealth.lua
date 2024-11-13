local bufnr = vim.api.nvim_get_current_buf()

vim.treesitter.start(bufnr, 'vimdoc')
vim.wo.conceallevel = 2
vim.wo.concealcursor = 'n'

vim.keymap.set('n', 'K', function()
  local url = (vim.fn.expand('<cWORD>') --[[@as string]]):match('|(%S-)|')
  if url then
    return vim.cmd.help(url)
  end

  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local from, to
  from, to, url = vim.api.nvim_get_current_line():find('%[.-%]%((%S-)%)')
  if from and col >= from and col <= to then
    vim.system({ 'xdg-open', url }, nil, function(res)
      if res.code ~= 0 then
        vim.notify('Failed to open URL' .. url, vim.log.levels.ERROR)
      end
    end)
  end
end, { buffer = bufnr, silent = true })
vim.b[bufnr].markdown_keys = true
