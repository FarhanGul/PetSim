--!Type(Client)

local save = require("SaveManager")
local data = require("GameData")
local events = require("EventManager")
local audio = require("AudioManager")

--!SerializeField
local rarity : string = "Common"
--!SerializeField
local xpGained :number = 90
--!SerializeField
local stepsRequired : number = 6
--!SerializeField
local pulseObjects : { GameObject } = {}

local stoppingDistance = 2
local waitBeforeSequencePlays = 1
local pulseDuration = 0.2
local waitBetweenPulses = 0.75
local gameTitle = "Petal Pulse"
local gameDescription = "Watch carefully as the plant's bioluminescent petals light up in a sequence. Your task is to repeat the pattern exactly as shown"
local pet = nil
local readyToPlayView = nil
local activityView = nil
local sequence = nil
local acceptingInputForStep = nil
local animator : Animator
local tapHandler : TapHandler

function self:Awake()
    animator = self.gameObject:GetComponent(Animator)
    tapHandler = self.gameObject:GetComponent(TapHandler)
    events.SubscribeEvent(events.simonSayTrigger,function(args)
        SimonSaysTriggerInvoked(args[1])
    end)
    events.SubscribeEvent(events.registerReadyToPlayView,function(args)
        readyToPlayView = args[1]
    end)
    events.SubscribeEvent(events.registerActivityView,function(args)
        activityView = args[1]
    end)
    events.SubscribeEvent(events.petSpawned,function(args)
        pet = args[1]
    end)
    events.SubscribeEvent(events.petTargetUpdated,function(args)
        FinishGame()
    end)
    tapHandler.Tapped:Connect(function() 
        if(pet ~= nil) then
            pet.MoveTo(self.transform,stoppingDistance,Show)
        end
    end)
    events.SubscribeEvent(events.lateGameStart,function(args)
        if(animator:GetBool("Discovered")) then
            tapHandler.enabled = false
        end
    end)
end

function FinishGame()
    activityView.Hide()
    readyToPlayView.Hide()
    UnitializeGame()
end

function UnitializeGame()
    acceptingInputForStep = nil
    SetCollider(true)
end

function Show()
    sequence = {}
    SetCollider(false)
    activityView.Show(gameTitle,rarity,xpGained,"Patterns left")
    readyToPlayView.Show(OnPlay,OnHelp)
    SetProgress()
end

function OnPlay()
    readyToPlayView.Hide()
    PlaySequence()
end

function OnHelp()
    Chat:DisplayChatBubble(self.transform,gameDescription,"Rules")
end

function SetProgress()
    local stepsLeft = stepsRequired - #sequence
    local label = stepsLeft
    local pc = ((stepsRequired - stepsLeft)/stepsRequired)
    activityView.SetProgress(label,pc)
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
                    if(#sequence == stepsRequired)then
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
    UnitializeGame()
    Show()
end

function LevelComplete()
    save.AddDiscoveredAnimation(self.name)
    tapHandler.enabled = false
    animator:SetBool("Discovered",true)
    save.AddPetXp(xpGained)
    FinishGame()
end

function PlayNote(id)
    audio.Play("Note"..id)
end

function SetCollider(isActive)
    self.gameObject:GetComponent(SphereCollider).enabled = isActive
end