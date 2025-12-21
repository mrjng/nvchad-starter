require "nvchad.autocmds"

-- cscope
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.filereadable("cscope.out") == 1 then
      vim.cmd("silent! cs add cscope.out")
    end
  end,
})

local autocmd = vim.api.nvim_create_autocmd

-- Auto-trim trailing whitespace on save
autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    pcall(function() vim.cmd [[%s/\s\+$//e]] end)
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Linux Kernel Code Formatting
autocmd("FileType", {
  pattern = { "c", "cpp", "h", "make" },
  callback = function()
    -- CORRECT WAY: Look for "Kbuild" or "Kconfig" files in the current folder or parents
    local get_root = vim.fs.find({ "Kbuild", "Kconfig" }, {
      upward = true,
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    })

    -- If we found a kernel build file, apply strict kernel rules
    if #get_root > 0 then
      vim.opt_local.tabstop = 8
      vim.opt_local.shiftwidth = 8
      vim.opt_local.softtabstop = 8
      vim.opt_local.expandtab = false -- REAL TABS (Crucial!)
      vim.opt_local.cindent = true
      vim.opt_local.textwidth = 80
      vim.opt_local.colorcolumn = "81"
    else
      -- Standard formatting for your other projects
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
    end
  end,
})
