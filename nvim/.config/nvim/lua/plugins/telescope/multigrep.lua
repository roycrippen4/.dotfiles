return function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = require('telescope.finders').new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local pieces = vim.split(prompt, '  ')
      local args = { 'rg' }
      if pieces[1] then
        table.insert(args, '-e')
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, '-g')
        table.insert(args, pieces[2])
      end

      return vim
        .iter({ args, { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' } })
        :flatten()
        :totable()
    end,
    entry_maker = require('telescope.make_entry').gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  require('telescope.pickers')
    .new(opts, {
      debounce = 100,
      prompt_title = 'Multi Grep',
      finder = finder,
      previewer = require('telescope.config').values.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end
