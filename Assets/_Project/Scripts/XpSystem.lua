--!Type(Module)
local uiComponents = require("UIComponents")
local data = require("GameData")

function new()
    local this = {}
    local xp = 0
    local lerpSpeed = 5
    local uiXpFill
    local uiLevelText : UILabel
    local level
    local totalXpInCurrentLevel
    local xpEarnedInCurrentLevel

    function Calculate()
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

    function UpdateStyle()
        uiLevelText:SetPrelocalizedText(level)
        uiXpFill.style.width = StyleLength.new(Length.Percent((xpEarnedInCurrentLevel/totalXpInCurrentLevel)*100))
    end

    function this.Create(initialXp)
        xp = initialXp
        Calculate()
        local ve = VisualElement.new()
        uiLevelText = uiComponents.Text()
        ve:Add(uiLevelText)
        local xpBar = uiComponents.Element({"xp-bar"})
        uiXpFill = uiComponents.Element({"xp-bar-fill"})
        xpBar:Add(uiXpFill)
        ve:Add(xpBar)
        UpdateStyle()
        return ve
    end

    function this.AddXp(delta)
        xp += delta
        xp = Mathf.Min(xp,data.petXpProgression[#data.petXpProgression])
        Calculate()
        UpdateStyle()
    end

    return this
end
