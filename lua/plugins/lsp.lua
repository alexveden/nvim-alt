return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
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

          -- client.server_capabilities.semanticTokensProvider = nil

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

          map('[d', vim.diagnostic.goto_prev, 'Previous [d]iagnostic')
          map(']d', vim.diagnostic.goto_next, 'Next [d]iagnostic')
          map('<leader>lD', require('telescope.builtin').diagnostics, '[D]iagnostics')

          if client:supports_method 'textDocument/codeAction' then
            map('<leader>la', vim.lsp.buf.code_action, 'code [a]ction', { 'n', 'v' })
          end

          -- -- if client.supports_method 'textDocument/formatting' then
          -- NOTE:: see comform plugin
          --   map('<leader>lf', function()
          --     vim.lsp.buf.format { timeout_ms = 5000 }
          --   end, 'code [f]ormat', { 'n', 'v' })
          -- -- end

          if client:supports_method 'textDocument/references' then
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [r]eferences')
            map('<leader>lR', require('telescope.builtin').lsp_references, '[G]oto [r]eferences')
          end

          if client:supports_method 'textDocument/rename' then
            map('<leader>lr', vim.lsp.buf.rename, '[R]ename')
          end

          if client:supports_method 'textDocument/signatureHelp' then
            map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help', { 'i' })
            map('K', vim.lsp.buf.signature_help, 'Signature Help')
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
          --
          -- -- Fuzzy find all the symbols in your current workspace.
          -- --  Similar to document symbols, except searches over your entire project.
          map('<leader>lp', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Project symbols')
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

      -- lsp.setup_diagnostics(signs)
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '󰋼',
            [vim.diagnostic.severity.HINT] = '󰌵',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local ensure_installed = {
        'stylua', -- Used to format Lua code
      }
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        --ensure_installed = {'djlsp'}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
      }

      --
      -- LUA
      --
      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths
                -- here.
                -- '${3rd}/luv/library'
                -- '${3rd}/busted/library'
              },
              -- Or pull in all of 'runtimepath'.
              -- NOTE: this is a lot slower and will cause issues when working on
              -- your own configuration.
              -- See https://github.com/neovim/nvim-lspconfig/issues/3189
              -- library = {
              --   vim.api.nvim_get_runtime_file('', true),
              -- }
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })

      --
      -- C
      --
      vim.lsp.config['clangd'] = {
        cmd = { 'clangd' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        root_markers = {
          '.clangd',
          '.clang-tidy',
          '.clang-format',
          'compile_commands.json',
          'compile_flags.txt',
          'configure.ac', -- AutoTools
          '.git',
        },
        capabilities = {
          textDocument = {
            completion = {
              editsNearCursor = true,
              completionItem = { snippetSupport = false },
            },
          },
          offsetEncoding = { 'utf-8', 'utf-16' },
        },
        ---@param client vim.lsp.Client
        ---@param init_result ClangdInitializeResult
        on_init = function(client, init_result)
          if init_result.offsetEncoding then
            client.offset_encoding = init_result.offsetEncoding
          end
        end,
      }

      vim.lsp.config['jedi_language_server'] = {
        cmd = { 'jedi-language-server' },
        filetypes = { 'python' },

        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
        capabilities = {
          textDocument = {
            completion = {
              editsNearCursor = true,
              completionItem = { snippetSupport = false },
            },
          },
        },
      on_attach = function(client, bufnr)
        -- Enable diagnostics
        vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                -- Enable diagnostics
                virtual_text = true,  -- or your preferred diagnostic config
                signs = true,
                update_in_insert = false,
            }
        )
    end
      }

      vim.lsp.config['jinja_lsp'] = {
        cmd = { 'jinja-lsp' },
        filetypes = { 'jinja' },
        root_markers = {
          'requirements.txt',
          '.git',
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
