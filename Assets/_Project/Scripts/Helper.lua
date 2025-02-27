--!Type(Module)

function ShuffleArray(arr)
    local n = #arr
    for i = n, 2, -1 do
        local j = math.random(i) -- Generate a random index
        arr[i], arr[j] = arr[j], arr[i] -- Swap elements
    end
end

function GetRandomExcluding(from, to, exclude)
    local rand = math.random(from , to)
    while( exclude[rand] ~= nil) do
        rand = math.random(from , to)
    end
    return rand
end

function InjectIds(structure)
    local newStructure = {}
    local id = 1
    for k, v in pairs(structure) do
        newStructure[k] = {
            id = k,
            value = v
        }
    end
    structure = newStructure
end

function GetNextKey(structure, currentKey)
    for i = 1, #structure do
        if structure[i].key == currentKey and i < #structure then
            return structure[i + 1].key
        end
    end
    return nil
end

function GetValue(structure, searchKey)
    for i = 1, #structure do
        if structure[i].key == searchKey then
            return structure[i]
        end
    end
    return nil
end