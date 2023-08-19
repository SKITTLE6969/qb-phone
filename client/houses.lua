local QBCore = exports['qb-core']:GetCoreObject()

-- -- NUI Callback

-- RegisterNUICallback('GetPlayerHouses', function(_, cb)
--     QBCore.Functions.TriggerCallback('qb-phone:server:GetPlayerHouses', function(Houses)
--         cb(Houses)
--     end)
-- end)

-- RegisterNUICallback('GetPlayerKeys', function(_, cb)
--     QBCore.Functions.TriggerCallback('qb-phone:server:GetHouseKeys', function(Keys)
--         cb(Keys)
--     end)
-- end)

-- RegisterNUICallback('SetHouseLocation', function(data, cb)
--     SetNewWaypoint(data.HouseData.HouseData.coords.enter.x, data.HouseData.HouseData.coords.enter.y)
--     QBCore.Functions.Notify("GPS satt til " .. data.HouseData.HouseData.adress .. "!", "success")
--     cb("ok")
-- end)

-- RegisterNUICallback('RemoveKeyholder', function(data, cb)
--     TriggerServerEvent('qb-houses:server:removeHouseKey', data.HouseData.name, {
--         citizenid = data.HolderData.citizenid,
--         firstname = data.HolderData.charinfo.firstname,
--         lastname = data.HolderData.charinfo.lastname,
--     })

--     cb("ok")
-- end)

-- RegisterNUICallback('TransferCid', function(data, cb)
--     local TransferedCid = data.newBsn

--     QBCore.Functions.TriggerCallback('qb-phone:server:TransferCid', function(CanTransfer)
--         cb(CanTransfer)
--     end, TransferedCid, data.HouseData)
-- end)

-- RegisterNUICallback('FetchPlayerHouses', function(data, cb)
--     QBCore.Functions.TriggerCallback('qb-phone:server:MeosGetPlayerHouses', function(result)
--         cb(result)
--     end, data.input)
-- end)

-- RegisterNUICallback('SetGPSLocation', function(data, cb)
--     SetNewWaypoint(data.coords.x, data.coords.y)
--     QBCore.Functions.Notify('GPS satt!', "success")

--     cb("ok")
-- end)

-- RegisterNUICallback('SetApartmentLocation', function(data, cb)
--     local ApartmentData = data.data.appartmentdata
--     local TypeData = Apartments.Locations[ApartmentData.type]

--     SetNewWaypoint(TypeData.coords.enter.x, TypeData.coords.enter.y)
--     QBCore.Functions.Notify('GPS satt!', "success")

--     cb("ok")
-- end)

-- NUI Callback

RegisterNUICallback('SetupHouses', function(_, cb)
    lib.callback('ps-housing:server:GetPlayerProperties', false, function(Houses)
        cb(Houses)
    end)
end)

RegisterNUICallback('gpsProperty', function(data, cb)
    print(data.house)
    local house = data.house
    local property = house.propertyId

    exports['ps-housing']:HouseTrack(property)

    --TriggerServerEvent('setPlayerWaypoint', property)

    TriggerEvent('qb-phone:client:CustomNotification', "PROPERTIES", "GPS Marker Set!", "fas fa-car", "#e84118", 5000)

    cb("ok")
end)

RegisterNUICallback('GiveKeys', function(data, cb)
    TriggerServerEvent('qb-phone:server:giveKeys', data)
    cb("ok")
end)

RegisterNUICallback('KickPlayer', function(data, cb)
    TriggerServerEvent("ps-housing:server:removeAccess", data.propertyId, data.playerId)
    cb("ok")
end)

RegisterNetEvent('qb-phone:client:giveKeys', function(property, toplayer)
    TriggerServerEvent("ps-housing:server:addAccess", property, toplayer)
end)

RegisterNUICallback('GetPlayersWithAccess', function(data, cb)
    local propertyId = data.propertyId
    local playersWithAccess = lib.callback.await("ps-housing:cb:getPlayersWithAccess", source, propertyId)
    cb(playersWithAccess)
end)
