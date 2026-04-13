return {
  "marko-cerovac/material.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.material_style = "darker"
    require("material").setup({
      contrast = {
        sidebars = true,
        floating_windows = true,
        cursor_line = true,
      },
      plugins = {
        "flash",
        "gitsigns",
        "nvim-cmp",
        "telescope",
        "which-key",
      },
      custom_colors = function(colors)
        colors.editor.bg = "#121212"
        colors.editor.bg_alt = "#0a0a0a"
        colors.backgrounds.sidebars = "#0e0e0e"
        colors.backgrounds.floating_windows = "#161616"
        colors.backgrounds.cursor_line = "#131126"
      end,
    })
    vim.cmd.colorscheme("material")

    local hl = vim.api.nvim_set_hl

    -----------------------------------------------------------
    -- Editor chrome (PyCharm "Material Darker Leet 2" .icls)
    -----------------------------------------------------------
    hl(0, "CursorLine", { bg = "#131126" })
    hl(0, "Visual", { bg = "#0a7f7b", fg = "#fffbf7" })
    hl(0, "Cursor", { fg = "#000000", bg = "#ffcc00" })

    -- Gutter
    hl(0, "SignColumn", { bg = "#050b09" })
    hl(0, "FoldColumn", { bg = "#050b09" })
    hl(0, "LineNr", { fg = "#34967a", bg = "#050b09" })
    hl(0, "CursorLineNr", { fg = "#616161", bg = "#050b09" })

    -- Matched braces
    hl(0, "MatchParen", { bg = "#3f3f3f", underline = true, sp = "#b39613" })

    -- Search
    hl(0, "Search", { bg = "#464646" })
    hl(0, "IncSearch", { fg = "#212c32", bg = "#f8e71c" })
    hl(0, "CurSearch", { fg = "#212c32", bg = "#f8e71c" })

    -- Diagnostics
    hl(0, "DiagnosticError", { fg = "#ff5370" })
    hl(0, "DiagnosticWarn", { fg = "#ffcb6b" })
    hl(0, "DiagnosticInfo", { fg = "#c3e88d" })
    hl(0, "DiagnosticHint", { fg = "#89ddff" })
    hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#ff5370" })
    hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#ffcb6b" })
    hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#c3e88d" })

    -- Diff
    hl(0, "DiffAdd", { bg = "#45582b" })
    hl(0, "DiffChange", { bg = "#927243" })
    hl(0, "DiffDelete", { bg = "#b63b50" })
    hl(0, "DiffText", { bg = "#43698d" })

    -- Popups & floats
    hl(0, "NormalFloat", { bg = "#161616" })
    hl(0, "FloatBorder", { fg = "#424242", bg = "#161616" })
    hl(0, "Pmenu", { bg = "#000000" })
    hl(0, "PmenuSel", { bg = "#0a7f7b" })

    -- Inline hints & links
    hl(0, "LspInlayHint", { fg = "#b0bec5", bg = "#1a1a1a" })
    hl(0, "Underlined", { fg = "#ff9800", underline = true })

    -----------------------------------------------------------
    -- Default syntax (all languages)
    -----------------------------------------------------------
    hl(0, "Comment", { fg = "#77aa27", italic = true })
    hl(0, "@comment", { fg = "#77aa27", italic = true })

    hl(0, "Keyword", { fg = "#c792ea", italic = true })
    hl(0, "@keyword", { fg = "#c792ea", italic = true })
    hl(0, "@keyword.conditional", { fg = "#c792ea", italic = true })
    hl(0, "@keyword.repeat", { fg = "#c792ea", italic = true })
    hl(0, "@keyword.return", { fg = "#c792ea", italic = true })
    hl(0, "@keyword.exception", { fg = "#c792ea", italic = true })
    hl(0, "@keyword.import", { fg = "#c792ea", italic = true })
    hl(0, "@keyword.operator", { fg = "#c792ea", italic = true })
    hl(0, "@keyword.function", { fg = "#c792ea", italic = true })

    hl(0, "@function", { fg = "#3bff22" })
    hl(0, "@function.method", { fg = "#3bff22" })
    hl(0, "@function.call", { fg = "#ffec82" })
    hl(0, "@function.method.call", { fg = "#ffec82" })

    hl(0, "@variable.parameter", { fg = "#f78c6c" })
    hl(0, "@attribute", { fg = "#82aaff" })

    -----------------------------------------------------------
    -- Python
    -----------------------------------------------------------
    hl(0, "@keyword.python", { fg = "#47c8c7", italic = true })
    hl(0, "@keyword.conditional.python", { fg = "#47c8c7", italic = true })
    hl(0, "@keyword.repeat.python", { fg = "#47c8c7", italic = true })
    hl(0, "@keyword.return.python", { fg = "#47c8c7", italic = true })
    hl(0, "@keyword.exception.python", { fg = "#47c8c7", italic = true })
    hl(0, "@keyword.import.python", { fg = "#47c8c7", italic = true })
    hl(0, "@keyword.operator.python", { fg = "#47c8c7", italic = true })
    hl(0, "@keyword.function.python", { fg = "#47c8c7", italic = true })
    hl(0, "@keyword.coroutine.python", { fg = "#47c8c7", italic = true })
    hl(0, "@keyword.type.python", { fg = "#47c8c7", italic = true })

    hl(0, "@function.python", { fg = "#f894bc" })
    hl(0, "@function.method.python", { fg = "#f894bc" })
    hl(0, "@function.call.python", { fg = "#82aaff" })
    hl(0, "@function.method.call.python", { fg = "#82aaff" })
    hl(0, "@function.builtin.python", { fg = "#d08989" })
    hl(0, "@constructor.python", { fg = "#4aedc8", italic = true })

    hl(0, "@variable.builtin.python", { fg = "#e5c5af", italic = true })
    hl(0, "@variable.parameter.python", { fg = "#aed4f7" })

    hl(0, "@number.python", { fg = "#b98ef7" })
    hl(0, "@number.float.python", { fg = "#b98ef7" })

    hl(0, "@comment.python", { fg = "#159223", italic = true })
    hl(0, "@string.documentation.python", { fg = "#8b8598", italic = true })

    hl(0, "@attribute.python", { fg = "#94adef" })
    hl(0, "@attribute.builtin.python", { fg = "#94adef" })

    hl(0, "@constant.builtin.python", { fg = "#82aaff" })
    hl(0, "@boolean.python", { fg = "#82aaff" })

    hl(0, "@keyword_argument.python", { fg = "#c8afe5" })

    -----------------------------------------------------------
    -- JavaScript / TypeScript
    -----------------------------------------------------------
    hl(0, "@variable.builtin.javascript", { fg = "#ff4965" })
    hl(0, "@variable.builtin.typescript", { fg = "#ff4965" })
    hl(0, "@variable.builtin.tsx", { fg = "#ff4965" })
    hl(0, "@type.parameter.typescript", { fg = "#ffcb6b" })
    hl(0, "@type.parameter.tsx", { fg = "#ffcb6b" })
    hl(0, "@attribute.typescript", { fg = "#82aaff" })
    hl(0, "@attribute.javascript", { fg = "#82aaff" })

    -----------------------------------------------------------
    -- Go
    -----------------------------------------------------------
    hl(0, "@function.builtin.go", { fg = "#82aaff" })
    hl(0, "@type.go", { fg = "#c3e88d" })

    -----------------------------------------------------------
    -- CSS / SCSS
    -----------------------------------------------------------
    hl(0, "@property.css", { fg = "#80cbc4" })
    hl(0, "@property.scss", { fg = "#80cbc4" })
    hl(0, "@tag.css", { fg = "#eeffff" })
    hl(0, "@tag.attribute.css", { fg = "#ffcb6b", bold = true })

    -----------------------------------------------------------
    -- HTML / XML
    -----------------------------------------------------------
    hl(0, "@tag.html", { fg = "#f07178" })
    hl(0, "@tag.xml", { fg = "#f07178" })
    hl(0, "@tag.attribute.html", { fg = "#ffcb6b", bold = true })
    hl(0, "@tag.attribute.xml", { fg = "#ffcb6b", bold = true })
    hl(0, "@tag.delimiter.html", { fg = "#89ddff" })
    hl(0, "@tag.delimiter.xml", { fg = "#89ddff" })

    -----------------------------------------------------------
    -- YAML
    -----------------------------------------------------------
    hl(0, "@property.yaml", { fg = "#f07178" })
    hl(0, "@string.yaml", { fg = "#89ddff" })

    -----------------------------------------------------------
    -- JSON
    -----------------------------------------------------------
    hl(0, "@boolean.json", { fg = "#c792ea", bold = true })
    hl(0, "@number.json", { fg = "#f78c6c" })
    hl(0, "@property.json", { fg = "#c792ea", bold = true })

    -----------------------------------------------------------
    -- Markdown
    -----------------------------------------------------------
    hl(0, "@markup.heading", { fg = "#c3e88d", underline = true })
    hl(0, "@markup.heading.1", { fg = "#c3e88d", underline = true, bold = true })
    hl(0, "@markup.heading.2", { fg = "#c3e88d", underline = true, bold = true })
    hl(0, "@markup.heading.3", { fg = "#c3e88d", underline = true })
    hl(0, "@markup.heading.4", { fg = "#c3e88d", underline = true })
    hl(0, "@markup.strong", { fg = "#f07178", bold = true })
    hl(0, "@markup.italic", { fg = "#f07178", italic = true })
    hl(0, "@markup.raw", { fg = "#c792ea" })
    hl(0, "@markup.raw.block", { fg = "#c792ea" })
    hl(0, "@markup.link.label", { fg = "#f07178", underline = true })
    hl(0, "@markup.link.url", { fg = "#f78c6c" })
    hl(0, "@markup.list", { fg = "#ff5370", bold = true })
    hl(0, "@markup.quote", { fg = "#82aaff", bold = true })

    -----------------------------------------------------------
    -- Bash
    -----------------------------------------------------------
    hl(0, "@function.call.bash", { fg = "#82aaff", italic = true })
  end,
}
