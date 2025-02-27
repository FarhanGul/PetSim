--!Type(Client)
local save = require("SaveManager")

--!SerializeField
local petPrefab : GameObject = nil

function self:Awake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        Hatch()
    end)
end

function Hatch()
    save.pets[petPrefab.name] = save.PetData()
    local pet = Object.Instantiate(petPrefab)
    pet.transform.position = self.transform.position
    pet.transform.rotation = self.transform.rotation
    pet.name = petPrefab.name
    save.CompleteObjective("firstEgg")
    GameObject.Destroy(self.gameObject)
end