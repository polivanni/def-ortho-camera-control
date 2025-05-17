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

function M.restict_camera_position(camera_id, button_left, top_right)
    local restricted_camera_pos = vmath.vector3(0)
    local camera_pos = go.get_position(camera_id)
    if camera_pos.x < button_left.x then
        restricted_camera_pos.x = button_left.x
    end
    if camera_pos.y < button_left.y then
        restricted_camera_pos.y = button_left.y
    end
    if camera_pos.x > top_right.x then
        restricted_camera_pos.x = top_right.x
    end
    if camera_pos.y > top_right.y then
        restricted_camera_pos.y = top_right.y
    end
    go.set_position(restricted_camera_pos, camera_id)
end

function M.assert_valid_constraints(constraints)
    assert(type(constraints.button_left) == "userdata" and constraints.button_left.x ~= nil and constraints.button_left.y ~= nil)
    assert(type(constraints.top_right) == "userdata" and constraints.top_right.x ~= nil and constraints.top_right.y ~= nil)
    assert(constraints.top_right.x >= constraints.button_left.x and constraints.top_right.y >= constraints.button_left.y)
end

return M
