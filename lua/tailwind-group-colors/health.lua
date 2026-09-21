--- `:checkhealth tailwind-group-colors`

local M = {}

function M.check()
  local health = vim.health
  health.start("tailwind-group-colors")

  if vim.fn.has("nvim-0.10") == 1 then
    health.ok("Neovim >= 0.10")
  else
    health.error("Neovim >= 0.10 is required for vim.treesitter.query.add_directive()")
  end

  for _, lang in ipairs({ "tsx", "typescript", "javascript" }) do
    local ok = pcall(vim.treesitter.language.add, lang)
    if ok then
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

  local conf = mod.config()
  health.info(("kinds: %d"):format(#conf.kinds))
  health.info(("class functions: %s"):format(table.concat(vim.tbl_keys(conf.functions), ", ")))
  health.info(("class attributes: %s"):format(table.concat(vim.tbl_keys(conf.attributes), ", ")))
end

return M
