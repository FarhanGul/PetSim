--!Type(Module)
local data = require("GameData")

function new(xpFill,xpRequiredUntilNextLevel,xpDescription,age)
    local this = {}
    local level
    local totalXpInCurrentLevel
    local xpEarnedInCurrentLevel

    function GetAgeText()
        if(level == 1) then return "Baby"
        elseif(level == 2) then return "Adolescent"
        else return "Adult"
        end
    end

    function Calculate(xp)
        xp = Mathf.Min(xp,data.petXpProgression[#data.petXpProgression])
        local progression = data.petXpProgression
        for i = 1 , #progression do
            if (xp <= progression[i] or i == #progression) then
                level = i
                if(i == 1) then
                    totalXpInCurrentLevel = progression[i]
                    xpEarnedInCurrentLevel = xp
                else
                    totalXpInCurrentLevel = progression[i] - progression[i-1]
                    xpEarnedInCurrentLevel = xp - progression[i-1]
                end
                return
            end
        end
    end

    function this.Update(xp)
        Calculate(xp)
        if(level == #data.petXpProgression)then
            xpDescription.style.display = DisplayStyle.None
            xpFill.style.width = StyleLength.new(Length.Percent((100)))
            xpRequiredUntilNextLevel.text = "Max Level"
        else

            xpRequiredUntilNextLevel.text = (totalXpInCurrentLevel - xpEarnedInCurrentLevel)
            xpFill.style.width = StyleLength.new(Length.Percent((xpEarnedInCurrentLevel/totalXpInCurrentLevel)*100))
            xpDescription.style.display = DisplayStyle.Flex
        end
        age.text = GetAgeText()
    end

    return this
end