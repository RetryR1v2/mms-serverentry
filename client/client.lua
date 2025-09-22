local VORPcore = exports.vorp_core:GetCore()

if Config.Debug then
    Citizen.Wait(5000)
    Citizen.CreateThread(function()
        TriggerEvent('mms-serverentry:client:WhitelistCheck')
    end)
end

RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function()
    Citizen.Wait(10000)
    TriggerEvent('mms-serverentry:client:WhitelistCheck')
end)


RegisterNetEvent('mms-serverentry:client:WhitelistCheck')
AddEventHandler('mms-serverentry:client:WhitelistCheck',function()
    local ImWhitelisted = VORPcore.Callback.TriggerAwait('mms-serverentry:callback:WhitelistCheck')
    while not ImWhitelisted do
        ImWhitelisted = VORPcore.Callback.TriggerAwait('mms-serverentry:callback:WhitelistCheck')
        local MyCoords = GetEntityCoords(PlayerPedId())
        local Distance = #(Config.SpawnPoint - MyCoords)
        if Distance > Config.SpawnRadius and not ImWhitelisted then
            SetEntityCoords(PlayerPedId(),Config.SpawnPoint.x,Config.SpawnPoint.y,Config.SpawnPoint.z - 0.8,true,false,false,true)
            VORPcore.NotifyRightTip(_U('YouAreNotWhitelisted'),5000)
        end
        Citizen.Wait(1500)
    end
end)

