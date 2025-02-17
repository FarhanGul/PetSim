--!Type(Module)

function TextButton(text,onPressed)
    local button = UIButton.new()
    button:AddToClassList("bg-color-black")
    local label = UILabel.new()
    label:AddToClassList("text-color-white")
    label:SetPrelocalizedText(text)
    button:Add(label)
    button:RegisterPressCallback(onPressed)
    return button
end