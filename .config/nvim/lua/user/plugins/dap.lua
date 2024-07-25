local fn = vim.fn

return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    config = function(_, handlers)
      local dap = require 'dap'
      local dapui = require 'dapui'
      local mason = require 'mason-nvim-dap'

      fn.sign_define('DapBreakpoint', { text = '' })
      fn.sign_define('DapBreakpointCondition', { text = '' })
      fn.sign_define('DapLogPoint', { text = '' })
      fn.sign_define('DapStopped', { text = '' })
      fn.sign_define('DapBreakpointRejected', { text = '' })

      dapui.setup {}

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.print(handlers)
      mason.setup {
        automatic_installation = false,
        ensure_installed = vim.tbl_keys(handlers),
        handlers = not vim.tbl_isempty(handlers) and handlers or nil,
      }
    end,
    keys = {
      {
        "<leader>dbc",
        '<cmd>lua require("dap").set_breakpoint(vim.ui.input("Breakpoint condition: "))<cr>',
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dbl",
        '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.ui.input("Log point message: "))<cr>',
        desc = "Logpoint",
      },
      { "<leader>dbr", '<cmd>lua require("dap.breakpoints").clear()<cr>', desc = "Remove All Breakpoints" },
      { "<leader>dbs", "<cmd>Telescope dap list_breakpoints<cr>", desc = "Show All Breakpoints" },
      { "<leader>dbt", '<cmd>lua require("dap").toggle_breakpoint()<cr>', desc = "Toggle Breakpoint" },
      { "<leader>dc", function()
        vim.system({ 'open', '-a', '"Google Chrome"', '--args', '--remote-debugging-port=9222', '--user-data-dir=/tmp/remote-debug-profile'})
        return '<cmd>lua require("dap").continue()<cr>'
      end, expr = true, desc = "Continue" },
      {
        "<leader>dw",
        '<cmd>lua require("dap.ui.widgets").hover(nil, { border = "none" })<cr>',
        desc = "Evaluate Expression",
        mode = { "n", "v" },
      },
      { "<leader>dp", '<cmd>lua require("dap").pause()<cr>', desc = "Pause" },
      { "<leader>dr", "<cmd>Telescope dap configurations<cr>", desc = "Run" },
      { "<leader>dsb", '<cmd>lua require("dap").step_back()<cr>', desc = "Step Back" },
      { "<leader>dsc", '<cmd>lua require("dap").run_to_cursor()<cr>', desc = "Run to Cursor" },
      { "<leader>dsi", '<cmd>lua require("dap").step_into()<cr>', desc = "step Into" },
      { "<leader>dso", '<cmd>lua require("dap").step_over()<cr>', desc = "Step Over" },
      { "<leader>dsx", '<cmd>lua require("dap").step_out()<cr>', desc = "Step Out" },
      { "<leader>dx", '<cmd>lua require("dap").terminate()<cr>', desc = "Terminate" },
    },
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'nvim-neotest/nvim-nio',
    },
  },
}
