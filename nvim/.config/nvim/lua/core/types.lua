---@class InspectionTableOpts
---@field end_col integer
---@field end_right_gravity boolean
---@field end_row integer
---@field hl_eol boolean
---@field hl_group string
---@field hl_group_link string
---@field ns_id integer
---@field priority integer
---@field right_gravity boolean

---@class TSInspectionTable
---@field capture string
---@field hl_group string
---@field hl_group_link string
---@field lang string
---@field metadata table

---@class InspectionTable
---@field col integer
---@field end_col integer
---@field end_row integer
---@field id integer
---@field ns string
---@field ns_id integer
---@field opts InspectionTableOpts
---@field row integer

---@class InspectInfo
---@field buffer integer
---@field col integer
---@field extmarks InspectionTable[]
---@field row integer
---@field semantic_tokens InspectionTable[]
---@field syntax table
---@field treesitter TSInspectionTable[]

---@class FormattedLinePart
---@field text string The text to display
---@field col_start integer The start column. Used for highlighting
---@field col_end integer The start column. Used for highlighting
---@field hl_group string The highlight group to use

---@alias FormattedLine FormattedLinePart[]

---@class AutocmdEvent
---@field BufAdd 'BufAdd'
---@field BufDelete 'BufDelete'
---@field BufEnter 'BufEnter'
---@field BufFilePost 'BufFilePost'
---@field BufFilePre 'BufFilePre'
---@field BufHidden 'BufHidden'
---@field BufLeave 'BufLeave'
---@field BufModifiedSet 'BufModifiedSet'
---@field BufNew 'BufNew'
---@field BufNewFile 'BufNewFile'
---@field BufRead 'BufRead'
---@field BufReadPost 'BufReadPost'
---@field BufReadCmd 'BufReadCmd'
---@field BufReadPre 'BufReadPre'
---@field BufUnload 'BufUnload'
---@field BufWinEnter 'BufWinEnter'
---@field BufWinLeave 'BufWinLeave'
---@field BufWipeout 'BufWipeout'
---@field BufWrite 'BufWrite'
---@field BufWritePre 'BufWritePre'
---@field BufWriteCmd 'BufWriteCmd'
---@field BufWritePost 'BufWritePost'
---@field ChanInfo 'ChanInfo'
---@field ChanOpen 'ChanOpen'
---@field CmdUndefined 'CmdUndefined'
---@field CmdlineChanged 'CmdlineChanged'
---@field CmdlineEnter 'CmdlineEnter'
---@field CmdlineLeave 'CmdlineLeave'
---@field CmdwinEnter 'CmdwinEnter'
---@field CmdwinLeave 'CmdwinLeave'
---@field ColorScheme 'ColorScheme'
---@field ColorSchemePre 'ColorSchemePre'
---@field CompleteChanged 'CompleteChanged'
---@field CompleteDonePre 'CompleteDonePre'
---@field CompleteDone 'CompleteDone'
---@field CursorHold 'CursorHold'
---@field CursorHoldI 'CursorHoldI'
---@field CursorMoved 'CursorMoved'
---@field CursorMovedI 'CursorMovedI'
---@field DiffUpdated 'DiffUpdated'
---@field DirChanged 'DirChanged'
---@field DirChangedPre 'DirChangedPre'
---@field ExitPre 'ExitPre'
---@field FileAppendCmd 'FileAppendCmd'
---@field FileAppendPost 'FileAppendPost'
---@field FileAppendPre 'FileAppendPre'
---@field FileChangedRO 'FileChangedRO'
---@field FileChangedShell 'FileChangedShell'
---@field FileChangedShellPost 'FileChangedShellPost'
---@field FileReadCmd 'FileReadCmd'
---@field FileReadPost 'FileReadPost'
---@field FileReadPre 'FileReadPre'
---@field FileType 'FileType'
---@field FileWriteCmd 'FileWriteCmd'
---@field FileWritePost 'FileWritePost'
---@field FileWritePre 'FileWritePre'
---@field FilterReadPost 'FilterReadPost'
---@field FilterReadPre 'FilterReadPre'
---@field FilterWritePost 'FilterWritePost'
---@field FilterWritePre 'FilterWritePre'
---@field FocusGained 'FocusGained'
---@field FocusLost 'FocusLost'
---@field FuncUndefined 'FuncUndefined'
---@field UIEnter 'UIEnter'
---@field UILeave 'UILeave'
---@field InsertChange 'InsertChange'
---@field InsertCharPre 'InsertCharPre'
---@field InsertEnter 'InsertEnter'
---@field InsertLeavePre 'InsertLeavePre'
---@field InsertLeave 'InsertLeave'
---@field MenuPopup 'MenuPopup'
---@field ModeChanged 'ModeChanged'
---@field OptionSet 'OptionSet'
---@field QuickFixCmdPre 'QuickFixCmdPre'
---@field QuickFixCmdPost 'QuickFixCmdPost'
---@field QuitPre 'QuitPre'
---@field RemoteReply 'RemoteReply'
---@field SearchWrapped 'SearchWrapped'
---@field RecordingEnter 'RecordingEnter'
---@field RecordingLeave 'RecordingLeave'
---@field SafeState 'SafeState'
---@field SessionLoadPost 'SessionLoadPost'
---@field SessionWritePost 'SessionWritePost'
---@field ShellCmdPost 'ShellCmdPost'
---@field Signal 'Signal'
---@field ShellFilterPost 'ShellFilterPost'
---@field SourcePre 'SourcePre'
---@field SourcePost 'SourcePost'
---@field SourceCmd 'SourceCmd'
---@field SpellFileMissing 'SpellFileMissing'
---@field StdinReadPost 'StdinReadPost'
---@field StdinReadPre 'StdinReadPre'
---@field SwapExists 'SwapExists'
---@field Syntax 'Syntax'
---@field TabEnter 'TabEnter'
---@field TabLeave 'TabLeave'
---@field TabNew 'TabNew'
---@field TabNewEntered 'TabNewEntered'
---@field TabClosed 'TabClosed'
---@field TermOpen 'TermOpen'
---@field TermEnter 'TermEnter'
---@field TermLeave 'TermLeave'
---@field TermClose 'TermClose'
---@field TermRequest 'TermRequest'
---@field TermResponse 'TermResponse'
---@field TextChanged 'TextChanged'
---@field TextChangedI 'TextChangedI'
---@field TextChangedP 'TextChangedP'
---@field TextChangedT 'TextChangedT'
---@field TextYankPost 'TextYankPost'
---@field User 'User'
---@field VimEnter 'VimEnter'
---@field VimLeave 'VimLeave'
---@field VimLeavePre 'VimLeavePre'
---@field VimResized 'VimResized'
---@field VimResume 'VimResume'
---@field VimSuspend 'VimSuspend'
---@field WinClosed 'WinClosed'
---@field WinEnter 'WinEnter'
---@field WinLeave 'WinLeave'
---@field WinNew 'WinNew'
---@field WinScrolled 'WinScrolled'
---@field WinResized 'WinResized'

