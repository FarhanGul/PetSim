--!Type(Client)

local save = require("SaveManager")
local data = require("GameData")
local events = require("EventManager")
local audio = require("AudioManager")

--!SerializeField
local pulseObjects : { GameObject } = {}

--!SerializeField
local rtsCam : CustomRTSCamera = nil

local stoppingDistance = 6
local waitBeforeSequencePlays = 1
local pulseDuration = 0.25
local waitBetweenPulses = 0.25
local pet = nil
local readyToPlayView = nil
local activityView = nil
local sequence = nil
local acceptingInputForStep = nil
local animator : Animator
local tapHandler : TapHandler
local gameData
local madeAtleastOneCorrectGuess = false
local collider : SphereCollider

function self:Awake()
    gameData = data.simonSays
    collider = self.gameObject:GetComponent(SphereCollider)
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
    events.SubscribeEvent(events.localPetSpawned,function(args)
        pet = args[1]
    end)
    tapHandler.Tapped:Connect(function() 
        if(pet ~= nil) then
            pet.MoveTo(self.transform,stoppingDistance,Show)
        end
    end)
end

function self:Update()
    if(activityView.IsDisplayed() and client.localPlayer.character.isMoving)then
        events.InvokeEvent(events.petTargetUpdated,true)
        GameOver()
    end
end

function Show()
    madeAtleastOneCorrectGuess = false;
    sequence = {}
    SetCollider(false)
    activityView.Show(gameData.title,"Toy",GetXpAtScore(0),"Highscore : "..tostring(save.simonSaysHighscore))
    readyToPlayView.Show(OnPlay,OnHelp)
    SetProgress()
    rtsCam:SmoothCenterOnTarget(self.transform:Find("CenterOn"), 12, 15)
end

function GetXpAtScore(score)
    if(score == 0) then return 0 end
    -- Base XP for completing any round
    local baseXp = 4

    -- Use exponential growth
    local multiplier = math.pow(1.5, score)
    local xp = math.floor(baseXp * multiplier)

    return math.min(xp, 25000)
end

function TestGrowthFunction()
    for i = 0 , 100 do
        print(tostring(i).." - "..tostring(GetXpAtScore((i))))
    end
end

function OnPlay()
    readyToPlayView.Hide()
    PlaySequence()
end

function OnHelp()
    Chat:DisplayChatBubble(client.localPlayer.character.chatBubbleTransform,gameData.description,"You")
end

function SetProgress()
    local score = #sequence
    if(score > save.simonSaysHighscore)then
        activityView.SetProgress(tostring(score),1)
        activityView.SetProgressDescription("New Highscore!")
    else
        local label = tostring(score).." / "..tostring(save.simonSaysHighscore)
        local pc = score/save.simonSaysHighscore
        activityView.SetProgress(label,pc)
    end
    activityView.SetXpGained(GetXpAtScore(score))
end

function PlaySequence()
    acceptingInputForStep = nil
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
                madeAtleastOneCorrectGuess = true
                if(acceptingInputForStep == #sequence)then
                    PlaySequence()
                else
                    acceptingInputForStep += 1
                end
            else
                audio.Play("GameOver")
                GameOver()
                Show()
            end
        end)
    end
end

function GameOver()
    if(madeAtleastOneCorrectGuess)then
        local score = #sequence
        if(score > save.simonSaysHighscore)then
            save.SetSimonSaysNewHighscore(score)
        end
        save.AddPetXp(GetXpAtScore(#sequence))
        save.CompleteObjective("firstPlay")
    end
    activityView.Hide()
    readyToPlayView.Hide()
    acceptingInputForStep = nil
    SetCollider(true)
end

function PlayNote(id)
    if(id == nil) then return end
    audio.Play("Note"..id)
end

function SetCollider(isActive)
    collider.enabled = isActive
end