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

        local url = "https://raw.githubusercontent.com/" .. creator .. "/" .. rName .. "/main/Modules/" .. p .. ".lua"
        local source = game:HttpGet(url)
        local module = loadstring(source, p)()
        cache[p] = module
        return module
    end

    getgenv().import = import
    return import(path)
end
