displayTime = 300
ondutycommand = 'onduty'
passwordmode = true
password = 'pulisia'

blip = nil
blips = {}

local onduty = false

RegisterCommand(ondutycommand, function(source, args)
    if passwordmode then 
        if args[1] == password then
            if not onduty then 
                onduty = true
                TriggerEvent('chatMessage', '', {255,255,255}, '^2You are now ^*On-Duty^r^2 and you are able to recieve 911 calls.')
            else
                onduty = false
                TriggerEvent('chatMessage',  '', {255,255,255}, '^1You are now ^*Off-Duty^r^1 and you will no longer be able to recieve 911 calls.')
            end
        else
            TriggerEvent('chatMessage', '', {255,255,255}, '^1Incorrect Password')
        end
    else
        if not onduty then 
            onduty = true
            TriggerEvent('chatMessage', '', {255,255,255}, '^2You are now ^*On-Duty^r^2 and you are able to recieve 911 calls.')
        else
            onduty = false
            TriggerEvent('chatMessage', '', {255,255,255}, '^1You are now ^*Off-Duty^r^1 and you will no longer be able to recieve 911 calls.')
        end
    end 
end)


Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/911', 'Submits a 911 call to the Emergency Services!', {
    { name="Report", help="Enter the incident/report here!" }
})
end)

RegisterNetEvent('911:setBlip')
AddEventHandler('911:setBlip', function(name, x, y, z)
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 66)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('911 Call - ' .. name)
    EndTextCommandSetBlipName(blip)
    table.insert(blips, blip)
    Wait(displayTime * 1000)
    for i, blip in pairs(blips) do 
        RemoveBlip(blip)
    end
end)

RegisterNetEvent('911:sendtoteam')
AddEventHandler('911:sendtoteam', function(name, location, msg, x, y, z)
    if onduty then 
        TriggerServerEvent('911:sendmsg', name, location, msg, x, y, z)
    end
end)

RegisterCommand('entorno', function(source, args)
    local name = GetPlayerName(PlayerId())
    local ped = GetPlayerPed(PlayerId())
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local street = GetStreetNameAtCoord(x, y, z)
    local location = GetStreetNameFromHashKey(street)
    local msg = table.concat(args, ' ')
    if args[1] == nil then
        TriggerEvent('chatMessage', '^5911', {255,255,255}, ' ^7Please enter your ^1report/issue.')
    else
        TriggerServerEvent('911', location, msg, x, y, z, name)
    end
end)

