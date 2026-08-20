return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = { julia = { "juliaformatter" } },
    formatters = {
      juliaformatter = {
        command = "juliaformatter",
        args = { "$FILENAME" },
        stdin = false,
      },
    },
  },
}
