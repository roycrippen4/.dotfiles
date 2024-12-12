local hl_mapping = {
  ['<CR>'] = function(prompt_bufnr)
    local hl_name = require('telescope.actions.state').get_selected_entry().value
    require('telescope.actions').close(prompt_bufnr)
    local value = vim.api.nvim_get_hl(0, { name = hl_name })
    local out = {}
    if value.fg then
      table.insert(out, ('#%06x'):format(value.fg))
    end
    if value.bg then
      table.insert(out, ('#%06x'):format(value.bg))
    end

    ---@diagnostic disable-next-line
    if value.link then
      ---@diagnostic disable-next-line
      table.insert(out, 'link: ' .. value.link)
    end

    if #out > 0 then
      local to_copy = table.concat(out, '\n')
      vim.fn.setreg('+', to_copy)
      vim.notify(to_copy, vim.log.levels.INFO, { title = 'Copied' })
    end
  end,
}

return { mappings = { i = hl_mapping, n = hl_mapping } }
