vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- make the background transparent
local function make_transparent()
  local groups = {
    "Normal", "NormalNC", "EndOfBuffer",
    "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer",
  }
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = "none" })
  end

  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3b3b3b", bg = "none" })
  vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#3b3b3b", bg = "none" })

end

-- apply now
make_transparent()

-- re-apply after theme loads
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = make_transparent,
})

-- re-apply when NvimTree windows appear
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
  pattern = { "NvimTree", "NvimTree*" },
  callback = make_transparent,
})
