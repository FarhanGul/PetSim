--!Type(Client)
local save = require("SaveManager")
local events = require("EventManager")
local data = require("GameData")
local dialogueManager = require("DialogueManager")

--!SerializeField
local foodId : string = ""

--!SerializeField
local stoppingDistance : number = 1

local pet = nil
local eat = nil
local amount = nil
local activityView : ActivityView = nil
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
    events.SubscribeEvent(events.registerActivityView,function(args)
        activityView = args[1]
    end)
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        if(pet ~= nil and save.canEat) then
            pet.MoveTo(self.transform,stoppingDistance,StartEating)
        end
    end)
end

function Eat()
    amount -= 1
    SetProgress()
    if(amount == 0)then
        save.AddPetXp(foodData.xpGained)
        save.AddDiscoveredObject(self.gameObject.name)
        events.InvokeEvent(events.petTargetUpdated,true)
        StopEating()
        events.InvokeEvent(events.newDiscovery)
        Destroy()
        if(save.currentObjective == "firstFeed")then
            local dialogue = dialogueManager.Create()
            dialogue.PlayerSays("Look at you grow!")
            dialogue.PlayerSays("Max rewarded me with sea shells for helping out with the pets")
            dialogue.PlayerSays("Something tells me they might be more than just souvenirs")
            dialogue.Start(function()
                save.CompleteObjective("firstFeed")
            end)
        end
    end
end

function StartEating()
    amount = foodData.timeRequiredToConsume
    activityView.Show(foodData.name,foodData.rarity,foodData.xpGained,"Time Remaining")
    SetProgress()
    eat:Start()
end

function SetProgress()
    local label = tostring(amount).." s";
    local pc = ((foodData.timeRequiredToConsume - amount)/foodData.timeRequiredToConsume)
    activityView.SetProgress(label,pc)
end

function StopEating()
    activityView.Hide()
    eat:Stop()
end

function GetId()
    return foodId
end

function Destroy()
    self:GetComponent(TapHandler).enabled = false
    self:GetComponent(MeshRenderer).enabled = false
end