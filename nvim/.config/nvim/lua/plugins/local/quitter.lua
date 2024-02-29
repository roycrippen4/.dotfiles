local plug_types = {
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
  fidget = true,
}

local function quit_vim()
  local wins = vim.api.nvim_list_wins()
  local file_win_count = 0

  for _, w in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(w)
    local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })

    -- Check if win is not a plug/special win
    if not plug_types[ft] then
      file_win_count = file_win_count + 1
    end
  end

  if file_win_count == 0 then
    vim.cmd('qa')
  end
end

-- autoquit vim if only plugin windows are open
vim.api.nvim_create_autocmd('QuitPre', {
  callback = function()
    vim.defer_fn(quit_vim, 100)
  end,
})
