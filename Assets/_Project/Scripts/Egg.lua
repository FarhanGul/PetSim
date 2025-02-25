--!Type(Client)

--!SerializeField
local pet : string

function self:Awake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
    end)
end