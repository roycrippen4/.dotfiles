-- ---@class Clock
-- local Clock = {}
-- Clock.__index = Clock

-- function Clock:new()
--   return setmetatable({
--     timer = nil,
--   }, Clock)
-- end

-- function Clock:start(interval, callback, duration)
--   if type(callback) ~= 'function' then
--     error('Callback must be a function')
--     return
--   end

--   if not self.timer or not self.timer:is_active() then
--     self.timer = vim.loop.new_timer()
--     self.timer:start(0, interval or 100, vim.schedule_wrap(callback))
--   end

--   if duration and type(duration) == 'number' then
--     vim.loop.new_timer():start(
--       duration,
--       0,
--       vim.schedule_wrap(function()
--         self:stop()
--       end)
--     )
--   end
-- end

-- -- Stops the clock
-- function Clock:stop()
--   if self.timer and self.timer:is_active() then
--     self.timer:stop()
--   end
-- end

-- function Clock:restart()

-- end

-- return Clock
local Clock = {}
Clock.__index = Clock

-- Constructor for the Clock
function Clock.new()
  local self = setmetatable({}, Clock)
  self.tickTimer = nil -- Timer for the clock ticks
  self.durationTimer = nil -- Timer for the clock duration
  self.interval = 100
  self.callback = nil
  self.duration = nil
  return self
end

-- Stops any active timers
function Clock:stopTimers()
  if self.tickTimer and self.tickTimer:is_active() then
    self.tickTimer:stop()
  end
  if self.durationTimer and self.durationTimer:is_active() then
    self.durationTimer:stop()
  end
end

-- Starts or restarts the clock with a custom command and optional auto-stop
function Clock:start(interval, callback, duration)
  -- Store parameters for restarting
  self.interval = interval or self.interval
  self.callback = callback or self.callback
  self.duration = duration or self.duration

  -- Ensure a valid function is provided
  if type(self.callback) ~= 'function' then
    error('Callback must be a function')
    return
  end

  -- Stop any existing timers
  self:stopTimers()

  -- Start the tick timer
  self.tickTimer = vim.loop.new_timer()
  self.tickTimer:start(
    0, -- Initial delay
    self.interval,
    vim.schedule_wrap(self.callback)
  )

  -- Start the duration timer if a duration is specified
  if self.duration and type(self.duration) == 'number' then
    self.durationTimer = vim.loop.new_timer()
    self.durationTimer:start(
      self.duration,
      0,
      vim.schedule_wrap(function()
        self:stop()
      end)
    )
  end
end

-- Stops the clock and any running timers
function Clock:stop()
  self:stopTimers()
end

-- Resets the duration of the clock
function Clock:resetDuration()
  self:start(self.interval, self.callback, self.duration)
end

return Clock
