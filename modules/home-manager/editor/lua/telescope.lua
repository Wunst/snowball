require("telescope").setup{
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

require("telescope").load_extension"file_browser"

vim.keymap.set("n", " ff", function () require("telescope.builtin").find_files{} end)
vim.keymap.set("n", " fg", function () require("telescope.builtin").live_grep{} end)
vim.keymap.set("n", " fm", function () require("telescope").extensions.file_browser{} end)
