local cmp = require("cmp")
cmp.setup(
    {
        experimental = {
            ghost_text = true
        },
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end
        },
        window = {},
        mapping = cmp.mapping.preset.insert(
            {
                ["<C-j>"] = cmp.mapping.scroll_docs(-4),
                ["<C-k>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<Tab>"] = cmp.mapping(
                    function(fallback)
                        local col = vim.fn.col(".") - 1

                        if cmp.visible() then
                            cmp.select_next_item(select_opts)
                        elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                            fallback()
                        else
                            cmp.complete()
                        end
                    end,
                    { "i", "s" }
                )
            }
        ),
        sources = cmp.config.sources(
            {
                { name = "nvim_lsp" },
                { name = "vsnip" }
            },
            {
                { name = "buffer" }
            }
        )
    }
)

-- Set configuration for specific filetype.
cmp.setup.filetype(
    "gitcommit",
    {
        sources = cmp.config.sources(
            {
                { name = "cmp_git" } -- You can specify the `cmp_git` source if you were installed it.
            },
            {
                { name = "buffer" }
            }
        )
    }
)

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
    { "/", "?" },
    {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" }
        }
    }
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
    ":",
    {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
            {
                { name = "path" }
            },
            {
                { name = "cmdline" }
            }
        )
    }
)

-- lsp-format
require("lsp-format").setup {}
local on_attach = function(client)
    require("lsp-format").on_attach(client)
end

local caps = vim.tbl_extend(
    'keep',
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
);

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require('lspconfig')["nil_ls"].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ['nil'] = {
            testSetting = 42,
            formatting = {
                command = { "alejandra" },
            },
        },
    },
}
require("lspconfig")["rust_analyzer"].setup {
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig")["zk"].setup {
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig")["lua_ls"].setup {
    on_attach = on_attach,
    capabilities = capabilities
}
