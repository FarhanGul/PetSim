--!Type(Client)

local save = require("SaveManager")

function self:ClientAwake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        save.SetCoins(save.coins + 1 )
    end)
end