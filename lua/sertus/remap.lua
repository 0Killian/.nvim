-- Telescope
vim.keymap.set('n', "<leader>fr", require("telescope.builtin").oldfiles, { desc = "[fr] Find recently opened files" })
vim.keymap.set('n', "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set('n', "<leader>bff", function()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
		winblend = 10,
		previewer = false
	})
end, { desc = "[bff] Fuzzily search in the current buffer" })

vim.keymap.set('n', "<leader>sf", require("telescope.builtin").find_files, { desc = "[sf] Search files" })
vim.keymap.set('n', "<leader>sg", require("telescope.builtin").git_files, { desc = "[sg] Search git files" })
vim.keymap.set('n', "<leader>gw", require("telescope.builtin").grep_string, { desc = "[gw] Grep by word" })
vim.keymap.set('n', "<leader>gs", require("telescope.builtin").live_grep, { desc = "[gs] Grep by string" })

-- Displace lines
-- From ThePrimeagen's dotfile
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Open NERDTree
vim.keymap.set("n", "<leader>fv", ":NERDTree<CR>", { desc = "[fv] Open file tree" })

-- Debugger
vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "[F5] Debugger: Start/Continue" })
vim.keymap.set("n", "<F1>", require("dap").step_into, { desc = "[F1] Debugger: Step into" })
vim.keymap.set("n", "<F2>", require("dap").step_over, { desc = "[F2] Debugger: Step over" })
vim.keymap.set("n", "<F3>", require("dap").step_out, { desc = "[F3] Debugger: Step out" })
vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint, { desc = "[b] Debugger: Toggle breakpoint" })
vim.keymap.set("n", "<leader>B", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint Condition"))
end, { desc = "[B] Debugger: Set breakpoint" })
vim.keymap.set("n", "<F7>", require("dapui").toggle, { desc = "[F7] Debugger: Toggle UI" })
