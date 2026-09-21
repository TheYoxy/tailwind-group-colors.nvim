# tailwind-group-colors.nvim

Colour Tailwind CSS classes by utility family inside Neovim.

`margin` utilities get one colour, `padding` another, `display` another, and so on. The point is readability: a long `cn('...')` string becomes scannable instead of a wall of one colour.

Built on Neovim's own Tree-sitter support. No custom grammar, only query files plus a directive.

```
className={cn('px-1 py-2 mbs-1 col-start-2 grid gap-x-6 disabled:mt-2 text-sm', className)}
                 └ padding ┘      └ margin    └ grid   └ display └ gap        └ margin   └ font
```

## Requirements

- Neovim 0.10 or newer (uses `vim.treesitter.query.add_directive`).
- A Tree-sitter parser for `tsx`, `typescript`, or `javascript`. The `tsx` parser covers `.tsx`; install with `:TSInstall tsx typescript javascript`.

## Installation

lazy.nvim:

```lua
{
  "theyoxy/tailwind-group-colors.nvim",
  lazy = false,
  opts = {},
}
```

Load it at startup (`lazy = false`). The query files have to be on the runtimepath before Tree-sitter highlights the first buffer, and a plugin lazy-loaded on `ft` can load too late. If you do lazy-load it, use `event = "VeryLazy"` and not `ft`.

Manual (packer, mini.deps, built-in `:packadd`): add the directory to `runtimepath` as usual. The plugin configures itself on load, so `setup()` is optional.

## Configuration

Everything is optional.

```lua
require("tailwind-group-colors").setup({
  enabled = true,
  priority = 128,

  -- JSX attributes whose string value is a class list.
  attributes = { class = true, className = true, classList = true },

  -- Functions whose string arguments are class lists.
  functions = { cn = true, clsx = true, cva = true, classNames = true, twMerge = true },

  -- Override the default colours. Groups are named `@tailwind.<kind>`.
  highlights = {
    ["@tailwind.margin"] = { fg = "#cba6f7" },
    ["@tailwind.padding"] = { link = "Keyword" },
  },
})
```

### Options

| Option | Default | Meaning |
| --- | --- | --- |
| `enabled` | `true` | Master switch. |
| `priority` | `128` | Extmark priority. Must beat the surrounding string highlight, which uses `100`. |
| `attributes` | see above | JSX attributes that carry class lists. |
| `functions` | see above | Functions whose string arguments carry class lists. |
| `kinds` | 60 families | The utility families and their matchers. See below. |
| `palette` | 12 groups | Highlight groups cycled across kinds for default colours. |
| `highlights` | `{}` | Explicit `nvim_set_hl` entries, keyed by group name. |
| `classify` | `nil` | Full override: `function(token, ctx): Kind?`. |

## Kinds

Every kind produces a highlight group `@tailwind.<name>`. Default colours cycle through `palette`, so neighbouring kinds differ. Any single kind can be overridden.

Included families:

- Layout: `display`, `position`, `inset`, `z-index`, `overflow`, `aspect-ratio`, `columns`, `object`, `float`, `clear`, `visibility`, `isolation`, `box-sizing`, `break`
- Spacing: `margin`, `padding`, `gap`, `space`
- Sizing: `width`, `height`, `size`
- Flexbox and grid: `flex`, `grid`, `align`
- Typography: `font`, `font-size`, `tracking`, `leading`, `text-align`, `text-transform`, `text-decoration`, `text-overflow`, `text-wrap`, `whitespace`, `list`, `vertical-align`, `line-clamp`, `indent`
- Borders and effects: `rounded`, `border`, `outline`, `table`, `shadow`, `opacity`, `background`, `filter`, `mix-blend`, `mask`
- Transforms and motion: `transform`, `transition`, `animate`
- Interactivity: `cursor`, `pointer-events`, `select`, `resize`, `snap`, `touch`, `appearance`, `will-change`, `scroll`

## Variants

Variants are handled. Only the utility behind the variant is coloured:

- `disabled:px-1` colours `px-1`
- `md:hover:m-2` colours `m-2`
- `[&_p]:leading-relaxed` colours `leading-relaxed`
- `hover:-mt-2` colours `-mt-2`

Colons inside `[...]` or `(...)` are ignored, so `[&:hover]:gap-x-2` colours only `gap-x-2`.

## Extending

Add a family at runtime:

```lua
local twgc = require("tailwind-group-colors")

-- gap-x-* as its own kind
twgc.register_kind({ name = "gap-x", prefix = { "gap-x-" } })

-- a helper that produces class lists
twgc.register_function("tv")

-- an attribute that carries class lists
twgc.register_attribute("classNames")
```

A kind is either `exact` (class names matched literally) or `prefix` (matched by prefix, longest prefix first). Edit `lua/tailwind-group-colors/kinds.lua` to change the shipped set.

## How it works

1. `queries/<lang>/highlights.scm` captures the string fragment that holds a class list and its owner (attribute or function name), then attaches the `#tailwind-group-colors!` directive.
2. The Lua directive runs inside the Tree-sitter highlighter. It checks the owner against `attributes` / `functions`, splits the string on whitespace, strips variant prefixes, classifies each utility, and paints it with an `ephemeral` extmark.
3. Ephemeral extmarks are recreated on every redraw, so there is no stale state to invalidate.

There is no new grammar and no separate parser. The stock parsers do the work.

## Limitations

- Colour utilities are intentionally skipped. `text-red-500`, `bg-red-500`, `fill-*`, `stroke-*`, `from-*`, `via-*`, `to-*` stay uncoloured. One side effect: `border-red-500` still matches the `border` family because the matcher is prefix based.
- Only literal strings are seen. `cn('px-1', condition && 'py-2')` colours `px-1` but not `py-2`, since the second value is not a direct string argument.
- Only `tsx`, `typescript`, and `javascript` query files ship. Add another language by copying a query file under `queries/<lang>/highlights.scm`.

## Health

```vim
:checkhealth tailwind-group-colors
```

Checks the Neovim version, the parsers, and the loaded configuration.

## License

MIT. See [LICENSE](LICENSE).
