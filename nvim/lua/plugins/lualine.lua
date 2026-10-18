local dotnet = require("easy-dotnet")

require("lualine").setup {
  sections = {
    -- ...
    lualine_a = { "mode", dotnet.lualine.jobs },
    -- Shows the default startup project and its launch profile (if any),
    -- pushed by the server whenever it changes.
    lualine_x = { dotnet.lualine.active_project },
    -- ...
  },
}
