local Service = setmetatable({}, {
    __index = function(self, Name: string)
        local _cloneref = cloneref or function(obj)
            return obj
        end

        local obj = game:GetService(Name)
        return _cloneref(obj)
    end,
})

return Service
