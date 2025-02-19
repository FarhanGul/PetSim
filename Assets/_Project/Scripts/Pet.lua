--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")
local save = require("SaveManager")
local XpSystem = require("XpSystem")

local speed = 5;  
local followDistance = 2; 
local petData
local ve
local xpSystem

function self:Start()
    events.SubscribeEvent(events.petXpUpdated,function(args)
        if(self.gameObject.name == args[1]) then
            xpSystem.AddXp(args[2])
        end
    end)
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
    end)
    petData = save.pets[self.gameObject.name]
    print("Name : "..self.gameObject.name)
    Show()
end

function self:OnDestroy()
    Hide()
end

function Show()
    ve = VisualElement.new()
    xpSystem = XpSystem.new()
    ve:Add(xpSystem.Create(petData.xp))
    uiController.Add(ve)
end

function Hide()
    ve:RemoveFromHierarchy()
end

function self:Update()
    xpSystem.Update(Time.deltaTime)
    local target = client.localPlayer.character
    if ( target == nil ) then return end

    local distance = Vector3.Distance(self.transform.position, target.transform.position);
    if (distance > followDistance) then
        self.transform.position = Vector3.Lerp(self.transform.position, target.transform.position, speed * Time.deltaTime / distance);
    end
end