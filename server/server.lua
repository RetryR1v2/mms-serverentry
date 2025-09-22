-- Server Side
local VORPcore = exports.vorp_core:GetCore()

local HasCooldown = false
local CooldownTimer = 0

VORPcore.Callback.Register('mms-serverentry:callback:WhitelistCheck', function(source,cb)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local CharID = Character.charIdentifier
    local ImWhitelisted = false
    local MyWhitelist = MySQL.query.await("SELECT * FROM mms_einreise WHERE charidentifier=@charid", { ["charid"] = CharID})
    if #MyWhitelist > 0 then
        ImWhitelisted = true
        return cb(ImWhitelisted)
    else
        return cb(ImWhitelisted)
    end
end)

RegisterCommand(Config.WhitelistCommand, function(source, args, rawcommand)
    local src = source
    local ID = args[1]
    local SPOT = args[2]
    local IDFound = false
    local AdminChar = VORPcore.getUser(src).getUsedCharacter
    local AdminName = AdminChar.firstname .. ' ' .. AdminChar.lastname
    local ImAdmin = false
    local MyGroup = AdminChar.group
    -- Check if Im Admin

    for h,v in ipairs(Config.AdminGroups) do
        if v.Group == MyGroup then
            ImAdmin = true
        end
    end

    if ImAdmin then

        -- Check if Player Exists
        for h,v in ipairs(GetPlayers()) do
            if v == ID then
                IDFound = true
            end
        end

        if IDFound then
            local NewChar = VORPcore.getUser(ID).getUsedCharacter
            local NewIdentiefier = NewChar.identifier
            local NewCharIdentifier = NewChar.charIdentifier
            local NewCharName = NewChar.firstname .. ' ' .. NewChar.lastname
            local AlreadyWhitelisted = MySQL.query.await("SELECT * FROM mms_einreise WHERE charidentifier=@charid", { ["charid"] = NewCharIdentifier})
            if #AlreadyWhitelisted > 0 then
                VORPcore.NotifyRightTip(src,_U('THISIDALREADYWHITELSITED'),5000)
            else
                MySQL.insert('INSERT INTO `mms_einreise` (identifier, charidentifier, name, admin) VALUES (?, ?, ?, ?)',
                {NewIdentiefier,NewCharIdentifier,NewCharName,AdminName}, function()end)
                VORPcore.NotifyRightTip(ID,_U('YourAreWhitelisted'),5000)
                VORPcore.NotifyRightTip(src,_U('NewPlayerWhitelsited'),5000)
                if Config.UseReinSpots then
                    local SpotFound = false
                    for h,v in ipairs(Config.ReinSpots) do
                        if v.Spot == SPOT then
                            SpotFound = true
                            local Ped = GetPlayerPed(ID)
                            SetEntityCoords(Ped,v.Coords.x,v.Coords.y,v.Coords.z,true,false,false,true)
                        end
                    end
                    if not SpotFound then
                        VORPcore.NotifyRightTip(src,_U('SPOTNOTFOUND'),5000)
                    end
                end
            end
        else
            VORPcore.NotifyRightTip(src,_U('IDNOTFOUND'),5000)
        end
    else
        VORPcore.NotifyRightTip(src,_U('NORIGHTTOUSE'),5000)
    end

end)

RegisterCommand(Config.CallAdminCommand,function(source, args, rawcommand)
    local src = source
    local NewChar = VORPcore.getUser(src).getUsedCharacter
    local NewCharName = NewChar.firstname .. ' ' .. NewChar.lastname
    local NewCharIdentifier = NewChar.charIdentifier
    local ImWhitelisted = false
    local AlreadyWhitelisted = MySQL.query.await("SELECT * FROM mms_einreise WHERE charidentifier=@charid", { ["charid"] = NewCharIdentifier})
    if #AlreadyWhitelisted > 0 then
        ImWhitelisted = true
    end
    if not HasCooldown and not ImWhitelisted then
        local AdminsOnline = 0
        for h,v in ipairs(GetPlayers()) do
            local ID = v
            local Char = VORPcore.getUser(ID).getUsedCharacter
            local MyGroup = Char.group
            for h,v in ipairs(Config.AdminGroups) do
                if v.Group == MyGroup then
                    AdminsOnline = AdminsOnline +1
                    VORPcore.NotifySimpleTop(ID,_U('SomeoneRequestWhitelist'), NewCharName, 5000)
                end
            end
        end
        if AdminsOnline == 0 then
            VORPcore.NotifyRightTip(src,_U('NoAdminHere'),5000)
        end
        HasCooldown = true
        TriggerEvent('mms-serverentry:server:Cooldown')
    elseif HasCooldown then
        VORPcore.NotifyRightTip(src,_U('PleaseWait') .. CooldownTimer / 1000 .. _U('Sec'),5000)
    elseif ImWhitelisted then
        VORPcore.NotifyRightTip(src,_U('AlreadyWhitelisted'),5000)
    end
end)

RegisterServerEvent('mms-serverentry:server:Cooldown',function()
    CooldownTimer = Config.CallAdminCooldown *1000
    while HasCooldown do
        Citizen.Wait(1000)
        CooldownTimer = CooldownTimer - 1000
        if CooldownTimer <= 0 then
            HasCooldown = false
        end
    end
end)