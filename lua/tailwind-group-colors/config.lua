--- Default configuration for tailwind-group-colors.
---
--- `kinds` lives in lua/tailwind-group-colors/kinds.lua and is derived from the
--- Tailwind CSS v4 docs (https://tailwindcss.com/docs/), minus colour utilities.
--- Extend it in that file, with `register_kind`, or via `setup({ kinds = ... })`.

local kinds = require("tailwind-group-colors.kinds")

--- @class twgc.Kind
--- @field name string Kind label; highlight group defaults to `@tailwind.<name>`.
--- @field exact? string[] Class names matched literally.
--- @field prefix? string[] Class names matched by prefix (longest prefix wins).
--- @field hl? string Explicit highlight group override.

--- @class twgc.Config
--- @field enabled boolean Master switch.
--- @field priority integer Extmark priority; must beat the surrounding string capture.
--- @field attributes table<string, boolean> JSX attributes whose string value is a class list.
--- @field functions table<string, boolean> Functions whose string arguments are class lists.
--- @field kinds twgc.Kind[] Ordered list of class kinds.
--- @field palette string[] Highlight groups cycled across kinds for default colours.
--- @field highlights table<string, vim.api.keyset.highlight> Explicit group overrides, keyed by group name.
--- @field classify? fun(token: string, ctx: string?): twgc.Kind? Optional full override of the classifier.

return {
  enabled = true,
  priority = 128,

  attributes = {
    class = true,
    className = true,
    classList = true,
  },

  functions = {
    cva = true,
    cn = true,
    clsx = true,
    classNames = true,
    twMerge = true,
  },

  kinds = kinds,

  -- Default colours cycle through these groups, so neighbouring kinds differ.
  -- Override any individual kind via `highlights` or by setting `hl` on it.
  palette = {
    "@number",
    "@keyword",
    "@function",
    "@constant",
    "@string",
    "@type",
    "@property",
    "@operator",
    "@variable",
    "@punctuation",
    "@attribute",
    "@label",
  },

  highlights = {},
}
