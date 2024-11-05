return {
  --- Strip raw terminal output of term codes
  --- @param str string
  --- @return string
  from_term = function(str)
    local update, _ = str:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "")
    return update
  end,
  --- Escape Lua string as raw terminal input
  --- @param str string
  --- @return string
  to_term = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end,
}
