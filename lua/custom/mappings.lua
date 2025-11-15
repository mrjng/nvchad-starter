local M = {}

M.normal_mode = {
  ["<leader>cr"] = { ":cs find c <C-R>=expand('<cword>')<CR><CR>", "Cscope: Find references" },
  ["<leader>cs"] = { ":cs find s <C-R>=expand('<cword>')<CR><CR>", "Cscope: Find symbol" },
  ["<leader>cd"] = { ":cs find d <C-R>=expand('<cword>')<CR><CR>", "Cscope: Go to definition" },
  ["<leader>ce"] = { ":cs find e <C-R>=expand('<cword>')<CR><CR>", "Cscope: Find assignments" },
  ["<leader>ct"] = { ":cs find t <C-R>=expand('<cword>')<CR><CR>", "Cscope: Find called funcs" },
}

return M
