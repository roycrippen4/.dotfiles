return function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result, ctx)
    if not result or vim.tbl_isempty(result) then
      vim.notify('No definitions found', vim.log.levels.INFO)
      return
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
      return
    end

    --- why tf does this work?
    local locations = (vim.bo.ft == 'lua' or vim.bo.ft == 'svelte') and {}
      or vim.lsp.util.locations_to_items(result, client.offset_encoding)
    if #locations > 1 then
      require('telescope.builtin').lsp_definitions({
        cwd = vim.fn.getcwd(),
        locations = locations,
        client_id = ctx.client_id,
      })
    else
      if vim.fn.has('nvim-0.11') == 1 then
        vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
      else
        ---@diagnostic disable-next-line
        vim.lsp.util.jump_to_location(result[1], client.offset_encoding)
      end
    end
  end)
end
