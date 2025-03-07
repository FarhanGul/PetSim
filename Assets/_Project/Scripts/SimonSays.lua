--!Type(Client)

local save = require("SaveManager")
local data = require("GameData")
local events = require("EventManager")
local audio = require("AudioManager")

local waitBeforeSequencePlays = 1
local pulseDuration = 0.2
local waitBetweenPulses = 0.75
local gameTitle = "Petal Pulse"
local gameDescription = "Watch carefully as the plant's bioluminescent petals light up in a sequence. Your task is to repeat the pattern exactly as shown"
local levelData = {
    {
        xpGained = 90,
        stepsRequired = 6
    },
    {
        xpGained = 180,
        stepsRequired = 12
    },
    {
        xpGained = 270,
        stepsRequired = 16
    }
}

--!SerializeField
local pulseObjects : { GameObject } = {}
--!SerializeField
local stoppingDistance : number = 1

local pet = nil
local readyToPlayView = nil
local foodView = nil
local sequence = nil
local currentLevelData
local acceptingInputForStep = nil

function self:Awake()
    events.SubscribeEvent(events.simonSayTrigger,function(args)
        SimonSaysTriggerInvoked(args[1])
    end)
    events.SubscribeEvent(events.playGame,function(args)
        StartGame()
    end)
    events.SubscribeEvent(events.registerReadyToPlayView,function(args)
        readyToPlayView = args[1]
    end)
    events.SubscribeEvent(events.registerFoodView,function(args)
        foodView = args[1]
    end)
    events.SubscribeEvent(events.petSpawned,function(args)
        pet = args[1]
    end)
    events.SubscribeEvent(events.petTargetUpdated,function(args)
        OnPetTargetUpdated()
    end)
    self.gameObject:GetComponent(TapHandler).Tapped:Connect(function() 
        if(pet ~= nil) then
            pet.MoveTo(self.transform,stoppingDistance,Show)
        end
    end)
end

function StartGame()
    readyToPlayView.Hide()
    sequence = {}
    currentLevelData = levelData[save.gameLevels.simonSays]
    foodView.Show(gameTitle,currentLevelData.xpGained,"Sequences left")
    PlaySequence()
end

function FinishGame()
    foodView.Hide()
    readyToPlayView.Hide()
    acceptingInputForStep = nil
    events.InvokeEvent(events.followPlayer)
    SetCollider(true)
end

function Show()
    SetCollider(false)
    readyToPlayView.Show({
        title = gameTitle,
        level = save.gameLevels.simonSays,
        description = gameDescription
    })
end

function OnPetTargetUpdated()
    FinishGame()
end

function SetProgress()
    local stepsLeft = currentLevelData.stepsRequired - #sequence
    local label = stepsLeft
    local pc = ((currentLevelData.stepsRequired - stepsLeft)/currentLevelData.stepsRequired)
    foodView.SetProgress(label,pc)
end

function PlaySequence()
    SetProgress()
    Timer.After(waitBeforeSequencePlays, function()
        table.insert(sequence,math.random(1 , 4))
        ShowStep(1)
    end)
end


function ShowStep(step)
    local obj = pulseObjects[sequence[step]]
    PlayNote(sequence[step])
    obj:SetActive(true)
    Timer.After(pulseDuration, function()
        obj:SetActive(false)
        if(step == #sequence)then
            acceptingInputForStep = 1
        else
            Timer.After(waitBetweenPulses, function()
                ShowStep(step+1)
            end)
        end
    end)
end

function SimonSaysTriggerInvoked(id)
    if(acceptingInputForStep ~= nil)then
        local obj = pulseObjects[sequence[acceptingInputForStep]]
        PlayNote(sequence[acceptingInputForStep])
        obj:SetActive(true)
        Timer.After(pulseDuration, function()
            obj:SetActive(false)
            local isCorrect = sequence[acceptingInputForStep] == id
            if(isCorrect)then
                if(acceptingInputForStep == #sequence)then
                    if(#sequence == currentLevelData.stepsRequired)then
                        LevelComplete()
                    else
                        PlaySequence()
                    end
                else
                    acceptingInputForStep += 1
                end
            else
                GameOver()
            end
        end)
    end
end

function GameOver()
    audio.Play("GameOver")
    -- Play Sound Effect and Shake object
    FinishGame()
    print("Game over")
end

function LevelComplete()
    print("Level Complete")
    save.AddPetXp(currentLevelData.xpGained)
    FinishGame()
end

function PlayNote(id)
    audio.Play("Note"..id)
end

function SetCollider(isActive)
    self.gameObject:GetComponent(SphereCollider).enabled = isActive
end