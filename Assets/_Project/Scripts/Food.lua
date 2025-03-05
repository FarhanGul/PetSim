--!Type(Client)
local save = require("SaveManager")
local events = require("EventManager")
local data = require("GameData")

--!SerializeField
local foodId : string = ""

local pet = nil
local moveTo = nil
local distanceToKeepWithPetWhenStopping = 1
local eat = nil
local amount = nil
local foodView : FoodView = nil

function self:Awake()
    eat = Timer.new(1, Eat,true)
    eat:Stop()
    events.SubscribeEvent(events.petSpawned,function(args)
        pet = args[1]
    end)
    events.SubscribeEvent(events.followPlayer,function(args)
        StopEating()
    end)
    events.SubscribeEvent(events.petInteraction,function(args)
        if(args[1] ~= self)then
            StopEating()
        end
    end)
    events.SubscribeEvent(events.gameStart,function(args)
        amount = data.foods[foodId].timeRequiredToConsume
    end)
    events.SubscribeEvent(events.registerFoodView,function(args)
        foodView = args[1]
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
            StartEating()
        end
    end
end

function Eat()
    amount -= 1
    foodView.SetProgress(amount)
    if(amount == 0)then
        save.AddPetXp(data.foods[foodId].xpGained)
        save.AddHiddenObject(self.gameObject.name)
        events.InvokeEvent(events.followPlayer)
        GameObject.Destroy(self.gameObject)
    end
end

function StartEating()
    foodView.Show(foodId)
    foodView.SetProgress(amount)
    moveTo = nil
    eat:Start()
end

function StopEating()
    foodView.Hide()
    events.InvokeEvent(events.stoppedEating)
    eat:Stop()
    moveTo = nil
end

function GetId()
    return foodId
end