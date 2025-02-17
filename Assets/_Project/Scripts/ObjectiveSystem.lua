--!Type(Client)

local uiController = require("UIController")
local events = require("EventManager")

local objectives = {
    fistEgg = { id = 1, text = "Visit the pet shop to get your first egg", },
    buyFirstFood = { id = 2, text ="Buy food for your pet from the pet shop. There is a free coin dispenser nearby.", }
}

local current = objectives.fistEgg
local ve

function self:ClientAwake()
    events.SubscribeEvent(events.boughtEgg,function(args)
        ChangeIf(objectives.fistEgg, objectives.buyFirstFood)
    end)
    events.SubscribeEvent(events.gameStart,function(args)
        Show()
    end)
end

function Show()
    ve = VisualElement.new()
    local label = UILabel.new()
    label:SetPrelocalizedText(current.text)
    ve:Add(label)
    uiController.instance.ReplaceRoot(ve)
end

function Hide()
    ve:RemoveFromHierarchy()
end

function ChangeIf(objective, new)
    if(current.id == objective.id)then
        current = new
        Show()
    end
end
