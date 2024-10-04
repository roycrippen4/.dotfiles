local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local M = {
  toggle = 0,
  hl_timer = vim.loop.new_timer(),
}

function M.toggle_recording_hl()
  if M.toggle == 0 then
    vim.api.nvim_set_hl(0, 'ST_Macro', { link = 'ST_MacroA' })
    vim.api.nvim_set_hl(0, 'ST_MacroSep', { link = 'ST_MacroSepA' })
    M.toggle = 1
  else
    vim.api.nvim_set_hl(0, 'ST_Macro', { link = 'ST_MacroB' })
    vim.api.nvim_set_hl(0, 'ST_MacroSep', { link = 'ST_MacroSepB' })
    M.toggle = 0
  end
end

function M.start_record_highlight()
  M.hl_timer:start(
    0,
    500,
    vim.schedule_wrap(function()
      M.toggle_recording_hl()
    end)
  )
end

function M.stop_timer()
  M.hl_timer:stop()
end

local macrohl = augroup('MacroHL', { clear = true })
-- Toggles highlight group for the statusline macro segment
autocmd(E.RecordingEnter, {
  group = macrohl,
  callback = function()
    M.start_record_highlight()
  end,
})
-- Stops toggling the highlight group for the statusline macro segment
autocmd(E.RecordingLeave, {
  group = macrohl,
  callback = function()
    M.stop_timer()
  end,
})
