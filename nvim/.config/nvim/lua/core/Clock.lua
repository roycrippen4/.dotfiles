---@class Clock
local Clock = {}
Clock.__index = Clock

function Clock:new()
  return setmetatable({
    timer = nil,
  }, Clock)
end

function Clock:start(interval, callback, duration)
  if type(callback) ~= 'function' then
    error('Callback must be a function')
    return
  end

  if not self.timer or not self.timer:is_active() then
    self.timer = vim.loop.new_timer()
    self.timer:start(0, interval or 100, vim.schedule_wrap(callback))
  end

  if duration and type(duration) == 'number' then
    vim.loop.new_timer():start(
      duration,
      0,
      vim.schedule_wrap(function()
        self:stop()
      end)
    )
  end
end

-- Stops the clock
function Clock:stop()
  if self.timer and self.timer:is_active() then
    self.timer:stop()
  end
end

return Clock
