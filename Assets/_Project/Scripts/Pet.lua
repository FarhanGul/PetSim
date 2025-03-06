--!Type(Client)
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")

local followDistance = 2; 
local followPlayer = true
local stoppingDistance = 3
local moveToTarget = nil
local onReachedTarget = nil

function self:Awake()
    events.SubscribeEvent(events.followPlayer,function(args)
        events.InvokeEvent(events.petTargetUpdated)
        followPlayer = true;
    end)
end

function self:Update()
    local player = client.localPlayer.character
    if ( player == nil ) then return end

    if(followPlayer)then
        moveToTarget = nil
        local distance = Vector3.Distance(self.transform.position, player.transform.position);
        if (distance > followDistance) then
            self.transform.position = Vector3.Lerp(self.transform.position, player.transform.position, data.speeds.pet * Time.deltaTime / distance);
        end
        self.transform:LookAt(player.transform.position)
    elseif(moveToTarget ~= nil) then
        self.transform:LookAt(self.transform.position)
        local distance = Vector3.Distance(moveToTarget.position, self.transform.position);
        if (distance > stoppingDistance) then
            self.transform.position = Vector3.Lerp(self.transform.position, moveToTarget.position, data.speeds.pet * Time.deltaTime / distance)
            self.transform:LookAt(moveToTarget.position)
        else
            moveToTarget = nil
            onReachedTarget()
        end
    end
end

function MoveTo(target,onReachedTargetCallback)
    events.InvokeEvent(events.petTargetUpdated)
    followPlayer = false
    moveToTarget = target
    onReachedTarget = onReachedTargetCallback
end