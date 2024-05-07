return {
  {

    -- for lsp features in code cells / embedded code
    'jmbuhr/otter.nvim',
    dev = false,
    dependencies = {
      {
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
        'hrsh7th/nvim-cmp',
      },
    },
    opts = {
      lsp = {
        hover = {
          border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        },
        -- `:h events` that cause the diagnostics to update. Set to:
        -- { "BufWritePost", "InsertLeave", "TextChanged" } for less performant
        -- but more instant diagnostic updates
        diagnostic_update_events = { 'BufWritePost', 'InsertLeave' },
      },
      buffers = {
        set_filetype = true,
        write_to_disk = false,
      },
      handle_leading_whitespace = true,
    },
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          assert(client, 'LSP client not found')
          ---@diagnostic disable-next-line: inject-field
          client.server_capabilities.document_formatting = true

          local map = function(keys, func, desc, mode)
            if not mode then
              mode = 'n'
            end
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- -- Jump to the definition of the word under your cursor.
          -- --  This is where a variable was first declared, or where a function is defined, etc.
          -- --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          map('[g', vim.diagnostic.goto_prev, 'Previous diagnostic')
          map(']g', vim.diagnostic.goto_next, 'Next diagnostic')
          map('<leader>lD', require('telescope.builtin').diagnostics, '[D]iagnostics')

          if client.supports_method 'textDocument/codeAction' then
            map('<leader>la', vim.lsp.buf.code_action, 'code [a]ction', { 'n', 'v' })
          end

          -- if client.supports_method 'textDocument/formatting' then
          map('<leader>lf', vim.lsp.buf.format, 'code [f]ormat', { 'n', 'v' })
          -- end

          if client.supports_method 'textDocument/references' then
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [r]eferences')
            map('<leader>lR', require('telescope.builtin').lsp_references, '[G]oto [r]eferences')
          end

          if client.supports_method 'textDocument/rename' then
            map('<leader>lr', vim.lsp.buf.rename, '[R]ename')
          end

          if client.supports_method 'textDocument/signatureHelp' then
            map('<leader>lh', vim.lsp.buf.signature_help, 'Signature [H]elp')
          end

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('<leader>li', require('telescope.builtin').lsp_implementations, '[i]mplementation')
          --
          --
          -- -- Jump to the type of the word under your cursor.
          -- --  Useful when you're not sure what type a variable is and you want to see
          -- --  the definition of its *type*, not where it was *defined*.
          map('<leader>ld', require('telescope.builtin').lsp_type_definitions, 'Type [d]efinition')
          --
          --
          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[S]ymbols')
          map('<C-d>', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
          --
          -- -- Fuzzy find all the symbols in your current workspace.
          -- --  Similar to document symbols, except searches over your entire project.
          map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace symbols')
          --
          -- TODO: implement language specific initialization
          --
          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      --
      local util = require 'lspconfig.util'

      --- Get quarto LUA paths
      local function get_quarto_resource_path()
        local function strsplit(s, delimiter)
          local result = {}
          for match in (s .. delimiter):gmatch('(.-)' .. delimiter) do
            table.insert(result, match)
          end
          return result
        end

        local f = assert(io.popen('quarto --paths', 'r'))
        local s = assert(f:read '*a')
        f:close()
        return strsplit(s, '\n')[2]
      end

      local lua_library_files = vim.api.nvim_get_runtime_file('', true)
      local lua_plugin_paths = {}
      local resource_path = get_quarto_resource_path()
      if resource_path == nil then
        vim.notify_once 'quarto not found, lua library files not loaded'
      else
        table.insert(lua_library_files, resource_path .. '/lua-types')
        table.insert(lua_plugin_paths, resource_path .. '/lua-plugin/plugin.lua')
      end

      local servers = {
        clangd = {
          capabilities = {
            offsetEncoding = "utf-16",
          }
        },
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},

        -- Markdown LSP + Quarto server
        -- also needs:
        -- $home/.config/marksman/config.toml :
        -- [core]
        -- markdown.file_extensions = ["md", "markdown", "qmd"]
        marksman = {
          filetypes = { 'markdown', 'quarto' },
          root_dir = util.root_pattern('.git', '.marksman.toml', '_quarto.yml'),
        },

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              runtime = {
                version = 'LuaJIT',
                plugin = lua_plugin_paths,
              },
              diagnostics = {
                globals = { 'vim', 'quarto', 'pandoc', 'io', 'string', 'print', 'require', 'table' },
                disable = { 'trailing-space' },
              },
              workspace = {
                library = lua_library_files,
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
              format = {
                -- see null-ls.stylua
                enable = false,
              },
            },
          },
        },
        jedi_language_server = {
          capabilities = {
            -- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = false,
              },
            },
          },
          root_dir = function(fname)
            return util.root_pattern('.git', 'setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt')(fname) or util.path.dirname(fname)
          end,
        },
      }

      local signs = {
        { name = 'DiagnosticSignError', text = '', texthl = 'DiagnosticSignError' },
        { name = 'DiagnosticSignWarn', text = '', texthl = 'DiagnosticSignWarn' },
        { name = 'DiagnosticSignHint', text = '󰌵', texthl = 'DiagnosticSignHint' },
        { name = 'DiagnosticSignInfo', text = '󰋼', texthl = 'DiagnosticSignInfo' },
        -- { name = 'DapStopped',             text = get_icon 'DapStopped',             texthl = 'DiagnosticWarn' },
        -- { name = 'DapBreakpoint',          text = get_icon 'DapBreakpoint',          texthl = 'DiagnosticInfo' },
        -- { name = 'DapBreakpointRejected',  text = get_icon 'DapBreakpointRejected',  texthl = 'DiagnosticError' },
        -- { name = 'DapBreakpointCondition', text = get_icon 'DapBreakpointCondition', texthl = 'DiagnosticInfo' },
        -- { name = 'DapLogPoint',            text = get_icon 'DapLogPoint',            texthl = 'DiagnosticInfo' },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, sign)
      end
      -- lsp.setup_diagnostics(signs)

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      local lsp_flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
      }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            server.flags = vim.tbl_deep_extend('force', {}, lsp_flags, server.lsp_flags or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
