--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")
local save = require("SaveManager")

local ve
local petFoodCost = 5
local isUiActive

function self:Awake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        Show()
    end)
end

function self:Update()
    if(isUiActive and client.localPlayer.character.isMoving)then
        Hide()
    end
end

function Show()
    isUiActive = true
    ve = VisualElement.new()
    local label = UILabel.new()
    label:SetPrelocalizedText("Welcome to the pet shop")
    ve:Add(label)
    ve:Add(uiComponents.TextButton("Buy Egg",function() 
        Hide()
        events.InvokeEvent(events.boughtEgg)
    end,true))
    ve:Add(uiComponents.TextButton("Buy Pet Food ( "..petFoodCost.." )",function() 
        if(save.coins >= petFoodCost) then
            events.InvokeEvent(events.boughtPetFood)
            save.SetCoins(save.coins - petFoodCost )
            print("Bought pet food")
        end
    end,save.coins >= petFoodCost))
    ve:Add(uiComponents.TextButton("Close",function() 
        Hide()
    end,true))
    uiController.Add(ve)
end

function Hide()
    isUiActive = false
    ve:RemoveFromHierarchy()
end