; extends
;
; The `; extends` modeline is required: Neovim's query loader keeps only the
; first non-extending file per language and silently drops the rest. Without it
; this file loses to nvim-treesitter's own queries/astro/highlights.scm.
;
; tailwind-group-colors: Astro markup. See queries/tsx/highlights.scm.
;
; class="px-1 py-2"
;
; `class={cn('px-1')}` and frontmatter need no pattern here: the astro parser
; injects TypeScript for both, so the typescript query handles them.
(attribute
  (attribute_name) @_twgc_ctx
  (quoted_attribute_value (attribute_value) @tailwind.classes)
  (#tailwind-group-colors! @tailwind.classes @_twgc_ctx))
