--!Type(Client)

local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")
local data = require("GameData")
local save = require("SaveManager")

local root : VisualElement
local ve : VisualElement

function self:ClientAwake()
    events.SubscribeEvent(events.boughtEgg,function(args)
        ChangeIf(data.objectives.firstEgg, data.objectives.buyFirstFood)
    end)
    events.SubscribeEvent(events.boughtPetFood,function(args)
        ChangeIf(data.objectives.buyFirstFood, data.objectives.levelUpFirstPet)
    end)
    events.SubscribeEvent(events.gameStart,function(args)
        root = uiController.Add(uiComponents.AbsoluteStretch())
        Show()
    end)
end

function Show()
    ve = VisualElement.new()
    local label = UILabel.new()
    label:SetPrelocalizedText(save.currentObjective.text)
    ve:Add(label)
    root:Clear()
    root:Add(ve)
end

function Hide()
    ve:RemoveFromHierarchy()
end

function ChangeIf(objective, new)
    if(save.currentObjective.id == objective.id)then
        save.currentObjective = new
        Show()
    end
end
