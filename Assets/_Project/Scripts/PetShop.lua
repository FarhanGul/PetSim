--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")

-- local petFoodCost = 5

local ve
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
    ve:Add(uiComponents.Text("Welcome to the pet shop"))
    if( save.currentObjective == data.objectives.firstEgg ) then
        ve:Add(uiComponents.Text("Looks like you are new here, get your first egg for free only at the pet shop"))
        ve:Add(Item("Egg",0,events.boughtEgg))
    else
        ve:Add(Item("Egg",data.cost.egg,events.boughtEgg))
        ve:Add(Item("Pet Food",data.cost.petFood,events.boughtPetFood))
    end
    uiController.Add(ve)
end

function Item(title,cost,invokeEventName)
    local costText = cost == 0 and "Free" or cost
    return uiComponents.TextButton("Buy "..title.." ( "..costText.." )",function() 
        if(save.coins >= cost) then
            save.SetCoins(save.coins - cost )
            events.InvokeEvent(invokeEventName)
            Reset()
        end
    end,save.coins >= cost)
end

function Hide()
    isUiActive = false
    ve:RemoveFromHierarchy()
end

function Reset()
    Hide()
    Show()
end