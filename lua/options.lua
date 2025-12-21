require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!

-- Sync clipboard between OS and Neovim
-- "unnamedplus" allows the + register (system clipboard) to be used by default
-- o.clipboard = "unnamedplus"

-- (Optional) If you want to enable mouse support to copy text on select
o.mouse = "a"

