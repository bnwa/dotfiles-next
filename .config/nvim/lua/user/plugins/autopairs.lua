return {
  'windwp/nvim-autopairs',
  opts = {
    check_ts = true,
    -- Don't autoclose when an unopened close pair is subsequent
    enable_check_bracket_line = false,
    -- Only pair when subsequent character is white space
    ignored_next_char =  [=[[%w%%%'%[%"%.%`%$%/]]=],
    ts_config = {
      lua = {
        'string',
      },
      java = {
        'string',
      },
      javascript = {
        'string',
        'regex'
      },
      typescript = {
        'string',
        'regex'
      },
    }
  },
}
