--!Type(Client)
local dialogueManager = require("DialogueManager")
local save = require("SaveManager")

local character : Character
local states = {
    intro = 1,
    silent = 2
}
local state = states.intro

function self:Awake()
    character = self.gameObject:GetComponent(Character)
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        if(state == states.intro) then
            local dialogue = dialogueManager.Create("Island resident",character.chatBubbleTransform)
            dialogue.NpcSays("Hello traveller, what brings you to the island?")
            dialogue.PlayerSays("Hey, I have come to see the exotic creatures present here")
            dialogue.PlayerSays("Do you know where I can find them?")
            dialogue.NpcSays("Oh yes this place was bustling with activity before the mysterious presence took over!")
            dialogue.NpcSays("All the creatures have migrated ever since")
            dialogue.NpcSays("Come to think of it, we could use your help")
            dialogue.PlayerSays("Of course, tell me more!")
            dialogue.NpcSays("Some eggs were left behind during the migration and they are ready to hatch")
            dialogue.NpcSays("They need care before they can be on their own")
            dialogue.NpcSays("I'm pretty sure I saw an egg behind that rock over there")
            state = states.silent
            dialogue.Start(function()
                save.CompleteObjective("introDialogue")
            end)
        end
    end)
end