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
