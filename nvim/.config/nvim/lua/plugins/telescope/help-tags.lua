-- some plugin names don't match the name you would require
-- For example, conform.nvim would be loaded via `require("conform")` NOT `require("conform.nvim")`
-- This can be different for every plugin, so you'll need to figure this out on your own.
local map = {
  ['conform.nvim'] = 'conform',
  ['crates.nvim'] = 'crates',
  ['nvim-dap'] = 'dap',
  ['nvim-nio'] = 'nio',
  ['nvim-scissors'] = 'scissors',
  ['toggleterm.nvim'] = 'toggleterm',
  ['trouble.nvim'] = 'trouble',
  ['nvim-dap-ui'] = 'dapui',
}
local plugins = require('lazy').plugins()

local help_tag_mapping = {
  ['<CR>'] = function(prompt_bufnr)
    local selection = require('telescope.actions.state').get_selected_entry()
    if not selection then
      return
    end

    ---@type string
    local doc_path = selection.filename or selection.path
    require('telescope.actions').close(prompt_bufnr)

    if pcall(vim.cmd.help, selection.value) then
      return
    end

    local plugin_to_load = nil
    for _, p in pairs(plugins) do
      if doc_path:find(p.dir, 1, true) then
        plugin_to_load = p.name
        break
      end
    end

    if plugin_to_load then
      plugin_to_load = map[plugin_to_load] or plugin_to_load
      if not pcall(require, plugin_to_load) then
        return
      end
    end

    vim.cmd('help ' .. selection.value)
  end,
}

return { mappings = { i = help_tag_mapping, n = help_tag_mapping } }
