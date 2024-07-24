local M = {}

function M.create()
    ---@class ortho_control.null_zoomer : ortho_control.camera_zoomer
    local null_zoomer = {}
    function null_zoomer.handle_zoom() end

    function null_zoomer.handle_movement() end

    function null_zoomer.on_update() end

    return null_zoomer
end

return M
