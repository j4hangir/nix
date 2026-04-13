return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local on_attach = function(_, bufnr)
      local m = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      -- m (definition) and q (hover) are global in keymaps.lua
      m("n", "gr", vim.lsp.buf.references, "References")
      m("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
      m("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    end

    local servers = {
      lua_ls = {
        cmd_name = "lua-language-server",
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      },
      pyright = { cmd_name = "pyright-langserver" },
      ts_ls = { cmd_name = "typescript-language-server" },
      gopls = { cmd_name = "gopls" },
      rust_analyzer = { cmd_name = "rust-analyzer" },
    }

    for server, cfg in pairs(servers) do
      if vim.fn.executable(cfg.cmd_name) == 1 then
        lspconfig[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = cfg.settings,
        })
      end
    end
  end,
}
