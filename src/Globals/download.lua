return function(asset, t, filepath)
    local getasset = assert(getcustomasset, "* getcustomasset doesn't exist")
    local completed = false
    local thread

    if not t then
        thread = nil
        return
    end

    thread = task.spawn(function()
        local ok, result = pcall(function()
            print("[*] Downloading asset: " .. tostring(asset))
            return getasset(asset)
        end)

        if not ok then
            print("@ Error: " .. tostring(result) .. " | Request: " .. tostring(ok))
            completed = true
            return "Blank"
        end

        if result then
            print("[*] Writing to file at: " .. tostring(filepath))
            writefile(filepath .. ".png", result)
            completed = true
        end
    end)

    return thread, function() return completed end
end
