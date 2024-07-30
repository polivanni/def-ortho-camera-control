local M = {}

M.screen_height = nil
M.screen_width = nil

M.width_factor = nil
M.height_factor = nil

M.EVENT_CAMERA_ZOOM_CHANGED = hash("camera_zoom_changed")
M.EVENT_SCREEN_SIZE_CHANGED = hash("screen_size_changed_event")

M.camera_zoom = 1

function M.set_camera_zoom(value)
    local prev_value = M.camera_zoom
    M.camera_zoom = value

    if prev_value ~= value then
        M.on_camera_zoom_changed()
    end
end

function M.set_screen_aspects(w, h)
    M.screen_height = h
    M.screen_width = w

    M.width_factor = w / M.get_reference_width()
    M.height_factor = h / M.get_reference_height()

    M.on_screen_size_changed()
end

function M.get_reference_width()
    return sys.get_config_int("display.width")
end

function M.get_reference_height()
    return sys.get_config_int("display.height")
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

function M.on_screen_size_changed()
    M.subs = M.subs or {}
    for url, _ in pairs(M.subs) do
        msg.post(url, M.EVENT_SCREEN_SIZE_CHANGED)
    end
end

function M.subscribe_on_screen_size_changed(url)
    M.subs = M.subs or {}
    M.subs[url] = true
end

function M.unsubscribe_on_screen_size_changed(url)
    M.subs = M.subs or {}
    M.subs[url] = nil
end

return M
