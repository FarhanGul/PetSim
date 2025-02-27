--!Type(Module)
local data = require("GameData")

function Create(npcName,npcChatBubbleTransform)
    local this = {}
    local dialogueList = {}
    local Message = function(speaker,message)
        local this = {}
        this.speakerName = speaker == "npc" and npcName or "You"
        this.speaker = speaker == "npc" and npcChatBubbleTransform or client.localPlayer.character.chatBubbleTransform
        this.message = message
        return this
    end
    local OnEnd
    local ShowNextMessage 
    ShowNextMessage = function(messageIndex)
        if(messageIndex > #dialogueList) then
            OnEnd()
            return
        end
        local entry = dialogueList[messageIndex]
        Chat:DisplayChatBubble(entry.speaker,entry.message,entry.speakerName)
        Timer.After(data.intervals.timeUntilNextChat, function() 
            ShowNextMessage(messageIndex+1)
        end)
    end
    this.NpcSays = function(message)
        table.insert(dialogueList,Message("npc", message))
    end
    this.PlayerSays = function(message)
        table.insert(dialogueList,Message("player", message))
    end
    this.Start = function(onEnd)
        if(data.debug.skipDialogue) then
            onEnd()
            return
        end
        OnEnd = onEnd
        ShowNextMessage(1)
    end
    return this
end