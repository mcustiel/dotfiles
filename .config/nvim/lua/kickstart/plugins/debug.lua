-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',

  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mxsdev/nvim-dap-vscode-js',

    {
      'microsoft/vscode-js-debug',

      config = function() end,

      build =
      'rm -rf out && npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out && git checkout -- package*.json',
    },
  },

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {
        -- function(config)
        -- all sources with no handler get passed here

        -- Keep original functionality
        --   require('mason-nvim-dap').default_setup(config)
        -- end,
      },

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
        -- 'js-debug-adapter',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = '[DEBUG] Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = '[DEBUG] Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = '[DEBUG] Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = '[DEBUG] Step Out' })
    vim.keymap.set('n', '<F4>', dap.close, { desc = '[DEBUG] Stop' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = '[DEBUG] Toggle breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    -- require('dap-go').setup()

    -- dap.configurations.go = {
    --   {
    --     type = 'go',
    --     name = 'Debug',
    --     request = 'launch',
    --     program = '${file}',
    --   }
    -- }
    --
    require('dap-vscode-js').setup({
      -- node_path = 'node', -- Path of node executable. Defaults to $NODE_PATH, and then 'node'
      debugger_path = os.getenv('MC_JS_DEBUG') or vim.fn.stdpath('data') .. '/lazy/vscode-js-debug', -- Path to vscode-js-debug installation.
      -- debugger_cmd = { 'js-debug-adapter' },                             -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
      adapters = { 'pwa-node', 'pwa-chrome', 'node-terminal' },                                      -- which adapters to register in nvim-dap

      -- log_file_path = '(stdpath cache)/dap_vscode_js.log' -- Path for file logging
      -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
      -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    })

    -- dap.configurations.go = {
    --   {
    --     type = "go",
    --     name = "Debug",
    --     request = "launch",
    --     program = "${file}",
    --   }
    -- }

    for _, language in ipairs({ "typescript", "javascript" }) do
      dap.configurations[language] = {
        {
          name = 'Launch file',
          type = 'pwa-node',
          request = 'launch',
          program = '${file}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          preLaunchTask = 'tsc',
        },
        {
          name = 'Attach to node process',
          type = 'pwa-node',
          request = 'attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          rootPath = '${workspaceFolder}',
        },
        {
          name = 'Debug Jest Tests',
          type = 'pwa-node',
          request = 'launch',
          runtimeExecutable = 'node',
          runtimeArgs = {
            './node_modules/jest/bin/jest.js',
            '--runInBand',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
        {
          name = 'TS Node Launch',
          type = 'pwa-node',
          request = 'launch',
          sourceMaps = true,
          cwd = '${workspaceFolder}',
          runtimeExecutable = 'node',
          runtimeArgs = { '--nolazy', '-r', 'ts-node/register' },

          args = { '--inspect', '${file}' },

          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
      }
    end
  end,
}
