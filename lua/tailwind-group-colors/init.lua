--- tailwind-group-colors
---
--- Colour Tailwind CSS classes by utility family, driven entirely by
--- Tree-sitter queries. A `queries/<lang>/highlights.scm` pattern captures the
--- string fragment that holds a class list and attaches the custom
--- `#tailwind-group-colors!` directive. That directive is executed by Neovim's
--- Tree-sitter highlighter for every visible match, so it can paint each utility
--- with an `ephemeral` extmark and keep no state of its own.
---
--- No new grammar is involved: the stock `tsx` / `typescript` / `javascript`
--- parsers produce the `call_expression` / `jsx_attribute` / `string_fragment`
--- nodes used here.
---
--- Usage:
---   require("tailwind-group-colors").setup({ ... })

local api = vim.api
local ts = vim.treesitter

local defaults = require("tailwind-group-colors.config")
local conf = vim.deepcopy(defaults)

local M = {}

M.ns = api.nvim_create_namespace("TailwindGroupColors")

--- token -> twgc.Kind, for exact class names.
local exact = {}
--- { prefix = string, kind = twgc.Kind }[] sorted longest-first.
local prefixes = {}

--- Build the lookup tables and make sure every kind has a highlight group.
local function build_index()
  exact, prefixes = {}, {}

  for i, kind in ipairs(conf.kinds) do
    kind.hl = kind.hl or ("@tailwind." .. kind.name)
    if not conf.highlights[kind.hl] then
      conf.highlights[kind.hl] = { link = conf.palette[((i - 1) % #conf.palette) + 1] }
    end

    for _, token in ipairs(kind.exact or {}) do
      exact[token] = kind
    end
    for _, prefix in ipairs(kind.prefix or {}) do
      prefixes[#prefixes + 1] = { prefix = prefix, kind = kind }
    end
  end

  table.sort(prefixes, function(a, b)
    return #a.prefix > #b.prefix
  end)
end

--- (Re)create the highlight groups for the configured kinds.
local function apply_highlights()
  for name, opts in pairs(conf.highlights) do
    api.nvim_set_hl(0, name, vim.tbl_extend("force", { default = true }, opts))
  end
end

--- Is `ctx` (an attribute or function name) allowed to own a class list?
--- @param ctx string?
local function is_class_context(ctx)
  return ctx ~= nil and (conf.functions[ctx] == true or conf.attributes[ctx] == true)
end

--- Classify a single class token. Negative utilities (`-m-2`) are matched
--- without their leading dash. Variants are stripped by the caller, so only the
--- utility itself (`px-1` in `disabled:px-1`) reaches this function.
--- @param token string
--- @return twgc.Kind?
local function classify(token)
  if conf.classify then
    return conf.classify(token, nil)
  end

  local kind = exact[token]
  if kind then
    return kind
  end

  local bare = token:sub(1, 1) == "-" and token:sub(2) or token
  for _, entry in ipairs(prefixes) do
    if bare:sub(1, #entry.prefix) == entry.prefix then
      return entry.kind
    end
  end
end

--- Offset (1-based) of the utility inside a class token, skipping any variant
--- prefixes. `disabled:px-1` -> 10 (`px-1`), `md:hover:m-2` -> 10 (`m-2`),
--- `[&_p]:leading-relaxed` -> after the `]`. Colons inside `[]` or `()` are
--- ignored.
--- @param token string
--- @return integer
local function variant_offset(token)
  local depth, last = 0, 0
  for i = 1, #token do
    local c = token:sub(i, i)
    if c == "[" or c == "(" then
      depth = depth + 1
    elseif c == "]" or c == ")" then
      depth = math.max(depth - 1, 0)
    elseif c == ":" and depth == 0 then
      last = i
    end
  end
  return last + 1
end

--- Translate a 1-based byte index in `text` into a buffer position. `text` starts
--- at `(sr, sc)`, which lets multi-line template literals work too.
--- @return integer row, integer col
local function byte_to_pos(text, idx, sr, sc)
  local before = text:sub(1, idx - 1)
  local newlines = select(2, before:gsub("\n", ""))
  if newlines == 0 then
    return sr, sc + (idx - 1)
  end
  local last_newline = before:match(".*()\n")
  return sr + newlines, idx - last_newline - 1
end

--- Paint every class of `node` that matches a configured kind.
--- @param bufnr integer
--- @param node TSNode
local function paint(bufnr, node)
  local text = ts.get_node_text(node, bufnr)
  local sr, sc = node:range()
  local init = 1

  while true do
    local s, e = text:find("%S+", init)
    if not s then
      break
    end

    local token = text:sub(s, e)
    local base = variant_offset(token)
    local kind = classify(token:sub(base))
    if kind then
      -- Paint only the utility, leaving the variant prefix (`disabled:`, `md:`,
      -- `[&_p]:`, ...) untouched.
      local r1, c1 = byte_to_pos(text, s + base - 1, sr, sc)
      local r2, c2 = byte_to_pos(text, e + 1, sr, sc)
      -- `ephemeral` marks are only valid inside a decoration provider. The
      -- Tree-sitter highlighter runs this directive from one, but other
      -- consumers of the highlights query (e.g. `:InspectTree`) do not, so
      -- skip painting there instead of erroring.
      pcall(api.nvim_buf_set_extmark, bufnr, M.ns, r1, c1, {
        end_row = r2,
        end_col = c2,
        hl_group = kind.hl,
        priority = conf.priority,
        ephemeral = true, -- recreated by the highlighter on every redraw
      })
    end

    init = e + 1
  end
end

--- `#tailwind-group-colors! @tailwind.classes @_twgc_ctx`
--- @param match table<integer, TSNode[]>
--- @param _ integer
--- @param bufnr integer
--- @param predicate (string|integer)[]
local function handler(match, _, bufnr, predicate)
  if not conf.enabled then
    return
  end

  local content = match[predicate[2]]
  if not content then
    return
  end

  local ctx_nodes = predicate[3] and match[predicate[3]]
  local ctx = ctx_nodes and ctx_nodes[1] and ts.get_node_text(ctx_nodes[1], bufnr) or nil
  if not is_class_context(ctx) then
    return
  end

  for _, node in ipairs(content) do
    paint(bufnr, node)
  end
end

--- The active configuration.
--- @return twgc.Config
function M.config()
  return conf
end

--- Add a kind at runtime. @param kind twgc.Kind
function M.register_kind(kind)
  table.insert(conf.kinds, kind)
  build_index()
  apply_highlights()
end

--- Treat `name` as a class-list producing function. @param name string
function M.register_function(name)
  conf.functions[name] = true
end

--- Treat `name` as a class-list carrying JSX attribute. @param name string
function M.register_attribute(name)
  conf.attributes[name] = true
end

--- @param opts? twgc.Config
function M.setup(opts)
  conf = vim.tbl_deep_extend("force", conf, opts or {})

  build_index()

  vim.treesitter.query.add_directive("tailwind-group-colors!", handler, { force = true })
  apply_highlights()

  api.nvim_create_autocmd("ColorScheme", {
    group = api.nvim_create_augroup("TailwindGroupColors", { clear = true }),
    callback = apply_highlights,
  })

  return M
end

return M
