; extends
;
; The `; extends` modeline is required: Neovim's query loader keeps only the
; first non-extending file per language and silently drops the rest. Without it
; this file loses to nvim-treesitter's own queries/tsx/highlights.scm.
;
; tailwind-group-colors: colour Tailwind classes by utility family.
;
; This file only declares *where* class lists live. Each captured string is
; handed to the `#tailwind-group-colors!` directive (lua/tailwind-group-colors),
; which splits it, classifies every utility and paints it with an ephemeral
; extmark. No new grammar is involved.
;
;   @tailwind.classes -> the class list text
;   @_twgc_ctx       -> the attribute / function name that owns the list
;
; The Lua side checks `_twgc_ctx` against the configured attributes and
; functions, so `data-slot='...'` is ignored while `className=...` and
; `cn(...)` are not.

; className="px-1 py-2"
(jsx_attribute
  (property_identifier) @_twgc_ctx
  (string (string_fragment) @tailwind.classes)
  (#tailwind-group-colors! @tailwind.classes @_twgc_ctx))

; className={'px-1 py-2'}
(jsx_attribute
  (property_identifier) @_twgc_ctx
  (jsx_expression (string (string_fragment) @tailwind.classes))
  (#tailwind-group-colors! @tailwind.classes @_twgc_ctx))

; cn('px-1 py-2'), clsx('...'), cva('...'), classNames('...'), twMerge('...')
(call_expression
  function: (identifier) @_twgc_ctx
  arguments: (arguments (string (string_fragment) @tailwind.classes))
  (#tailwind-group-colors! @tailwind.classes @_twgc_ctx))
