--!Type(Client)
local dialogueManager = require("DialogueManager")
local save = require("SaveManager")
local data = require("GameData")
local events = require("EventManager")

local character : Character
local dialogueInProgress = false
local buyItemView = nil

function self:Awake()
    events.SubscribeEvent(events.registerBuyItemView, function(args)
        buyItemView = args[1]
    end)
    character = self.gameObject:GetComponent(Character)
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        if(dialogueInProgress)then
            return
        end
        Scenerio("talkToCartographer",function(dialogue)
            dialogue.PlayerSays("Hey, do you know how I can get to the other islands?")
            dialogue.NpcSays("How convenient for you to run into a cartographer")
            dialogue.NpcSays("I can show you how to navigate the sea")
            dialogue.NpcSays("For the right price of course")
        end)
        Scenerio("buyFirstMap",function(dialogue)
            dialogue.NpcSays("Ready to buy that map?")
            ShowBuyUI()
        end)
    end)
end

function self:Update()
    if(buyItemView.IsDisplayed() and client.localPlayer.character.isMoving)then
        buyItemView.Hide()
    end
end

function Scenerio(objective,setupDialogue)
    if(save.currentObjective == objective) then
        local dialogue = dialogueManager.Create("Cartographer",character.chatBubbleTransform)
        setupDialogue(dialogue)
        dialogueInProgress = true
        dialogue.Start(function()
            if(save.currentObjective == "talkToCartographer") then
                save.CompleteObjective(objective)
                ShowBuyUI()
            end
            dialogueInProgress = false
        end)
    end
end

function ShowBuyUI()
    local item = data.buyableItems.day2Map
    buyItemView.Show(item,save.coins >= item.cost,function()
        save.ChangeCoins(-item.cost)
        save.AddMap("Day2")
        save.CompleteObjective("buyFirstMap")
        buyItemView.Hide()
    end)
end