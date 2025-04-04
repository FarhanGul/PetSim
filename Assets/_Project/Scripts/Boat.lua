--!Type(Client)
local save = require("SaveManager")
local events = require("EventManager")
local data = require("GameData")
local sceneLoader = require("CustomSceneLoader")

local locationView = nil
local currentLocationIndex = 1
local locationKeys = {}

function self:Awake()
    -- Get all location keys in order
    for key, _ in pairs(data.locations) do
        table.insert(locationKeys, key)
    end
    
    -- Get reference to location selection view
    events.SubscribeEvent(events.registerLocationSelectionView, function(args)
        locationView = args[1]
    end)
    
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        if #save.maps < 2 then return end
        -- Find current location index
        for i, key in ipairs(locationKeys) do
            if key == save.currentLocation then
                currentLocationIndex = i
                break
            end
        end
        
        -- Show location selection with callbacks
        locationView.Show(
            function() -- On Left
                currentLocationIndex = currentLocationIndex - 1
                if currentLocationIndex < 1 then
                    currentLocationIndex = #locationKeys
                end
                UpdateLocationDisplay()
            end,
            function() -- On Right
                currentLocationIndex = currentLocationIndex + 1
                if currentLocationIndex > #locationKeys then
                    currentLocationIndex = 1
                end
                UpdateLocationDisplay()
            end,
            function() -- On Go
                locationView.Hide()
                save.UpdateLocation(locationKeys[currentLocationIndex])
                sceneLoader.SendMovePlayerToSceneRequest(save.currentLocation)
            end
        )
        
        UpdateLocationDisplay()
    end)
end

function UpdateLocationDisplay()
    local locationKey = locationKeys[currentLocationIndex]
    local locationData = data.locations[locationKey]
    local isCurrent = locationKey == save.currentLocation
    locationView.SetLocation(locationData, isCurrent)
end

function self:Update()
    if(locationView.IsDisplayed() and client.localPlayer.character.isMoving)then
        locationView.Hide()
    end
end