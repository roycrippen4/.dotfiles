local arrows = {
  right = '',
  left = '',
  up = '',
  down = '',
}

return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        keys = {
          {
            '<leader>de',
            function()
              -- Calling this twice to open and jump into the window.
              require('dapui').eval()
              require('dapui').eval()
            end,
            desc = 'Evaluate expression',
          },
        },
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
        opts = {
          icons = {
            collapsed = arrows.right,
            current_frame = arrows.right,
            expanded = arrows.down,
          },
          floating = { border = 'rounded' },
          layouts = {
            {
              elements = {
                { id = 'stacks', size = 0.30 },
                { id = 'breakpoints', size = 0.20 },
                { id = 'scopes', size = 0.50 },
              },
              position = 'right',
              size = 50,
            },
          },
        },
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = { virt_text_pos = 'eol' },
      },
      {
        'mxsdev/nvim-dap-vscode-js',
        opts = {
          debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
          adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        },
      },
      {
        'microsoft/vscode-js-debug',
        build = 'npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out',
      },
      {
        'jbyuki/one-small-step-for-vimkind',
        keys = {
          {
            '<leader>dl',
            function()
              require('osv').launch({ port = 8086 })
            end,
            desc = 'Launch Lua adapter',
          },
        },
      },
    },
    keys = {
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle breakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end,
        desc = 'Breakpoint condition',
      },
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Continue',
      },
      {
        '<F8>',
        function()
          require('dap').step_over()
        end,
        desc = 'Step over',
      },
      {
        '<F9>',
        function()
          require('dap').step_into()
        end,
        desc = 'Step into',
      },
      {
        '<F10>',
        function()
          require('dap').step_out()
        end,
        desc = 'Step Out',
      },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- Automatically open the UI when a new debug session is created.
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close({})
      end

      -- Lua configurations.
      dap.adapters.nlua = function(callback)
        callback({ type = 'server', host = '127.0.0.1', port = 8086 })
      end

      dap.configurations['lua'] = {
        {
          type = 'nlua',
          request = 'attach',
          name = 'Attach to running Neovim instance',
        },
      }

      -- C configurations.
      dap.adapters.codelldb = {
        type = 'server',
        host = '127.0.0.1',
        port = '6969',
        executable = {
          command = 'codelldb',
          args = { '--port', '6969' },
        },
      }

      -- Add configurations from launch.json
      require('dap.ext.vscode').load_launchjs(nil, {
        ['codelldb'] = { 'c' },
        ['pwa-node'] = { 'typescript', 'javascript' },
      })
    end,
  },
}
