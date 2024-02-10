local isPauseMenuActive = false
local mapProp = "prop_tourist_map_01"
local mapPropObject = nil 
function startMapAnimation()
    local playerPed = PlayerPedId()

    RequestModel(mapProp)
    while not HasModelLoaded(mapProp) do
        Wait(1)
    end

    RequestAnimDict("amb@world_human_tourist_map@male@base")
    while not HasAnimDictLoaded("amb@world_human_tourist_map@male@base") do
        Wait(1)
    end

    mapPropObject = CreateObject(GetHashKey(mapProp), 0, 0, 0, true, true, true) -- Store the prop object globally
    local rightHandIndex = GetPedBoneIndex(playerPed, 57005)
    AttachEntityToEntity(mapPropObject, playerPed, rightHandIndex, 0.09, 0.02, -0.08, -80.0, 0.0, 0.0, true, true, false, true, 1, true)
    
    TaskPlayAnim(playerPed, "amb@world_human_tourist_map@male@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
end

function stopMapAnimation()
    ClearPedTasks(PlayerPedId())
    RemoveAnimDict("amb@world_human_tourist_map@male@base")
    if mapPropObject and DoesEntityExist(mapPropObject) then
        DeleteObject(mapPropObject)
        mapPropObject = nil -- Clear the reference after deletion
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)

        if IsPauseMenuActive() and not isPauseMenuActive then
            isPauseMenuActive = true
            startMapAnimation()
        elseif not IsPauseMenuActive() and isPauseMenuActive then
            isPauseMenuActive = false
            stopMapAnimation()
        end
    end
end)