---@type AutocmdEvent
_G.E = {
  -- After adding a new buffer or existing unlisted buffer to the buffer list
  -- (except during startup, see |VimEnter|), or renaming a listed buffer.
  -- ---
  -- Before |BufEnter|.
  -- ---
  -- NOTE:
  -- Current buffer "%" is not the target buffer "<afile>", "<abuf>".
  -- |<buffer=abuf>|
  BufAdd = 'BufAdd',

  -- Before deleting a buffer from the buffer list.
  -- The BufUnload may be called first (if the buffer was loaded).
  -- Also used just before a buffer in the buffer list is renamed.
  -- ---
  -- NOTE:
  -- Current buffer "%" is not the target buffer "<afile>", "<abuf>".
  -- |<buffer=abuf>|
  -- Do not change to another buffer.
  BufDelete = 'BufDelete',

  -- After entering (visiting, switching-to) a new or existing buffer.
  -- Useful for setting filetype options.
  -- Compare |BufNew| which does not trigger for existing buffers.
  -- ---
  -- After |BufAdd|.
  -- After |BufReadPost|.
  BufEnter = 'BufEnter',

  -- After changing the name of the current buffer
  -- with the ":file" or ":saveas" command.
  BufFilePost = 'BufFilePost',

  -- Before changing the name of the current buffer
  -- with the ":file" or ":saveas" command.
  BufFilePre = 'BufFilePre',

  -- Before a buffer becomes hidden: when there are no longer windows
  -- that show the buffer, but the buffer is not unloaded or deleted.
  -- Not used for ":qa" or ":q" when exiting Vim.
  -- ---
  -- NOTE: Current buffer "%" is not the target buffer "<afile>", "<abuf>".
  -- |<buffer=abuf>|
  BufHidden = 'BufHidden',

  -- Before leaving to another buffer.
  -- Also when leaving or closing the current window and
  -- the new current window is not for the same buffer.
  -- ---
  -- Not used for ":qa" or ":q" when exiting Vim.
  BufLeave = 'BufLeave',

  -- After the `'modified'` value of a buffer has been changed.
  BufModifiedSet = 'BufModifiedSet',

  -- After creating a new buffer (except during startup, see |VimEnter|)
  -- or renaming an existing buffer. Unlike |BufEnter|, visiting
  -- (switching to) an existing buffer will not trigger this again.
  -- ---
  -- NOTE: Current buffer "%" is not the target
  -- buffer "<afile>", "<abuf>". |<buffer=abuf>|
  -- ---
  -- See also |BufAdd|, |BufNewFile|.
  BufNew = 'BufNew',

  -- When starting to edit a file that doesn't exist.
  -- Can be used to read in a skeleton file.
  BufNewFile = 'BufNewFile',

  -- When starting to edit a new buffer, after reading the file
  -- into the buffer, before processing modelines.
  -- See |BufWinEnter| to do something after processing modelines.
  -- ---
  -- Also triggered:
  -- - when writing an unnamed buffer in a way that
  --   the buffer gets a name
  -- - after successfully recovering a file
  -- - for the "filetypedetect" group when
  --   executing ":filetype detect"
  -- ---
  -- Not triggered:
  -- - for the `:read file` command
  -- - when the file doesn't exist
  BufRead = 'BufRead',

  -- When starting to edit a new buffer, after reading the file
  -- into the buffer, before processing modelines.
  -- See |BufWinEnter| to do something after processing modelines.
  -- ---
  -- Also triggered:
  -- - when writing an unnamed buffer in a way that
  --   the buffer gets a name
  -- - after successfully recovering a file
  -- - for the "filetypedetect" group when
  --   executing ":filetype detect"
  -- ---
  -- Not triggered:
  -- - for the `:read file` command
  -- - when the file doesn't exist
  BufReadPost = 'BufReadPost',

  -- Before starting to edit a new buffer.
  -- Should read the file into the buffer.
  -- ---
  -- See |Cmd-event|
  BufReadCmd = 'BufReadCmd',

  -- When starting to edit a new buffer, before reading the file into the buffer.
  -- Not used if the file doesn't exist.
  BufReadPre = 'BufReadPre',

  -- Before unloading a buffer, when the text in the buffer is going to be freed.
  -- ---
  -- After |BufWritePost|.
  -- Before |BufDelete|.
  -- ---
  -- Triggers for all loaded buffers when Vim isgoing to exit.
  -- ---
  -- NOTE: Current buffer "%" is not the target
  -- buffer "<afile>", "<abuf>". |<buffer=abuf>|
  -- Do not switch buffers or windows!
  -- Not triggered when exiting and |v:dying| is 2 or more.
  BufUnload = 'BufUnload',

  -- After a buffer is displayed in a window.
  -- This may be when the buffer is loaded (after processing modelines)
  -- or when a hidden buffer is displayed (and is no longer hidden).
  -- ---
  -- Not triggered for |:split| without arguments, since the buffer does not change,
  -- or :split with a file already open in a window.
  -- ---
  -- Triggered for |:split| with the name of the current buffer, since it reloads that buffer.
  BufWinEnter = 'BufWinEnter',

  -- Before a buffer is removed from a window.
  -- Not when it's still visible in another window.
  -- Also triggered when exiting.
  -- ---
  -- Before BufUnload, BufHidden.
  -- ---
  -- NOTE:
  -- Current buffer "%" is not the target buffer "<afile>", "<abuf>".
  -- |<buffer=abuf>|
  -- Not triggered when exiting and |v:dying| is 2 or more.
  BufWinLeave = 'BufWinLeave',

  -- Before completely deleting a buffer.
  -- The |BufUnload| and |BufDelete| events may be called
  -- first (if the buffer was loaded and was in the buffer list).
  -- Also used just before a buffer is renamed (also when it's not in the buffer list).
  -- ---
  -- NOTE:
  -- Current buffer "%" is not the target buffer "<afile>", "<abuf>".
  -- |<buffer=abuf>|
  -- Do not change to another buffer.
  BufWipeout = 'BufWipeout',

  -- Before writing the whole buffer to a file.
  BufWrite = 'BufWrite',

  -- Before writing the whole buffer to a file.
  BufWritePre = 'BufWritePre',

  -- Before writing the whole buffer to a file.
  -- Should do the writing of the file and reset 'modified' if successful,
  -- unless '+' is in 'cpo' and writing to another file |cpo-+|.
  -- The buffer contents should not be changed.
  -- When the command resets 'modified' the undo information is adjusted
  -- to mark older undo states as 'modified', like |:write| does.
  -- |Cmd-event|
  BufWriteCmd = 'BufWriteCmd',

  -- After writing the whole buffer to a file (should undo the commands for |BufWritePre|).
  BufWritePost = 'BufWritePost',

  -- State of channel changed, for instance the
  -- client of a RPC channel described itself.
  -- ---
  -- Sets these |v:event| keys:
  --     info
  -- ---
  -- See |nvim_get_chan_info()| for the format of the info Dictionary.
  ChanInfo = 'ChanInfo',

  -- Just after a channel was opened.
  -- ---
  -- Sets these |v:event| keys:
  --     info
  -- ---
  -- See |nvim_get_chan_info()| for the format of the info Dictionary.
  ChanOpen = 'ChanOpen',

  -- When a user command is used but it isn't defined.
  -- Useful for defining a command only when it's used.
  -- The pattern is matched against the command name.
  -- Both |<amatch>| and |<afile>| expand to the command name.
  -- ---
  -- NOTE: Autocompletion won't work until the command is defined.
  -- An alternative is to always define the user command and have it
  -- invoke an autoloaded function.
  -- ---
  -- See |autoload|.
  CmdUndefined = 'CmdUndefined',

  -- After a change was made to the text inside command line.
  -- Be careful not to mess up the command line, it may cause Vim to lock up.
  -- ---
  -- |<afile>| expands to the |cmdline-char|.
  CmdlineChanged = 'CmdlineChanged',

  -- After entering the command-line (including non-interactive
  -- use of ":" in a mapping: use |<Cmd>| instead to avoid this).
  -- The pattern is matched against |cmdline-char|.
  -- ---
  -- |<afile>| expands to the |cmdline-char|.
  -- ---
  -- Sets these |v:event| keys:
  --     cmdlevel
  --     cmdtype
  CmdlineEnter = 'CmdlineEnter',

  -- Before leaving the command-line (including non-interactive
  -- use of ":" in a mapping: use |<Cmd>| instead to avoid this).
  -- ---
  -- |<afile>| expands to the |cmdline-char|.
  -- ---
  -- Sets these |v:event| keys:
  --     abort (mutable)
  --     cmdlevel
  --     cmdtype
  -- ---
  -- NOTE:
  -- `abort` can only be changed from false to true.
  -- It cannot execute an already aborted cmdline by changing it to false.
  CmdlineLeave = 'CmdlineLeave',

  -- After entering the command-line window.
  -- Useful for setting options specifically for this special type of window.
  -- <afile> expands to a single character, indicating the type of command-line.
  -- ---
  -- |cmdwin-char|
  CmdwinEnter = 'CmdwinEnter',

  -- Before leaving the command-line window.
  -- Useful to clean up any global setting done with |CmdwinEnter|.
  -- ---
  -- <afile> expands to a single character, indicating the type of command-line.
  -- ---
  -- |cmdwin-char|
  CmdwinLeave = 'CmdwinLeave',

  -- After loading a color scheme. See |:colorscheme|
  -- ---
  -- Not triggered if the color scheme is not found.
  -- The pattern is matched against the colorscheme name.
  -- |<afile>| can be used for the name of the actual file
  -- where this option was set, and |<amatch>| for
  -- the new colorscheme name.
  ColorScheme = 'ColorScheme',

  -- Before loading a color scheme. See |:colorscheme|
  -- ---
  -- Useful to setup removing things added by a
  -- color scheme, before another one is loaded.
  ColorSchemePre = 'ColorSchemePre',

  -- After each time the Insert mode completion menu changed.
  -- Not fired on |popup-menu| hide.
  -- Use |CompleteDonePre| or |CompleteDone| for |popup-menu| hide event.
  -- ---
  -- Sets these |v:event| keys:
  --     completed_itemSee |complete-items|.
  --     heightnr of items visible
  --     widthscreen cells
  --     rowtop screen row
  --     colleftmost screen column
  --     sizetotal nr of items
  --     scrollbarTRUE if visible
  -- ---
  -- Non-recursive (event cannot trigger itself).
  -- Cannot change the text. |textlock|
  -- ---
  -- The size and position of the popup are also
  -- available by calling |pum_getpos()|.
  CompleteChanged = 'CompleteChanged',

  -- After Insert mode completion is done.
  -- Either when something was completed or abandoning
  -- completion. |ins-completion|
  -- ---
  -- |complete_info()| can be used, the info is cleared
  -- after triggering |CompleteDonePre|.
  -- The |v:completed_item| variable contains
  -- information about the completed item.
  CompleteDonePre = 'CompleteDonePre',

  -- After Insert mode completion is done.
  -- Either when something was completed or abandoning
  -- completion. |ins-completion|
  --
  -- |complete_info()| cannot be used, the info is
  -- cleared before triggering |CompleteDone|.
  -- Use |CompleteDonePre| if you need it.
  --
  -- |v:completed_item| gives the completed item.
  CompleteDone = 'CompleteDone',

  -- When the user doesn't press a key for the time specified with 'updatetime'.
  -- Not triggered until the user has pressed a key
  -- (i.e. doesn't fire every 'updatetime' ms if you leave Vim to make some coffee. :)
  -- See |CursorHold-example| for previewing tags.
  --
  -- This event is only triggered in Normal mode.
  -- It is not triggered when waiting for a command argument to be typed,
  -- or a movement after an operator.
  -- While recording the CursorHold event is not triggered. |q|
  --
  -- Internally the autocommand is triggered by the <CursorHold> key.
  -- In an expression mapping |getchar()| may see this character.
  -- ---
  -- NOTE: Interactive commands cannot be used for this event.
  -- There is no hit-enter prompt, the screen is updated directly (when needed).
  -- ---
  -- NOTE:
  -- In the future there will probably be another option to set the time.
  -- ---
  -- HINT:
  -- to force an update of the status lines use:
  -- :let &ro = &ro
  CursorHold = 'CursorHold',

  -- Like CursorHold, but in Insert mode.
  -- Not triggered when waiting for another key, e.g.
  -- after CTRL-V, and not in CTRL-X mode |insert_expand|.
  CursorHoldI = 'CursorHoldI',

  -- After the cursor was moved in Normal or Visual mode or to another window.
  -- Also when the text of the cursor line has been changed, e.g. with
  -- "x", "rx" or "p".
  --
  -- Not always triggered when there is typeahead, while executing commands
  -- in a script file, or when an operator is pending.
  --
  -- For an example see |match-parens|.
  -- ---
  -- Note: Cannot be skipped with |:noautocmd|.
  -- ---
  -- Careful:
  -- This is triggered very often, don't do anything
  -- that the user does not expect or that is slow.
  CursorMoved = 'CursorMoved',

  -- After the cursor was moved in Insert mode.
  -- Not triggered when the popup menu is visible.
  -- Otherwise the same as CursorMoved.
  CursorMovedI = 'CursorMovedI',

  -- After diffs have been updated.
  -- Depending on what kind of diff is being
  -- used (internal or external) this can be
  -- triggered on every change or when
  -- doing |:diffupdate|.
  DiffUpdated = 'DiffUpdated',

  -- After the |current-directory| was changed.
  --
  -- The pattern can be:
  -- "window"  to trigger on `:lcd`
  -- "tabpage" to trigger on `:tcd`
  -- "global"  to trigger on `:cd`
  -- "auto"    to trigger on 'autochdir'.
  --
  -- Sets these |v:event| keys:
  --     cwd:            current working directory
  --     scope:          "global", "tabpage", "window"
  --     changed_window: v:true if we fired the event
  --                     switching window (or tab)
  --
  -- <afile> is set to the new directory name.
  -- Non-recursive (event cannot trigger itself).
  DirChanged = 'DirChanged',

  -- When the |current-directory| is going to be changed, as with |DirChanged|.
  --
  -- The pattern is like with |DirChanged|.
  --
  -- Sets these |v:event| keys:
  --     directory:      new working directory
  --     scope:          "global", "tabpage", "window"
  --     changed_window: |v:true| if we fired the event switching window (or tab)
  --
  -- |<afile>| is set to the new directory name.
  -- Non-recursive (event cannot trigger itself).
  DirChangedPre = 'DirChangedPre',

  -- When using `:quit`, `:wq` in a way it makes
  -- Vim exit, or using `:qall`, just after |QuitPre|.
  -- Can be used to close any non-essential window.
  -- Exiting may still be cancelled if there is a modified buffer that
  -- isn't automatically saved, use |VimLeavePre| for really exiting.
  -- ---
  -- See also |QuitPre|, |WinClosed|.
  ExitPre = 'ExitPre',

  -- Before appending to a file.
  -- Should do the appending to the file.
  -- Use the '[ and '] marks for the range of lines.
  -- |Cmd-event|
  FileAppendCmd = 'FileAppendCmd',

  -- After appending to a file.
  FileAppendPost = 'FileAppendPost',

  -- Before appending to a file.
  -- Use the '[ and '] marks for the range of lines.
  FileAppendPre = 'FileAppendPre',

  -- Before making the first change to a read-only file.
  -- Can be used to checkout the file from a source control system.
  -- Not triggered when the change was caused by an autocommand.
  -- Triggered when making the first change in
  -- a buffer or the first change after 'readonly' was set,
  -- just before the change is applied to the text.
  -- ---
  -- **WARNING**:
  -- If the autocommand moves the cursor the effect of the change is undefined.
  -- *E788*
  -- Cannot switch buffers.  You can reload the buffer but not edit another one.
  -- *E881*
  -- If the number of lines changes saving for undo may fail and the change will be aborted.
  FileChangedRO = 'FileChangedRO',

  -- When Vim notices that the modification time of a file has changed since editing started.
  -- Also when the file attributes of the file change or when the size of the file changes. |timestamp|
  --
  -- Triggered for each changed file, after:
  -- - executing a shell command
  -- - |:checktime|
  -- - |FocusGained|
  --
  -- Not used when 'autoread' is set and the buffer was not changed.
  -- If a FileChangedShell autocommand exists the warning message and prompt is not given.
  --
  -- |v:fcs_reason| indicates what happened.
  -- Set |v:fcs_choice| to control what happens next.
  -- ---
  -- **NOTE**:
  -- Current buffer "%" is not the target buffer "<afile>" and "<abuf>". |<buffer=abuf>|
  -- *E246* *E811*
  -- Cannot switch, jump to or delete buffers. Non-recursive (event cannot trigger itself).
  FileChangedShell = 'FileChangedShell',

  -- After handling a file that was changed outside of Vim.
  -- Can be used to update the statusline.
  FileChangedShellPost = 'FileChangedShellPost',

  -- Before reading a file with a ":read" command.
  -- Should do the reading of the file. |Cmd-event|
  FileReadCmd = 'FileReadCmd',

  -- After reading a file with a ":read" command.
  -- Note that Vim sets the '[ and '] marks to the first and last line of the read.
  -- This can be used to operate on the lines just read.
  FileReadPost = 'FileReadPost',

  -- Before reading a file with a ":read" command.
  FileReadPre = 'FileReadPre',

  -- When the 'filetype' option has been set.
  -- The pattern is matched against the filetype.
  -- |<afile>| is the name of the file where this option was set.
  -- |<amatch>| is the new value of 'filetype'.
  -- Cannot switch windows or buffers.
  -- ---
  -- See |filetypes|.
  FileType = 'FileType',

  -- Before writing to a file, when not writing the whole buffer.
  -- Should do the writing to the file.
  -- Should not change the buffer.
  -- Use the '[ and '] marks for the range of lines.
  -- |Cmd-event|
  FileWriteCmd = 'FileWriteCmd',

  -- After writing to a file, when not writing the whole buffer.
  FileWritePost = 'FileWritePost',

  -- Before writing to a file, when not writing the whole buffer.
  -- Use the '[ and '] marks for the range of lines.
  FileWritePre = 'FileWritePre',

  -- After reading a file from a filter command.
  -- Vim checks the pattern against the name of
  -- the current buffer as with FilterReadPre.
  --
  -- Not triggered when 'shelltemp' is off.
  FilterReadPost = 'FilterReadPost',

  -- Before reading a file from a filter command.
  -- Vim checks the pattern against the name of the current buffer,
  -- not the name of the temporary file that is the output of the filter command.
  -- Not triggered when 'shelltemp' is off.
  FilterReadPre = 'FilterReadPre',

  -- After writing a file for a filter command or
  -- making a diff with an external diff
  -- (see |DiffUpdated| for internal diff).
  -- Vim checks the pattern against the name of
  -- the current buffer as with FilterWritePre.
  -- Not triggered when 'shelltemp' is off.
  FilterWritePost = 'FilterWritePost',

  -- Before writing a file for a filter command or
  -- making a diff with an external diff.
  -- Vim checks the pattern against the name of
  -- the current buffer, not the name of the
  -- temporary file that is the output of the
  -- filter command.
  -- Not triggered when 'shelltemp' is off.
  FilterWritePre = 'FilterWritePre',

  -- Nvim got focus.
  FocusGained = 'FocusGained',

  -- Nvim lost focus.
  -- Also (potentially) when a GUI dialog pops up.
  FocusLost = 'FocusLost',

  -- When a user function is used but it isn't defined.
  -- Useful for defining a function only when it's used.
  -- The pattern is matched against the function name.
  -- Both |<amatch>| and |<afile>| are set to the name of the function.
  -- ---
  -- **NOTE**:
  -- When writing Vim scripts a better alternative is to
  -- use an autoloaded function.
  -- See |autoload-functions|.
  FuncUndefined = 'FuncUndefined',

  -- After a UI connects via |nvim_ui_attach()|, or
  -- after builtin TUI is started, after |VimEnter|.
  --
  -- Sets these |v:event| keys:
  --     chan: |channel-id| of the UI
  UIEnter = 'UIEnter',

  -- After a UI disconnects from Nvim, or after
  -- builtin TUI is stopped, after |VimLeave|.
  -- Sets these |v:event| keys:
  --     chan: |channel-id| of the UI
  UILeave = 'UILeave',

  -- When typing |<Insert>| while in Insert or |Replace| mode.
  -- The |v:insertmode| variable indicates the new mode.
  -- Be careful not to move the cursor or do
  -- anything else that the user does not expect.
  InsertChange = 'InsertChange',

  -- When a character is typed in Insert mode, before inserting the char.
  -- The |v:char| variable indicates the char typed and can be changed during the
  -- event to insert a different character.
  -- When |v:char| is set to more than one character this text is inserted literally.
  --
  -- Cannot change the text. |textlock|
  InsertCharPre = 'InsertCharPre',

  -- Just before starting Insert mode.
  -- Also for |Replace| mode and |Virtual-Replace| mode.
  -- The |v:insertmode| variable indicates the mode.
  -- Be careful not to do anything else that the user does not expect.
  -- The cursor is restored afterwards.
  -- If you do not want that set |v:char| to a non-empty string.
  InsertEnter = 'InsertEnter',

  -- Just before leaving Insert mode.
  -- Also when using CTRL-O |i_CTRL-O|.
  -- Be careful not to change mode or use `:normal`,
  -- it will likely cause trouble.
  InsertLeavePre = 'InsertLeavePre',

  -- Just after leaving Insert mode.
  -- Also when using CTRL-O |i_CTRL-O|.
  -- But not for |i_CTRL-C|.
  InsertLeave = 'InsertLeave',

  -- Just before showing the popup menu (under the right mouse button).
  -- Useful for adjusting the menu for what is under the cursor or mouse pointer.
  -- The pattern is matched against one or two characters representing the mode:
  --     n    Normal
  --     v    Visual
  --     o    Operator-pending
  --     i    Insert
  --     c    Command line
  --     tl   Terminal
  MenuPopup = 'MenuPopup',

  -- After changing the mode.
  -- The pattern is matched against `'old_mode:new_mode'`,
  -- for example match against `*:c` to simulate |CmdlineEnter|.
  --
  -- The following values of |v:event| are set:
  --     **old_mode**  The mode before it changed.
  --     **new_mode**  The new mode as also returned
  --               by |mode()| called with a non-zero argument.
  --
  -- When ModeChanged is triggered, old_mode will have the value of
  -- new_mode when the event was last triggered.
  --
  -- This will be triggered on every minor mode change.
  --
  -- Usage example to use relative line numbers when entering visual mode:
  -- ```vim
  -- :au ModeChanged [vV\x16]*:* let &l:rnu = mode() =~# '^[vV\x16]'
  -- :au ModeChanged *:[vV\x16]* let &l:rnu = mode() =~# '^[vV\x16]'
  -- :au WinEnter,WinLeave * let &l:rnu = mode() =~# '^[vV\x16]'
  -- ```
  ModeChanged = 'ModeChanged',

  -- After setting an option (except during |startup|).
  -- The |autocmd-pattern| is matched against the long option name.
  -- |<amatch>| indicates what option has been set.
  --
  -- |v:option_type| indicates whether it's global or local scoped.
  -- |v:option_command| indicates what type of set/let command was
  -- used (follow the tag to see the table).
  -- |v:option_new| indicates the newly set value.
  -- |v:option_oldlocal| has the old local value.
  -- |v:option_oldglobal| has the old global value.
  -- |v:option_old| indicates the old option value.
  --
  -- |v:option_oldlocal| is only set when |:set| or |:setlocal| or
  -- a |modeline| was used to set the option.
  -- Similarly |v:option_oldglobal| is only set when |:set| or
  -- |:setglobal| was used.
  --
  -- This does not set |<abuf>|, you could use |bufnr()|.
  --
  -- Note that when setting a |global-local| option with |:set|,
  -- then |v:option_old| is the old global value.
  -- However, for all options that are not global-local it is the
  -- old local value.
  --
  -- ---
  -- Usage example:
  -- Check for the existence of the directory in the 'backupdir'
  -- and 'undodir' options, create the directory if it doesn't exist yet.
  -- ---
  -- **NOTE**:
  -- Do not reset the same option during this autocommand,
  -- that may break plugins. You can always use |:noautocmd| to prevent
  -- triggering |OptionSet|.
  -- ---
  -- Non-recursive: |:set| in the autocommand does
  -- not trigger OptionSet again.
  --
  -- Not triggered on startup.
  OptionSet = 'OptionSet',

  -- Before a quickfix command is run (
  --   |:make|, |:lmake|, |:grep|, |:lgrep|, |:grepadd|,
  --   |:lgrepadd|, |:vimgrep|, |:lvimgrep|, |:vimgrepadd|,
  --   |:lvimgrepadd|, |:cfile|, |:cgetfile|, |:caddfile|,
  --   |:lfile|, |:lgetfile|, |:laddfile|, |:helpgrep|,
  --   |:lhelpgrep|, |:cexpr|, |:cgetexpr|, |:caddexpr|,
  --   |:cbuffer|, |:cgetbuffer|, |:caddbuffer|
  -- ).
  --
  -- The pattern is matched against the command being run.
  -- When |:grep| is used but 'grepprg' is set to "internal"
  -- it still matches "grep".
  --
  -- This command cannot be used to set the 'makeprg' and
  -- 'grepprg' variables.
  -- If this command causes an error, the quickfix
  -- command is not executed.
  QuickFixCmdPre = 'QuickFixCmdPre',

  -- Like QuickFixCmdPre, but after a quickfix
  -- command is run, before jumping to the first location.
  -- For |:cfile| and |:lfile| commands it is run after the
  -- error file is read and before moving to the first error.
  -- ---
  -- See |QuickFixCmdPost-example|.
  QuickFixCmdPost = 'QuickFixCmdPost',

  -- When using `:quit`, `:wq` or `:qall`, before deciding whether
  -- it closes the current window or quits Vim.
  --
  -- For `:wq` the buffer is written before QuitPre is triggered.
  --
  -- Can be used to close any non-essential window if the current
  -- window is the last ordinary window.
  -- ---
  -- See also |ExitPre|, |WinClosed|.
  QuitPre = 'QuitPre',

  -- When a reply from a Vim that functions as server was received server2client().
  -- The pattern is matched against the {serverid}.
  -- |<amatch>| is equal to the {serverid} from which the reply was sent.
  -- |<afile>| is the actual reply string.
  -- Note that even if an autocommand is defined, the reply should be read with
  -- remote_read() to consume it.
  RemoteReply = 'RemoteReply',

  -- After making a search with |n| or |N| if the search wraps
  -- around the document back to the start/finish respectively.
  SearchWrapped = 'SearchWrapped',

  -- When a macro starts recording.
  -- The pattern is the current file name.
  -- |reg_recording()| is the current register that is used.
  RecordingEnter = 'RecordingEnter',

  -- When a macro stops recording.
  --
  -- The pattern is the current file name.
  -- |reg_recording()| is the recorded register.
  -- |reg_recorded()| is only updated after this event.
  --
  -- Sets these |v:event| keys:
  --     regcontents
  --     regname
  RecordingLeave = 'RecordingLeave',

  -- When nothing is pending, going to wait for the user to type a character.
  --
  -- This will not be triggered when:
  --   - an operator is pending
  --   - a register was entered with "r
  --   - halfway executing a command
  --   - executing a mapping
  --   - there is typeahead
  --   - Insert mode completion is active
  --   - Command line completion is active
  --
  -- You can use `mode()` to find out what state Vim is in.
  -- That may be:
  --   - Visual mode
  --   - Normal mode
  --   - Insert mode
  --   - Command-line mode
  --
  -- Depending on what you want to do, you may also check more with
  -- `state()`, e.g. whether the screen was scrolled for messages.
  SafeState = 'SafeState',

  -- After loading the session file created using	the |:mksession| command.
  SessionLoadPost = 'SessionLoadPost',

  -- After writing a session file by calling the |:mksession| command.
  SessionWritePost = 'SessionWritePost',

  -- After executing a shell command with |:!cmd|, |:make|
  -- and |:grep|.
  --
  -- Can be used to check for any changed files.
  -- For non-blocking shell commands, see |job-control|.
  ShellCmdPost = 'ShellCmdPost',

  -- After Nvim receives a signal.
  --
  -- The pattern is matched against the signal name.
  -- Only "SIGUSR1" and "SIGWINCH" are supported.
  -- ---
  -- Example:
  -- ```vim
  --     autocmd Signal SIGUSR1 call some#func()
  -- ```
  Signal = 'Signal',

  -- After executing a shell command with
  -- ":{range}!cmd", ":w !cmd" or ":r !cmd".
  -- Can be used to check for any changed files.
  ShellFilterPost = 'ShellFilterPost',

  -- Before sourcing a Vimscript/Lua file.
  -- |:source| <afile> is the name of the file being sourced.
  SourcePre = 'SourcePre',

  -- After sourcing a Vimscript/Lua file.
  -- |:source| <afile> is the name of the file being sourced.
  -- Not triggered when sourcing was interrupted.
  -- Also triggered after a SourceCmd autocommand was triggered.
  SourcePost = 'SourcePost',

  -- When sourcing a Vimscript/Lua file.
  -- |:source| <afile> is the name of the file being sourced.
  -- The autocommand must source that file.
  -- |Cmd-event|
  SourceCmd = 'SourceCmd',

  -- When trying to load a spell checking file and it can't be found.
  -- The pattern is matched against the language.
  -- <amatch> is the language, 'encoding' also matters.
  -- ---
  -- See |spell-SpellFileMissing|.
  SpellFileMissing = 'SpellFileMissing',

  -- During startup, after reading from stdin into
  -- the buffer, before executing modelines.
  -- |--|
  StdinReadPost = 'StdinReadPost',

  -- During startup, before reading from stdin into the buffer.
  -- |--|
  StdinReadPre = 'StdinReadPre',

  -- Detected an existing swap file when starting to edit a file.
  -- Only when it is possible to select a way to handle the situation,
  -- when Vim would ask the user what to do.
  --
  -- The |v:swapname| variable holds the name of the swap file found,
  -- |<afile>| the file being edited.
  --
  -- |v:swapcommand| may contain a command to be executed in the opened file.
  -- The commands should set the |v:swapchoice| variable to a string with one
  -- character to tell Vim what should be done next:
  --     'o'    open read-only
  --     'e'    edit the file anyway
  --     'r'    recover
  --     'd'    delete the swap file
  --     'q'    quit, don't edit the file
  --     'a'    abort, like hitting CTRL-C
  -- When set to an empty string the user will be asked, as if there was
  -- no SwapExists autocmd.
  -- *E812*
  -- Cannot change to another buffer, change the buffer name or change directory.
  SwapExists = 'SwapExists',

  -- When the 'syntax' option has been set.
  -- The pattern is matched against the syntax name.
  -- |<afile>| expands to the name of the file where
  -- this option was set.
  -- |<amatch>| expands to the new value of 'syntax'.
  -- ---
  -- See |:syn-on|.
  Syntax = 'Syntax',

  -- Just after entering a tab page. |tab-page|
  -- ---
  -- After |WinEnter|.
  -- Before |BufEnter|.
  TabEnter = 'TabEnter',

  -- Just before leaving a tab page. |tab-page|
  -- ---
  -- After |WinLeave|.
  TabLeave = 'TabLeave',

  -- When creating a new tab page. |tab-page|
  -- ---
  -- After |WinEnter|.
  -- Before |BufEnter|.
  TabNew = 'TabNew',

  -- After entering a new tab page. |tab-page|
  -- ---
  -- After BufEnter.
  TabNewEntered = 'TabNewEntered',

  -- After closing a tab page.
  -- <afile> expands to the tab page number.
  TabClosed = 'TabClosed',

  -- When a |terminal| job is starting.
  -- Can be used to configure the terminal buffer.
  TermOpen = 'TermOpen',

  -- After entering |Terminal-mode|.
  -- ---
  -- After TermOpen.
  TermEnter = 'TermEnter',

  -- After leaving |Terminal-mode|.
  -- ---
  -- After TermClose.
  TermLeave = 'TermLeave',

  -- When a |terminal| job ends.
  -- Sets these |v:event| keys:
  --     status
  TermClose = 'TermClose',

  -- When a |:terminal| child process emits an OSC or DCS sequence.
  -- Sets |v:termrequest|.
  -- The |event-data| is the request string.
  TermRequest = 'TermRequest',

  -- When Nvim receives an OSC or DCS response from the host terminal.
  -- Sets |v:termresponse|.
  -- The |event-data| is the response string.
  -- May be triggered during another event (file I/O, a shell command,
  -- or anything else that takes time).
  -- ---
  -- Example:
  -- ```lua
  -- -- Query the terminal palette for the RGB value of color 1
  -- -- (red) using OSC 4
  -- vim.api.nvim_create_autocmd('TermResponse', {
  --   once = true,
  --   callback = function(args)
  --     local resp = args.data
  --     local r, g, b = resp:match("\027%]4;1;rgb:(%w+)/(%w+)/(%w+)")
  --   end,
  -- })
  -- io.stdout:write("\027]4;1;?\027\\")
  -- ```
  TermResponse = 'TermResponse',

  -- After a change was made to the text in the current buffer
  -- in Normal mode.
  -- That is after |b:changedtick| has changed (also when that
  -- happened before the TextChanged autocommand was defined).
  -- Not triggered when there is typeahead or when an operator
  -- is pending.
  -- ---
  -- **Note**:
  -- Cannot be skipped with `:noautocmd`.
  -- ---
  -- **Careful**:
  -- This is triggered very often, don't do anything that
  -- the user does not expect or that is slow.
  TextChanged = 'TextChanged',

  -- After a change was made to the text in the
  -- current buffer in |Insert| mode.
  --
  -- Not triggered when the popup menu is visible.
  -- Otherwise the same as |TextChanged|.
  TextChangedI = 'TextChangedI',

  -- After a change was made to the text in the current
  -- uffer in |Insert| mode, only when the popup menu is
  -- visible.
  -- Otherwise the same as |TextChanged|.
  TextChangedP = 'TextChangedP',

  -- After a change was made to the text in the current
  -- buffer in |Terminal-mode|.
  -- Otherwise the same as |TextChanged|.
  TextChangedT = 'TextChangedT',

  -- Just after a |yank| or |deleting| command, but
  -- not if the black hole register |quote_| is used
  -- nor for |setreg()|.
  --
  -- Pattern must be "*".
  --
  -- Sets these |v:event| keys:
  --     inclusive
  --     operator
  --     regcontents
  --     regname
  --     regtype
  --     visual
  -- The `inclusive` flag combined with the |'[|
  -- and |']| marks can be used to calculate the
  -- precise region of the operation.
  --
  -- Non-recursive (event cannot trigger itself).
  -- Cannot change the text. |textlock|
  TextYankPost = 'TextYankPost',

  -- Not executed automatically.
  -- Use |:doautocmd| to trigger this,
  -- typically for "custom events" in a plugin.
  -- ---
  -- Example:
  -- ```vim
  -- :autocmd User MyPlugin echom 'got MyPlugin event'
  -- :doautocmd User MyPlugin
  -- ```
  User = 'User',

  -- After doing all the startup stuff, including-loading vimrc files,
  -- executing the "-c cmd" arguments, creating all windows and loading
  -- the buffers in them.
  --
  -- Just before this event is triggered the |v:vim_did_enter| variable
  -- is set, so that you can do the following:
  -- ```vim
  -- if v:vim_did_enter
  --   call s:init()
  -- else
  --   au VimEnter * call s:init()
  -- endif
  -- ```
  VimEnter = 'VimEnter',

  -- Before exiting Vim, just after writing the .shada file.
  -- Executed only once, like VimLeavePre.
  --
  -- Use |v:dying| to detect an abnormal exit.
  -- Use |v:exiting| to get the exit code.
  --
  -- Not triggered if |v:dying| is 2 or more.
  VimLeave = 'VimLeave',

  -- Before exiting Vim, just before writing the .shada file.
  -- This is executed only once, if there is a match with the
  -- name of what happens to be the current buffer when exiting.
  --
  -- Mostly useful with a "*" pattern.
  --
  -- ```vim
  -- :autocmd VimLeavePre * call CleanupStuff()
  -- ```
  -- Use |v:dying| to detect an abnormal exit.
  -- Use |v:exiting| to get the exit code.
  -- Not triggered if |v:dying| is 2 or more.
  VimLeavePre = 'VimLeavePre',

  -- After the Vim window was resized, thus 'lines'
  -- and/or 'columns' changed.
  -- Not triggered when starting up.
  VimResized = 'VimResized',

  -- After Nvim resumes from |suspend| state.
  VimResume = 'VimResume',

  -- Before Nvim enters |suspend| state.
  VimSuspend = 'VimSuspend',

  -- When closing a window, just before it is removed from the window layout.
  -- The pattern is matched against the |window-ID|.
  -- Both |<amatch>| and |<afile>| are set to the |window-ID|.
  --
  -- After |WinLeave|.
  -- Non-recursive (event cannot trigger itself).
  -- ---
  -- See also |ExitPre|, |QuitPre|.
  WinClosed = 'WinClosed',

  -- After entering another window.
  -- Not done for the first window, when Vim has just started.
  --
  -- Useful for setting the window height.
  --
  -- If the window is for another buffer, Vim executes
  -- the BufEnter autocommands after the WinEnter autocommands.
  -- ---
  -- **Note**:
  -- For split and tabpage commands the WinEnter event is triggered
  -- after the split or tab command but before the file is loaded.
  WinEnter = 'WinEnter',

  -- Before leaving a window.
  -- If the window to be entered next is for a different buffer,
  -- Vim executes the |BufLeave| autocommands before the WinLeave
  -- autocommands (but not for ":new").
  --
  -- Not used for ":qa" or ":q" when exiting Vim.
  --
  -- Before |WinClosed|.
  WinLeave = 'WinLeave',

  -- When a new window was created.
  -- Not done for the first window, when Vim has just started.
  --
  -- Before |WinEnter|.
  WinNew = 'WinNew',

  -- After any window in the current tab page	scrolled the text
  -- (horizontally or vertically)	or changed width or height.
  -- See |win-scrolled-resized|.
  --
  -- The pattern is matched against the |window-ID| of the first
  -- window that scrolled or resized.
  -- Both <amatch> and <afile> are set to the |window-ID|.
  --
  -- |v:event| is set with information about size and scroll changes.
  -- |WinScrolled-event|
  --
  -- Only starts triggering after startup finished and the first
  -- screen redraw was done.
  -- Does not trigger when defining the first WinScrolled or WinResized
  -- event, but may trigger when adding more.
  -- ---
  -- **Non-recursive**:
  -- The event will not trigger while executing commands for the
  -- WinScrolled event.
  -- However, if the command causes a window to scroll or change size,
  -- then another WinScrolled event will be triggered later.
  WinScrolled = 'WinScrolled',

  -- After a window in the current tab page changed width or height.
  -- See |win-scrolled-resized|.
  --
  -- |v:event| is set with information about size changes.
  -- |WinResized-event|
  --
  -- Same behavior as |WinScrolled| for the pattern, triggering
  -- and recursiveness.
  WinResized = 'WinResized',
}
