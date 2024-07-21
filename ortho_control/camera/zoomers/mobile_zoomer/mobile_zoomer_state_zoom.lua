local camera = require "orthographic.camera"
local utility = require "ortho_control.utility"
local zoomer_utility = require "ortho_control.camera.zoomers.zoomer_utility"
local camera_state = require "ortho_control.camera.camera_state"
local consts = require "ortho_control.consts"

local SCREEN_ZOOM_FACTOR = 0.000002

local M = {}

---@param state_machine state_machine
---@param action_table action_table
---@param camera_id url|string|hash
---@param min_zoom number
---@param max_zoom number
---@param zoom_delta number
---@return camera_zoomer_state_zoom
function M.create(state_machine, action_table, camera_id, min_zoom, max_zoom, zoom_delta)
    ---@class camera_zoomer_state_zoom : camera_zoomer_state
    ---@field state_machine state_machine
    ---@field camera_id url|string|hash
    ---@field state_to_change integer
    ---@field state_params any[]
    ---@field touch_distance float
    local state = {
        state_machine = state_machine,
        zoom_delta = zoom_delta,
        min_zoom = min_zoom,
        max_zoom = max_zoom,
        camera_id = camera_id,
        action_table = action_table,
    }

    function state:enter(x1, y1, x2, y2)
        self.touch_distance = utility.distancesq(x1, y1, x2, y2)
    end

    function state:exit()
        self.touch_distance = nil
    end

    ---@param self camera_zoomer_state_zoom
    function state:on_input(action_id, action)
        if action and action.touch then
            local count_actions = #action.touch
            if count_actions == 0 then
                self.state_to_change = consts.ZOOMER_STATE.IDLE
            elseif count_actions == 1 then
                self.state_to_change = consts.ZOOMER_STATE.MOVE
                self.state_params = zoomer_utility.get_params_for_move(action)
            else
                local touch_1 = action.touch[1]
                local touch_2 = action.touch[2]
                local touch_distance = utility.distancesq(touch_1.x, touch_1.y, touch_2.x, touch_2.y)

                local touch_diff = (touch_distance - self.touch_distance) * SCREEN_ZOOM_FACTOR

                local zoom = camera.get_zoom(self.camera_id)
                local new_zoom = zoom + touch_diff * (self.zoom_delta + zoom)

                -- for some reason zoom changes to negative
                if new_zoom > 0 then
                    self:change_zoom(new_zoom)
                end

                self.touch_distance = touch_distance
            end
        end
    end

    function state:on_update(dt)
        if self.state_to_change then
            zoomer_utility.change_state(self.state_machine, self.state_to_change, self.state_params)
            self.state_to_change = nil
            self.state_params = nil
        end
    end

    ---@param self camera_zoomer_state_zoom
    ---@param zoom float
    function state:change_zoom(zoom)
        zoom = utility.clamp(zoom, self.min_zoom, self.max_zoom)
        camera.set_zoom(self.camera_id, zoom)
        camera_state.set_camera_zoom(zoom)
    end

    function state:final() end

    return state
end

return M
