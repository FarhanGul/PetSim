--!Type(Client)
local save = require("SaveManager")
local events = require("EventManager")
local data = require("GameData")
local dialogueManager = require("DialogueManager")
local audio = require("AudioManager")

--!SerializeField
local foodVariety : {GameObject} = {}

local foodId : string = ""
local stoppingDistance : number = 1.3
local pet : IslandPet = nil
local eat = nil
local amount = nil
local activityView : ActivityView = nil
local foodData
local tapHandler : TapHandler = nil

function self:Awake()
    tapHandler = self:GetComponent(TapHandler)
    Initialize()
    events.SubscribeEvent(events.localPetSpawned,function(args)
        pet = args[1]
    end)
    events.SubscribeEvent(events.petTargetUpdated,function(args)
        StopEating()
    end)
    events.SubscribeEvent(events.registerActivityView,function(args)
        activityView = args[1]
    end)
    tapHandler.Tapped:Connect(function() 
        if(pet ~= nil and save.canEat) then
            pet.MoveTo(self.transform,stoppingDistance,StartEating)
        end
    end)
end

function self:Update()
    if(activityView.IsDisplayed() and client.localPlayer.character.isMoving)then
        activityView.Hide()
        events.InvokeEvent(events.petTargetUpdated,true)
    end
end

function Initialize()
    eat = Timer.new(1, Eat,true)
    eat:Stop()
    SetupRandomFood()
end

function SetupRandomFood()
    foodId = GetRandomFood()
    foodData =  data.foods[foodId]
    ShowModel()
end

function ShowModel()
    tapHandler.enabled = true
    for i = 1, #foodVariety do
        foodVariety[i]:SetActive(foodVariety[i].name == foodId)
    end
end

function HideModel()
    tapHandler.enabled = false
    for i = 1, #foodVariety do
        foodVariety[i]:SetActive(false)
    end
end

function GetRandomFood()
    -- Find food in foodVariety that matches the randomly selected rarity
    local roll = math.random(1, 100)
    local selectedRarity
    local weights = data.rarityWeights
    if roll <= weights.Rare then
        selectedRarity = "Rare"
    elseif roll <= weights.Rare + weights.Uncommon then
        selectedRarity = "Uncommon"
    else
        selectedRarity = "Common"
    end

    -- Create a list of foods matching the selected rarity
    local possibleFoods = {}
    for i, food in ipairs(foodVariety) do
        local foodName = food.name
        if data.foods[foodName] and data.foods[foodName].rarity == selectedRarity then
            table.insert(possibleFoods, foodName)
        end
    end

    -- Select a random food from the possible foods
    if #possibleFoods > 0 then
        foodId = possibleFoods[math.random(1, #possibleFoods)]
    else
        -- Fallback to first food if no matching rarity found
        foodId = foodVariety[1].name
    end
    return foodId
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
            dialogue.PlayerSays("Bulb's growing so fast. I have a feeling you've got a surprise waiting for me.")
            dialogue.PlayerSays("The caretaker rewarded me with sea shells for helping out with the pets")
            dialogue.PlayerSays("Something tells me they might be more than just souvenirs")
            dialogue.Start(function()
                save.CompleteObjective("firstFeed")
            end)
        end
    end
end

function StartEating()
    audio.Play("Eating")
    amount = foodData.timeRequiredToConsume
    activityView.Show(foodData.name,"Food",foodData.xpGained,"Time Remaining")
    SetProgress()
    eat:Start()
    pet.GetAnimator():SetBool("Eat",true)
end

function SetProgress()
    local label = tostring(amount).." s";
    local pc = ((foodData.timeRequiredToConsume - amount)/foodData.timeRequiredToConsume)
    activityView.SetProgress(label,pc)
end

function StopEating()
    audio.Stop("Eating")
    activityView.Hide()
    eat:Stop()
    pet.GetAnimator():SetBool("Eat",false)
end

function GetId()
    return foodId
end

function Destroy()
    HideModel()
    -- Setup a timer to regenerate food 
    local wait = math.random(data.foodRegnerationWait.min, data.foodRegnerationWait.max)
    Timer.After(wait, SetupRandomFood)
end