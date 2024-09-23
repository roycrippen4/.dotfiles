local leet_arg = 'leetcode.nvim'

---@type LazyPluginSpec
return {
  'kawre/leetcode.nvim', --- https://github.com/kawre/leetcode.nvim
  lazy = leet_arg ~= vim.fn.argv()[1],
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-treesitter/nvim-treesitter',
    'rcarriga/nvim-notify',
    'nvim-tree/nvim-web-devicons',
  },
  ---@module "leetcode"
  ---@type lc.UserConfig
  opts = {
    arg = leet_arg,
    lang = 'rust',
    hooks = {
      ---@type fun(question: lc.ui.Question)[]
      ['question_enter'] = {
        function()
          if vim.bo.ft ~= 'rust' then
            return
          end

          require('lspconfig').rust_analyzer.setup({})

          local target_dir = vim.fn.stdpath('data') .. '/leetcode'
          local output_file = target_dir .. '/rust-project.json'

          if vim.fn.isdirectory(target_dir) ~= 1 then
            return
          end

          local crates = ''
          local next = ''

          local rs_files = vim.fn.globpath(target_dir, '*.rs', false, true)
          for _, f in ipairs(rs_files) do
            crates = crates .. next .. '{"root_module": "' .. f .. '","edition": "2021","deps": []}'
            next = ','
          end

          if crates == '' then
            print('No .rs files found in directory: ' .. target_dir)
            return
          end

          local sysroot_src = vim.fn.system('rustc --print sysroot'):gsub('\n', '') .. '/lib/rustlib/src/rust/library'
          local json_content = '{"sysroot_src": "' .. sysroot_src .. '", "crates": [' .. crates .. ']}'

          local file = io.open(output_file, 'w')
          if not file then
            print('Failed to open file: ' .. output_file)
            return
          end

          file:write(json_content)
          file:close()

          local clients = vim.lsp.get_clients()
          local rust_analyzer_attached = false

          for _, client in ipairs(clients) do
            if client.name == 'rust_analyzer' then
              rust_analyzer_attached = true
              break
            end
          end

          if rust_analyzer_attached then
            vim.cmd('RustAnalyzer restart')
          end
        end,
      },
    },
  },
}
