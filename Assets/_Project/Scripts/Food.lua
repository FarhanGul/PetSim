--!Type(Client)
local save = require("SaveManager")
local events = require("EventManager")
local data = require("GameData")

local pet = nil
local moveTo = nil
local distanceToKeepWithPetWhenStopping = 1
local eat = nil
local amount = 8

function self:Awake()
    eat = Timer.new(1, function()
        save.AddPetXp(1)
        amount -= 1
        if(amount == 0)then
            events.InvokeEvent(events.followPlayer)
            GameObject.Destroy(self.gameObject)
        end
    end,true)
    eat:Stop()
    events.SubscribeEvent(events.petSpawned,function(args)
        pet = args[1]
    end)
    events.SubscribeEvent(events.followPlayer,function(args)
        Stop()
    end)
    events.SubscribeEvent(events.petInteraction,function(args)
        if(args[1] ~= self)then
            Stop()
        end
    end)
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        if(pet ~= nil) then
            events.InvokeEvent(events.petInteraction,self)
            moveTo = self.transform.position
        end
    end)
end

function self:Update()
    if(moveTo ~= nil) then
        local petTransform = pet.gameObject.transform
        petTransform:LookAt(self.transform.position)
        local distance = Vector3.Distance(self.transform.position, petTransform.position);
        if (distance > distanceToKeepWithPetWhenStopping) then
            petTransform.position = Vector3.Lerp(petTransform.position, self.transform.position, data.speeds.pet * Time.deltaTime / distance)
        else
            moveTo = nil
            eat:Start()
        end
    end
end

function Stop()
    eat:Stop()
    moveTo = nil
end