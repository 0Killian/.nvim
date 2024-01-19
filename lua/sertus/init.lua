require('sertus.set')
require('sertus.lazy')
require('sertus.colorscheme')
require('sertus.remap')

--- LSP Config
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[rn] LSP: Rename");
    nmap("<leader>ca", vim.lsp.buf.code_action, "[ca] LSP: Code action");

    nmap("gd", require("telescope.builtin").lsp_definitions, "[gd] LSP: Goto definition");
    nmap("gr", require("telescope.builtin").lsp_references, "[gr] LSP: Goto references");
    nmap("gi", require("telescope.builtin").lsp_implementations, "[gr] LSP: Goto implementations");
    
    nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "[D] LSP: Type definition");
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D] LSP: Document symbols");
    nmap("<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "[D] LSP: Workspace symbols");

    nmap('K', vim.lsp.buf.hover, "[K] LSP: Hover documenation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "[<C-k>] LSP: Signature documentation")
end

-- Document existing key chains
require("which-key").register {
    ["<leader>c"] = { name = "Code", _ = "which_key_ignore" },
    ["<leader>d"] = { name = "Document", _ = "which_key_ignore" },
    ["<leader>g"] = { name = "Git/Goto", _ = "which_key_ignore" },
    ["<leader>h"] = { name = "Git Hunk", _ = "which_key_ignore" },
    ["<leader>r"] = { name = "Rename", _ = "which_key_ignore" },
    ["<leader>s"] = { name = "Search", _ = "which_key_ignore" },
    ["<leader>t"] = { name = "Toggle", _ = "which_key_ignore" },
    ["<leader>w"] = { name = "Workspace", _ = "which_key_ignore" },
}

require("which-key").register({
    ["<leader>"] = { name = "VISUAL <leader>"},
    ["<leader>h"] = { name = "Git Hunk"},
}, { mode = 'v' })

-- This order needs to be respected
require("mason").setup()
require("mason-lspconfig").setup()

local servers = {
    clangd = {},
    rust_analyzer = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        }
    }
}

require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes
        }
    end
}

--- Configure nvim-cmp
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s", }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s", }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
    }
}
