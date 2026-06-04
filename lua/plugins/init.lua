return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- load YOUR custom config file we just wrote
      require "configs.lspconfig"
    end,
  },

  -- Rust development
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",
    config = function ()
      local codelldb_pkg = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
      local extension_path = codelldb_pkg .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path.. "lldb/lib/liblldb.dylib"
      local cfg = require('rustaceanvim.config')

      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        tools = {
          enable_nextest = false,
        },
      }
    end
  },

  -- DAP, Debugger Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      local codelldb_pkg = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
      local extension_path = codelldb_pkg .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path.. "lldb/lib/liblldb.dylib"
      -- Define lldb adapter directly without relying on lazy-loaded rustaceanvim
      dap.adapters.lldb = {
        type = "server",
        port = "${port}",
        host = "127.0.0.1",
        executable = {
          command = codelldb_path,
          args = { "--liblldb", liblldb_path, "--port", "${port}" },
        },
      }

      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '🟡', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶️', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' })

      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#ff0000', bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379', bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2d4a3e' })
      -- vscode launch.json is loaded on-demand automatically by nvim-dap.
      -- Map type "lldb" configurations to C, C++, and Rust files.
      require('dap.ext.vscode').type_to_filetypes = {
        lldb = { "rust", "c", "cpp" }
      }
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end
      local gdb_command = "gdb"
      if vim.fn.executable("riscv64-elf-gdb") == 1 then
        gdb_command = "riscv64-elf-gdb"
      elseif vim.fn.executable("riscv64-unknown-elf-gdb") == 1 then
        gdb_command = "riscv64-unknown-elf-gdb"
      elseif vim.fn.executable("gdb-multiarch") == 1 then
        gdb_command = "gdb-multiarch"
      end

      local port = "25000"
      local uid_handle = io.popen("id -u")
      if uid_handle then
        local uid = tonumber(uid_handle:read("*a"))
        uid_handle:close()
        if uid then
          port = tostring(uid % 5000 + 25000)
        end
      end

      dap.adapters.gdb = {
        type = "executable",
        command = gdb_command,
        args = { "-i", "dap", "-nx" },
      }
      dap.configurations.c = {
        {
          name = "Attach to QEMU (xv6)",
          type = "gdb",
          request = "attach",
          target = "localhost:" .. port,
          program = function()
            return vim.fn.getcwd() .. "/kernel/kernel"
          end,
          cwd = "${workspaceFolder}",
        },
        {
          name = "Launch Local Executable",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = true,
        }
      }
    end
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      require("dapui").setup()
    end,
  },

  -- Rust Formatting
  {
    'rust-lang/rust.vim',
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },

  -- Crates automatic version completion
  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true
          },
        },
      }
      require('cmp').setup.buffer({
        sources = { { name = "crates" }}
      })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "rust", "c", "cpp"
      },
    },
  },

  -- Add this block to enable cscope/ctags commands
  {
    "dhananjaylatkar/cscope_maps.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },  -- optional, for a Telescope picker
    cmd = { "Cscope", "Cs", },                             -- load only when you invoke these
    opts = {},                                            -- defaults are fine
    config = function(_, opts)
      require("cscope_maps").setup(opts)
    end,
  },
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup {
        max_length = 0,           -- Unlimited length
        silent = true,            -- Disable message on copy
        trim = false,             -- Do not trim newlines
      }

      -- Automatically copy to system clipboard on yank
      local function copy()
        if vim.v.event.operator == "y" and vim.v.event.regname == "" then
          require("osc52").copy_register("")
        end
      end

      vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
        virt_text_pos = "eol",
      },
      current_line_blame_formatter = "                    <author>, <author_time:%R> · <summary>",
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
        width = 80,
        height = 25,
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#7aa2f7", italic = true })
    end,
  },
}
