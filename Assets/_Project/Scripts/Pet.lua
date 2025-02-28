--!Type(Client)
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")

local followDistance = 2; 
local followPlayer = true

function self:Awake()
    events.SubscribeEvent(events.petInteraction,function(args)
        followPlayer = false;
    end)
    events.SubscribeEvent(events.followPlayer,function(args)
        followPlayer = true;
    end)
end

function self:Update()
    local target = client.localPlayer.character
    if ( target == nil ) then return end

    if(followPlayer)then
        local distance = Vector3.Distance(self.transform.position, target.transform.position);
        if (distance > followDistance) then
            self.transform.position = Vector3.Lerp(self.transform.position, target.transform.position, data.speeds.pet * Time.deltaTime / distance);
        end
        self.transform:LookAt(target.transform.position)
    end
end