-- Register the directive and defaults as soon as the plugin is on the
-- runtimepath, so the Tree-sitter queries never run before the handler exists.
-- Users can still call `require("tailwind-group-colors").setup(opts)` later to
-- override anything.
if vim.g.loaded_tailwind_group_colors then
  return
end
vim.g.loaded_tailwind_group_colors = true

if vim.fn.has("nvim-0.10") == 0 then
  return
end

require("tailwind-group-colors").setup()
