return {
	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
            {
                "williamboman/mason-lspconfig.nvim",
                dependencies = {
                    { "williamboman/mason.nvim", config = true }
                }
            },

			{ "j-hui/fidget.nvim", opts = {} },

			"folke/neodev.nvim",
		},
        config = function()
            -- Switch for controlling autoformatting
            local autoformat = true
            vim.api.nvim_create_user_command("ToggleAutoformat", function()
                autoformat = not autoformat
                print("Autoformatting is now " .. (autoformat and "on" or "off"))
            end, {})

            -- augroups for autoformatting
            local _augroups = {}
            local get_augroup = function(client)
                if not _augroups[client.id] then
                    local group_name = "sertus-lsp-format-" .. client.name
                    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
                    _augroups[client.id] = id
                end

                return _augroups[client.id]
            end

            -- Whenever an LSP attaches to a buffer, this function will be called
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("sertus-lsp-attach-format", { clear = true }),
                callback = function(args)
                    local client_id = args.data.client_id
                    local client = vim.lsp.get_client_by_id(client_id)
                    local bufnr = args.buf

                    if not client.server_capabilities.documentFormattingProvider then
                        return
                    end

                    if client.name == "tsserver" then -- TsServer runs poorly
                        return
                    end

                    -- Create an autocmd that will run *before* we save the buffer
                    --  Run the formatting command for the LSP that has just attached.
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = get_augroup(client),
                        buffer = bufnr,
                        callback = function()
                            if not autoformat then
                                return
                            end

                            vim.lsp.buf.format {
                                async = false,
                                filter = function(c)
                                    return c.client_id == client_id
                                end
                            }
                        end
                    })
                end
            })
        end
	},

	-- Auto Completion
	{
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippet engine
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",

            -- LSP Completion
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",

            -- Adds snippets
            "rafamadriz/friendly-snippets",
        }
	}
}
