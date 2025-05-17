local camera = require "orthographic.camera"
local ortho_control = require "ortho_control.ortho_control"
local utility = require "ortho_control.utilities"
local utilities = require "ortho_control.utilities"

local M = {}

---@param self ortho_control.desktop_zoomer
---@param zoom number
local function change_zoom(self, zoom)
    zoom = utility.clamp(zoom, self.min_zoom, self.max_zoom)
    camera.set_zoom(self.camera_id, zoom)
    ortho_control.set_camera_zoom(zoom)
end



---@param camera_id url|hash
---@param min_zoom float
---@param max_zoom float
---@param zoom_delta float
---@param action_table ortho_control.action_table
---@param constraints ortho_control.constraints
---@return ortho_control.desktop_zoomer
function M.create(camera_id, min_zoom, max_zoom, zoom_delta, action_table, constraints)
    ---@class ortho_control.desktop_zoomer : ortho_control.camera_zoomer
    ---@field camera_id url|hash
    ---@field min_zoom float
    ---@field max_zoom float
    ---@field zoom_delta float
    ---@field width_factor float
    ---@field height_factor float
    ---@field pressed_pos vector3
    ---@field camera_pos vector3
    ---@field is_drag boolean
    ---@field subs number
    ---@field action_table ortho_control.action_table
    local zoomer = {
        camera_id = camera_id,
        min_zoom = min_zoom,
        max_zoom = max_zoom,
        zoom_delta = zoom_delta,
        width_factor = ortho_control.width_factor,
        height_factor = ortho_control.height_factor,
        action_table = action_table,
        constraints = constraints,
    }

    ortho_control.subscribe_on_screen_size_changed(msg.url())

    ---@param self ortho_control.desktop_zoomer
    function zoomer:on_message(message_id, message, sender)
        if message_id == ortho_control.EVENT_SCREEN_SIZE_CHANGED then
            self.width_factor = ortho_control.width_factor
            self.height_factor = ortho_control.height_factor
        elseif message_id == ortho_control.SET_MOVEMENT_CONSTRAINTS then
            utilities.assert_valid_constraints(message.constraints)
            self.constraints = message.constraints
        end
    end

    ---@param self ortho_control.desktop_zoomer
    function zoomer.final(self)
        ortho_control.unsubscribe_on_screen_size_changed(msg.url())
        self.subs = nil
    end

    ---@param self ortho_control.desktop_zoomer
    function zoomer:on_input(action_id, action)
        local action_pos = vmath.vector3(action.x, action.y, 0)
        local action_world_pos = camera.screen_to_world(self.camera_id, action_pos)
        local camera_pos = go.get_position(self.camera_id)
        local zoom = camera.get_zoom(self.camera_id)

        if action_id == self.action_table.touch then
            if action.pressed then
                self.pressed_pos = vmath.vector3(action.x, action.y, 0)
                self.camera_pos = go.get_position(self.camera_id)
                self.is_drag = true
            elseif action.released then
                self.is_drag = false
            else
                if self.is_drag then
                    local drag_vector = vmath.vector3(action.x, action.y, 0) - self.pressed_pos

                    local drag_x = drag_vector.x * self.width_factor
                    local drag_y = drag_vector.y * self.height_factor
                    local drag_z = drag_vector.z
                    drag_vector = vmath.vector3(drag_x, drag_y, drag_z) / zoom

                    local target_position = (-drag_vector + self.camera_pos)
                    go.set_position(target_position, self.camera_id)
                end
            end
        else
            if action_id == self.action_table.mouse_wheel_up then
                zoom = zoom + zoom * self.zoom_delta
                change_zoom(self, zoom)
            elseif action_id == self.action_table.mouse_wheel_down then
                zoom = zoom - zoom * self.zoom_delta
                change_zoom(self, zoom)
            end

            local new_action_pos = camera.world_to_screen(camera_id, action_world_pos)
            local diff = new_action_pos - action_pos
            diff = diff / zoom
            camera_pos = camera_pos + diff
            go.set_position(camera_pos, camera_id)
        end
        if self.constraints then
            utilities.restict_camera_position(camera_id, self.constraints.botton_left, self.constraints.top_right)
        end
    end

    function zoomer:on_update(dt) end

    ---@param action_table ortho_control.action_table
    function zoomer:set_action_table(action_table)
        self.action_table = action_table
    end

    return zoomer
end

return M
