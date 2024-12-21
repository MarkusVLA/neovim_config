-- Basic settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Line number settings
vim.opt.number = true         -- Show regular line numbers
vim.opt.relativenumber = true -- Show relative line numbers simultaneously

-- Enable true colors
vim.opt.termguicolors = true

-- Packer plugin setup and plugins -- 
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- Gruvbox Theme
    use {
        'ellisonleao/gruvbox.nvim',
        as = 'gruvbox',
        config = function()
            vim.o.background = "dark"
            require("gruvbox").setup({
                transparent_mode = true,
                contrast = "medium",
            })
            vim.cmd([[colorscheme gruvbox]])
        end
    }
    -- -- Second theme: Switch by commenting.
    -- use {
    -- "catppuccin/nvim",
    -- as = "catppuccin",
    -- config = function()
    --     require("catppuccin").setup({
    --         transparent_background = true,
    --         flavour = "mocha", -- Can be: latte, frappe, macchiato, mocha
    --     })
    --     vim.cmd.colorscheme "catppuccin"
    -- end
    -- }
    
    -- Auto-pairs
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup({
                enable_check_bracket_line = true,
                ignored_next_char = "[%w%.]",
                check_ts = false,
                enable_afterquote = true,
                enable_moveright = true,
                disable_filetype = { "TelescopePrompt" },
                fast_wrap = {
                    map = '<M-e>',
                    chars = { '{', '[', '(', '"', "'" },
                    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
                    end_key = '$',
                    keys = 'qwertyuiopzxcvbnmasdfghjkl',
                    check_comma = true,
                    highlight = 'Search',
                    highlight_grey='Comment'
                },
            })
        end
    }
    
    -- LSP
    use {
        'neovim/nvim-lspconfig',
        requires = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        }
    }
    
    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
        }
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
        }
    }
end)

-- Setup Mason
require('mason').setup()
require('mason-lspconfig').setup()

-- Setup completion
local cmp = require('cmp')
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    }
})

-- Configure LSP with completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup C/C++ LSP (clangd)
require('lspconfig').clangd.setup({
    capabilities = capabilities,
    
    cmd = {
        "clangd",  
        --  note that clangd has to be installed with system package manager.
        --  "/opt/homebrew/opt/llvm/bin/clangd", for MacOS, also add to path.      
        --  brew install llvm
        --  export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
        --  which clangd  # Should show /opt/homebrew/opt/llvm/bin/clangd
        --  :MasonUninstall clangd
        --  
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
    },

    on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
        -- Key mappings
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    end,
})

-- Setup Python LSP (pyright)
require('lspconfig').pyright.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        -- Same keybindings as clangd
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    end,
})

require('lspconfig').glsl_analyzer.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        -- Same keybindings as other LSPs
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    end,
    filetypes = { "glsl", "vert", "frag", "geom", "comp" },  -- supported file extensions
    cmd = { "glsl_analyzer" }  -- make sure this is installed via Mason
})

-- Add filetype detection for GLSL files
vim.filetype.add({
    extension = {
        vert = 'glsl',
        frag = 'glsl',
        geom = 'glsl',
        comp = 'glsl'
    }
})
-- Telescope setup and keymaps
require('telescope').setup({
    defaults = {
        file_ignore_patterns = { 
            "node_modules",
            ".git",
            "build/.*",      -- Modified this line
            "*/build/.*",    -- Added this to catch build dirs in subdirectories
            "build",         -- Added this to catch the build dir itself
        },
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
            }
        }
    }
})

-- Telescope keymaps
vim.keymap.set('n', '<space>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<space>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<space>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<space>fh', '<cmd>Telescope help_tags<cr>')


-- Add this somewhere after your plugin setup
require('nvim-treesitter.configs').setup({
    ensure_installed = { "lua", "python", "cpp", "glsl" },  -- add to your existing list
    highlight = {
        enable = true,
    },
})



