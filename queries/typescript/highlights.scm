; extends
;
; tailwind-group-colors: plain TypeScript has no JSX nodes, so only the
; class-function form applies here. See queries/tsx/highlights.scm for JSX.
;
;   cn('px-1 py-2'), clsx('...'), cva('...'), classNames('...'), twMerge('...')

(call_expression
  function: (identifier) @_twgc_ctx
  arguments: (arguments (string (string_fragment) @tailwind.classes))
  (#tailwind-group-colors! @tailwind.classes @_twgc_ctx))
