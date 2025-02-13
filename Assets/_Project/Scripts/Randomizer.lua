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