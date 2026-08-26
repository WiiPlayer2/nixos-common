local wezterm = require "wezterm"
local module = {}

local function distrobox_list()
    local has_distrobox = wezterm.run_child_process { "which", "distrobox" }
    if not has_distrobox then
        return {}
    end

    local success, stdout, stderr = wezterm.run_child_process { "distrobox", "ls" }
    if not success then
        return {}
    end

    local names = {}
    for _, line in ipairs(wezterm.split_by_newlines(stdout)) do
        local endOfName = string.find(line, " ", 16)
        if endOfName then
            local name = string.sub(line, 16, endOfName - 1)
            if name ~= "NAME" then
                table.insert(names, name)
            end
        end
    end

    return names
end

local function create_distrobox_domain(name)
    function fixup(cmd)
        local wrapped = {
            'distrobox',
            'enter',
            name,
        }

        if cmd.args then
            table.insert(wrapped, "--")
            for _, arg in ipairs(cmd.args) do
                table.insert(wrapped, arg)
            end
        end

        cmd.args = wrapped

        return cmd
    end

    return wezterm.exec_domain(
        "distrobox:" .. name,
        fixup
    )
end

function module.add_distrobox_domains(domains)
    for _, name in pairs(distrobox_list()) do
        table.insert(
            domains,
            create_distrobox_domain(name)
        )
    end
end

function module.get_distrobox_name(domain)
    local result = string.match(domain, "distrobox:(%w+)")
    if result then
        return result
    else
        return nil
    end
end

return module
