-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "tokyodark",
  transparency = true,

  -- Override highlights here
  hl_override = {
    -- Change "CursorLine" to a darker/clearer background color
    CursorLine = { bg = "#2c323c" },

    -- Optional: If Visual selection is also hard to see, fix it here
    Visual = { bg = "#3a404a" },

    -- Make the comment italic
    Comment = { italic = true , fg = "#8b9bb4"},
	  ["@comment"] = { italic = true, fg = "#8b9bb4"},
  },
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

return M
