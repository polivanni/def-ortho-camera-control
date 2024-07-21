local M = {}

function M.clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end

function M.distancesq(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    local distance = dx ^ 2 + dy ^ 2
    return distance
end

return M
