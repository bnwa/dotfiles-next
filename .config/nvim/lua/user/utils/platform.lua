local arch = {
    arm64 = jit.arch == 'arm64',
    x86 = jit.arch == 'x86',
    x64 = jit.arch == 'x64',
}

local os = {
    mac = vim.fn.has 'mac' == 1,
    win = vim.fn.has 'win64' == 1,
    linux = vim.fn.has 'linux' == 1,
    unix = vim.fn.has 'unix' == 1,
}

---Strip terminal escapes from raw stdout string
---@param str string
---@return string
local function from_term(str)
    return str:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "")
end
---Escape string meant for terminal input
---@param str string
---@return string
local function to_term(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
--- Execute platform command line synchronously
--- @param cmd string[]
--- @return boolean
--- @return string
local function exec(cmd)
    local done = vim.system(cmd):wait()
    local success = done.code == 0
    local stderr = done.stderr
    local stdout = done.stdout
    if not success then
        if stderr == nil then
            return false, ""
        else
            local err_msg, _ = from_term(stderr)
            return false, err_msg
        end
    end
    if stdout == nil then return true, "" end
    local output, _ = from_term(stdout)
    return true, output
end
---Determine if supported platform UI is currently rendered in dark mode
---@return boolean ok whether IO completed succesfully or not
---@return boolean|string result when ok, boolean; err string otherwise
local function is_dark_mode()
    if not os.mac then return false,"OS must be Darwin" end
    local ok, mode = exec { 'defaults', 'read', '-g', 'AppleInterfaceStyle' }
    if not ok then
        return false,mode
    elseif vim.trim(mode) == 'Dark' then
        return true,true
    else
        return true,false
    end
end

return {
    arch = arch,
    os = os,
    is_dark_mode = is_dark_mode,
    exec = exec,
}
