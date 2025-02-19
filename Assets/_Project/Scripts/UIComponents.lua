--!Type(Module)

function Element(classList)
    local element = VisualElement.new()
    for i = 1, #classList do
        element:AddToClassList(classList[i])
    end
    return element
end

function Text(text)
    local label = UILabel.new()
    label:SetPrelocalizedText(text)
    return label
end

function TextButton(text,onPressed,enabled)
    local button = UIButton.new()
    button:AddToClassList(enabled and "bg-black" or "bg-grey")
    local label = UILabel.new()
    label:AddToClassList("text-white")
    label:SetPrelocalizedText(text)
    button:Add(label)
    button:RegisterPressCallback(onPressed)
    return button
end

function AbsoluteStretch()
    local container = VisualElement.new()
    container:Add("absolute-stretch")
    return container
end

function XpBar()
    
end