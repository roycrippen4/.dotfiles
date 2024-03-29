local present, whichkey = pcall(require, 'which-key')

if not present then
  return
end

whichkey.setup({
  icons = {
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '', -- symbol pre-pended to a group
  },
  disable = {
    filetypes = {
      'vim',
    },
  },
})

whichkey.register({
  --[===========================================================================]
  --[-------------------------------  DEBUG  -----------------------------------]
  --[===========================================================================]
  ['<leader>d'] = { name = ' Debug  ', _ = 'which_key_ignore' },
  --[===========================================================================]
  --[-------------------------------  UNDO   -----------------------------------]
  --[===========================================================================]
  ['<leader>u'] = { name = ' UndoTree  ', _ = 'which_key_ignore' },

  --[===========================================================================]
  --[-------------------------------Find/LSP------------------------------------]
  --[===========================================================================]
  ['<leader>f'] = { name = ' Find  ', _ = 'which_key_ignore' },
  ['<leader>fg'] = { name = ' Git  ', _ = 'which_key_ignore' },
  ['<leader>l'] = { name = ' LSP  ', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = ' Refactor/rename 󰑕 ', _ = 'which_key_ignore' },

  --[===========================================================================]
  --[-------------------------- Markdown Preview -------------------------------]
  --[===========================================================================]
  ['<leader>m'] = { name = ' Markdown Preview  ', _ = 'which_key_ignore' },
  ['<leader>mp'] = { name = ' Start Markdown Preview  ', _ = 'which_key_ignore' },

  --[===========================================================================]
  --[-------------------------------- MISC -------------------------------------]
  --[===========================================================================]
  -- ['<leader>a'] = { name = 'Autosave', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = ' Trouble  ', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = ' Lookup Keymaps  ', _ = 'which_key_ignore' },
  ['<leader>z'] = { name = '  Zen ', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = ' Lazygit ⏾ ', _ = 'which_key_ignore' },
  ['gc'] = { name = ' Comment  ', _ = 'which_key_ignore' },
})
