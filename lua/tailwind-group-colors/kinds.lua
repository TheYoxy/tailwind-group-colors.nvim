--- Tailwind class kinds, derived from the Tailwind CSS v4 docs
--- (https://tailwindcss.com/docs/).
---
--- Coverage:
---   - core utility families only (not every family in the docs)
---   - color utilities are intentionally omitted, so `bg-red-500`,
---     `text-red-500`, `fill-*`, `stroke-*`, ... stay uncoloured
---   - variants (`md:`, `hover:`, `[&_p]:`, ...) are supported: the variant
---     prefix is skipped and only the utility behind it is coloured
---
--- Each entry has:
---   name   -> kind label; the highlight group defaults to `@tailwind.<name>`
---   exact  -> class names matched literally
---   prefix -> class names matched by prefix (longest prefix wins)
---
--- Add a family by adding one entry, or call
--- `require("tailwind-group-colors").register_kind`.

return {
  -- Layout
  {
    name = "display",
    exact = {
      "block",
      "inline",
      "inline-block",
      "flow-root",
      "flex",
      "inline-flex",
      "grid",
      "inline-grid",
      "contents",
      "table",
      "inline-table",
      "table-caption",
      "table-cell",
      "table-column",
      "table-column-group",
      "table-footer-group",
      "table-header-group",
      "table-row-group",
      "table-row",
      "list-item",
      "hidden",
      "sr-only",
      "not-sr-only",
    },
  },
  { name = "position", exact = { "static", "fixed", "absolute", "relative", "sticky" } },
  { name = "inset", prefix = { "inset-", "top-", "right-", "bottom-", "left-", "start-", "end-" } },
  { name = "z-index", prefix = { "z-" } },
  { name = "overflow", prefix = { "overflow-", "overscroll-" } },
  { name = "aspect-ratio", prefix = { "aspect-" } },
  { name = "columns", prefix = { "columns-" } },
  { name = "object", prefix = { "object-" } },
  { name = "float", prefix = { "float-" } },
  { name = "clear", prefix = { "clear-" } },
  { name = "visibility", exact = { "visible", "invisible", "collapse" } },
  { name = "isolation", exact = { "isolate", "isolation-auto" } },
  { name = "box-sizing", exact = { "box-border", "box-content" } },
  { name = "break", prefix = { "break-" } },

  -- Spacing
  { name = "margin", prefix = { "m-", "mx-", "my-", "ms-", "me-", "mbs-", "mbe-", "mt-", "mr-", "mb-", "ml-" } },
  { name = "padding", prefix = { "p-", "px-", "py-", "ps-", "pe-", "pbs-", "pbe-", "pt-", "pr-", "pb-", "pl-" } },
  { name = "gap", prefix = { "gap-", "gap-x-", "gap-y-" } },
  { name = "space", prefix = { "space-x-", "space-y-" } },

  -- Sizing
  { name = "width", prefix = { "w-", "min-w-", "max-w-" } },
  { name = "height", prefix = { "h-", "min-h-", "max-h-" } },
  { name = "size", prefix = { "size-" } },

  -- Flexbox & Grid
  { name = "flex", prefix = { "flex-", "basis-", "grow-", "shrink-" }, exact = { "grow", "shrink" } },
  { name = "grid", prefix = { "grid-", "auto-cols-", "auto-rows-", "col-", "row-" } },
  { name = "align", prefix = { "justify-", "items-", "self-", "place-", "content-", "order-" } },

  -- Typography
  {
    name = "font",
    prefix = { "font-" },
    exact = { "italic", "not-italic", "antialiased", "subpixel-antialiased" },
  },
  {
    name = "font-size",
    exact = {
      "text-xs",
      "text-sm",
      "text-base",
      "text-lg",
      "text-xl",
      "text-2xl",
      "text-3xl",
      "text-4xl",
      "text-5xl",
      "text-6xl",
      "text-7xl",
      "text-8xl",
      "text-9xl",
    },
  },
  { name = "tracking", prefix = { "tracking-" } },
  { name = "leading", prefix = { "leading-" } },
  {
    name = "text-align",
    exact = { "text-left", "text-center", "text-right", "text-justify", "text-start", "text-end" },
  },
  { name = "text-transform", exact = { "uppercase", "lowercase", "capitalize", "normal-case" } },
  {
    name = "text-decoration",
    exact = { "underline", "overline", "line-through", "no-underline" },
    prefix = { "decoration-", "underline-offset-" },
  },
  { name = "text-overflow", exact = { "truncate", "text-ellipsis", "text-clip" } },
  {
    name = "text-wrap",
    exact = { "text-wrap", "text-nowrap", "text-balance", "text-pretty" },
    prefix = { "wrap-" },
  },
  { name = "whitespace", prefix = { "whitespace-" } },
  { name = "list", prefix = { "list-" } },
  { name = "vertical-align", prefix = { "align-" } },
  { name = "line-clamp", prefix = { "line-clamp-" } },
  { name = "indent", prefix = { "indent-" } },

  -- Borders & effects
  { name = "rounded", prefix = { "rounded-" }, exact = { "rounded" } },
  { name = "border", prefix = { "border-" }, exact = { "border" } },
  { name = "outline", prefix = { "outline-" }, exact = { "outline" } },
  {
    name = "table",
    exact = {
      "table-auto",
      "table-fixed",
      "border-collapse",
      "border-separate",
      "caption-top",
      "caption-bottom",
    },
  },
  { name = "shadow", prefix = { "shadow-", "text-shadow-" }, exact = { "shadow", "text-shadow" } },
  { name = "opacity", prefix = { "opacity-" } },
  {
    name = "background",
    prefix = {
      "bg-blend-",
      "bg-clip-",
      "bg-origin-",
      "bg-repeat",
      "bg-no-repeat",
      "bg-fixed",
      "bg-local",
      "bg-scroll",
      "bg-auto",
      "bg-cover",
      "bg-contain",
      "bg-size-",
      "bg-top",
      "bg-bottom",
      "bg-left",
      "bg-right",
      "bg-center",
      "bg-linear-",
      "bg-radial",
      "bg-conic-",
      "bg-none",
    },
  },
  {
    name = "filter",
    prefix = {
      "blur-",
      "brightness-",
      "contrast-",
      "grayscale-",
      "hue-rotate-",
      "invert-",
      "saturate-",
      "sepia-",
      "drop-shadow-",
      "backdrop-",
      "filter-",
    },
    exact = {
      "blur",
      "brightness",
      "contrast",
      "grayscale",
      "hue-rotate",
      "invert",
      "saturate",
      "sepia",
      "filter-none",
    },
  },
  { name = "mix-blend", prefix = { "mix-blend-" } },
  { name = "mask", prefix = { "mask-" } },

  -- Transforms & motion
  {
    name = "transform",
    prefix = {
      "scale-",
      "rotate-",
      "translate-",
      "skew-",
      "origin-",
      "transform-",
      "perspective-",
      "backface-",
      "zoom-",
    },
  },
  { name = "transition", prefix = { "transition-", "duration-", "ease-", "delay-" }, exact = { "transition" } },
  { name = "animate", prefix = { "animate-" } },

  -- Interactivity
  { name = "cursor", prefix = { "cursor-" } },
  { name = "pointer-events", prefix = { "pointer-events-" } },
  { name = "select", prefix = { "select-" } },
  { name = "resize", prefix = { "resize-" }, exact = { "resize" } },
  { name = "snap", prefix = { "snap-" } },
  { name = "touch", prefix = { "touch-" } },
  { name = "appearance", prefix = { "appearance-" } },
  { name = "will-change", prefix = { "will-change-" } },
  { name = "scroll", prefix = { "scroll-", "scrollbar-" } },
}
