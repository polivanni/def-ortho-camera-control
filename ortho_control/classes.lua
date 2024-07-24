---@meta

---@class ortho_control.camera_zoomer
---@field on_input fun(self:ortho_control.camera_zoomer, action_id:string, action:table)
---@field on_update fun(self:ortho_control.camera_zoomer, dt:number)
---@field final fun(self:ortho_control.camera_zoomer)
---@field on_message fun(self:ortho_control.camera_zoomer, message_id:hash, message:table, sender:url)
---@field set_action_table fun(self:ortho_control.camera_zoomer, action_table:ortho_control.action_table)

---@class ortho_control.camera_zoomer_state
---@field enter fun(self:ortho_control.camera_zoomer_state, ...)
---@field exit fun(self:ortho_control.camera_zoomer_state)
---@field on_input fun(self:ortho_control.camera_zoomer_state, action_id:hash, action:table)
---@field on_update fun(self:ortho_control.camera_zoomer_state, dt:number)

---@class ortho_control.state_machine
---@field change_state fun(state:string|integer, params:...)
