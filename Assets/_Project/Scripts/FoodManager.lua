--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")

function self:Awake()
    events.SubscribeEvent(events.gameStart,function(args)
        InitializeFoods()
    end)
end

function InitializeFoods()
    for i = 1, self.transform.childCount do
        local child = self.transform:GetChild(i)
        local foodData = save.foods.GetById(child.name)
        local food = child:GetComponent(Food)
        if(foodData == nil)then
            foodData = save.FoodData()
            foodData.id = child.name
            foodData.timeToGrow = 0
            foodData.eatingTimeLeft =  data.foods[food.GetId()].canBeEatenForSeconds
        else
        end
    end
end