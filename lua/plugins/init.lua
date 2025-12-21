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
      -- First, load the default NvChad internal config
      require "nvchad.configs.lspconfig"

      -- Then, load YOUR custom config file we just wrote
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
      local codelldb_pkg = vim.fn.expand("$MASON/packages/codelldb")
      local extension_path = codelldb_pkg .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path.. "lldb/lib/liblldb.dylib"
      local cfg = require('rustaceanvim.config')

      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end
  },

  -- DAP, Debugger Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
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
  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
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
      current_line_blame = true, -- Set this to true
      current_line_blame_opts = {
        delay = 500, -- Delay in ms before blame appears (like VSCode)
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      },
    },
    require("gitsigns").setup {
      -- ... other settings ...
      preview_config = {
        -- Default options for the floating window
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
        width = 80, -- <--- LIMIT WIDTH HERE
        height = 25,
      },
    }
  },
}
