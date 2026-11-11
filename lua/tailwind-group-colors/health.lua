--- `:checkhealth tailwind-group-colors`

local M = {}

local langs = { "tsx", "typescript", "javascript", "html", "astro" }

function M.check()
  local health = vim.health
  health.start("tailwind-group-colors")

  if vim.fn.has("nvim-0.10") == 1 then
    health.ok("Neovim >= 0.10")
  else
    health.error("Neovim >= 0.10 is required for vim.treesitter.query.add_directive()")
  end

  local available = {}
  for _, lang in ipairs(langs) do
    local ok = pcall(vim.treesitter.language.add, lang)
    if ok then
      available[#available + 1] = lang
      health.ok(("parser '%s' available"):format(lang))
    else
      health.warn(("parser '%s' missing"):format(lang), { "Install it with :TSInstall " .. lang })
    end
  end

  local loaded, mod = pcall(require, "tailwind-group-colors")
  if not loaded then
    health.error("module failed to load: " .. tostring(mod))
    return
  end

  -- Neovim keeps only one non-extending highlights file per language and drops
  -- the rest, so a missing `; extends` leaves the plugin silently inert. Only
  -- check languages whose parser is installed; the query cannot load without it.
  for _, lang in ipairs(available) do
    local ok, query = pcall(vim.treesitter.query.get, lang, "highlights")
    local found = false
    if ok and query then
      for _, capture in ipairs(query.captures) do
        if capture == "tailwind.classes" then
          found = true
          break
        end
      end
    end
    if found then
      health.ok(("queries/%s/highlights.scm is loaded"):format(lang))
    else
      health.error(
        ("queries/%s/highlights.scm is not part of the merged query"):format(lang),
        { "Another query file for this language won the merge; ours must start with '; extends'" }
      )
    end
  end

  local conf = mod.config()
  health.info(("kinds: %d"):format(#conf.kinds))
  health.info(("class functions: %s"):format(table.concat(vim.tbl_keys(conf.functions), ", ")))
  health.info(("class attributes: %s"):format(table.concat(vim.tbl_keys(conf.attributes), ", ")))
end

return M
