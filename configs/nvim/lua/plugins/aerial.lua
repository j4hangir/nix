local kind_map = {
  [1]  = { icon = "▫ ", hl = "Function"  },   -- File
  [2]  = { icon = "◆ ", hl = "Keyword"   },   -- Module
  [3]  = { icon = "◆ ", hl = "Keyword"   },   -- Namespace
  [4]  = { icon = "◆ ", hl = "Keyword"   },   -- Package
  [5]  = { icon = "◇ ", hl = "Type"      },   -- Class
  [6]  = { icon = "ƒ ", hl = "Function"  },   -- Method
  [7]  = { icon = "· ", hl = "Identifier"},   -- Property
  [8]  = { icon = "· ", hl = "Identifier"},   -- Field
  [9]  = { icon = "● ", hl = "Function"  },   -- Constructor
  [10] = { icon = "∷ ", hl = "Type"      },   -- Enum
  [11] = { icon = "◈ ", hl = "Type"      },   -- Interface
  [12] = { icon = "ƒ ", hl = "Function"  },   -- Function
  [13] = { icon = "α ", hl = "Constant"  },   -- Variable
  [14] = { icon = "π ", hl = "Constant"  },   -- Constant
  [15] = { icon = "\" ", hl = "String"   },   -- String
  [16] = { icon = "# ", hl = "Number"    },   -- Number
  [17] = { icon = "◎ ", hl = "Boolean"   },   -- Boolean
  [18] = { icon = "[] ", hl = "Type"     },   -- Array
  [19] = { icon = "{} ", hl = "Type"     },   -- Object
  [20] = { icon = "κ ", hl = "Keyword"   },   -- Key
  [21] = { icon = "∅ ", hl = "Constant"  },   -- Null
  [22] = { icon = "∷ ", hl = "Type"      },   -- EnumMember
  [23] = { icon = "◇ ", hl = "Type"      },   -- Struct
  [24] = { icon = "⚡", hl = "Operator"  },   -- Event
  [25] = { icon = "± ", hl = "Operator"  },   -- Operator
  [26] = { icon = "τ ", hl = "Type"      },   -- TypeParameter
}

local function file_structure()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")
  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  local bufnr = vim.api.nvim_get_current_buf()

  vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(err, result)
    if err or not result or #result == 0 then
      vim.notify("No symbols", vim.log.levels.WARN)
      return
    end

    local items = {}

    local function flatten(symbols, depth)
      for _, s in ipairs(symbols) do
        local info = kind_map[s.kind] or { icon = "? ", hl = "Normal" }
        table.insert(items, {
          name = s.name,
          icon = info.icon,
          hl = info.hl,
          depth = depth,
          lnum = (s.selectionRange or s.range).start.line + 1,
          col = (s.selectionRange or s.range).start.character,
        })
        if s.children then
          flatten(s.children, depth + 1)
        end
      end
    end
    flatten(result, 0)

    local displayer = entry_display.create({
      separator = "",
      items = {
        { width = 40 },
        { remaining = true },
      },
    })

    vim.schedule(function()
      pickers.new({}, {
        prompt_title = vim.fn.expand("%:t"),
        finder = finders.new_table({
          results = items,
          entry_maker = function(item)
            local indent = string.rep("  ", item.depth)
            return {
              value = item,
              ordinal = item.name,
              lnum = item.lnum,
              col = item.col,
              display = function(entry)
                return displayer({
                  { indent .. entry.value.icon .. entry.value.name, entry.value.hl },
                })
              end,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        previewer = false,
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col })
          end)
          return true
        end,
      }):find()
    end)
  end)
end

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "p", file_structure, desc = "File structure" },
  },
}
