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
    HandleIfAlreadyHatched()
end

function HandleIfAlreadyHatched()
    if(save.pets[petPrefab.name] ~= nil)then
        Destroy()
    end
end

function Hatch()
    save.NewPet(petPrefab.name,self.transform.position)
    save.AddDiscoveredObject(self.gameObject.name)
    if(save.currentObjective == "firstEgg")then
        local dialogue = dialogueManager.Create()
        dialogue.PlayerSays("Oh aren't you adorable!")
        dialogue.PlayerSays("I'll call you axolotl")
        dialogue.Start(function()
            save.CompleteObjective("firstEgg")
        end)
    elseif(save.currentObjective == "secondEgg")then
        local dialogue = dialogueManager.Create()
        dialogue.PlayerSays("Hey little fellow!")
        dialogue.Start(function()
            save.CompleteObjective("secondEgg")
        end)
    end
    events.InvokeEvent(events.newDiscovery)
    Destroy()
end

function Destroy()
    Component.Destroy(self:GetComponent(TapHandler))
    Component.Destroy(self:GetComponent(MeshRenderer))
end