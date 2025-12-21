local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- 1. STANDARD SERVERS
-- These servers just use the default NvChad configuration.
local servers = { "html", "cssls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- 2. KERNEL SPECIFIC SETUP (CLANGD)
-- We set this up separately because we need to inject the specific flags.
lspconfig.clangd.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,

  -- The command that runs the language server
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never", -- Critical for Kernel!
    "--completion-style=detailed",
    "--function-arg-placeholders",
  },

  -- Force clangd to look for the compile_commands.json in the current directory
  root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
}
