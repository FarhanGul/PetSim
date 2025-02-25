--!Type(Client)

local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")
local data = require("GameData")
local save = require("SaveManager")

local root : VisualElement
local ve : VisualElement

function self:Awake()
    events.SubscribeEvent(events.objectiveCompleted,function(args)
        Show()
    end)
    events.SubscribeEvent(events.gameStart,function(args)
        root = uiController.Add(uiComponents.AbsoluteStretch())
        Show()
    end)
end

function Show()
    ve = VisualElement.new()
    local label = UILabel.new()
    label:SetPrelocalizedText(data.objectives[save.currentObjective])
    ve:Add(label)
    root:Clear()
    root:Add(ve)
end

function Hide()
    ve:RemoveFromHierarchy()
end