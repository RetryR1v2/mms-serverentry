Config = {}

Config.defaultlang = "de_lang"

Config.Debug = true

Config.WhitelistCommand = 'entry'  -- /Rein ID SPOT  Exaple /Rein 23 SD
Config.SpawnPoint = vector3(3288.21, -1318.24, 51.75)
Config.SpawnRadius = 25
Config.CallAdminCommand = 'callentry'
Config.CallAdminCooldown = 60 -- Time in Sec

Config.AdminGroups = {
    { Group = 'admin' },
    { Group = 'moderator' },
    { Group = 'supporter' },
}

Config.UseReinSpots = true

Config.ReinSpots = {
    { Spot = 'SD', Coords = vector3(2777.43, -1532.59, 48.54) },
    { Spot = 'WP', Coords = vector3(452.42, 2248.43, 248.94) },
}