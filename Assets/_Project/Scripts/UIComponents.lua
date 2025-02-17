--!Type(Module)

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