require "nvchad.autocmds"

-- cscope
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.filereadable("cscope.out") == 1 then
      vim.cmd("silent! cs add cscope.out")
    end
  end,
})
