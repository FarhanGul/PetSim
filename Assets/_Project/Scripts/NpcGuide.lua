--!Type(Client)
local dialogueManager = require("DialogueManager")
local save = require("SaveManager")

local character : Character
local dialogueInProgress = false

function self:Awake()
    character = self.gameObject:GetComponent(Character)
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        if(dialogueInProgress)then
            return
        end
        Scenerio("introDialogue",function(dialogue)
            dialogue.NpcSays("Hey there I'm max the caretaker of this archipelago, what brings you here?")
            dialogue.PlayerSays("Hi Max, I have come to see the exotic creatures!")
            -- dialogue.PlayerSays("Do you know where I can find them?")
            -- dialogue.NpcSays("Oh yes this place was bustling with activity")
            -- dialogue.NpcSays("But that was before the mysterious presence took over our island!")
            -- dialogue.NpcSays("All the creatures have migrated ever since")
            -- dialogue.NpcSays("Come to think of it, we could use your help")
            -- dialogue.NpcSays("Some eggs were left behind during the migration and they are ready to hatch")
            -- dialogue.NpcSays("They need care before they can be on their own")
            -- dialogue.NpcSays("I'm pretty sure I saw an egg hidden behind one of those rocks")
        end)
    end)
end

function Scenerio(objective,setupDialogue)
    if(save.currentObjective == objective) then
        local dialogue = dialogueManager.Create("Max",character.chatBubbleTransform)
        setupDialogue(dialogue)
        dialogueInProgress = true
        dialogue.Start(function()
            save.CompleteObjective(objective)
            dialogueInProgress = false
        end)
    end
end