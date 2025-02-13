--!Type(Module)

local uiController = require("UIController")

local function Singleton()
    local _ = {}
    local list = {
        "Get your first egg",
        "Hatch the egg",
        "Level up the pet"
    }
    local current = 1
    local ve

    function _.Show()
        ve = VisualElement.new()
        local label = UILabel.new()
        label:SetPrelocalizedText(list[current])
        ve:Add(label)
        uiController.instance.ReplaceRoot(ve)
    end

    function _.Hide()
        ve:RemoveFromHierarchy()
    end

    return _
end

instance = Singleton()