--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")

local ve

function self:Awake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        Show()
    end)
end

function Show()
    ve = VisualElement.new()
    local label = UILabel.new()
    label:SetPrelocalizedText("Welcome to the pet shop")
    ve:Add(label)
    ve:Add(uiComponents.TextButton("Buy Egg",function() 
        events.InvokeEvent(events.boughtEgg)
        Hide()
    end))
    uiController.instance.ReplaceRoot(ve)
end

function Hide()
    ve:RemoveFromHierarchy()
end