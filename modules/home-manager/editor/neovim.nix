{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true; # TODO: Make this configurable.

    extraPackages = with pkgs; [
      xsel # Clipboard helper.
      fd
      ripgrep
    ];

    extraLuaConfig = /* lua */ ''
      vim.o.nu = true
      vim.o.rnu = true

      vim.o.shiftwidth = 2
      vim.o.expandtab = true
      vim.o.smartindent = true

      vim.o.clipboard = "unnamedplus"

      vim.o.undofile = true
      vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"

      vim.g.mapleader = " "
      vim.g.maplocalleader = ","

      -- TODO: base16 theming
      vim.cmd.colorscheme "retrobox"
    '';

    plugins = with pkgs.vimPlugins; [
      { plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = /* lua */ ''
          require("nvim-treesitter.configs").setup{
            highlight = {
              enable = true,
            },
          }
        ''; }

      telescope-file-browser-nvim
      telescope-ui-select-nvim
      { plugin = telescope-nvim;
        type = "lua";
        config = /* lua */ ''
          local telescope = require("telescope")

          telescope.setup{
            pickers = {
              find_files = {
                hidden = true,
                file_ignore_patterns = {
                  ".git",
                },
              },
            },
            extensions = {
              file_browser = {
                hijack_netrw = true,
                path = "%:p:h",
                select_buffer = true,
                grouped = true,
                hidden = { file_browser = true },
              },
            },
          }

          telescope.load_extension "file_browser"
          telescope.load_extension "ui-select"

          vim.keymap.set("n", " ff", require("telescope.builtin").find_files)
          vim.keymap.set("n", " fg", require("telescope.builtin").live_grep)
          vim.keymap.set("n", " fm", telescope.extensions.file_browser.file_browser)
        ''; }

      { plugin = nvim-lspconfig;
        type = "lua";
        config = /* lua */ ''
          local lspconfig = require("lspconfig")

          lspconfig.nil_ls.setup{}
          lspconfig.ts_ls.setup{}
          lspconfig.clangd.setup{}
          lspconfig.gdscript.setup{}

          vim.keymap.set("n", "gd", vim.lsp.buf.definition)
          vim.keymap.set("n", "gD", vim.lsp.buf.references) -- shows references in quickfix-list
          vim.keymap.set("n", " ca", vim.lsp.buf.code_action)
        ''; }

      # Completion sources.
      vim-vsnip
      cmp-vsnip
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-path
      cmp-cmdline

      { plugin = nvim-cmp;
        type = "lua";
        config = /* lua */ ''
          local cmp = require("cmp")

          cmp.setup{
            snippet = {
              expand = function (args) vim.fn["vsnip#anonymous"](args.body) end,
            },

            mapping = cmp.mapping.preset.insert{
              ["<C-Space>"] = cmp.mapping.complete(),

              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),

              ["<C-p>"] = cmp.mapping.select_prev_item(),
              ["<C-n>"] = cmp.mapping.select_next_item(),

              ["<CR>"] = cmp.mapping.confirm({ select = false }), -- TODO: This is buggy sometimes
            },

            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "nvim_lsp_signature_help" },
              { name = "vsnip" },
            }, {
              { name = "path" },
            }, {
              { name = "buffer" },
            })
          }

          cmp.setup.cmdline({ "/", "?" }, { -- grep words from file
            sources = {
              { name = "buffer" },
            },
          })

          cmp.setup.cmdline(":", {
            sources = cmp.config.sources({
              { name = "cmdline" },
            }, {
              { name = "path" },
            }),
          })
        ''; }

      # Pretty multiline errors.
      { plugin = lsp_lines-nvim;
        type = "lua";
        config = /* lua */ ''
          require("lsp_lines").setup()
          vim.diagnostic.config{
            virtual_text = false, -- disable builtin error display
            virtual_lines = true,
          }
        ''; }

      { plugin = render-markdown-nvim;
        type = "lua";
        config = /* lua */ ''
          require("render-markdown").setup{}
        ''; }
    ];
  };

  home.shellAliases.v = "nvim";
}
