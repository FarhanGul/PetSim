--!Type(Client)

local save = require("SaveManager")
local uiController = require("UIController")
local uiComponents = require("UIComponents")

local ve
local isUiActive

function self:Awake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        if(not isUiActive) then
            Show()
        end
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
    label:SetPrelocalizedText("Coin dispenser")
    ve:Add(label)
    ve:Add(uiComponents.TextButton("Push",function() 
        save.SetCoins(save.coins + 1 )
    end,true))
    uiController.Add(ve)
end

function Hide()
    isUiActive = false
    ve:RemoveFromHierarchy()
end