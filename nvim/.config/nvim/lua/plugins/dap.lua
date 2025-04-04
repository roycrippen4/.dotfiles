---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == 'table' and table.concat(args, ' ') or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input('Run with args: ', args_str)) --[[@as string]]
    if config.type and config.type == 'java' then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require('dap.utils').splitstr(new_args)
  end
  return config
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
local function get_pkg_path(pkg, path, opts)
  pcall(require, 'mason')
  local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ''
  local ret = root .. '/packages/' .. pkg .. '/' .. path
  if opts.warn and not vim.uv.fs_stat(ret) then
    Snacks.notify.warn(('Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package.'):format(pkg, path))
  end
  return ret
end

---@type LazyPluginSpec[]
return {
  {
    'mfussenegger/nvim-dap', -- https://github.com/mfussenegger/nvim-dap
    dependencies = {
      'rcarriga/nvim-dap-ui', -- https://github.com/rcarriga/nvim-dap-ui
      { 'theHamsta/nvim-dap-virtual-text', opts = {} }, -- https://github.com/theHamsta/nvim-dap-virtual-text
      {
        'williamboman/mason.nvim',
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, 'js-debug-adapter')
        end,
      },
    },

    -- stylua: ignore
    keys = {
      { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      -- { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
      local has_mason_nvim_dap, _ = pcall(require, 'mason-nvim-dap.nvim')
      if has_mason_nvim_dap then
        require('mason-nvim-dap').setup()
      end

      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

      local vscode = require('dap.ext.vscode')
      local json = require('plenary.json')

      ---@diagnostic disable-next-line
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      local dap = require('dap')
      if not dap.adapters['pwa-node'] then
        require('dap').adapters['pwa-node'] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'node',
            args = {
              get_pkg_path('js-debug-adapter', 'js-debug/src/dapDebugServer.js'),
              '${port}',
            },
          },
        }
      end
      if not dap.adapters['node'] then
        dap.adapters['node'] = function(cb, config)
          if config.type == 'node' then
            config.type = 'pwa-node'
          end
          local native_adapter = dap.adapters['pwa-node']
          if type(native_adapter) == 'function' then
            native_adapter(cb, config)
          else
            cb(native_adapter)
          end
        end
      end
      local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }
      vscode.type_to_filetypes['node'] = js_filetypes
      vscode.type_to_filetypes['pwa-node'] = js_filetypes

      vim.iter(js_filetypes):each(function(lang) ---@param lang string
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = 'pwa-node',
              request = 'launch',
              name = 'Launch file',
              program = '${file}',
              cwd = '${workspaceFolder}',
            },
            {
              type = 'pwa-node',
              request = 'attach',
              name = 'Attach',
              processId = require('dap.utils').pick_process,
              cwd = '${workspaceFolder}',
            },
          }
        end
        if lang == 'typescript' then
          dap.configurations[lang] = {
            {
              name = 'Debug typescript',
              type = 'pwa-node',
              request = 'launch',
              program = '${file}',
              cwd = '${workspaceFolder}',
              runtimeExecutable = 'npx',
              runtimeArgs = { 'tsx', '--tsconfig', vim.fn.stdpath('config') .. '/tsconfig.json', '${file}' },
            },
          }
        end
      end)
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'nvim-neotest/nvim-nio' },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open({})
        vim.cmd.NvimTreeClose()
      end

      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close({})
        vim.cmd.NvimTreeOpen()
      end

      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close({})
        vim.cmd.NvimTreeOpen()
      end
    end,
  },
}
