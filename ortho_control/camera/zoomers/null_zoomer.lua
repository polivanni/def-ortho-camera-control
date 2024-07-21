local M = {}

function M.create()
    ---@class null_zoomer : camera_zoomer
    local null_zoomer = {}
    function null_zoomer.handle_zoom() end

    function null_zoomer.handle_movement() end

    function null_zoomer.on_update() end

    return null_zoomer
end

return M
