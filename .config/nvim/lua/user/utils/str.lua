return {
  --- Strip raw terminal output of term codes
  --- @param str string
  from_term = function(str)
    return str:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "")
  end,
}
