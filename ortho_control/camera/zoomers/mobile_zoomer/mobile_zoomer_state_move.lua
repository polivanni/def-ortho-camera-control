local camera = require "orthographic.camera"
local consts = require "ortho_control.consts"
local zoomer_utility = require "ortho_control.camera.zoomers.zoomer_utility"
local render_state = require "ortho_control.render_state"

local M = {}

local IDLE_FRAME_COUNT = 5

---@param state_machine ortho_control.state_machine
---@param action_table ortho_control.action_table
---@param camera_id url|string|hash
---@return camera_zoomer_state_move
function M.create(state_machine, action_table, camera_id)
    ---@class camera_zoomer_state_move : ortho_control.camera_zoomer_state
    ---@field width_factor number
    ---@field height_factor number
    ---@field state_machine ortho_control.state_machine
    ---@field camera_id url|string|hash
    ---@field pressed_pos vector3
    ---@field camera_pos vector3
    ---@field idle_frames integer
    ---@field state_to_change integer
    ---@field state_params any[]
    ---@field new_pos vector3
    ---@field subs number
    ---@field action_table ortho_control.action_table
    local state = {
        state_machine = state_machine,
        camera_id = camera_id,
        width_factor = 1,
        height_factor = 1,
        action_table = action_table,
    }

    render_state.subscribe_on_screen_size_changed(msg.url())


    function state:on_message(message_id, message, sender)
        if message_id == render_state.EVENT_SCREEN_SIZE_CHANGED then
            state.width_factor = render_state.width_factor
            state.height_factor = render_state.height_factor
        end
    end

    function state:final()
        render_state.unsubscribe_on_screen_size_changed(msg.url())
        self.subs = nil
    end

    function state:enter(action_x, action_y)
        self.width_factor = render_state.width_factor
        self.height_factor = render_state.height_factor

        self.pressed_pos = vmath.vector3(action_x, action_y, 0)
        self.camera_pos = go.get_position(self.camera_id)
        self.idle_frames = 0
    end

    function state.exit(self)
        self.pressed_pos = nil
        self.camera_pos = nil
        self.idle_frames = 0
    end

    function state:on_input(action_id, action)
        -- TODO: does not work for pc
        if action_id == self.action_table.touch_multi then
            if action.released then
                self.state_to_change = consts.ZOOMER_STATE.IDLE
            elseif #action.touch > 1 then
                self.state_to_change = consts.ZOOMER_STATE.ZOOM
                self.state_params = zoomer_utility.get_params_for_zoom(action)
            else
                local drag_vector = vmath.vector3(action.x, action.y, 0) - self.pressed_pos

                local zoom = camera.get_zoom(self.camera_id)

                local drag_x = drag_vector.x * self.width_factor
                local drag_y = drag_vector.y * self.height_factor
                local drag_z = drag_vector.z
                drag_vector = vmath.vector3(drag_x, drag_y, drag_z) / zoom

                local target_position = (-drag_vector + self.camera_pos)
                self.new_pos = target_position
            end

            self.idle_frames = 0
        end
    end

    function state:on_update(dt)
        if self.state_to_change then
            zoomer_utility.change_state(self.state_machine, self.state_to_change, self.state_params)
            self.state_params = nil
            self.state_to_change = nil
        elseif self.new_pos then
            go.set_position(self.new_pos, self.camera_id)
            self.new_pos = nil
        end

        if self.idle_frames >= IDLE_FRAME_COUNT then
            self.state_to_change = consts.ZOOMER_STATE.IDLE
        end

        self.idle_frames = self.idle_frames + 1
    end

    return state
end

return M
