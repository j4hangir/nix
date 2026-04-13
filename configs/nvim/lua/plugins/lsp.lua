return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      float = { border = "rounded", source = true },
    })

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
      pyright = {
        cmd_name = "pyright-langserver",
        on_init = function(client)
          local root = client.config.root_dir
          if not root then return end
          for _, venv in ipairs({ ".venv", "venv", ".env", "env" }) do
            local python = root .. "/" .. venv .. "/bin/python"
            if vim.uv.fs_stat(python) then
              client.config.settings.python.pythonPath = python
              client:notify("workspace/didChangeConfiguration", {
                settings = client.config.settings,
              })
              return
            end
          end
        end,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      },
      ts_ls = { cmd_name = "typescript-language-server" },
      gopls = { cmd_name = "gopls" },
      rust_analyzer = { cmd_name = "rust-analyzer" },
    }

    for name, cfg in pairs(servers) do
      if vim.fn.executable(cfg.cmd_name) == 1 then
        vim.lsp.config(name, {
          on_attach = on_attach,
          on_init = cfg.on_init,
          capabilities = capabilities,
          settings = cfg.settings,
        })
        vim.lsp.enable(name)
      end
    end
  end,
}
