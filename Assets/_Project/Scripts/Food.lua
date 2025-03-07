--!Type(Client)
local save = require("SaveManager")
local events = require("EventManager")
local data = require("GameData")

--!SerializeField
local foodId : string = ""

local pet = nil
local eat = nil
local amount = nil
local foodView : FoodView = nil
local foodData

function self:Awake()
    foodData =  data.foods[foodId]
    eat = Timer.new(1, Eat,true)
    eat:Stop()
    events.SubscribeEvent(events.petSpawned,function(args)
        pet = args[1]
    end)
    events.SubscribeEvent(events.petTargetUpdated,function(args)
        StopEating()
    end)
    events.SubscribeEvent(events.gameStart,function(args)
        amount = foodData.timeRequiredToConsume
    end)
    events.SubscribeEvent(events.registerFoodView,function(args)
        foodView = args[1]
    end)
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        if(pet ~= nil) then
            pet.MoveTo(self.transform,StartEating)
        end
    end)
end

function Eat()
    amount -= 1
    SetProgress()
    if(amount == 0)then
        save.AddPetXp(foodData.xpGained)
        events.InvokeEvent(events.followPlayer)
        save.AddHiddenObject(self.gameObject.name)
        GameObject.Destroy(self.gameObject)
    end
end

function StartEating()
    foodView.Show(foodData.name,foodData.xpGained,"Time Remaining")
    SetProgress()
    eat:Start()
end

function SetProgress()
    local label = tostring(amount).." s";
    local pc = ((foodData.timeRequiredToConsume - amount)/foodData.timeRequiredToConsume)
    foodView.SetProgress(label,pc)
end

function StopEating()
    foodView.Hide()
    eat:Stop()
end

function GetId()
    return foodId
end