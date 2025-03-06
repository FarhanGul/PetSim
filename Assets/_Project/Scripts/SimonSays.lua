--!Type(Client)

local save = require("SaveManager")
local data = require("GameData")
local events = require("EventManager")

local pet = nil
local readyToPlayView = nil

function self:Awake()
    events.SubscribeEvent(events.registerReadyToPlayView,function(args)
        readyToPlayView = args[1]
    end)
    events.SubscribeEvent(events.petSpawned,function(args)
        pet = args[1]
    end)
    events.SubscribeEvent(events.petTargetUpdated,function(args)
        Hide()
    end)
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        if(pet ~= nil) then
            pet.MoveTo(self.transform,Show)
        end
    end)
end

function self:Update()

end

function Show()
    readyToPlayView.Show({
        title = "Petal Pulse",
        level = 1,
        description = "Watch carefully as the plant's bioluminescent petals light up in a sequence. Your task is to repeat the pattern exactly as shown"
    })
end

function Hide()
    readyToPlayView.Hide()
end