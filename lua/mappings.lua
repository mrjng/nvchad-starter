require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Nvim DAP
local dap = require('dap')
local dapui = require('dapui')

map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = " Debug: Continue" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = " Debug: Step Over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = " Debug: Step Into" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = " Debug: Step Out" })
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debug: reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debug: run last" })

-- ─────────────────────────────────────────────────────────────────────────
-- Function-key friendly steps (optional):
map('n', '<F5>',  dap.continue,        { desc = ' Debug: Continue' })
map('n', '<F10>', dap.step_over,       { desc = ' Debug: Step Over' })
map('n', '<F11>', dap.step_into,       { desc = ' Debug: Step Into' })
map('n', '<F12>', dap.step_out,        { desc = ' Debug: Step Out' })

-- ─────────────────────────────────────────────────────────────────────────
-- Breakpoints
map('n', '<Leader>db',  dap.toggle_breakpoint,  { desc = ' Debug: Toggle Breakpoint' })
map('n', '<Leader>dB',  function() dap.set_breakpoint(vim.fn.input('Condition: ')) end, { desc = ' Debug: Conditional Breakpoint' })
map('n', '<Leader>dC',  dap.clear_breakpoints,  { desc = ' Debug: Clear All Breakpoints' })

-- ─────────────────────────────────────────────────────────────────────────
-- GDB-style frame navigation
map('n', '<Leader>du',  dap.up,    { desc = ' Debug: Frame Up' })   -- like GDB “up”
map('n', '<Leader>dd',  dap.down,  { desc = ' Debug: Frame Down' }) -- like GDB “down”

-- ─────────────────────────────────────────────────────────────────────────
-- Run controls
map('n', '<Leader>dR',  dap.run_to_cursor,  { desc = ' Debug: Run to Cursor' })
map('n', '<Leader>dp',  dap.pause,          { desc = ' Debug: Pause' })

-- ─────────────────────────────────────────────────────────────────────────
-- REPL & UI
map('n', '<Leader>dr',  dap.repl.open,      { desc = ' Debug: Open REPL' })
map('n', '<Leader>di',  dapui.toggle,       { desc = ' Debug: Toggle DAP UI' })
-- map('n', '<Leader>ds',  dapui.scopes,       { desc = ' Debug: Show Scopes' })

-- ─────────────────────────────────────────────────────────────────────────
-- Expression evaluation
-- map({'n','v'}, '<Leader>de', dap.eval,      { desc = ' Debug: Evaluate' })

-- ─────────────────────────────────────────────────────────────────────────
-- Exception breakpoints (e.g. break on all exceptions)
map('n', '<Leader>dE', function() dap.set_exception_breakpoints({'all'}) end, { desc = ' Debug: Exception Breakpoints' })
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

-- Cscope
map("n", "<leader>sd", "Find symbol; :Cs find s <C-R>=expand('<cword>')<CR><CR>", opts) -- Find symbol
map("n", "<leader>gd", "Global definition; :Cs find g <C-R>=expand('<cword>')<CR><CR>", opts) -- Global definition
map("n", "<leader>cd", "Callers of function; :Cs find c <C-R>=expand('<cword>')<CR><CR>", opts) -- Callers of function
map("n", "<leader>td", "Text search; :Cs find t <C-R>=expand('<cword>')<CR><CR>", opts) -- Text search

-- Copy to system clipboard using Leader + y
map("n", "<leader>y", require("osc52").copy_operator, { expr = true, desc = "Copy to OS clipboard" })
map("n", "<leader>yy", "<leader>y_", { remap = true, desc = "Copy line to OS clipboard" })
map("v", "<leader>y", require("osc52").copy_visual, { desc = "Copy selection to OS clipboard" })
