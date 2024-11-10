local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local toggle = false
local hl_timer = vim.uv.new_timer()
local macrohl = augroup('MacroHL', { clear = true })

autocmd('RecordingEnter', {
  desc = 'Toggles highlight group for the statusline macro segment',
  group = macrohl,
  callback = function()
    hl_timer:start(
      0,
      500,
      vim.schedule_wrap(function()
        if not toggle then
          vim.api.nvim_set_hl(0, 'StatusLineMacro', { link = 'StatusLineMacroA' })
          toggle = true
        else
          vim.api.nvim_set_hl(0, 'StatusLineMacro', { link = 'StatusLineMacroB' })
          toggle = false
        end
      end)
    )

    autocmd('RecordingLeave', {
      once = true,
      desc = 'Stops toggling the highlight group for the statusline macro segment',
      group = macrohl,
      callback = function()
        hl_timer:stop()
      end,
    })
  end,
})
