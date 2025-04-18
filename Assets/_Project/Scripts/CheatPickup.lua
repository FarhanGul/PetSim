--!Type(Client)
local save = require("SaveManager")
local petManager = require("PetManager")
local data = require("GameData")

function self:Awake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        Cheat()
        GameObject.Destroy(self.gameObject)
    end)
end

function Cheat()
    save.AddMap("Island2")
    petManager.NewPet("Bulb",client.localPlayer.character.transform.position)
    petManager.NewPet("Axolotl",client.localPlayer.character.transform.position)
    for key, value in pairs(data.objectives) do
        save.CompleteObjective(value.key)
    end
end