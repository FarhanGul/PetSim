--!Type(Client)

local animator : Animator
local tapHandler : TapHandler
local collider : Collider

function self:Awake()
    animator = self.gameObject:GetComponent(Animator)
    tapHandler = self.gameObject:GetComponent(TapHandler)
    collider = self.gameObject:GetComponent(Collider)
    tapHandler.Tapped:Connect(function() 
        animator:SetBool("IsVisible",true)
        Component.Destroy(tapHandler)
        Component.Destroy(collider)
    end)
end