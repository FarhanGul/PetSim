--!Type(Client)
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")

local followDistance = 3; 
local followPlayer
local stoppingDistance = nil
local moveToTarget = nil
local onReachedTarget = nil
local animator : Animator = nil

function self:Awake()
    animator = self:GetComponent(Animator)
    events.SubscribeEvent(events.petTargetUpdated,function(args)
        if(args[1] ~= nil)then
            followPlayer = args[1];
        end
    end)
end

function self:Start()
    events.InvokeEvent(events.petTargetUpdated,true)
end

function self:Update()
    local player = client.localPlayer.character
    if ( player == nil ) then return end

    if(followPlayer)then
        moveToTarget = nil
        local distance = Vector3.Distance(self.transform.position, player.transform.position);
        if (distance > followDistance) then
            animator:SetBool("Run",true)
            self.transform.position = Vector3.Lerp(self.transform.position, player.transform.position, data.speeds.pet * Time.deltaTime / distance);
        else
            animator:SetBool("Run",false)
        end
        self.transform:LookAt(player.transform.position)
    elseif(moveToTarget ~= nil) then
        local targetPos : Vector3 = moveToTarget.position
        targetPos.y = self.transform.position.y
        local distance = Vector3.Distance(targetPos, self.transform.position);
        if (distance > stoppingDistance) then
            animator:SetBool("Run",true)
            self.transform.position = Vector3.Lerp(self.transform.position, targetPos, data.speeds.pet * Time.deltaTime / distance)
            self.transform:LookAt(targetPos)
        else
            animator:SetBool("Run",false)
            moveToTarget = nil
            onReachedTarget()
        end
        self.transform:LookAt(targetPos)
    end
end

function MoveTo(target,_stoppingDistance,onReachedTargetCallback)
    stoppingDistance = _stoppingDistance
    events.InvokeEvent(events.petTargetUpdated)
    followPlayer = false
    moveToTarget = target
    onReachedTarget = onReachedTargetCallback
end

function GetAnimator()
    return animator
end