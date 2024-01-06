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

require('overseer').patch_dap(true)
require('dap.ext.vscode').json_decode = require('overseer.json').decode

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

dap.adapters['pwa-node'] = {
  type = 'server',
  host = '127.0.0.1',
  port = 8123,
  executable = {
    command = 'js-debug-adapter',
  },
}

for _, language in ipairs({ 'typescript', 'javascript' }) do
  dap.configurations[language] = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      cwd = '${workspaceFolder}',
      runtimeExecutable = 'node',
    },
  }
end
