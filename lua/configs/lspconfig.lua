-- lua/configs/lspconfig.lua

-- 1. DEFINE CAPABILITIES (Crucial for Autocomplete)
-- We cannot use 'nvlsp.capabilities' because it relies on the deprecated code.
-- We recreate it here to ensure nvim-cmp (autocomplete) works.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Add nvim-cmp capabilities if present
local status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- 2. DEFINE ON_ATTACH (Keymappings)
-- This runs when the server starts. We define standard mappings here.
local on_attach = function(client, bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr, silent = true }

  -- Standard LSP Keys (Go to Definition, Hover, etc.)
  map("n", "gD", vim.lsp.buf.declaration, opts)
  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("n", "<leader>ra", vim.lsp.buf.rename, opts)
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  map("n", "<leader>fm", function() vim.lsp.buf.format { async = true } end, opts)
end

-- 3. SETUP CLANGD (Linux Kernel) - NATIVE v0.11 WAY
-- instead of lspconfig.clangd.setup, we assign to vim.lsp.config
vim.lsp.config["clangd"] = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never", -- Critical for Kernel
    "--completion-style=detailed",
    "--function-arg-placeholders",
  },
  -- 'root_markers' is the new v0.11 way to find the project root
  root_markers = { "compile_commands.json", ".git", "Kbuild" },
  capabilities = capabilities,
  on_attach = on_attach,
}

-- 4. SETUP HTML/CSS (Standard Servers)
local servers = { "html", "cssls" }

for _, server in ipairs(servers) do
  vim.lsp.config[server] = {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

-- 5. ENABLE SERVERS
-- This is the final step required in NeoVim v0.11
vim.lsp.enable("clangd")
for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
