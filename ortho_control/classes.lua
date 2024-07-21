---@meta

---@class camera_zoomer
---@field on_input fun(self:camera_zoomer, action_id:string, action:table)
---@field on_update fun(self:camera_zoomer, dt:number)
---@field final fun(self:camera_zoomer)
---@field on_message fun(self:camera_zoomer, message_id:hash, message:table, sender:url)
---@field set_action_table fun(self:camera_zoomer, action_table:action_table)

---@class camera_zoomer_state
---@field enter fun(self:camera_zoomer_state, ...)
---@field exit fun(self:camera_zoomer_state)
---@field on_input fun(self:camera_zoomer_state, action_id:hash, action:table)
---@field on_update fun(self:camera_zoomer_state, dt:number)

---@class state_machine
---@field change_state fun(state:string|integer, params:...)
