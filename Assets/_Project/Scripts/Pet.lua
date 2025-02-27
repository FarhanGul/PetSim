--!Type(Client)
local uiComponents = require("UIComponents")
local events = require("EventManager")
local save = require("SaveManager")

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
    petData = save.pets[self.gameObject.name]
end

function self:Update()
    local target = client.localPlayer.character
    if ( target == nil ) then return end

    local distance = Vector3.Distance(self.transform.position, target.transform.position);
    if (distance > followDistance) then
        self.transform.position = Vector3.Lerp(self.transform.position, target.transform.position, speed * Time.deltaTime / distance);
    end
    self.transform:LookAt(target.transform.position)
end