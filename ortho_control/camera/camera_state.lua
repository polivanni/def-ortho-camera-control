local M = {}

M.EVENT_CAMERA_ZOOM_CHANGED = hash("camera_zoom_changed")

M.camera_zoom = 1

function M.set_camera_zoom(value)
    local prev_value = M.camera_zoom
    M.camera_zoom = value

    if prev_value ~= value then
        M.on_camera_zoom_changed()
    end
end

function M.on_camera_zoom_changed()
    M.subs = M.subs or {}
    for url, _ in pairs(M.subs) do
        msg.post(url, M.EVENT_CAMERA_ZOOM_CHANGED, { zoom = M.camera_zoom })
    end
end

function M.subscribe_on_zoom_changed(url)
    M.subs = M.subs or {}
    M.subs[url] = true
end

function M.unsubscribe_on_zoom_changed(url)
    M.subs = M.subs or {}
    M.sub[url] = nil
end

return M
