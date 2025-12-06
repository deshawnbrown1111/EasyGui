return function(path)
    path = path:gsub("%.lua$", "")
    local creator = "deshawnbrown1111"
    local rName = "EasyGui"

    local cache = getgenv().__import_cache or {}
    getgenv().__import_cache = cache

    local function import(p)
        p = p:gsub("%.lua$", "")
        if cache[p] then
            return cache[p]
        end

        local base = "https://raw.githubusercontent.com/" .. creator .. "/" .. rName .. "/main/"
        local url = base .. "Modules/" .. p .. ".lua"
        local source = game:HttpGet(url)

        if not source or source == "" then
            url = base .. "Globals/" .. p .. ".lua"
            source = game:HttpGet(url)
        end

        local module = loadstring(source, p)()
        cache[p] = module
        return module
    end

    getgenv().import = import
    return import(path)
end
