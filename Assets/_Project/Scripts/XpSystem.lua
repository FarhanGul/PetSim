--!Type(Module)
local uiComponents = require("UIComponents")

function new()
    local this = {}
    local xp = 0
    local baseXp = 100
    local growthFactor = 1.5

    -- xp needed for the current level (will be updated)
    local targetXp = baseXp

    -- The current XP progress displayed in the UI (for smooth animation)
    local displayedXp = 0

    -- The actual (target) XP progress within the current level
    local targetProgress = 0

    local lerpSpeed = 5

    local uiXpFill    -- VisualElement for the XP bar fill
    local uiLevelText -- UILabel for the level text
    local level = 1

    -- Converts a total xp value to a level.
    -- Returns: currentLevel, xpProgress (in current level), xpNeeded (for next level)
    local function XpToLevel(xpValue)
        local currentLevel = 1
        local xpNeeded = baseXp
        while xpValue >= xpNeeded do
            xpValue = xpValue - xpNeeded
            currentLevel = currentLevel + 1
            xpNeeded = baseXp * (growthFactor ^ (currentLevel - 1))
        end
        return currentLevel, xpValue, xpNeeded
    end

    -- Creates the UI and initializes the XP display.
    function this.Create(initialXp)
        xp = initialXp or 0
        local currentLevel, currentProgress, xpNeeded = XpToLevel(xp)
        level = currentLevel
        targetXp = xpNeeded
        targetProgress = currentProgress
        displayedXp = currentProgress

        local ve = VisualElement.new()

        -- Create level text UI (convert level to string)
        uiLevelText = uiComponents.Text(tostring(level))
        ve:Add(uiLevelText)

        -- Create XP bar UI
        local xpBar = uiComponents.Element({"xp-bar"})
        uiXpFill = uiComponents.Element({"xp-bar-fill"})
        xpBar:Add(uiXpFill)
        ve:Add(xpBar)

        return ve
    end

    -- Adds XP and recalculates level/progress.
    -- Multiple calls will update the targetProgress, and the animation (in Update) will catch up smoothly.
    function this.AddXp(delta)
        xp = xp + delta
        local newLevel, currentProgress, xpNeeded = XpToLevel(xp)

        if newLevel > level then
            level = newLevel
            uiLevelText:SetPrelocalizedText(tostring(level))
            -- (Optional) Notify a level-up event here.
        end

        targetXp = xpNeeded
        targetProgress = currentProgress
    end

    -- Updates the UI elements.
    -- Call this every frame with the frame's deltaTime.
    function this.Update(deltaTime)
        -- Smoothly interpolate displayedXp toward targetProgress
        displayedXp = displayedXp + (targetProgress - displayedXp) * lerpSpeed * deltaTime
        local progressPercent = math.min(displayedXp / targetXp, 1.0) * 100
        uiXpFill.style.width = StyleLength.new(Length.Percent(progressPercent))
    end

    return this
end
