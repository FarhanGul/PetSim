--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")

local speed = 5;  
local followDistance = 2; 

function self:ClientAwake()
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
    end)
end

function self:Update()
    local target = client.localPlayer.character
    if ( target == nil ) then return end

    local distance = Vector3.Distance(self.transform.position, target.transform.position);
    if (distance > followDistance) then
        self.transform.position = Vector3.Lerp(self.transform.position, target.transform.position, speed * Time.deltaTime / distance);
    end
end
