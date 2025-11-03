return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      no_italic = true,
      custom_highlights = function(colors)
        return {
          ["@markup.raw.block.markdown"] = { fg = colors.overlay1 },
          ["@markup.heading.1.markdown"] = { fg = colors.overlay1 },
          ["@markup.heading.2.markdown"] = { fg = colors.overlay1 },
          ["@markup.heading.3.markdown"] = { fg = colors.overlay1 },
        }
      end,
    }
  },
}
