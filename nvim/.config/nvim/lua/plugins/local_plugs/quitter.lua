local M = {}

M.plug_types = {
  NvimTree = true,
  TelescopePrompt = true,
  Trouble = true,
  harpoon = true,
  help = true,
  logger = true,
  noice = true,
  prompt = true,
  terminal = true,
  toggleterm = true,
}

function M.quit_vim()
  local wins = vim.api.nvim_list_wins()
  local non_plugin_win_count = 0

  for _, w in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(w)
    local bt = vim.api.nvim_get_option_value('buftype', { buf = buf })
    local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })

    -- Check if win is not a plug/special win
    if bt == '' and not M.plug_types[ft] then
      non_plugin_win_count = non_plugin_win_count + 1
    end
  end

  if non_plugin_win_count == 0 then
    vim.api.nvim_command('qa')
  end
end

-- autoquit vim if only plugin windows are open
vim.api.nvim_create_autocmd('QuitPre', {
  callback = function()
    vim.defer_fn(function()
      M.quit_vim()
    end, 0)
  end,
})
