--!Type(Client)
local save = require("SaveManager")
local events = require("EventManager")

--!SerializeField
local petPrefab : GameObject = nil

function self:Awake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        Hatch()
    end)
end

function Hatch()
    save.NewPet(petPrefab.name,self.transform.position)
    save.CompleteObjective("firstEgg")
    GameObject.Destroy(self.gameObject)
end