{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.bm-neovim;
in
{
  options.programs.bm-neovim = with lib; {
    enable = mkEnableOption "neovim";

    defaultEditor = mkOption {
      type = types.bool;
      description = "Whether to configure nvim as the default editor using the EDITOR environment variable.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: Theming.
    programs.neovim = {
      enable = true;
      defaultEditor = cfg.defaultEditor;
      extraPackages = with pkgs; [
        # Clipboard provider.
        xsel
        fd
        ripgrep
      ];

      # TODO: refactor this into a separate lua config tree
      extraLuaConfig = # lua
        ''
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

          vim.o.wrap = false
        '';

      plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = # lua
            ''
              require("nvim-treesitter.configs").setup{
                highlight = {
                  enable = true,
                },
              }
            '';
        }

        telescope-file-browser-nvim
        {
          plugin = telescope-nvim;
          type = "lua";
          config = # lua
            ''
              local telescope = require("telescope")

              telescope.setup{
                pickers = {
                  find_files = {
                    hidden = true,
                    file_ignore_patterns = {
                      -- ignore .git/
                      "^%.git/" -- this is a weird lua pattern syntax, apparently
                    },
                  },
                },
                extensions = {
                  file_browser = {
                    hijack_netrw = true,
                    path = "%:p:h",
                    select_buffer = true,
                    grouped = true,
                    hidden = {
                      file_browser = true,
                      folder_browser = true,
                    },
                  },
                },
              }

              telescope.load_extension("file_browser")

              vim.keymap.set("n", " ff", require("telescope.builtin").find_files)
              vim.keymap.set("n", " fg", require("telescope.builtin").live_grep)
              vim.keymap.set("n", " fm", telescope.extensions.file_browser.file_browser)
            '';
        }

        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = # lua
            ''
              local lspconfig = require("lspconfig")

              lspconfig.nil_ls.setup{}
              lspconfig.ts_ls.setup{}
              lspconfig.clangd.setup{}
              lspconfig.gdscript.setup{}
              lspconfig.rust_analyzer.setup{}

              vim.keymap.set("n", "gd", vim.lsp.buf.definition)
              vim.keymap.set("n", " ca", vim.lsp.buf.code_action)
            '';
        }

        # Completion sources.
        vim-vsnip
        cmp-vsnip
        cmp-buffer
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp-path
        cmp-cmdline

        {
          plugin = nvim-cmp;
          type = "lua";
          config = # lua
            ''
              local cmp = require("cmp")

              local cmp_confirm = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
              })
              -- don't confirm for signature help to allow new line without selecting argument name
              local confirm = cmp.sync(function(fallback)
              local e = cmp.core.view:get_selected_entry()
                if e and e.source.name == "nvim_lsp_signature_help" then
                  fallback() 
                else
                  cmp_confirm(fallback) 
                end 
              end)

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
                  ["<CR>"] = confirm,
                },
                sources = cmp.config.sources({
                  { name = "nvim_lsp" },
                  { name = "nvim_lsp_signature_help" },
                  { name = "vsnip" },
                }, {
                  { name = "path" },
                }, {
                  { name = "buffer" },
                }),
              }

              cmp.setup.cmdline({ "/", "?" }, { -- grep words from file
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                  { name = "buffer" },
                },
              })

              cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                  { name = "cmdline" },
                }, {
                  { name = "path" },
                }),
              })
            '';
        }

        # Pretty multiline errors.
        {
          plugin = lsp_lines-nvim;
          type = "lua";
          config = # lua
            ''
              require("lsp_lines").setup()
              vim.diagnostic.config{
                virtual_text = false, -- disable builtin error display
                virtual_lines = true,
              }
            '';
        }

        # TODO: Try markview
        {
          plugin = render-markdown-nvim;
          type = "lua";
          config = # lua
            ''
              require("render-markdown").setup{}
            '';
        }
      ];
    };

    home.shellAliases.v = "nvim";
  };
}
