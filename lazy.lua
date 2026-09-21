-- lazy.nvim package spec.
--
-- lazy.nvim reads this file straight from the repository and merges it into the
-- plugin's spec (scoped with `specs`), so a user only needs to reference the
-- repo:
--
--   { "theyoxy/tailwind-group-colors.nvim" }
--
-- Keep it a start plugin. The `queries/<lang>/highlights.scm` files have to be
-- on the runtimepath before Tree-sitter highlights the first buffer, so the
-- plugin must not be lazy-loaded on `ft`. `lazy = false` is lazy.nvim's default,
-- but stating it here documents the constraint for anyone who lazy-loads
-- explicitly.
return {
  "theyoxy/tailwind-group-colors.nvim",
  -- Auto-detected from the repo name (`tailwind-group-colors.nvim` ->
  -- `tailwind-group-colors`). Set explicitly so `opts` keeps calling
  -- `require("tailwind-group-colors").setup()` even if the heuristics change.
  main = "tailwind-group-colors",
  lazy = false,
  opts = {},
}
