--!Type(Module)

local root : VisualElement = nil

function Initialize(ve)
    root = ve
end

function ReplaceRoot(ve)
    root:Clear()
    root:Add(ve)
end

function Add(ve)
    root:Add(ve)
    return ve
end