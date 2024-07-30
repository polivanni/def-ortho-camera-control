local zoomer_utility = require "ortho_control.camera.zoomers.zoomer_utility"
local consts = require "ortho_control.constants"

local M = {}

---@param state_machine ortho_control.state_machine
---@param action_table ortho_control.action_table
---@return camera_zoomer_state_idle
function M.create(state_machine, action_table)
    ---@class camera_zoomer_state_idle : ortho_control.camera_zoomer_state
    ---@field state_machine ortho_control.state_machine
    ---@field state_to_change integer
    ---@field state_params any[]
    ---@field action_table ortho_control.action_table
    local state = {
        state_machine = state_machine,
        action_table = action_table,
    }

    function state.on_input(self, action_id, action)
        if action_id == self.action_table.touch and action.pressed then
            self.state_to_change = consts.ZOOMER_STATE.MOVE
            self.state_params = zoomer_utility.get_params_for_move(action)
        elseif action_id == self.action_table.touch_multi then
            if action.touch then
                if #action.touch == 1 then
                    self.state_to_change = consts.ZOOMER_STATE.MOVE
                    self.state_params = zoomer_utility.get_params_for_move(action)
                elseif #action.touch >= 2 then
                    self.state_to_change = consts.ZOOMER_STATE.ZOOM
                    self.state_params = zoomer_utility.get_params_for_zoom(action)
                end
            end
        end
    end

    function state.on_update(self)
        if self.state_to_change then
            zoomer_utility.change_state(self.state_machine, self.state_to_change, self.state_params)
            self.state_to_change = nil
            self.state_params = nil
        end
    end

    function state.enter(self) end

    function state.exit(self) end

    function state.final(self) end

    return state
end

return M
