local dressing_ok, dressing = pcall(require, 'dressing')

if not dressing_ok then
  return
end

dressing.setup({
  input = {
    win_options = {
      winhighlight = 'FloatBorder:CmpBorder',
      winblend = 5,
    },
  },
  select = {
    trim_prompt = false,
    get_config = function(opts)
      local winopts = {
        height = 0.6,
        width = 0.5,
      }

      if opts.kind == 'luasnip' then
        opts.prompt = 'Snippet choice: '
        winopts = {
          height = 0.35,
          width = 0.3,
        }

        if opts.prompt and not opts.prompt:match(':%s*$') then
          opts.prompt = opts.prompt .. ': '
        end

        return {
          backend = 'telescope',
          telescope = { winopts = winopts },
        }
      end
    end,
  },
})
