{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # LSP
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      # Navegación
      telescope-nvim
      plenary-nvim

      # Sintaxis
      nvim-treesitter.withAllGrammars

      # Utilidades
      nvim-autopairs
      comment-nvim
      lualine-nvim
      gitsigns-nvim

      # Tema
      tokyonight-nvim
    ];

    initLua = ''
      -- Opciones generales
      vim.g.mapleader = " "
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.termguicolors = true
      vim.opt.signcolumn = "yes"
      vim.opt.clipboard = "unnamedplus"
      vim.opt.ignorecase = true
      vim.opt.smartcase = true

      -- Tema
      vim.cmd.colorscheme("tokyonight-night")

      -- Lualine
      require("lualine").setup({
        options = { theme = "tokyonight" }
      })

      -- Gitsigns
      require("gitsigns").setup()

      -- Autopairs
      require("nvim-autopairs").setup()

      -- Comment
      require("Comment").setup()

      -- Telescope
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)

      -- Autocompletado
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- LSP
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- TypeScript / Vue
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        init_options = {
          plugins = {{
            name = "@vue/typescript-plugin",
            location = "",
            languages = { "vue" },
          }},
        },
        filetypes = { "typescript", "javascript", "vue" },
      })

      -- Vue
      lspconfig.volar.setup({
        capabilities = capabilities,
      })

      -- C#
      lspconfig.omnisharp.setup({
        capabilities = capabilities,
        cmd = { "OmniSharp" },
      })

      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
      })

      -- CSS / Tailwind
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.tailwindcss.setup({ capabilities = capabilities })

      -- Keymaps LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    '';
  };

  home.packages = with pkgs; [
    # LSP servers
    nodePackages.typescript-language-server
    vue-language-server
    omnisharp-roslyn
    pyright
    nodePackages.vscode-langservers-extracted
    tailwindcss-language-server

    # Herramientas Telescope
    ripgrep
    fd
  ];
}
