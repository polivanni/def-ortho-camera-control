local M = {}

M.screen_height = nil
M.screen_width = nil

M.width_factor = nil
M.height_factor = nil

M.EVENT_SCREEN_SIZE_CHANGED = hash("screen_size_changed_event")

function M.set_screen_aspects(w, h)
    M.screen_height = h
    M.screen_width = w

    M.width_factor = w / M.get_reference_width()
    M.height_factor = h / M.get_reference_height()

    M.on_screen_size_changed()
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

function M.get_reference_width()
    return sys.get_config_int("display.width")
end

function M.get_reference_height()
    return sys.get_config_int("display.height")
end

return M
