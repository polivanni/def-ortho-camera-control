local utilities = require "ortho_control.utilities"
local M = {}

M.screen_height = nil
M.screen_width = nil

M.width_factor = nil
M.height_factor = nil

M.EVENT_CAMERA_ZOOM_CHANGED = hash "camera_zoom_changed"
M.EVENT_SCREEN_SIZE_CHANGED = hash "screen_size_changed_event"
M.SET_MOVEMENT_CONSTRAINTS = hash "set_movement_constraints"

M.camera_zoom = 1

---@type table<hash, table<url, _>>
M.subs = {
    [M.EVENT_CAMERA_ZOOM_CHANGED] = {},
    [M.EVENT_SCREEN_SIZE_CHANGED] = {},
}

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

    local ref_w = M.get_reference_width()
    local ref_h = M.get_reference_height()
    M.width_factor = w / ref_w
    M.height_factor = h / ref_h

    M.on_screen_size_changed()
end

function M.get_reference_width()
    return sys.get_config_int("display.width")
end

function M.get_reference_height()
    return sys.get_config_int("display.height")
end

function M.on_camera_zoom_changed()
    for url, _ in pairs(M.subs[M.EVENT_CAMERA_ZOOM_CHANGED]) do
        msg.post(url, M.EVENT_CAMERA_ZOOM_CHANGED, { zoom = M.camera_zoom })
    end
end

function M.subscribe_on_zoom_changed(url)
    url = url or msg.url()
    M.subs[M.EVENT_CAMERA_ZOOM_CHANGED][url] = true
end

function M.unsubscribe_on_zoom_changed(url)
    url = url or msg.url()
    M.subs[M.EVENT_CAMERA_ZOOM_CHANGED][url] = nil
end

function M.on_screen_size_changed()
    for url, _ in pairs(M.subs[M.EVENT_SCREEN_SIZE_CHANGED]) do
        msg.post(url, M.EVENT_SCREEN_SIZE_CHANGED)
    end
end

function M.subscribe_on_screen_size_changed(url)
    url = url or msg.url()
    local h = utilities.url_to_hash(url)
    M.subs[M.EVENT_SCREEN_SIZE_CHANGED][h] = true
end

function M.unsubscribe_on_screen_size_changed(url)
    url = url or msg.url()
    local h = utilities.url_to_hash(url)
    M.subs[M.EVENT_SCREEN_SIZE_CHANGED][h] = nil
end

return M
