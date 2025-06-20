local M = {}

--- Destructure table into tuple consisting of 
--- specified key values in order, then all extant
--- unspecified keys in a separate table in the final
--- return value
---@generic K, V
---@param tbl table<K, V> @ The input table from which values will be extracted.
---@param keys K[] @ The list of keys to extract from the input table.
---@return ...V, table<K, V> @ Returns multiple values corresponding to the specified keys and a table containing all unspecified keys.
function M.destruct(tbl, keys)
    local values = {}
    local remaining = {}
    local keys_set = {}

    -- Add specified keys to keys_set for tracking
    for _, key in ipairs(keys) do
        keys_set[key] = true
    end

    -- Extract specified values
    for _, key in ipairs(keys) do
        table.insert(values, tbl[key])
    end

    -- Collect unspecified keys into remaining
    for key, value in pairs(tbl) do
        if not keys_set[key] then
            remaining[key] = value
        end
    end

    -- Return specified values and remaining table
    return unpack(values), remaining
end

return M
