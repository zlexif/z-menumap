
local isPauseMenuActive = false
local mapProp = "prop_tourist_map_01" 
local mapBone = 60309 

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

    local mapObject = CreateObject(GetHashKey(mapProp), 0, 0, 0, true, true, true)
    local rightHandIndex = GetPedBoneIndex(playerPed, 57005) -- Right hand bone index

    local positionOffset = {x = 0.09, y = 0.02, z = -0.08}
    local rotation = {x = -80.0, y = 0.0, z = 0.0}

    AttachEntityToEntity(mapObject, playerPed, rightHandIndex, positionOffset.x, positionOffset.y, positionOffset.z, rotation.x, rotation.y, rotation.z, true, true, false, true, 1, true)
    
    TaskPlayAnim(playerPed, "amb@world_human_tourist_map@male@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
end


function stopMapAnimation()
    ClearPedTasks(PlayerPedId())
    RemoveAnimDict("amb@world_human_tourist_map@male@base")
    local playerPed = PlayerPedId()
    local object = GetClosestObjectOfType(GetEntityCoords(playerPed), 5.0, GetHashKey(mapProp), false, false, false)
    if DoesEntityExist(object) then
        DeleteObject(object)
    end
end

-- Main loop to check for pause menu status
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300) -- Check every 300ms to reduce performance impact

        if IsPauseMenuActive() and not isPauseMenuActive then
            isPauseMenuActive = true
            startMapAnimation()
        elseif not IsPauseMenuActive() and isPauseMenuActive then
            isPauseMenuActive = false
            stopMapAnimation()
        end
    end
end)
