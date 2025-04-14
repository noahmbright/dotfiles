return {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },

    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dap.adapters.lldb = {
            type = 'executable',
            command = '/opt/homebrew/opt/llvm/bin/lldb-dap', -- adjust as needed, must be absolute path
            name = 'lldb'
        }

        dap.configurations.c = {
            {
                name = 'Launch',
                type = 'lldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                args = function()
                    return vim.fn.input('Command line args: ')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,

                -- 💀
                -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
                --
                --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
                --
                -- Otherwise you might get the following error:
                --
                --    Error on launch: Failed to attach to the target process
                --
                -- But you should be aware of the implications:
                -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
                -- runInTerminal = false,
            },
        }

        dap.configurations.cpp = dap.configurations.c

        --nvim dap
        vim.keymap.set('n', '<leader>b', ":lua require('dap').toggle_breakpoint()<CR>", { silent = true })
        vim.keymap.set('n', '<leader>B', ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition '))<CR>",
            { silent = true })
        vim.keymap.set('n', '<F1>', ":lua require('dap').continue()<CR>", { silent = true })
        vim.keymap.set('n', '<F2>', ":lua require('dap').step_into()<CR>", { silent = true })
        vim.keymap.set('n', '<F3>', ":lua require('dap').step_over()<CR>", { silent = true })
        vim.keymap.set('n', '<F4>', ":lua require('dap').step_out()<CR>", { silent = true })
        vim.keymap.set('n', '<F5>', ":lua require('dap').repl.open()<CR>", { silent = true })

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
}
