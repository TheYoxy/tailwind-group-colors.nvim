; tailwind-group-colors: JavaScript / JSX. See queries/tsx/highlights.scm.

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
