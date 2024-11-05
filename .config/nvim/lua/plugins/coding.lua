--- @type LazySpec[]
return {
  "zbirenbaum/copilot-cmp",
  opts = function(_, opts)
    LazyVim.on_load("cmp", function()
      local cmp = require("cmp")
      cmp.event:on("menu_opened", function()
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = false
      end)
    end)
    return opts
  end,
}
