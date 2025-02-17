--!Type(UI)

local uiController = require("UIController")

--!Bind
local root : VisualElement = nil

function self:ClientAwake()
    uiController.Initialize(root)
end