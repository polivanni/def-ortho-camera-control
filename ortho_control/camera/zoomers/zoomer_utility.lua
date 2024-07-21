local M = {}

function M.get_params_for_move(action)
    return {
        action.x,
        action.y,
    }
end

function M.get_params_for_zoom(action)
    assert(action.touch)
    assert(#action.touch > 1)
    return {
        action.touch[1].x,
        action.touch[1].y,
        action.touch[2].x,
        action.touch[2].y,
    }
end

function M.change_state(state_machine, state, array_params)
    if array_params then
        state_machine:change_state(state, unpack(array_params))
    else
        state_machine:change_state(state)
    end
end

return M
