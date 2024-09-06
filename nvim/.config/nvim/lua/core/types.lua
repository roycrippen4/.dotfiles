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
