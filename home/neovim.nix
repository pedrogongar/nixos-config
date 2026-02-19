{ config, pkgs, ... }:

let
  vueTypescriptPlugin = pkgs.vue-language-server + "/lib/node_modules/@vue/language-server";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Tema
      catppuccin-nvim

      # Autocompletado
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      friendly-snippets
      fidget-nvim

      # Navegación
      telescope-nvim
      plenary-nvim
      nvim-web-devicons

      # Sintaxis
      nvim-treesitter.withAllGrammars

      # Explorador de archivos
      oil-nvim

      # UI
      lualine-nvim
      bufferline-nvim
      indent-blankline-nvim
      which-key-nvim
      todo-comments-nvim
      trouble-nvim
      dressing-nvim

      # Git
      gitsigns-nvim

      # Utilidades
      nvim-autopairs
      nvim-ts-autotag
      comment-nvim
      nvim-surround
      flash-nvim
    ];

    initLua = ''
      -- ============ OPCIONES ============

      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

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
      vim.opt.cursorline = true
      vim.opt.scrolloff = 8
      vim.opt.sidescrolloff = 8
      vim.opt.splitbelow = true
      vim.opt.splitright = true
      vim.opt.undofile = true
      vim.opt.updatetime = 250
      vim.opt.wrap = false
      vim.opt.showmode = false
      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      -- ============ TEMA ============

      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          telescope = true,
          treesitter = true,
          which_key = true,
          indent_blankline = { enabled = true },
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
        },
      })
      vim.cmd.colorscheme("catppuccin")

      -- ============ UI PLUGINS ============

      require("lualine").setup({
        options = {
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })

      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          show_close_icon = false,
          show_buffer_close_icons = false,
          separator_style = "thin",
          offsets = {
            { filetype = "oil", text = "Explorador", highlight = "Directory" },
          },
        },
      })

      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = true, show_start = false, show_end = false },
      })

      require("which-key").setup({
        delay = 300,
      })

      require("dressing").setup()

      require("fidget").setup({
        notification = { window = { winblend = 0 } },
      })

      -- ============ GIT ============

      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "▁" },
          topdelete = { text = "▔" },
          changedelete = { text = "▎" },
        },
        current_line_blame = true,
        current_line_blame_opts = { delay = 500 },
      })

      -- ============ UTILIDADES ============

      require("nvim-autopairs").setup()
      require("nvim-ts-autotag").setup()
      require("Comment").setup()
      require("nvim-surround").setup()
      require("todo-comments").setup()
      require("trouble").setup()

      require("flash").setup({
        modes = { search = { enabled = false } },
      })

      -- ============ OIL (explorador) ============

      require("oil").setup({
        view_options = { show_hidden = true },
        keymaps = {
          ["q"] = "actions.close",
          ["<BS>"] = "actions.parent",
        },
      })

      -- ============ TELESCOPE ============

      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          file_ignore_patterns = { "node_modules", ".git/", "bin/", "obj/" },
        },
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Buscar archivos" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Buscar texto" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buscar buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Buscar ayuda" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Buscar diagnósticos" })
      vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Buscar referencias" })

      -- ============ AUTOCOMPLETADO ============

      require("luasnip.loaders.from_vscode").lazy_load()	
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
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
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
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
        formatting = {
          format = function(entry, vim_item)
            local source_names = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            }
            vim_item.menu = source_names[entry.source.name] or ""
            return vim_item
          end,
        },
      })

      -- ============ LSP ============

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local web_root = { "package.json", "tsconfig.json", ".git" }

      vim.lsp.config("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },
        capabilities = capabilities,
        root_markers = web_root,
        init_options = {
          plugins = {{
            name = "@vue/typescript-plugin",
            location = "${vueTypescriptPlugin}",
            languages = { "vue" },
          }},
        },
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
      })

      vim.lsp.config("volar", {
        cmd = { "vue-language-server", "--stdio" },
        capabilities = capabilities,
        root_markers = web_root,
        filetypes = { "vue" },
      })

      vim.lsp.config("omnisharp", {
        cmd = { "${pkgs.omnisharp-roslyn}/bin/OmniSharp" },
        capabilities = capabilities,
        root_markers = { "*.sln", "*.csproj", ".git" },
        filetypes = { "cs" },
        settings = {
          FormattingOptions = { EnableEditorConfigSupport = true },
          RoslynExtensionsOptions = { EnableAnalyzersSupport = true },
        },
      })

      vim.lsp.config("pyright", {
        cmd = { "pyright-langserver", "--stdio" },
        capabilities = capabilities,
        root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
        filetypes = { "python" },
      })

      vim.lsp.config("cssls", {
        cmd = { "vscode-css-language-server", "--stdio" },
        capabilities = capabilities,
        root_markers = web_root,
        filetypes = { "css", "scss", "less" },
      })

      vim.lsp.config("tailwindcss", {
        cmd = { "tailwindcss-language-server", "--stdio" },
        capabilities = capabilities,
        root_markers = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs", "tailwind.config.mjs" },
        filetypes = { "html", "css", "vue", "javascript", "typescript", "typescriptreact", "javascriptreact" },
      })

      vim.lsp.config("nil_ls", {
        cmd = { "nil" },
        capabilities = capabilities,
        root_markers = { "flake.nix", "default.nix", ".git" },
        filetypes = { "nix" },
        settings = {
          ["nil"] = {
            formatting = { command = { "nixpkgs-fmt" } },
          },
        },
      })

      vim.lsp.config("bashls", {
        cmd = { "bash-language-server", "start" },
        capabilities = capabilities,
        root_markers = { ".git" },
        filetypes = { "sh", "bash", "zsh" },
      })

      vim.lsp.enable({ "ts_ls", "volar", "omnisharp", "pyright", "cssls", "tailwindcss", "nil_ls", "bashls" })
     
      -- Keymaps LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = function(desc)
            return { buffer = ev.buf, desc = desc }
          end
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Ir a definición"))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Ir a declaración"))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Ir a implementación"))
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Ver referencias"))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Info hover"))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Renombrar"))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
          vim.keymap.set("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, opts("Formatear"))
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Diagnóstico anterior"))
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Diagnóstico siguiente"))
          vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts("Ver diagnóstico"))
        end,
      })

      -- ============ KEYMAPS GENERALES ============

      local map = vim.keymap.set

      -- Explorador
      map("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Explorador" })

      -- Buffers
      map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer siguiente" })
      map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer anterior" })
      map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Cerrar buffer" })

      -- Splits
      map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
      map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontal" })
      map("n", "<C-h>", "<C-w>h", { desc = "Ir split izquierda" })
      map("n", "<C-j>", "<C-w>j", { desc = "Ir split abajo" })
      map("n", "<C-k>", "<C-w>k", { desc = "Ir split arriba" })
      map("n", "<C-l>", "<C-w>l", { desc = "Ir split derecha" })

      -- Trouble
      map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnósticos" })
      map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Diagnósticos buffer" })

      -- Todo
      map("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "TODOs" })

      -- Flash
      map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash jump" })

      -- Guardar y salir rápido
      map("n", "<leader>w", "<cmd>w<cr>", { desc = "Guardar" })
      map("n", "<leader>q", "<cmd>q<cr>", { desc = "Salir" })
      map("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Guardar y salir" })

      -- Mover líneas
      map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Mover línea abajo" })
      map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Mover línea arriba" })

      -- Sin yank al pegar en visual
      map("v", "p", '"_dP', { desc = "Pegar sin yank" })

      -- Limpiar búsqueda
      map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Limpiar búsqueda" })
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
    nil
    bash-language-server
    nixpkgs-fmt

    # Herramientas Telescope
    ripgrep
    fd
  ];
}
