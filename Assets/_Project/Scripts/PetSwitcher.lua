--!Type(Client)
local events = require("EventManager")
local save = require("SaveManager")

local petSelectionView
local currentIndex
local petNames

function self:Awake()
    events.SubscribeEvent(events.registerPetSelectionView,function(args)
        petSelectionView = args[1]
    end)
    events.SubscribeEvent(events.petSwitcherOpened,function(args)
        Show()
    end)
    events.SubscribeEvent(events.petTargetUpdated,function(args)
        if(args[1] == nil) then
            Hide()
        end
    end)
end

function Show()
    if(not petSelectionView.IsDisplayed()) then
        petSelectionView.Show(PreviousPet,NextPet)
        events.InvokeEvent(events.petTargetUpdated,true)
        petNames = {}
        table.insert(petNames,save.equippedPet)
        for key in pairs(save.pets) do
            if(key ~= save.equippedPet) then
                table.insert(petNames, key)
            end
        end
        currentIndex = 1
        petSelectionView.UpdateScrollProgressText(1,#petNames)
    end
end

function Hide()
    if(petSelectionView.IsDisplayed()) then
        petSelectionView.Hide()
    end
end

function PreviousPet()
    currentIndex -= 1
    if (currentIndex <=0 ) then 
        currentIndex = #petNames
    end
    EquipPet()
end

function NextPet()
    currentIndex += 1
    if (currentIndex > #petNames ) then 
        currentIndex = 1
    end
    EquipPet()
end

function EquipPet()
    petSelectionView.UpdateScrollProgressText(currentIndex,#petNames)
    save.ChangePet(petNames[currentIndex])
end