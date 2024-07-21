local M = {}

M.DANWIN = "Darwin"
M.LINUX = "Linux"
M.WINDOWS = "Windows"
M.HTML5 = "HTML5"
M.ANDROID = "Android"
M.IPHONE_OS = "iPhone OS"

---@private
M.SYSTEM_NAME = nil

function M.get_system_info()
    local system_info = sys.get_sys_info()
    return system_info
end

---@return string
function M.get_system_language()
    local system_info = M.get_system_info()
    local language = system_info.language
    return language
end

function M.get_system_name()
    if M.SYSTEM_NAME then
        return M.SYSTEM_NAME
    end

    local system_info = M.get_system_info()
    local system_name = system_info.system_name
    M.SYSTEM_NAME = system_name
    return system_name
end

--#region PLATFORMS

function M.is_danwin()
    return M.get_system_name() == M.DANWIN
end

function M.is_linux()
    return M.get_system_name() == M.LINUX
end

function M.is_windows()
    return M.get_system_name() == M.WINDOWS
end

function M.is_html5()
    return M.get_system_name() == M.HTML5
end

function M.is_android()
    return M.get_system_name() == M.ANDROID
end

function M.is_ios()
    return M.get_system_name() == M.IPHONE_OS
end

--#endregion


return M
