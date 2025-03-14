--!Type(Client)
local save = require("SaveManager")
local events = require("EventManager")
local data = require("GameData")
local dialogueManager = require("DialogueManager")
local helper = require("Helper")

--!SerializeField
local petPrefab : GameObject = nil

function self:Awake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        Hatch()
    end)
end

function Hatch()
    save.NewPet(petPrefab.name,self.transform.position)
    save.AddDiscoveredObject(self.gameObject.name)
    if(save.currentObjective == "firstEgg")then
        save.currentObjective = helper.GetNextKey(data.objectives,"firstEgg")
        local dialogue = dialogueManager.Create()
        dialogue.PlayerSays("Oh aren't you adorable!")
        dialogue.PlayerSays("I'll call you axolotl")
        dialogue.Start(function()
            events.InvokeEvent(events.objectiveCompleted)
        end)
    end
    events.InvokeEvent(events.eggHatched)
    Destroy()
end

function Destroy()
    Component.Destroy(self:GetComponent(TapHandler))
    Component.Destroy(self:GetComponent(MeshRenderer))
end