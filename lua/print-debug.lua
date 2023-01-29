local M = {}

local c = {
  repeat_count = 20,
  placeholder = '@',
}
local templates = {
  javascript = [[console.log(`+++ @`);]],
  typescript = [[console.log(`+++ @`);]],
  javascriptreact = [[console.log(`+++ @`);]],
  typescriptreact = [[console.log(`+++ @`);]],
  go = [[fmt.Printf("+++ @\n")]],
  python = [[print(f"+++ @")]],
  sh = [[echo "+++ @"]],
  fish = [[echo "+++ @"]],
  c = [[printf("+++ @\n");]],
  lua = [[print '+++ @']],
  vim = [[echo '+++ @']],
}
c.templates = templates

function M.config(user_config)
  user_config = user_config or {}
  if user_config.placeholder then
    for ft, tpl in pairs(c.templates) do
      c.templates[ft] = tpl:gsub('@', user_config.placeholder)
    end
  end
  c = vim.tbl_deep_extend('force', c, user_config)
  vim.pretty_print(c)
end

M.current = {}
local function err(msg)
  vim.api.nvim_echo({ { '[print-debug.nvim] ' .. msg, 'ErrorMsg' } }, true, {})
end
local function err_no_templates()
  local ft = vim.bo.ft
  err("'" .. ft .. "'" .. ' does not exist on the templates.')
end

local A = 65
local Z = 90
local a = 97
local z = 122

---Add a print-debug code to the next line.
function M.add()
  local ft = vim.bo.ft
  M.current[ft] = M.current[ft] and M.current[ft] + 1 or A
  if M.current[ft] > Z then M.current[ft] = a end
  if M.current[ft] > z then M.current[ft] = A end

  local chars = string.rep(string.char(M.current[ft]), c.repeat_count)
  local template = c.templates[ft]
  if not template then
    err_no_templates()
    return
  end
  local code = template:gsub(c.placeholder, chars)

  local row_num = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row_num, row_num, true, { code })
  vim.cmd [[normal! j]]
end

---Search print debug strings using vim regex.
---@param vim_regex string
---@return number|nil
local function search(vim_regex)
  local lnum = vim.fn.search(vim_regex, 'cnw')
  if lnum == 0 then return nil end
  return lnum - 1
end

---Delete all print-debug codes.
function M.delete()
  local ft = vim.bo.ft
  local template = c.templates[ft]
  if not template then
    err_no_templates()
    return
  end
  local vim_regex = template:gsub('{}', [[\a\{]] .. c.repeat_count .. [[\}]])
  vim_regex = [[^\s*]] .. vim_regex .. [[\s*$]]
  local row_num = search(vim_regex)
  while row_num do
    vim.api.nvim_buf_set_lines(0, row_num, row_num + 1, true, {})
    row_num = search(vim_regex)
  end
end

return M
