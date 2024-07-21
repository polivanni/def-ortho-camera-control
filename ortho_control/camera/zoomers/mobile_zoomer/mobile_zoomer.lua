local state_idle = require "ortho_control.camera.zoomers.mobile_zoomer.mobile_zoomer_state_idle"
local state_move = require "ortho_control.camera.zoomers.mobile_zoomer.mobile_zoomer_state_move"
local state_zoom = require "ortho_control.camera.zoomers.mobile_zoomer.mobile_zoomer_state_zoom"
local consts = require "ortho_control.consts"

local M = {}

---@param camera_id url|hash
---@param min_zoom float
---@param max_zoom float
---@param zoom_delta float
---@param action_table action_table
---@return mobile_zoomer
function M.create(camera_id, min_zoom, max_zoom, zoom_delta, action_table)
    ---@class mobile_zoomer : camera_zoomer, state_machine
    ---@field camera_id url|hash
    ---@field min_zoom float
    ---@field max_zoom float
    ---@field zoom_delta float
    ---@field width_factor float
    ---@field height_factor float
    ---@field current_state camera_zoomer_state|nil
    ---@field action_table action_table
    local zoomer = {
        camera_id = camera_id,
        min_zoom = min_zoom,
        max_zoom = max_zoom,
        zoom_delta = zoom_delta,
        current_state = nil,
        action_table = action_table,
    }

    zoomer.states = {
        [consts.ZOOMER_STATE.IDLE] = state_idle.create(zoomer, zoomer.action_table),
        [consts.ZOOMER_STATE.MOVE] = state_move.create(zoomer, zoomer.action_table, camera_id),
        [consts.ZOOMER_STATE.ZOOM] = state_zoom.create(zoomer, zoomer.action_table, camera_id, min_zoom, max_zoom, zoom_delta),
    }

    ---@param self mobile_zoomer
    ---@param state string|integer
    ---@param ... unknown
    function zoomer:change_state(state, ...)
        assert(self.states[state], string.format("failed to find state=%s in #states=%s", state, #self.states))
        if self.current_state then
            self.current_state:exit()
        end
        self.current_state = self.states[state]
        self.current_state:enter(...)
    end

    ---@param self mobile_zoomer
    function zoomer:on_input(action_id, action)
        self.current_state:on_input(action_id, action)
    end

    ---@param self mobile_zoomer
    function zoomer:on_update(dt)
        self.current_state:on_update(dt)
    end

    function zoomer:final()
        for state_id, state in pairs(self.states) do
            state:final()
        end
    end

    zoomer:change_state(consts.ZOOMER_STATE.IDLE)

    return zoomer
end

return M
