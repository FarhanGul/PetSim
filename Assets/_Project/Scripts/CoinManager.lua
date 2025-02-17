--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")
local save = require("SaveManager")

local root : VisualElement

function self:ClientAwake()
    events.SubscribeEvent(events.gameStart,function(args)
        root = uiController.Add(uiComponents.AbsoluteStretch())
        Show()
    end)
    events.SubscribeEvent(events.currencyUpdated,function(args)
        Show()
    end)
end

function Show()
    ve = VisualElement.new()
    local label = UILabel.new()
    label:SetPrelocalizedText("Coins : "..save.coins)
    ve:Add(label)
    root:Clear()
    root:Add(ve)
end

