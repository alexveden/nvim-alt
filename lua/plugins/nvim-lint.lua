return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("lint").linters_by_ft = {
            python = { "flake8" },
            htmldjango = { "djlint" },
        }

        -- Set up autocmd to lint on save
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })
    end,
}
