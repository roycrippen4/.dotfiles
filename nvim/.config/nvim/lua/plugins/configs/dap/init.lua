local dap = require('dap')
local dapui = require('dapui')

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

--[=============================================================================================]
--[------------------------------------------ LUA ----------------------------------------------]
--[=============================================================================================]
dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 })
end
dap.configurations['lua'] = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
  },
}
