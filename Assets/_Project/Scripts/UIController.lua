--!Type(Module)


local function Singleton()
    local _ = {}

    local root : VisualElement = nil

    function _.Initialize(ve)
        root = ve
    end

    function _.ReplaceRoot(ve)
        root:Clear()
        root:Add(ve)
    end

    return _
end

instance = Singleton()