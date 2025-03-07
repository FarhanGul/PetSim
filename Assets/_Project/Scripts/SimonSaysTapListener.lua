--!Type(Client)

local events = require("EventManager")

--!SerializeField
local id : number = 1

function self:Awake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        events.InvokeEvent(events.simonSayTrigger,id)
    end)
end