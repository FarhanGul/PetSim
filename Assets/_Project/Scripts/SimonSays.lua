--!Type(Client)

local save = require("SaveManager")
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local data = require("GameData")
local events = require("EventManager")

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
    ve:Add(uiComponents.Text("Pet Challenge"))
    ve:Add(uiComponents.Text("Memory Madness"))
    ve:Add(uiComponents.PlayChallengeButton(data.cost.playSimonSays,function()
        print("Game event invoked")
        events.InvokeEvent(events.changeScene,"Test")
    end))
    uiController.Add(ve)
end

function Hide()
    isUiActive = false
    ve:RemoveFromHierarchy()
end