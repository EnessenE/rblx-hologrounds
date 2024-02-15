print("Started Holoscript - E")

local tableversion = {
    "V1.174 - Fixed issue with camera clipping through ceiling in Obstacles 1,2,3,5,7,8,9. Fixed issue in Obstacles10 with hands bieng out of sync. Fixed issue with obstacles1 lava",
    "V1.175 - Added (ugly) patch notes screen.",
    "V1.17501 - Ensigns are not seen as admin anymore",
    "V1.17502 - Ensigns are seen as admin again",
    "V1.1751 - Patch notes screen is a bit prettier",
    "V1.18 - Added Obstacles11, converted all sim models to folders",
    "V1.181 - Fixes to Obstacles11",
    "V1.182 - I created an issue with converting all sims models to folders. The smoothload function didn't have support for it. This has now been added",
    "V1.183 - Removed empty models that also caused issue in 1.181 and 1.182. Also fixed an issue where the holoscript would break if an empty sim is loaded.",
    "V1.183 - Total load time is now default 0 instead of nil. A respawn timeout has been added of 0.03 seconds.",
    "V1.19 - CTP now doesn't recognise a dead player as a player who can capture",
    "V1.191 - Removed RCL weapons",
    "V1.192 - Disabled Obstacles11 due to weld bug",
    "V1.2 - Moved erin chat to another discord",
    "V1.21 - Attempt to fix spread issue with firing weapons when user has a bad Connection",
    "V1.3 - Continuing on client improvements: VersionCheck has been updated to be more efficient. Fixed double respawn issue. Removed invisible bricks from S   pyder.",
    "V1.3[2] - Holoscript Quality Of Life improvements. Commands list has been reduced to only useable stuff. ERIN: Cut down the spam of VoltaRing. Removed VoltaWave at the start.",
    "V1.3[3] - Fixed issue with wARC taking to long to load. Reduced use of Volta Lighting in normal commands. Fixed issue where players would get teleported into the void.",
    "V1.3[4] - Rework of RandomGlobalFunctions. Removed GlobalFunctions. More in the next update.",
    "V1.31 - Fix for [starter/weapon]drop giving to many weapons.",
    "V1.4 - Fixed mistakes and added more spawns to ERIN map. Added Masterhand bossfight.",
    "V1.41 - Ready for training",
    "V1.42 - Changed sound for masterhand bossfight, changed way ERIN mech dies",
    "V1.43 - Fixed to deathcam in masterhand bossfight",
    "V1.44 - Fixed an issue with gun spread related to FIRING script. Fixed issue with VersionCheck and objectiveframes not updating.",
    "V1.44[2] - Fixed issue with masterhand health not using math.exe",
    "V1.45 - Final update, support discontinued. Final tuning to ERIN boss.",
    "V1.46 - Epic version of the ERIN boss fight",
    "V1.47 - Removed hidden cmdbar, added !walkspeed, and fixed wrong group ids",
    "V1.48 - Bullets can be seen again by other players,",
    "All recharge station are marked as inactive and all weapons now have infinite battery. Fairriver works again.",
    "Also officer map is still broken",
    "V1.49 - !rt/randomteams works again. Filtering enabled is now supported. Also obstacles11",
    "Imported Dress bossfight/sim. Unfinished but hey have fun",
    "4 new maps (with full FFA support). Bloxburg, RavenRock, Skylands and Depths",
    "Also timer works again",
    "V1.491 - Fixed an error where Dress couldn't be restarted, reduced dress health from 7000 > 1500 p.p. Fixed obstacles5 being gone. Woodtops water doesnt kill anymore and some barricade adjustments in this.",
    "ALL RadioStation spawns are changed/rotated. ALL FF's are now 1 seconds inside simulations. Also you cant cheat obstacles 11 anymore",
    "Added CTP support for Simplicity, BloxBurg, Skylands, RavenRock, Woodtops, RadioStation",
    "Added CTF support for Bastion, Bloxburg, Simplicity, Narrowgill, Skylands, RavenRock, Crown",
    "V1.492 - Added Dust(TDM, FFA, CTP)",
	"V1.493 - Updated chat, you now spawn closer for all obstacle and swordfight sims.",
	"V1.494 - Fixed obstacles5, fixed all TDM spawn issues, fixed chat not loading",
	"V1.5 - Auto mode. !automode to toggle. Fixed juggernaut",
	"V1.51 - Fixed chat, misc errors",
}

script.GUI:WaitForChild("HoloGUI")
_G.VSA1 = tableversion
_G.VSA2 = tableversion[#tableversion]

local ServerMessageEvent = Instance.new("RemoteEvent")
ServerMessageEvent.Name = "ServerMessageEvent"
ServerMessageEvent.Parent = game.ReplicatedStorage

local automode = true

local data = workspace.Data
local x = Instance.new("StringValue")
x.Value = _G.VSA2
x.Name = "Version"
x.Parent = data
local sadkfetrq3 = Instance.new("StringValue")
sadkfetrq3.Value = "GAME_MODE[OFFLINE]"
sadkfetrq3.Name = "Gamemode"
sadkfetrq3.Parent = data

holoscriptleader = true --if true, the holoscript manages the leaderboard.
leaderstatsname = "leaderstats" --Name of leaderstats, its recommmended to leave it to this unless a costum leaderboard is used.
killsname = "KOs" --Name of Kill stats
deathsname = "Wipeouts" --needs to be always set for TDM and elimination

local defaultwalkspeed = 16
local defaulthealth = 100
local defaultjump = 50 

_G.valkey = math.random(1, 9999) --randomizer to not override _G with other scripts. ("But enes, why didnt you just call it something else") Because I can. also had a idea for it but i forgot
_G.plrwalkspeed = defaultwalkspeed --Default settings for players, usefull in special simulations as this allows you to keep it after the players respawn
_G.plrhealth = defaulthealth
_G.jumppower = defaultjump
tdmdeathlimit = 20 --What deathlimit do you want for TDM? A trainer can also set this during a training, but it defaults to this.
elimationdealthlimit = 1 --Deathlimit for elimination
adminvalname = "Admin" .. _G.valkey --Name of admin value, Wouldn't recommend changing it but it >SHOULD< work fine.
alladmins = false --Everyone who joins gets admin if true
passivemessage = 1 --1 is hint, 2 is nothing
autoteamadmin = false --automaticly put people on trainers
trainerteam = game.Teams.Trainers --Path to Trainers team
traineeteam = game.Teams.Trainees --Path to Trainees team
maploadlocation = workspace.HoloScript --Location of where all maps are placed when loaded. I would recommend keeping it to this.

local chatService = game:GetService("Chat")
local Http = game:GetService("HttpService")
local webHook = require(game.ServerScriptService.WebhookAPI)
local myWebHook =
    webHook.new("722536962317221928", "5LEKplhvihs9USwZ5kJP5IwM3nmClS_Jsd-OdBV-PIHKy2EC1htIWhrru-qqydedt9eo")

smoothload = true --smoothloading of simulation, if enabled it is slower but gives performance improvements when loading big maps. If off a model is simply copied to workspace
smoothloadcyclesize = 32 --Cycle size of smoothloading aka how many parts are loaded at time while using smoothload
roundloadtime = true --If true rounds the expected number for loading.

placename = "IRIS" --not used atm
systemname = "IRIS"

_G["Admins" .. _G.valkey] = {"enes130", "Player1", "Player2", "SGAbrett"} --same as highrank admins
_G["AdminsLow" .. _G.valkey] = {"SlashOfDead"} --Same as normal admins
lowrank = 196 --Normal admins
highrank = 199 --Highest level of admins, can take admin from a lowrank
groupid = 3747606

disablemsg = true --disable msg command, doesnt affect loading messages
disableALLmessages = false --disables ALL messages created by this script
defaulttime = 10 --default msg time if non is set
mesmode = 4 --msg mode, 1 is with a default workspace message. 2 is a VERY simple gui. The gui is there if you want add costumization or something  �\_(?)_/�
messagetimeout = 1 --If multiple messages are called at the same time, this is how long the second message will wait until it overrides the one before it.
autosimulation = true --automatic tries to get all simulations if true. If false it needs to do it manually.
simlocation = game.ServerStorage.Sims --Location of simulations
guilocation = script.GUI --Location of GUI it uses to show messages to player

LeftHolodoor = game.Workspace.Lobby.MainHoloDoors.Left --Just put in nil if not used
RightHolodoor = game.Workspace.Lobby.MainHoloDoors.Right
maxholodoordistance = 150
holodoorsteps = 0.1

toolstorage = game.ServerStorage.Weapons --Location of weapons
toolstorage:Clone().Parent = game.ReplicatedStorage
defaultweapons = {"W17", "Y14"} --default weapons that are given if nothing is set. You can set weapons in the "loadprogramcustcheck" function
neverremoveweapons = {} --Weapons that never get removed by the holoscript.

soundonload = nil --Plays a sound at the start/end of a simulation
soundloadplaybackspeed = 1 --Playbackspeed of sound
soundonend = nil --SoundId here
soundendplaybackspeed = 1
soundonelimination = 142445692
soundeliplaybackspeed = 1
soundtimelimit = 10 --seconds
soundlocation = workspace --Location of where sound will be put. If in workspace everyone will hear it at the same time with equal volume.

_G.CaptureGoal = 500
_G.FlagCaptureGoal = 3

_G.enforceddeathlimit = false --keep on false. This is set by script
defaultdeathlimit = 1 --This deathlimit is default.
_G.deathlimit = defaultdeathlimit

juggernauthealth = 350 --Juggernaut health per player
juggernautspeed = 20 --Juggernaut walkspeed
juggernautjump = 45 --Juggernaut jumppowere
juggernautweapons = {"T11", "SKP", "L95"} --Weapons for the opposing team
juggernautfighter = {"REX"} --Weapons for the juggernaut

respawnonend = true
teleportonend = false
teleportposition = nil

--These teams are created automaticly, you can set the teamnames and colors here
specialteam = "Team"
specialteamcolor = BrickColor.new("Sand blue")

blueteamname = "Blue team"
blueteamcolor = BrickColor.new("Sand blue")

redteamname = "Red team"
redteamcolor = BrickColor.new("Dusty Rose")

ffateamname = "Free For All"
ffateamcolor = BrickColor.new("White")
-----------------------------------------

defwalkspeed = _G.plrwalkspeed
defhealth = _G.plrhealth
defjump = _G.jumppower

currentsim = nil
currentgamemode = sadkfetrq3
running = false
_G.timeoff = true
timeenforce = false
opendoor = false
timetarget = 0
waitnum = 0

local characters = {"!", "?", "{"} --1 char max on each
local command = {
    "admin",
    "unadmin",
    "msg",
    "msgmode",
    "load",
    "end",
    "smoothload",
    "mode",
    "gamemode",
    "timer",
    "endtimer",
    "tdmdeathlimit",
    "commands",
    "primary",
    "secondary",
    "gamemodes",
    "holodoors",
    "resetstats",
    "deathlimit",
    "maps",
    "weapons",
    "ctplimit",
    "capturelimit",
	"walkspeed",
	"automode"
}
local usefullcommands = {
    "admin",
    "unadmin",
    "load",
    "end",
    "mode",
    "gamemode",
    "timer",
    "endtimer",
    "tdmdeathlimit",
    "commands",
    "primary",
    "secondary",
    "gamemodes",
    "holodoors",
    "resetstats",
    "deathlimit",
    "maps",
    "weapons",
    "ctplimit",
    "capturelimit",
    "walkspeed"
}

local gamemodes = {"TDM", "Elimination", "Juggernaut", "Objective", "FFA", "CTP", "CTF"}
local maps = {}
local tttt = nil
function loadprogramcustcheck(program)
    if game.ServerStorage.SimAssets:FindFirstChild(program) ~= nil then
        for index, child in pairs(game.ServerStorage.SimAssets[program]:GetChildren()) do
            child:Clone().Parent = maploadlocation[program]
        end
    end
    local loadedMap = maploadlocation[program]

    if loadedMap then
        if loadedMap:FindFirstChild("CloseSpawns") then
            warn("Setting closer spawns")
			CloserSpawn()
		else
			custassignbricks()
        end
    end

    resetstats()
    if program == "Erin" then
        warn("Oh let's go!")
        maploadlocation[program].ERIN.Transform.Disabled = true
        currentgamemode.Value = "GAME_MODE[BOSS]"
        createspecial()
        custassignbricks()
        respawnall()
        warn("Current gamemode set to " .. currentgamemode.Value .. " by script")
        wait(2)
        coroutine.resume(
            coroutine.create(
                function()
                    repeat
                        wait()
                    until requestteam(game.Teams.Team) <= 0
                    warn("TEAM TEAM IS EMPTY")
                    local x, s = requestteam(game.Teams.Team)
                    if #s == 0 then
                        _G.MakeGui("You have failed the bossfight! Try again next time.", systemname, 5, "all")
                        workspace.HoloScript.Erin:ClearAllChildren()
                        wait(1)
                        realendprogram()
                    end
                end
            )
        )
    elseif program == "Masterhand" then
        warn("Oh let's go!")
        currentgamemode.Value = "GAME_MODE[BOSS]"
        createspecial()
        custassignbricks()
        _G.plrhealth = 500
        _G.plrwalkspeed = 25
        respawnall()
        wait()
        _G.MakeGui("WARNING: Deathlimit changed to 7", systemname, 5, "all")
        _G.deathlimit = 7
        _G.enforceddeathlimit = true
        givetools({"SUF", "L95", "SKP", "C22"})
        warn("Current gamemode set to " .. currentgamemode.Value .. " by script")
        wait(.1)
        respawnall()
    elseif program == "Dress" then
        warn("Oh let's go!")
        currentgamemode.Value = "GAME_MODE[BOSS]"
        game:GetService("ServerStorage").Assets.Dress:Clone().Parent = maploadlocation[program]
        createspecial()
        custassignbricks()
        _G.plrhealth = 500
        _G.plrwalkspeed = 25
        respawnall()
        wait()
        _G.MakeGui("WARNING: Deathlimit changed to 7", systemname, 5, "all")
        _G.deathlimit = 7
        _G.enforceddeathlimit = true
        givetools({"SUF", "L95", "SKP", "C22"})
        warn("Current gamemode set to " .. currentgamemode.Value .. " by script")
        wait(.1)
        respawnall()
    elseif program == "Officer" then
        warn("Oh let's go![2]")
        currentgamemode.Value = "GAME_MODE[BOSS]"
        createspecial()
        custassignbricks()
        _G.plrhealth = 500
        wait(.1)
        respawnall()
        warn("Current gamemode set to " .. currentgamemode.Value .. " by script")
        _G.SpecialMessage("An enhanced REX. Unfair isn't it?", 5) --lol
        game.ServerStorage.BossSlayer.Slayer:Clone().Parent = maploadlocation.Officer
        _G.MakeGui("WARNING: Deathlimit changed to 7", systemname, 5, "all")
        _G.deathlimit = 7
        _G.enforceddeathlimit = true
        givetools({"Y14", "W17"})
    elseif program == "Valley" then
        currentgamemode.Value = "GAME_MODE[MISSION]"
    elseif program == "Inquisitor" then
        timepass("02:00:00")
        --copy from serverstorage.assets
        tttt =
            maploadlocation[program].ChildRemoved:Connect(
            function(int)
                local x = int.Name
                warn(x .. " got destroyed in Inquisitor")
                if x ~= nil and x ~= "TankSpawn" then
                    if string.match(x, "Tank") == "Tank" then
                        game.ServerStorage.SimAssets.Inquisitor[x]:Clone().Parent = maploadlocation[program]
                    end
                end
            end
        )
        game.Lighting.OutdoorAmbient = Color3.new(68 / 255, 68 / 255, 68 / 255)
    elseif program == "Train" then
    elseif program == "IndigoI" then
        --script.IndigoI.Forcefield:MakeJoints()
    elseif program == "Swordfight" then
        givetools({"Sword"})
    elseif program == "CeruleanI" then
        game.ServerStorage.Assets.GameGui:Clone().Parent = game.StarterGui
    --game.ServerStorage.Assets.WaterentranceGenerator:Clone().Parent=maploadlocation.CeruleanI
    --game.ServerStorage.Assets.CliffsideGenerator:Clone().Parent=maploadlocation.CeruleanI
    --Moved to new function SimAssets
    --[[local weld1=Instance.new("ManualWeld")
		weld1.Parent= script.CeruleanI.CliffsideGenerator["Integrity - 100%"].Torso
		weld1.Part0 = script.CeruleanI.CliffsideGenerator["Integrity - 100%"].Head
		weld1.Part1 = script.CeruleanI.CliffsideGenerator["Integrity - 100%"].Torso
		local weld2=Instance.new("ManualWeld")
		weld2.Parent= script.CeruleanI.WaterentranceGenerator["Integrity - 100%"].Torso
		weld2.Part0 = script.CeruleanI.WaterentranceGenerator["Integrity - 100%"].Head
		weld2.Part1 = script.CeruleanI.WaterentranceGenerator["Integrity - 100%"].Torso]]
    end
end

function requestteam(team)
    local num = 0
    local s = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            if player.Team == team then
                num = num + 1
                table.insert(s, #s + 1, player.Name)
            end
        end
    end
    return num, s
end

function loadgamemodecustcheck(gamemode)
    if tdmdeathlimit == nil then
        _G.MakeGui("An error occured. The TDM deathlimit has been set to 20.", systemname, 5, "all")
        tdmdeathlimit = 20
    end
    if _G.deathlimit == nil then
        _G.MakeGui("An error occured. The general deathlimit has been set to 1.", systemname, 5, "all")
        _G.deathlimit = 0
    end
    if _G.CaptureGoal == nil then
        _G.MakeGui("An error occured. The CTP pointlimit has been set to 500.", systemname, 5, "all")
        _G.CaptureGoal = 500
    end
    ambient(166, 166, 166)
    data.ShowTag.Value = true
    currentgamemode.Value = "GAME_MODE[" .. string.upper(gamemode) .. "]"
    removeteams()
    resetspawn(maploadlocation[currentsim])
    resetstats()
    if gamemode == "Elimination" then
        removetools()
        givetools(defaultweapons)
        _G.enforceddeathlimit = true
        createteams()
        randomteams()
        respawnall()
        local eli =
            coroutine.create(
            function()
                --I am such a horrible scripter lol
                wait(3)
                _G.MakeGui(
                    "Elimination! When you reach " .. _G.deathlimit .. " death(s) you are out!",
                    systemname,
                    5,
                    "all"
                )
                repeat
                    wait()
                until requestteam(game.Teams[redteamname]) == 0 or requestteam(game.Teams[blueteamname]) == 0
                if requestteam(game.Teams[redteamname]) == 0 and requestteam(game.Teams[blueteamname]) == 0 then
                    _G.MakeGui("ITS A DRAW!", systemname, 5, "all")
                elseif requestteam(game.Teams[redteamname]) == 0 then
                    local x, s = requestteam(game.Teams[blueteamname])
                    _G.MakeGui(
                        blueteamname .. " has won elimination! Players on blue: " .. table.concat(s, ", "),
                        systemname,
                        5,
                        "all"
                    )
                elseif requestteam(game.Teams[blueteamname]) == 0 then
                    local x, s = requestteam(game.Teams[redteamname])
                    _G.MakeGui(
                        redteamname .. " has won elimination! Players on red: " .. table.concat(s, ", "),
                        systemname,
                        5,
                        "all"
                    )
                end
                realendprogram()
            end
        )
        coroutine.resume(eli)
    elseif gamemode == "CTP" then
        data.BlueTarget.Value = _G.CaptureGoal
        data.RedTarget.Value = _G.CaptureGoal
        removetools()
        givetools(defaultweapons)
        createteams()
        randomteams()
        respawnall()
        _G.MakeGui("Your team needs to reach " .. _G.CaptureGoal .. " points to win this match!", systemname, 5, "all")
        _G.MakeGui("Every second you will gain 1 point for each point you have captured.", systemname, 5, "all")
    elseif gamemode == "CTF" then
        data.BlueTarget.Value = _G.FlagCaptureGoal
        data.RedTarget.Value = _G.FlagCaptureGoal
        removetools()
        givetools(defaultweapons)
        createteams()
        randomteams()
        respawnall()
        _G.MakeGui(
            "Your team needs to capture " .. _G.FlagCaptureGoal .. " flag(s) to win this match!",
            systemname,
            5,
            "all"
        )
        _G.MakeGui("Every second you will gain 1 point for each point you have captured.", systemname, 5, "all")
        coroutine.resume(
            coroutine.create(
                function()
                    repeat
                        wait()
                    until data.Red.Value >= data.RedTarget.Value or data.Blue.Value >= data.BlueTarget.Value
                    if data.Blue.Value >= data.BlueTarget.Value then
                        print(blueteamname .. " has won capture the flag!")
                        local x, s = requestteam(game.Teams[blueteamname])
                        _G.MakeGui(
                            blueteamname .. " has won capture the flag! Players on blue: " .. table.concat(s, ", "),
                            systemname,
                            5,
                            "all"
                        )
                    elseif data.Red.Value >= data.RedTarget.Value then
                        print(redteamname .. " has won capture the flag!")
                        local x, s = requestteam(game.Teams[redteamname])
                        _G.MakeGui(
                            redteamname .. " has won capture the flag! Players on red: " .. table.concat(s, ", "),
                            systemname,
                            5,
                            "all"
                        )
                    else
                        _G.MakeGui("Something wierd happened! Contact the developer!", systemname, 5, "all")
                    end
                    realendprogram()
                end
            )
        )
    elseif gamemode == "TDM" then
        removetools()
        givetools(defaultweapons)
        data.BlueTarget.Value = tdmdeathlimit
        data.RedTarget.Value = tdmdeathlimit
        _G.enforceddeathlimit = false
        local tdm =
            coroutine.create(
            function()
                wait(3)
                _G.MakeGui(
                    "Your team needs " .. tdmdeathlimit .. " kill(s) to win this teamdeathmatch!",
                    systemname,
                    5,
                    "all"
                )
                local trd
                local tbd
                repeat
                    wait()
                    local totalreddeath = 0
                    local totalbluedeath = 0
                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v.TeamColor == redteamcolor then
                            totalreddeath = totalreddeath + v.leaderstats[killsname].Value
                        elseif v.TeamColor == blueteamcolor then
                            totalbluedeath = totalbluedeath + v.leaderstats[killsname].Value
                        end
                    end
                    trd = totalreddeath
                    tbd = totalbluedeath
                    data.BlueTarget.Value = tdmdeathlimit
                    data.RedTarget.Value = tdmdeathlimit
                    data.Blue.Value = tbd
                    data.Red.Value = trd
                until totalbluedeath >= tonumber(tdmdeathlimit) or totalreddeath >= tonumber(tdmdeathlimit) or
                    currentgamemode.Value ~= "GAME_MODE[TDM]"
                if tbd >= tonumber(tdmdeathlimit) then
                    print(blueteamname .. " has won the teamdeathmatch!")
                    local x, s = requestteam(game.Teams[blueteamname])
                    _G.MakeGui(
                        blueteamname .. " has won the teamdeathmatch! Players on blue: " .. table.concat(s, ", "),
                        systemname,
                        5,
                        "all"
                    )
                elseif trd >= tonumber(tdmdeathlimit) then
                    print(redteamname .. " has won the teamdeathmatch!")
                    local x, s = requestteam(game.Teams[redteamname])
                    _G.MakeGui(
                        redteamname .. " has won the teamdeathmatch! Players on red: " .. table.concat(s, ", "),
                        systemname,
                        5,
                        "all"
                    )
                end
                if currentgamemode.Value == "GAME_MODE[TDM]" then
                    wait(4)
                    realendprogram()
                end
            end
        )
        coroutine.resume(tdm)
        createteams()
        randomteams()
        respawnall()
    elseif gamemode == "Juggernaut" then
        local jug =
            coroutine.create(
            function()
                removetools()
                currentjug = nil
                local chosen = game.Players:children()[math.random(#game.Players:children())]
                givetools(juggernautweapons)
                createteams()
                if chosen ~= nil then
                    wait(1)
                    _G.MakeGui(chosen.Name .. " will be the juggernaut!", systemname, 5, "all")
                    for _, v in pairs(game.Players:GetPlayers()) do
                        v.TeamColor = redteamcolor
                    end
                    chosen.TeamColor = blueteamcolor
                    respawnall()
                    _G.enforceddeathlimit = true
                    currentjug = chosen
                    for i = 1, #juggernautfighter do
                        for _, v in pairs(toolstorage:GetChildren()) do
                            if string.lower(juggernautfighter[i]) == string.lower(v.Name) then
                                v:Clone().Parent = chosen.Backpack
                            end
                        end
                    end
                    wait(.2)
                    scaleCharacter(chosen.Character, 1.5)
                    local effeects = ((game.Players.NumPlayers) * 125) / 100
                    for i = 1, effeects do
                        _G.lightning(game.Workspace.Lobby.IRIS.Alive.Position, chosen.Character.Torso.Position)
                        chosen.Character.Humanoid.MaxHealth = chosen.Character.Humanoid.MaxHealth + juggernauthealth
                        chosen.Character.Humanoid.Health = chosen.Character.Humanoid.Health + juggernauthealth
                        wait(.03)
                    end
                    chosen.Character.Humanoid.WalkSpeed = juggernautspeed
                    chosen.Character.Humanoid.JumpPower = juggernautjump
                    wait(1)
                    _G.MakeGui("You have " .. _G.deathlimit .. " life(s) to kill the juggernaut!", systemname, 5, "all")
                    if chosen.Character:FindFirstChild("Animate") ~= nil then
                        chosen.Character.Animate.Disabled = true
                        wait(.1)
                        chosen.Character.Animate.Disabled = false
                    end
                    local guis = game.ServerStorage.Assets.JugGui:Clone()
                    guis.Parent = chosen.Character.Torso
                    guis.JugName.Text = chosen.Name
                    local health =
                        coroutine.create(
                        function()
                            repeat
                                wait()
                                for _, player in pairs(game.Players:GetPlayers()) do
                                    if player:FindFirstChild("PlayerGui") ~= nil then
                                        if player.PlayerGui:FindFirstChild("ARCGui") ~= nil then
                                            player.PlayerGui.ARCGui.TopFrame.MessagePart.Text =
                                                chosen.Character.Humanoid.Health
                                            player.PlayerGui.ARCGui.TopFrame.MessagePart.OwnerPart.Text =
                                                "Juggernaut health"
                                        end
                                    end
                                end
                            until currentjug == nil or gamemode ~= "Juggernaut"
                            for _, player in pairs(game.Players:GetPlayers()) do
                                if player:FindFirstChild("PlayerGui") ~= nil then
                                    if player.PlayerGui:FindFirstChild("ARCGui") ~= nil then
                                        player.PlayerGui.ARCGui.TopFrame.MessagePart.Text = ""
                                        player.PlayerGui.ARCGui.TopFrame.MessagePart.OwnerPart.Text = ""
                                    end
                                end
                            end
                        end
                    )
                    coroutine.resume(health)
                    chosen.Character.Humanoid.Died:Connect(
                        function()
                            if currentjug == chosen and gamemode == "Juggernaut" then
                                _G.MakeGui(chosen.Name .. ", the juggernaut has been killed!", systemname, 5, "all")
                                _G.enforceddeathlimit = false
                                currentgamemode.Value = "GAME_MODE[OFFLINE]"
                                currentjug = nil
                                realendprogram()
                            end
                        end
                    )
                end
            end
        )
        coroutine.resume(jug)
    elseif gamemode == "Objective" then
        createteams()
        givetools(defaultweapons)
        randomteams()
        respawnall()
    elseif gamemode == "FFA" and currentsim ~= "Train" then --"Storm blue"
        local ffa =
            coroutine.create(
            function()
                local special = Instance.new("Team")
                special.Parent = game.Teams
                special.Name = ffateamname
                special.TeamColor = ffateamcolor
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v.Team ~= trainerteam then
                        v.Team = special
                    end
                end
                warn("Created special team and set all players")
                spawndetect(maploadlocation[currentsim], special)
                givetools(defaultweapons)
                respawnall()
                _G.enforceddeathlimit = true
                wait(3)
                _G.MakeGui(
                    "Free for all! Kill everybody else! You have " .. _G.deathlimit .. " life(s)!",
                    systemname,
                    5,
                    "all"
                )
                repeat
                    wait()
                until requestteam(special) <= 1
                local x, s = requestteam(special)
                if #s == 0 then
                    _G.MakeGui("No one has won FFA!", systemname, 5, "all")
                else
                    _G.MakeGui(table.concat(s, ", ") .. " has won FFA!", systemname, 5, "all")
                end
                removeteams()
                special:Destroy()
                removetools()
                respawnall()
                realendprogram()
            end
        )
        coroutine.resume(ffa)
    else
        _G.MakeGui("Mode doesn't exist or isn't compatible with this map", systemname, 5, "all")
    end
end

_G.SetObjective = function(who, text)
    print(who, text)
    local target
    local nodo = false
    if who == "all" then
        target = magic
    elseif who then
        nodo = true
    elseif who == nil then
        nodo = true
    end
    if nodo == false then
    end
end

function resetstats()
    for index, child in pairs(game.Players:GetPlayers()) do
        if child:FindFirstChild("leaderstats") ~= nil then
            if child.leaderstats:FindFirstChild(deathsname) ~= nil then
                child.leaderstats[deathsname].Value = 0
            end
            if child.leaderstats:FindFirstChild(killsname) ~= nil then
                child.leaderstats[killsname].Value = 0
            end
        end
    end
end

function ambient(q, w, e)
    game.Lighting.Ambient = Color3.new(q / 255, w / 255, e / 255)
end

function createspecial()
    local special = Instance.new("Team")
    special.Parent = game.Teams
    special.Name = specialteam
    special.TeamColor = specialteamcolor
    for _, v in pairs(game.Players:GetPlayers()) do
        v.TeamColor = specialteamcolor
    end
    warn("Created special team and set all players")
end

function removespecial()
    if game.Teams:FindFirstChild(specialteam) ~= nil then
        game.Teams[specialteam]:Destroy()
        warn("Special team has been removed.")
    end
    if game.Teams:FindFirstChild("Team") ~= nil then
        game.Teams.Team:Destroy()
    end
end

function custassignbricks()
    local c = game.Workspace.Spawns.Red:GetChildren()
    for i = 1, #c do
        c[i].TeamColor = BrickColor.new("Earth green")
        c[i].BrickColor = BrickColor.new("Medium stone gray")
    end
    local v = game.Workspace.Spawns.Blue:GetChildren()
    for i = 1, #v do
        v[i].TeamColor = BrickColor.new("Earth green")
        v[i].BrickColor = BrickColor.new("Medium stone gray")
    end
end

function CloserSpawn()
    local c = game.Workspace.Spawns.Red:GetChildren()
    for i = 1, #c do
        c[i].TeamColor = BrickColor.new("Bright blue")
		c[i].BrickColor = BrickColor.new("Sand blue")
		c[i].Enabled = true
    end
    local v = game.Workspace.Spawns.Blue:GetChildren()
    for i = 1, #v do
		v[i].TeamColor = BrickColor.new("Bright blue")
		v[i].Enabled = true
        v[i].BrickColor = BrickColor.new("Sand blue")
    end
    local v = game.Workspace.SpawnsMain:GetChildren()
    for i = 1, #v do
        local item = v[i]
        if (item.Name ~= "Trainerspawn") then
            item.Enabled = false
        end
    end
end

function ReassignBricks()
    local p = game.Workspace.Spawns.Red:GetChildren()
    for i = 1, #p do
        p[i].TeamColor = BrickColor.new("Dusty Rose")
		p[i].BrickColor = BrickColor.new("Dusty Rose")
		p[i].Enabled = false
    end
    local z = game.Workspace.Spawns.Blue:GetChildren()
    for i = 1, #z do
        z[i].TeamColor = BrickColor.new("Sand blue")
		z[i].BrickColor = BrickColor.new("Sand blue")
		z[i].Enabled = false
    end

    local v = game.Workspace.SpawnsMain:GetChildren()
    for i = 1, #v do
        local item = v[i]
        item.Enabled = true
    end
end

function holoDoors()
    local hl = LeftHolodoor
    local hr = RightHolodoor
    if opendoor == true then
        opendoor = 2
        for z = 1, maxholodoordistance do
            wait()
            for _, v in pairs(hl:GetChildren()) do
                v.CFrame = v.CFrame + Vector3.new(0, 0, holodoorsteps)
            end
            for _, v in pairs(hr:GetChildren()) do
                v.CFrame = v.CFrame + Vector3.new(0, 0, -holodoorsteps)
            end
        end
        opendoor = false
    elseif opendoor == false then
        opendoor = 2
        for z = 1, maxholodoordistance do
            wait()
            for _, v in pairs(hl:GetChildren()) do
                v.CFrame = v.CFrame + Vector3.new(0, 0, -holodoorsteps)
            end
            for _, v in pairs(hr:GetChildren()) do
                v.CFrame = v.CFrame + Vector3.new(0, 0, holodoorsteps)
            end
        end
        opendoor = true
    end
end

function getweapon(what, weaponname, player)
    if toolstorage:FindFirstChild(weaponname) ~= nil then
        if what == "prim" then
            defaultweapons[1] = weaponname
            warn(weaponname .. " has been set as Primary weapon by " .. player.Name)
            _G.MakeGui(weaponname .. " has been set as Primary weapon.", systemname, 2.5, "all")
        elseif what == "secon" then
            defaultweapons[2] = weaponname
            warn(weaponname .. " has been set as Secondary weapon " .. player.Name)
            _G.MakeGui(weaponname .. " has been set as Secondary weapon.", systemname, 2.5, "all")
        else
            warn("Error with WHAT value. Error 017")
        end
    end
end

function scaleCharacter(model, scale)
    if not model or not scale then
        return
    end
    if not _G.ScaleCons then
        _G.ScaleCons = {}
    end
    if _G.ScaleCons[model] then
        _G.ScaleCons[model]:Disconnect()
    end
    local joints = {}
    local parts = {}
    local h = model:findFirstChild("Humanoid")
    if h then
        h.Parent = nil
    end
    local function handleHat(hat)
        --[[    if hat:findFirstChild("GotScaled") then return end
               local praps=Instance.new("Flag")
				praps.Parent=hat
				praps.Name = "GotScaled"
                Spawn(function ()
                        local h = hat:WaitForChild("Handle")
                        local m = h:WaitForChild("Mesh")
                        m.Scale = m.Scale * scale
                end)
                local yInc = (scale-1)*.5
                hat.AttachmentPos = (hat.AttachmentPos * scale) - (hat.AttachmentUp * Vector3.new(yInc,yInc,yInc))]]
        hat:Destroy()
    end
    for _, v in pairs(model:GetChildren()) do
        if v:IsA("BasePart") then
            table.insert(parts, v)
            v.Anchored = true
            v.FormFactor = "Custom"
            for _, j in pairs(v:GetChildren()) do
                if j:IsA("Motor6D") then
                    local t = {
                        Name = j.Name,
                        Parent = v,
                        Part0 = j.Part0,
                        Part1 = j.Part1,
                        C0 = j.C0,
                        C1 = j.C1
                    }
                    table.insert(joints, t)
                    j:Destroy()
                end
            end
        elseif v:IsA("Hat") then
            handleHat(v)
        end
    end
    for _, v in pairs(parts) do
        v.Size = v.Size * scale
        v.Anchored = false
    end
    for _, j in pairs(joints) do
        local c0 = {j.C0:components()}
        local c1 = {j.C1:components()}
        for i = 1, 3 do
            c0[i] = c0[i] * scale
            c1[i] = c1[i] * scale
        end
        j.C0 = CFrame.new(unpack(c0))
        j.C1 = CFrame.new(unpack(c1))
        local n = Instance.new("Motor6D")
        for k, v in pairs(j) do
            n[k] = v
        end
    end
    model.ChildAdded:Connect(
        function(c)
            if c:IsA("Hat") then
            end
        end
    )
    if h then
        h.Parent = model
    end
    if model.Humanoid then
        model.Humanoid:Destroy()
    end
    local human = Instance.new("Humanoid")
    human.Parent = model
    --  _G.ScaleCons[model] = con
end

function removetools()
    for _, v in pairs(game.StarterPack:GetChildren()) do
        --[[local nook1=0
		for i = 1,#neverremoveweapons do
			print(string.lower(neverremoveweapons[i]),string.lower(v.Name))
			if string.lower(neverremoveweapons[i])==string.lower(v.Name) then
				nook1=nook1+1
			end
			if nook1==0 then]]
        v:Destroy()
        --[[end
		end]]
    end
    for _, sub in pairs(game.Players:GetPlayers()) do
        if sub:FindFirstChild("Backpack") ~= nil then
            sub.Backpack:ClearAllChildren()
        else
            warn(sub.Name .. " backpack hasn't been found. Error 011")
        end
        if sub:FindFirstChild("StarterGear") ~= nil then
            sub.StarterGear:ClearAllChildren()
        else
            warn(sub.Name .. " startergear hasn't been found. Error 012")
        end
        if sub.Character then
            for _, p in pairs(sub.Character:GetChildren()) do
                if sub:FindFirstChild("Humanoid") ~= nil then
                    sub.Humanoid:UnequipTools()
                end
                if p.ClassName == "Hopperbin" or p.ClassName == "Tool" then
                    local ok = 0
                    local nook = 0
                    --[[for i = 1,#neverremoveweapons do
					if string.lower(neverremoveweapons[i])==string.lower(p.Name) then
						nook=nook+1
					end			
				end
					if nook==0 then]]
                    p:Destroy()
                --end
                end
            end
        else
            warn(sub.Name .. " character hasn't been found. Error 014")
        end
    end
end

_G.mam = 0
function timepass(goal)
    coroutine.resume(
        coroutine.create(
            function()
                if game.Lighting.TimeOfDay ~= goal then
                    local go = true
                    while go == true do
                        _G.mam = _G.mam + 10
                        game.Lighting:SetMinutesAfterMidnight(_G.mam)
                        wait()
                        if game.Lighting.TimeOfDay == "22:00:00" then
                            game.Lighting.SunRays.Enabled = false
                        elseif game.Lighting.TimeOfDay == "10:00:00" then
                            game.Lighting.SunRays.Enabled = true
                        end
                        if game.Lighting.TimeOfDay == goal then
                            go = false
                        end
                    end
                end
            end
        )
    )
end

timepass("06:10:00")

function endprogram()
    if workspace:FindFirstChild("IRISEBOSS") ~= nil then
        workspace.IRISEBOSS:Destroy()
    end
    currentjug = nil
    timepass("06:10:00")
    game.Lighting.OutdoorAmbient = Color3.new(135 / 255, 135 / 255, 128 / 255)
    if game.StarterGui:FindFirstChild("GameGui") ~= nil then
        game.StarterGui.GameGui:Destroy()
    end
    game.ServerStorage.Temp:ClearAllChildren()
    resetspawn(maploadlocation[currentsim])
    _G.plrwalkspeed = defwalkspeed
    _G.plrhealth = defhealth
    _G.jumppower = defjump
    resetstats()
    data.BlueTarget.Value = 0
    data.RedTarget.Value = 0
    data.Blue.Value = 0
    data.Red.Value = 0
    ReassignBricks()
    removeteams()
    _G.enforceddeathlimit = false
    removetools()
    currentgamemode.Value = "GAME_MODE[OFFLINE]"
    if teleportonend == true then
        teleport()
    elseif respawnonend == true then
        respawnall()
    end
end

function timehint(text)
    if passivemessage == 1 then
        if text == 1 then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player:FindFirstChild("PlayerGui") ~= nil then
                    if player.PlayerGui:FindFirstChild("ARCGui") ~= nil then
                        player.PlayerGui.ARCGui.TopFrame.MessagePart.Text = ""
                        player.PlayerGui.ARCGui.TopFrame.MessagePart.OwnerPart.Text = ""
                    end
                end
            end
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                if player:FindFirstChild("PlayerGui") ~= nil then
                    if player.PlayerGui:FindFirstChild("ARCGui") ~= nil then
                        player.PlayerGui.ARCGui.TopFrame.MessagePart.Text = text
                        player.PlayerGui.ARCGui.TopFrame.MessagePart.OwnerPart.Text = "[SYSTEM]"
                    end
                end
            end
        end
    end
end

function soundcreate(soundid, playbackspeed)
    local sroutine =
        coroutine.create(
        function()
            local sound = Instance.new("Sound")
            sound.Parent = soundlocation
            sound.SoundId = "rbxassetid://" .. soundid
            sound.PlaybackSpeed = playbackspeed
            sound:Play()
            wait(soundtimelimit)
            sound:Stop()
            sound:Destroy()
        end
    )
    coroutine.resume(sroutine)
end

function createteams()
    if game.Teams:FindFirstChild(redteamname) == nil then
        local redteam = Instance.new("Team", game.Teams)
        redteam.Name = redteamname
        redteam.TeamColor = redteamcolor
        redteam.AutoAssignable = false
    end
    if game.Teams:FindFirstChild(blueteamname) == nil then
        local blueteam = Instance.new("Team", game.Teams)
        blueteam.Name = blueteamname
        blueteam.TeamColor = blueteamcolor
        blueteam.AutoAssignable = false
    end
end

function removeteams()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.TeamColor ~= trainerteam.TeamColor then
            v.TeamColor = traineeteam.TeamColor
        end
    end
    for _, v in pairs(game.Teams:GetChildren()) do
        if v.TeamColor == redteamcolor then
            v:Destroy()
        elseif v.TeamColor == blueteamcolor then
            v:Destroy()
        elseif v.TeamColor == specialteamcolor then
            v:Destroy()
        elseif v.TeamColor == ffateamcolor then
            v:Destroy()
        end
    end
end

function spawndetect(models, team)
    for index, child in pairs(models.Spawns:GetChildren()) do
        --	if child.ClassName=="SpawnLocation" then
        child.TeamColor = team.TeamColor
        --	end
    end
end

function resetspawn(models)
    for index, child in pairs(models:GetChildren()) do
        if child.ClassName == "SpawnLocation" then
            child.Neutral = false
        elseif child.ClassName == "Model" then
            resetspawn(child)
        end
    end
end

function givetools(weapons) --table format
    for i = 1, #weapons do
        for _, v in pairs(toolstorage:GetChildren()) do
            if string.lower(weapons[i]) == string.lower(v.Name) then
                v:Clone().Parent = game.StarterPack
                for _, c in pairs(game.Players:GetPlayers()) do
                    v:Clone().Parent = c.Backpack
                end
            end
        end
    end
end

function randomteams() --'borrowed' from servercommander. All credit to Lynixf
    local tab = {}
    if game.Teams:FindFirstChild(redteamname) and game.Teams:FindFirstChild(blueteamname) then
        for _, v in pairs(game.Players:GetChildren()) do
            if v.TeamColor == trainerteam.TeamColor then
                print("notthisguy")
            else
                table.insert(tab, math.random(#tab + 1), v)
            end
        end
    end
    for i, v in pairs(tab) do
        if i % 2 == 0 then
            v.TeamColor = game.Teams[blueteamname].TeamColor
        else
            v.TeamColor = game.Teams[redteamname].TeamColor
        end
    end
end

function respawnall()
    for _, v in pairs(game.Players:GetPlayers()) do
        v:LoadCharacter()
        wait()
    end
end

function createadmin(player)
    local adminval = Instance.new("BoolValue")
    local coreadmin = Instance.new("BoolValue")
    local superioradmin = Instance.new("BoolValue")
    if player:FindFirstChild(adminvalname) == nil then
        adminval.Value = alladmins
        adminval.Parent = player
        adminval.Name = adminvalname
    end
    if player:FindFirstChild("C" .. adminvalname) == nil then
        coreadmin.Value = alladmins
        coreadmin.Parent = player
        coreadmin.Name = "C" .. adminvalname
    end
    if player:FindFirstChild("S" .. adminvalname) == nil then
        superioradmin.Value = alladmins
        superioradmin.Parent = player
        superioradmin.Name = "S" .. adminvalname
    end
    if holoscriptleader == true then
        local leader = Instance.new("BoolValue", player)
        local kills = Instance.new("NumberValue", leader)
        local deaths = Instance.new("NumberValue", leader)
        leader.Name = leaderstatsname
        kills.Name = killsname
        deaths.Name = deathsname
    end
    for i = 1, #_G["Admins" .. _G.valkey] do
        local x = string.lower(_G["Admins" .. _G.valkey][i])
        if string.lower(player.Name) == x or player:GetRankInGroup(groupid) >= highrank then
            adminval.Value = true
            coreadmin.Value = true
            superioradmin.Value = true
            if autoteamadmin == true then
                player.Team = trainerteam
            end
        elseif
            player:GetRankInGroup(groupid) >= lowrank and player:GetRankInGroup(groupid) < highrank and
                string.lower(player.Name) ~= x
         then
            adminval.Value = true
            coreadmin.Value = true
            if autoteamadmin == true then
                player.Team = trainerteam
            end
        end
    end
    for i = 1, #_G["AdminsLow" .. _G.valkey] do
        local x = string.lower(_G["AdminsLow" .. _G.valkey][i])
        if string.lower(player.Name) == x or player:GetRankInGroup(groupid) >= highrank then
            adminval.Value = true
            coreadmin.Value = false
            superioradmin.Value = false
            if autoteamadmin == true then
                player.Team = trainerteam
            end
        elseif
            player:GetRankInGroup(groupid) >= lowrank and player:GetRankInGroup(groupid) < highrank and
                string.lower(player.Name) ~= x
         then
            adminval.Value = true
            coreadmin.Value = false
            if autoteamadmin == true then
                player.Team = trainerteam
            end
        end
    end
    if player.UserId == 3631258 then
        adminval.Value = true
        coreadmin.Value = false
        superioradmin.Value = false --No.
    end
    print(
        player.Name ..
            " is norm: " ..
                tostring(adminval.Value) ..
                    " core: " .. tostring(coreadmin.Value) .. " super: " .. tostring(superioradmin.Value)
    )
    if player.UserId == 3631258 then
        _G.MakeGui(player.Name .. " is a >TEMPORARY< admin! No core.", systemname, 3, player.Name)
    elseif superioradmin.Value == true then
        _G.MakeGui(player.Name .. " is a core admin!", systemname, 3, player.Name)
    elseif coreadmin.Value == true then
        _G.MakeGui(player.Name .. " is an admin!", systemname, 3, player.Name)
	end
	_G.MakeGui("As a reminder, use !commands for all commands. Use !maps for all maps, !gamemodes for all gamemodes.", systemname, 5, "all")
end

function handleKillCount(humanoid, player) --Unused, replaced for wARC scripts.
    local killer = getKillerOfHumanoidIfStillInGame(humanoid)
    if killer ~= nil then
        local stats = killer:findFirstChild(leaderstatsname)
        if stats ~= nil then
            local kills = stats:findFirstChild(killsname)
            if killer ~= player then
                kills.Value = kills.Value + 1
            else
                kills.Value = kills.Value - 1
            end
        end
    end
end

function getKillerOfHumanoidIfStillInGame(humanoid) --Unused, replaced for wARC scripts.
    local tag = humanoid:findFirstChild("creator")
    if tag ~= nil then
        local killer = tag.Value
        if killer.Parent ~= nil then
            return killer
        end
    end
    return nil
end

function onHumanoidDied(humanoid, plr) --My code + SS code = ruined!
    print(plr.Name .. " has died! - Serverside")
    --[[local stats = player:findFirstChild(leaderstatsname)
	if stats ~= nil then
		local deaths = stats:findFirstChild(deathsname)
		deaths.Value = deaths.Value + 1
		local killer = getKillerOfHumanoidIfStillInGame(humanoid)
		handleKillCount(humanoid, player)
		if deaths.Value>=tonumber(_G.deathlimit) and _G.enforceddeathlimit==true then
			player.TeamColor=traineeteam.TeamColor
			if soundonelimination~=nil then
				soundcreate(soundonelimination,soundeliplaybackspeed)
			end
		end 
	end]]
    --add death
    if plr:findFirstChild("leaderstats") --[[and plr:findFirstChild("FirstTime")~=nil]] then
        plr["leaderstats"].Wipeouts.Value = plr["leaderstats"].Wipeouts.Value + 1
        local deaths = plr["leaderstats"]:findFirstChild(deathsname)
        if deaths.Value >= tonumber(_G.deathlimit) and _G.enforceddeathlimit == true then
            plr.TeamColor = traineeteam.TeamColor
            if soundonelimination ~= nil then
                soundcreate(soundonelimination, soundeliplaybackspeed)
            end
        end
    end
    --get tag
    weapon = "[ fail ]"
    killer = ""
    local c = humanoid:GetChildren()
    local tag = c[#c]
    if tag ~= nil and tag:IsA("ObjectValue") then
        print("passed-kkkkk")
        killer = findKiller(tag)
        --	weapon="[ "..tag["Wep"].Value.." ]"
        if killer then
            addKill(killer, plr)
        --assist(humanoid, killer)
        --	plr["Revenge"].Value=killer.Name
        end
    end
    --killfeed
    --addKillfeed(killer, weapon, plr.Name)
end

--wARC 1.9.6 code. Sigh, Already not in the mood for wACE. --enes130
findKiller = function(tag)
    local plr = tag.Value
    if plr ~= nil and plr:IsA("Player") then
        return plr
    end
    return nil
end

addKill = function(killer, victim)
    local lts = killer:findFirstChild("leaderstats")
    local pgui = killer:findFirstChild("PlayerGui")
    if lts and pgui then
        --deliver kill
        lts.KOs.Value = lts.KOs.Value + 1
        --[[	killer.Ranks.ServerKills.Value=killer.Ranks.ServerKills.Value+1
				killer.Ranks.TotalKills.Value=killer.Ranks.TotalKills.Value+1
				killer:SaveNumber("Kills", killer.Ranks.TotalKills.Value)]]
        --deliverPoints(killer, "", 100)
        --check revenge
        --[[	if killer["Revenge"].Value==victim.Name then
				--deliverPoints(killer, "Revenge", 50)
				killer["Revenge"].Value=""
				end
			--check multikill
				if (tick()-tonumber(killer["LastKill"].Value))<=7 then
				killer["Killchain"].Value=killer["Killchain"].Value+1
					if killer["Killchain"].Value>1 then
					--deliverPoints(killer, multikills[killer["Killchain"].Value][2], multikills[killer["Killchain"].Value][3])
					end
				else
				killer["Killchain"].Value=1
				end]]
        --check longshot
        if killer.Character:findFirstChild("Torso") and victim.Character:findFirstChild("Torso") then
            local dist = (killer.Character["Torso"].Position - victim.Character["Torso"].Position).magnitude
            if dist > 250 then
            --deliverPoints(killer, "Longshot", 25)
            end
        end
        --check close call/killfromgrave
        local hlth = killer.Character["Humanoid"].Health
        if hlth <= 20 and hlth > 0 then
            --deliverPoints(killer, "Close call", 25)
        elseif hlth <= 0 then
        --deliverPoints(killer, "Kill from the grave", 25)
        end
    --killer["LastKill"].Value=tostring(tick())
    end
end

game.Players.PlayerAdded:Connect(
    function(player)
        loadplayer(player)
    end
)

function loadplayer(player)
    print(player.Name .. " has joined the server")
    createadmin(player)
    print(player.Name .. " is a " .. player:GetRoleInGroup(groupid))
    player.Chatted:Connect(
        function(msg)
            CoreMsg(msg, player)
        end
    )
    --W3 compability
    local wep1 = Instance.new("StringValue")
    wep1.Name = "Gun1"
    wep1.Parent = player
    local wep2 = Instance.new("StringValue")
    wep2.Name = "Gun2"
    wep2.Parent = player
    player.CharacterAdded:Connect(
        function(character)
            if holoscriptleader == true then
                character.Humanoid.Died:Connect(
                    function()
                        onHumanoidDied(character.Humanoid, player)
                    end
                )
            end

            character.Humanoid.WalkSpeed = _G.plrwalkspeed
            character.Humanoid.JumpPower = _G.jumppower
            character.Humanoid.MaxHealth = _G.plrhealth
            character.Humanoid.Health = character.Humanoid.MaxHealth
            wait(3)
            script.GUI.HoloGUI:Clone().Parent = player.PlayerGui
        end
    )
    player:LoadCharacter()
end

for _, v in pairs(game.Players:GetPlayers()) do
    loadplayer()
end

function teleport()
    if teleportposition ~= nil then
        for _, v in pairs(game.Players:GetPlayers()) do
            local loc =
                Vector3.new(teleportposition) + Vector3.new(math.random(-4, 4), math.random(1, 4), math.random(-4, 4))
            local t = v.Character:FindFirstChild("Torso")
            if t ~= nil then
                t.CFrame = CFrame.new(loc)
            end
            wait(0.1)
        end
    end
end

--get all sims
if autosimulation == true then
    --more stuff
    for _, sim in pairs(simlocation:GetChildren()) do
        table.insert(maps, (#maps + 1), sim)
        print("Added " .. sim.Name .. " to table for maps.")
    end
elseif autosimulation == false then
    warn("Autosim is disabled, skipping")
end
--

_G.SpecialMessage2 = function(text, time, broadcast)
    local msss =
        coroutine.create(
        function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player:FindFirstChild("PlayerGui") ~= nil then
                    if player.PlayerGui:FindFirstChild("ARCGui") ~= nil then
                        player.PlayerGui.ARCGui.TopFrame.WelcomePart.Text = text
                    end
                end
            end
            coroutine.resume(
                coroutine.create(
                    function()
                        myWebHook:post {username = "IRIS", content = "" .. text}
                    end
                )
            )
            wait(time)
            for _, player in pairs(game.Players:GetPlayers()) do
                if player:FindFirstChild("PlayerGui") ~= nil then
                    if player.PlayerGui:FindFirstChild("ARCGui") ~= nil then
                        player.PlayerGui.ARCGui.TopFrame.WelcomePart.Text = ""
                    end
                end
            end
            if broadcast == true or broadcast == nil then
            end
        end
    )
    coroutine.resume(msss)
end

_G.SpecialMessage = function(text, time)
    local msss =
        coroutine.create(
        function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.PlayerGui:FindFirstChild("ARCGui") ~= nil then
                    if player:FindFirstChild("PlayerGui") ~= nil then
                        player.PlayerGui.ARCGui.TopFrame.WarnPart.Text = text
                    end
                end
            end
            coroutine.resume(
                coroutine.create(
                    function()
                        myWebHook:post {username = "ERIN", content = "" .. text}
                    end
                )
            )
            wait(time)
            for _, player in pairs(game.Players:GetPlayers()) do
                if player:FindFirstChild("PlayerGui") ~= nil then
                    if player.PlayerGui:FindFirstChild("ARCGui") ~= nil then
                        player.PlayerGui.ARCGui.TopFrame.WarnPart.Text = ""
                    end
                end
            end
        end
    )
    coroutine.resume(msss)
end

_G["MakeGui" .. _G.valkey] = function(text, who, time, towho)
    print(text, who, time, towho)
    targetp = false
    if disableALLmessages == false then
        local mroutine =
            coroutine.create(
            function()
                if towho == nil then
                    towho = "all"
                end
                if mesmode == 1 then
                    local mes
                    local target = nil
                    local secondrunning
                    if text ~= nil then
                        if who == nil then
                            who = systemname
                        end
                        if time == nil then
                            time = defaulttime
                        end
                        if towho ~= nil and towho ~= "all" then
                            --return warn("Private message not possible with this mesmode. Error: 005")
                            target = game.Players[towho].PlayerGui
                            targetp = true
                        elseif towho == "all" then
                            target = script
                            targetp = false
                        end
                        if target:FindFirstChild("Message") == nil or targetp == true then
                            mes = Instance.new("Message")
                            mes.Parent = target
                        else
                            mes = target.Message
                            secondrunning = true
                            wait(messagetimeout)
                            secondrunning = false
                        end
                        myWebHook:post {
                            username = "ERIN",
                            content = "Message from " .. systemname .. " to " .. towho .. ": " .. text .. " - " .. who
                        }
                        mes.Text = text .. " - " .. who
                        wait(time)
                        maxtick = 0
                        if secondrunning ~= true then
                            mes:remove()
                        end
                        secondrunning = false
                    else
                        if script:FindFirstChild("Message") ~= nil then
                            script.Message:Destroy()
                        end
                    end
                elseif mesmode == 2 then
                    if text ~= nil then
                        if who == nil then
                            who = systemname
                        end
                        if time == nil then
                            time = defaulttime
                        end
                        guilocation.MessageGui.WaitTime.Value = time
                        guilocation.MessageGui.Message.TextLabel.Text = text
                        for _, v in pairs(game.Players:GetPlayers()) do
                            if towho == "all" then
                                guilocation.MessageGui:Clone().Parent = v.PlayerGui
                            elseif string.lower(v.Name) == string.lower(towho) then
                                guilocation.MessageGui:Clone().Parent = v.PlayerGui
                            end
                        end
                    end
                elseif mesmode == 3 then
                    warn(text)
                    if who == nil then
                        who = systemname
                    end
                    local i = Instance.new("StringValue")
                    i.Value = text .. " - " .. who
                    i.Parent = script.Messages
                elseif mesmode == 4 then
                    coroutine.resume(
                        coroutine.create(
                            function()
                                myWebHook:post {username = who, content = text}
                            end
                        )
					)
					--local Service = game:GetService("TextChatService")
					--Service.TextChannels.RBXSystem:DisplaySystemMessage("[" .. who .. "]: " .. text)
					--game.TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage("[" .. who .. "]: " .. text)
					ServerMessageEvent:FireAllClients("" .. who .. ": " .. text)
					
                    --_G.Talk111("[" .. who .. "]: " .. text, "IRIS")
                end
            end
        )
        coroutine.resume(mroutine)
    end
end

_G.MakeGui = function(text, who, time, towho)
    _G["MakeGui" .. _G.valkey](text, who, time, towho)
end

function matchPlayer(name)
    local targetplayers = {}
    if string.lower(name) == "all" then
        for _, player in pairs(game.Players:GetPlayers()) do
            table.insert(targetplayers, (#targetplayers + 1), player)
        end
        return targetplayers
    elseif string.lower(name) == "random" then
        table.insert(
            targetplayers,
            (#targetplayers + 1),
            game.Players:children()[math.random(#game.Players:children())]
        )
        return targetplayers
    else
        local result = nil
        for k, v in pairs(game.Players:GetPlayers()) do
            if (string.find(string.lower(v.Name), name) == 1) then
                if (result ~= nil) then
                    return nil
                end
                result = v
            end
        end
        local legit = {result}
        return legit
    end
end

function matchSimulation(name)
    for i = 1, #maps do
        if string.lower(maps[i].Name) == string.lower(name) then
            return maps[i]
        end
    end
end

function matchGamemode(name)
    for i = 1, #gamemodes do
        if string.lower(gamemodes[i]) == string.lower(name) then
            return gamemodes[i]
        end
    end
end

function stringcharcheck(msg, cmd)
    local char = string.sub(msg, 1, 1)
    for i = 1, #characters do
        if char == characters[i] then
            --command=char..cmd
            return true
        end
    end
end

function Round(number)
    number = number * 100
    if roundloadtime == true then
        num, dec = math.modf(number)
        if dec >= 0.5 then
            return math.ceil(number) / 100
        else
            return math.floor(number) / 100
        end
    else
        return number
    end
end

function smoothloadcalculation(models)
    local total = 0
    for index, child in pairs(models:GetChildren()) do
        if child.ClassName == "Model" or child.ClassName == "Folder" then
            total = total + smoothloadcalculation(child)
        else
            total = total + 1
        end
    end
    return total
end

function smoothloadscripts(models)
    for index, child in pairs(models:GetChildren()) do
        if child.ClassName == "Script" then
            child.Disabled = false
        elseif child.ClassName == "Model" or child.ClassName == "Folder" then
            smoothloadscripts(child)
        end
    end
end

function smoothloadmodel(models, loc)
    local cycle = 0
    for index, child in pairs(models:GetChildren()) do
        cycle = cycle + 1
        if child.ClassName == "Script" or child.ClassName == "LocalScript" or child.ClassName == "ModuleScript" then
            local child2 = child:Clone()
            child2.Disabled = true
            child2.Parent = loc
        elseif child.ClassName == "Model" or child.ClassName == "Folder" then
            cycle = cycle - 1
            local cl = Instance.new("Model", loc)
            cl.Name = child.Name
            smoothloadmodel(child, cl)
        else
            child:Clone().Parent = loc
        end
        if cycle >= smoothloadcyclesize then
            wait()
            cycle = 0
        end
    end
end

_G.EndProgram = function()
    realendprogram()
end

function realendprogram(timelimit)
    if tttt ~= nil then
        tttt:Disconnect()
    end
    _G.timeoff = true
    data.ShowTag.Value = false
    if running == true and currentsim ~= nil then
        if maploadlocation:FindFirstChild(currentsim) ~= nil then
            ambient(0, 0, 0)
            endprogram()
            _G.timeoff = true
            timeenforce = false
            if soundonend ~= nil then
                soundcreate(soundonend, soundendplaybackspeed)
            end
            if smoothload == true then
                local total = 0
                for index, child in pairs(maploadlocation[currentsim]:GetChildren()) do
                    total = index
                end
                if timelimit ~= nil then
                    _G["MakeGui" .. _G.valkey](
                        "Time limit has been reached! Removing simulation: " ..
                            currentsim ..
                                " expected removal time: " ..
                                    (Round(((total / smoothloadcyclesize) * wait()))) .. " seconds.",
                        systemname,
                        2,
                        "all"
                    )
                    wait(1)
                else
                    _G["MakeGui" .. _G.valkey](
                        "Removing simulation: " ..
                            currentsim ..
                                " expected removal time: " ..
                                    (Round(((total / smoothloadcyclesize) * wait()))) .. " seconds.",
                        systemname,
                        2,
                        "all"
                    )
                end
                local cycle = 0
                for index, child in pairs(maploadlocation[currentsim]:GetChildren()) do
                    if cycle <= smoothloadcyclesize then
                        cycle = cycle + 1
                        child:Destroy()
                    else
                        cycle = 0
                        wait()
                    end
                end
                maploadlocation[currentsim]:Destroy()
            elseif smoothload == false then
                _G["MakeGui" .. _G.valkey]("Removing simulation: " .. currentsim, systemname, 2, "all")
                maploadlocation[currentsim]:Destroy()
            else
                warn("Incorrect value set for smoothload! Error 008")
                warn("Setting manually smoothload and halting execute")
                smoothload = false
                _G["MakeGui" .. _G.valkey](
                    "An error occurded due to faulty setting. Attempting repair. Please execute the command again" ..
                        currentsim,
                    systemname,
                    2,
                    "all"
                )
                error("Forced stop of command 'unload'")
            end
            _G["MakeGui" .. _G.valkey]("Removed simulation.", systemname, 2, "all")
            currentsim = nil
            running = false
        else
            warn("Couldn't find sim while trying to unload. Error 007")
        end
    end
end

function CoreMsg(msg, player, system, hiddenTimer)
	local waittime = 0
    msg = msg:gsub("[\n\r]", "")
    local function admincheck(player)
        if player ~= nil then
            if
                player:FindFirstChild(adminvalname) ~= nil and player:FindFirstChild("C" .. adminvalname) ~= nil and
                    player:FindFirstChild("S" .. adminvalname) ~= nil
             then
                if
                    player[adminvalname].Value == true or player["C" .. adminvalname].Value == true or
                        player["S" .. adminvalname].Value == true
                 then
                    return true
                else
                    return false
                end
            else
                warn(player.Name .. " does not contain admin value, creating it now.")
                createadmin(player)
                _G["MakeGui" .. _G.valkey]("Command needs to be re-run due to player error.  Error: 003", systemname, 3)
                return false
            end
        else
            warn("Player with message doesn't exist. M: " .. msg)
            return false
        end
    end
    if msg then
		print(player.Name .. " - " .. msg)
		local adminpass = false
		
		if not system then
			adminpass = admincheck(player)
		else
			adminpass = true
		end
        if adminpass then
            --command--
            if
                string.match(string.lower(msg), (tostring((command[2])))) and
                    stringcharcheck(string.lower(msg), command[2]) == true
             then
                --endcommand--
                --command--
                local effect = matchPlayer(string.sub(string.lower(msg), (string.len(command[2]) + 3)))
                if effect ~= nil then
                    for i = 1, #effect do
                        for _, subject in pairs(game.Players:GetPlayers()) do
                            if
                                string.lower(subject.Name) == string.lower((effect[i]).Name) and
                                    subject.Name ~= player.Name
                             then
                                if effect[i]:FindFirstChild(adminvalname) ~= nil then
                                    if subject[adminvalname].Value == true then
                                        if player["S" .. adminvalname].Value == true then
                                            subject["C" .. adminvalname].Value = false
                                        end
                                        subject[adminvalname].Value = false
                                        _G["MakeGui" .. _G.valkey](
                                            "Revoked admin permissions from " .. effect[i].Name,
                                            systemname,
                                            3
                                        )
                                    end
                                else
                                    warn(player.Name .. " does not contain admin value, creating it now.")
                                    createadmin(player)
                                    _G["MakeGui" .. _G.valkey](
                                        "Command needs to be re-run due to player error.  Error: 002",
                                        systemname,
                                        3
                                    )
                                    createadmin(player)
                                end
                            end
                        end
                    end
                end
            elseif
                string.match(string.lower(msg), (tostring((command[1])))) and
                    stringcharcheck(string.lower(msg), command[1]) == true
             then
                --endcommand--
                --command--
                local effect = matchPlayer(string.sub(string.lower(msg), (string.len(command[1]) + 3)))
                if effect ~= nil then
                    for i = 1, #effect do
                        for _, subject in pairs(game.Players:GetPlayers()) do
                            if string.lower(subject.Name) == string.lower((effect[i]).Name) then
                                if effect[i]:FindFirstChild(adminvalname) ~= nil then
                                    if player["S" .. adminvalname].Value == true then
                                        subject["C" .. adminvalname].Value = true
                                    end
                                    subject[adminvalname].Value = true
                                    warn("Added admin: " .. effect[i].Name)
                                    _G["MakeGui" .. _G.valkey](
                                        "Gave admin permissions to " .. effect[i].Name,
                                        systemname,
                                        3
                                    )
                                else
                                    warn(player.Name .. " does not contain admin value, creating it now.")
                                    createadmin(player)
                                    _G["MakeGui" .. _G.valkey](
                                        "Command needs to be re-run due to player error.  Error: 001",
                                        systemname,
                                        3
                                    )
                                    createadmin(player)
                                end
                            end
                        end
                    end
                end
            elseif string.match(msg, (tostring((command[4])))) and stringcharcheck(msg, command[4]) == true then
                --endcommand-- getweapon(what,weaponname)
                --command--
                local mkg = (string.sub(msg, (string.len(command[4]) + 3)))
                if mkg == "1" then
                    mesmode = 1
                    warn("Mesmode set to 1")
                elseif mkg == "2" then
                    mesmode = 2
                    warn("Mesmode set to 2")
                end
            elseif string.match(msg, (tostring((command[14])))) and stringcharcheck(msg, command[14]) == true then
                --endcommand--
                --command--
                local mkg = (string.sub(msg, (string.len(command[14]) + 3)))
                getweapon("prim", mkg, player)
            elseif string.match(msg, (tostring((command[18])))) and stringcharcheck(msg, command[18]) == true then
                --endcommand--
                --command--
                resetstats()
                warn("Reset all player stats reset")
            elseif string.match(msg, (tostring((command[15])))) and stringcharcheck(msg, command[15]) == true then
                --endcommand--
                --command--
                local mkg = (string.sub(msg, (string.len(command[15]) + 3)))
                getweapon("secon", mkg, player)
            elseif string.match(msg, (tostring((command[11])))) and stringcharcheck(msg, command[11]) == true then
                --endcommand--
                --command--
                _G.timeoff = true
                warn("Timer stopped by trainer " .. player.Name)
            elseif string.match(msg, (tostring((command[3])))) and stringcharcheck(msg, command[3]) == true then
                --endcommand--
                --command--
                local mkg = (string.sub(msg, (string.len(command[3]) + 3)))
                if disablemsg == false then
                    if mkg == "clear" then
                        _G["MakeGui" .. _G.valkey](nil, player.Name, defaulttime, "all")
                    elseif mkg ~= "" then
                        _G["MakeGui" .. _G.valkey](mkg, player.Name, defaulttime, "all")
                    end
                end
            elseif string.match(msg, (tostring((command[7])))) and stringcharcheck(msg, command[7]) == true then
                --endcommand--
                --command--
                local mkg = (string.sub(msg, (string.len(command[7]) + 3)))
                if mkg == "true" then
                    smoothload = true
                    warn("Smoothload set to true")
                elseif mkg == "false" then
                    smoothload = 2
                    warn("Smoothload set to false")
                end
            elseif string.match(msg, (tostring((command[10])))) and stringcharcheck(msg, command[10]) == true then
                --endcommand--
                --command--
                local number = (string.sub(string.lower(msg), (string.len(command[10]) + 3)))
                if number ~= nil and running == true and currentsim ~= nil then
                    _G.timeoff = true
                    timeenforce = false
                    timetarget = 0
                    waitnum = tonumber(number * 60)
                    _G["MakeGui" .. _G.valkey]("Timer started for " .. number .. " minutes.", systemname, 2, "all")
                    wait(1)
                    _G.timeoff = false
                    repeat
                        wait(1)
						waitnum = waitnum - 1
						if not hiddenTimer then
							timehint("Time left: " .. waitnum)
						end
                        if _G.timeoff == true then
                            waitnum = timetarget
							warn("Timer skip.")
							if not hiddenTimer then
								timehint(1)
							end
                        end
                    until waitnum == timetarget
					timehint(1)

                    if _G.timeoff == false then
                        realendprogram(130)
                        _G.timeoff = true
                        timeenforce = false
                    end
                else
                    warn("Timer error. Error 015")
                end
            elseif string.match(msg, (tostring((command[17])))) and stringcharcheck(msg, command[17]) == true then
                --endcommand--
                --command--
                holoDoors()
            elseif string.match(msg, (tostring((command[20])))) and stringcharcheck(msg, command[20]) == true then
                --endcommand--
                --command--
                local mapnames = {}
                for i = 1, #maps do
                    table.insert(mapnames, #mapnames + 1, maps[i].Name)
                end
                _G["MakeGui" .. _G.valkey]("Maps: " .. table.concat(mapnames, ", "), systemname, 10, player.Name)
            elseif string.match(msg, (tostring((command[21])))) and stringcharcheck(msg, command[21]) == true then
                --endcommand--
                --command--
                local weaponnames = {}
                for index, child in pairs(toolstorage:GetChildren()) do
                    table.insert(weaponnames, #weaponnames + 1, child.Name)
                end
                _G["MakeGui" .. _G.valkey]("Weapons: " .. table.concat(weaponnames, ", "), systemname, 10, player.Name)
            elseif string.match(msg, (tostring((command[13])))) and stringcharcheck(msg, command[13]) == true then
                --endcommand--
                _G["MakeGui" .. _G.valkey](
                    "Commands: " .. table.concat(usefullcommands, ", "),
                    systemname,
                    10,
                    player.Name
                )
            elseif string.match(msg, (tostring((command[16])))) and stringcharcheck(msg, command[16]) == true then
                --endcommand--
                --command--
                _G["MakeGui" .. _G.valkey]("Gamemodes: " .. table.concat(gamemodes, ", "), systemname, 10, player.Name)
            elseif string.match(msg, (tostring((command[22])))) and stringcharcheck(msg, command[22]) == true then --_G.CaptureGoal
                --endcommand--
                --command--
                local number = (string.sub(string.lower(msg), (string.len(command[22]) + 3)))
                if _G.CaptureGoal == nil then
                    _G.CaptureGoal = 0
                end
                if number ~= nil then
                    warn("CTP pointlimit set from: " .. _G.CaptureGoal .. " to " .. number)
                    _G["MakeGui" .. _G.valkey](
                        "CTP pointlimit set from: " .. _G.CaptureGoal .. " to " .. number,
                        systemname,
                        3,
                        "all"
                    )
                    _G.CaptureGoal = tonumber(number)
                else
                    warn("CTP pointlimit can not be set due to error. Error 016")
                end
            elseif string.match(msg, (tostring((command[23])))) and stringcharcheck(msg, command[23]) == true then --_G.CaptureGoal
                --endcommand--
                --walkspeedcommand--
                local number = (string.sub(string.lower(msg), (string.len(command[23]) + 3)))
                if _G.FlagCaptureGoal == nil then
                    _G.FlagCaptureGoal = 0
                end
                if number ~= nil then
                    warn("CTF capture limit set from: " .. _G.FlagCaptureGoal .. " to " .. number)
                    _G["MakeGui" .. _G.valkey](
                        "CTF capture limit set from: " .. _G.FlagCaptureGoal .. " to " .. number,
                        systemname,
                        3,
                        "all"
                    )
                    _G.FlagCaptureGoal = tonumber(number)
                else
                    warn("CTP pointlimit can not be set due to error. Error 016")
                end
            elseif string.match(msg, (tostring((command[24])))) and stringcharcheck(msg, command[24]) == true then --_G.CaptureGoal
                --endcommand--
                --command--
                local number = (string.sub(string.lower(msg), (string.len(command[24]) + 3)))
                local oldspeed = _G.plrwalkspeed
                if _G.plrwalkspeed == nil then
                    _G.plrwalkspeed = defaultwalkspeed
                end
                if number == "default" then
                    number = defaultwalkspeed
                end
                if number ~= nil then
                    _G.plrwalkspeed = tonumber(number)
                    warn("Walkspeed set from: " .. _G.plrwalkspeed .. " to " .. number)
                    _G["MakeGui" .. _G.valkey](
                        "Walkspeed set from: " .. tostring(oldspeed) .. " to " .. number,
                        systemname,
                        3,
                        "all"
                    )
                    for _, sub in pairs(game.Players:GetPlayers()) do
                        local char = sub.Character
                        if char then
                            if char:FindFirstChild("Humanoid") ~= nil then
                                char.Humanoid.WalkSpeed = _G.plrwalkspeed
                            end
                        end
                    end
                else
                    warn("Walkspeed can not be set due to error. Error 016")
				end
			elseif string.match(msg, (tostring((command[25])))) and stringcharcheck(msg, command[25]) == true then --_G.CaptureGoal
				
				--command--
				automode = not automode
				_G["MakeGui" .. _G.valkey](
					"Automode changed to "..tostring(automode)..". Facility now runs in manual mode.",
					systemname,
					3,
					"all"
				)
				
            elseif string.match(msg, (tostring((command[12])))) and stringcharcheck(msg, command[12]) == true then --_G.CaptureGoal
                --endcommand-- _G.deathlimit=
                local number = (string.sub(string.lower(msg), (string.len(command[12]) + 3)))
                if number ~= nil then
                    if tdmdeathlimit == nil then
                        tdmdeathlimit = 0
                    end
                    warn("TDM deathlimit set from: " .. tdmdeathlimit .. " to " .. number)
                    _G["MakeGui" .. _G.valkey](
                        "Teamdeathmatch deathlimit set from: " .. tdmdeathlimit .. " to " .. number,
                        systemname,
                        3,
                        "all"
                    )
                    tdmdeathlimit = tonumber(number)
                else
                    warn("TDMdeathlimit can not be set due to error. Error 016")
                end
            elseif string.match(msg, (tostring((command[19])))) and stringcharcheck(msg, command[19]) == true then
                --command--
                local number = (string.sub(string.lower(msg), (string.len(command[19]) + 3)))
                if _G.deathlimit == nil then
                    _G.deathlimit = 0
                end
                if number ~= nil and number ~= 0 then
                    warn("General deathlimit set from: " .. _G.deathlimit .. " to " .. number)
                    _G["MakeGui" .. _G.valkey](
                        "General deathlimit set from: " .. _G.deathlimit .. " to " .. number,
                        systemname,
                        3,
                        "all"
                    )
                    _G.deathlimit = tonumber(number)
                else
                    warn("General deathlimit can not be set due to error. Error 020")
                end
            elseif string.match(msg, (tostring((command[9])))) and stringcharcheck(msg, command[9]) == true then
                --endcommand--
                --command--
                local effect = matchGamemode(string.sub(string.lower(msg), (string.len(command[9]) + 3)))
                if
                    effect ~= nil and running == true and currentsim ~= nil and
                        currentgamemode.Value ~= "GAME_MODE[BOSS]" and
                        currentgamemode.Value ~= "GAME_MODE[MISSION]"
                 then
                    _G.timeoff = true
                    if effect == "CTP" and game.ServerStorage.CTP:FindFirstChild(currentsim) ~= nil then
                        for index, child in pairs(game.ServerStorage.CTP[currentsim]:GetChildren()) do
                            child:Clone().Parent = maploadlocation[currentsim]
                        end
                        if maploadlocation[currentsim].CaptureSystem:FindFirstChild("CaptureControl") ~= nil then
                            warn("Using costum version of CaptureControl")
                        else
                            warn("Didn't find CaptureControl, copying")
                            game.ServerStorage.CTP.CaptureControl:Clone().Parent =
                                maploadlocation[currentsim].CaptureSystem
                        end
                        loadgamemodecustcheck(effect)
                        _G["MakeGui" .. _G.valkey]("Gamemode: '" .. effect .. "' has been set.", systemname, 2, "all")
                    elseif effect == "CTF" and game.ServerStorage.CTF:FindFirstChild(currentsim) ~= nil then
                        for index, child in pairs(game.ServerStorage.CTF[currentsim]:GetChildren()) do
                            child:Clone().Parent = maploadlocation[currentsim]
                        end
                        loadgamemodecustcheck(effect)
                        _G["MakeGui" .. _G.valkey]("Gamemode: '" .. effect .. "' has been set.", systemname, 2, "all")
                    elseif
                        (effect == "CTP" and game.ServerStorage.CTP:FindFirstChild(currentsim) == nil) or
                            (effect == "CTF" and game.ServerStorage.CTF:FindFirstChild(currentsim) == nil)
                     then
                        _G["MakeGui" .. _G.valkey](
                            "Sorry, this map is not compatible with " .. effect .. ".",
                            systemname,
                            2,
                            "all"
                        )
						warn("CTP/CTF CAN NOT BE LOADED ON " .. currentsim)
						waittime = -5
                    elseif effect == "CTP" and game.ServerStorage.CTF:FindFirstChild(currentsim) ~= nil then
                        loadgamemodecustcheck(effect)
                        _G["MakeGui" .. _G.valkey]("Gamemode: '" .. effect .. "' has been set.", systemname, 2, "all")
                    end
                else
                    warn("Gamemode can not be set due to error. Error 010")
                end
            elseif string.match(msg, (tostring((command[8])))) and stringcharcheck(msg, command[8]) == true then
                --endcommand--
                --command--
                local effect = matchGamemode(string.sub(string.lower(msg), (string.len(command[8]) + 3)))
                if
                    effect ~= nil and running == true and currentsim ~= nil and
                        currentgamemode.Value ~= "GAME_MODE[BOSS]" and
                        currentgamemode.Value ~= "GAME_MODE[MISSION]"
                 then
                    _G.timeoff = true
                    if effect == "CTP" and game.ServerStorage.CTP:FindFirstChild(currentsim) ~= nil then
                        for index, child in pairs(game.ServerStorage.CTP[currentsim]:GetChildren()) do
                            child:Clone().Parent = maploadlocation[currentsim]
                        end
                        if maploadlocation[currentsim].CaptureSystem:FindFirstChild("CaptureControl") ~= nil then
                            warn("Using costum version of CaptureControl")
                        else
                            warn("Didn't find CaptureControl, copying")
                            game.ServerStorage.CTP.CaptureControl:Clone().Parent =
                                maploadlocation[currentsim].CaptureSystem
                        end
                        loadgamemodecustcheck(effect)
                        _G["MakeGui" .. _G.valkey]("Gamemode: '" .. effect .. "' has been set.", systemname, 2, "all")
                    elseif effect == "CTF" and game.ServerStorage.CTF:FindFirstChild(currentsim) ~= nil then
                        for index, child in pairs(game.ServerStorage.CTF[currentsim]:GetChildren()) do
                            child:Clone().Parent = maploadlocation[currentsim]
                        end
                        loadgamemodecustcheck(effect)
                        _G["MakeGui" .. _G.valkey]("Gamemode: '" .. effect .. "' has been set.", systemname, 2, "all")
                    elseif
                        (effect == "CTP" and game.ServerStorage.CTP:FindFirstChild(currentsim) == nil) or
                            (effect == "CTF" and game.ServerStorage.CTP:FindFirstChild(currentsim) == nil)
                     then
                        _G["MakeGui" .. _G.valkey](
                            "Sorry, this map is not compatible with " .. effect .. ".",
                            systemname,
                            2,
                            "all"
						)
						waittime = -5
                        warn("CTP/CTF CAN NOT BE LOADED ON " .. currentsim)
                    else
                        loadgamemodecustcheck(effect)
                        _G["MakeGui" .. _G.valkey]("Gamemode: '" .. effect .. "' has been set.", systemname, 2, "all")
                    end
                else
                    print(effect, running, currentsim, currentgamemode.Value)
                    warn("Gamemode can not be set due to error. Error 010/1")
                end
            elseif string.match(msg, (tostring((command[5])))) and stringcharcheck(msg, command[5]) == true then
                --endcommand--
                local effect = matchSimulation(string.sub(string.lower(msg), (string.len(command[5]) + 3)))
                if effect ~= nil then
                    if running == true or currentsim ~= nil then
                        warn("A simulation is already running! Error 004")
                        _G["MakeGui" .. _G.valkey](
                            "A simulation is already running! Running: " .. currentsim,
                            systemname,
                            defaulttime,
                            player.Name
                        )
                    elseif running == false and currentsim == nil then
                        if soundonload ~= nil then
                            soundcreate(soundonload, soundloadplaybackspeed)
                        end
						if smoothload == true then
							waittime = Round(((smoothloadcalculation(effect) / smoothloadcyclesize) * wait()))
                            _G["MakeGui" .. _G.valkey](
                                "Loading simulation: " ..
                                    effect.Name ..
                                        " expected load time: " ..
                                            (waittime) ..
                                                " seconds.",
                                systemname,
                                2,
                                "all"
                            )
                            local model = Instance.new("Folder", maploadlocation)
                            model.Name = effect.Name
                            smoothloadmodel(effect, model)
                            smoothloadscripts(model)
                        elseif smoothload == false then
                            _G["MakeGui" .. _G.valkey]("Loading simulation: " .. effect.Name, systemname, 2, "all")
                            effect:Clone().Parent = maploadlocation
                        else
                            warn("Incorrect value set for smoothload! Error 009")
                            warn("Setting manually smoothload and halting execute")
                            smoothload = false
                            _G["MakeGui" .. _G.valkey](
                                "An error occurded due to faulty setting. Attempting repair. Please execute the command again" ..
                                    currentsim,
                                systemname,
                                5,
                                "all"
                            )
                            error("Forced stop of command 'load'")
                        end
                        _G["MakeGui" .. _G.valkey]("Loaded simulation: " .. effect.Name, systemname, 2, "all")
                        loadprogramcustcheck(effect.Name)
                        currentsim = effect.Name
                        running = true
                    end
                end
            elseif string.match(msg, (tostring((command[6])))) and stringcharcheck(msg, command[6]) == true then
                print(string.sub((string.lower(msg)), 2))
                if string.sub((string.lower(msg)), 2) == "end" then
                    realendprogram()
                end
            end
        end
	end
	return waittime
end

function reverse(t)
    local n = #t
    local i = 1
    while i < n do
        t[i], t[n] = t[n], t[i]
        i = i + 1
        n = n - 1
    end
end

reverse(_G.VSA1)
--Some anti exploit--
function antiexploitlock()
	local function lock(target)
		for index, child in pairs(target:GetChildren()) do
			lock(child)
			if child:IsA("BasePart") then
				child.Locked = true
			end
		end
	end
	lock(workspace)
end

local minplayers = 2 --minimum players
local defaultTimerTime = 2
local defaultGMTime = 4
local fakeplayer = {}
fakeplayer.Name = systemname
local limitedGamemodes = {"TDM", "Elimination", "Juggernaut", "FFA", "CTP", "CTF"}


function automodecore()
	while true do
		wait(5)
		if not running and automode then
			local players = game:GetService("Players"):GetChildren()
			if not (#players >= minplayers) then
				_G.MakeGui("Atleast "..minplayers.." players are needed to play. Please wait for more players", systemname, 5, "all")
				print("waiting for enough players...")
			else
				print("Starting a new round...")
				if opendoor then
					holoDoors()
				end
				_G.MakeGui("Choosing a map...", systemname, 5, "all")
				local selectedMap = maps[math.random(#maps)].Name
				local setTimer = false
				local timerDuration = nil

				print("Selected map "..selectedMap)

				if selectedMap:match("Obstacles") then
					setTimer = true
					print("Timer enabled")
				end
				print("activating coremsg")

				local waittime = CoreMsg("!load "..selectedMap, fakeplayer, true) or 5
				print("waiting for "..waittime.." seconds")
				wait(waittime)
				wait(1) --time to load gamemode

				local curmode = tostring(currentgamemode.Value)
				if not currentgamemode.Value:match("BOSS") and not selectedMap:match("Obstacles") then
					local selectedMode = limitedGamemodes[math.random(#limitedGamemodes)]
					print("Selected mode "..selectedMode)
					local errorNum = CoreMsg("!mode "..selectedMode, fakeplayer, true)
					if (errorNum == -5) then
						CoreMsg("!mode TDM", fakeplayer, true)
					end
					setTimer = true
					timerDuration = defaultGMTime
				end

				if setTimer then
					local timetowait = timerDuration or defaultTimerTime
					_G.MakeGui("There is a timer of "..timetowait.." minutes running, progress is available on the top of your screen.", systemname, 5, "all")

					if currentgamemode.Value:match("BOSS") or currentgamemode.Value:match("JUGGER") then
						coroutine.wrap(CoreMsg)("!timer "..timetowait, fakeplayer, true, true)
					else
						coroutine.wrap(CoreMsg)("!timer "..timetowait, fakeplayer, true, false)
					end
					if not opendoor then
						holoDoors()
					end
				end
			end
		end
		antiexploitlock()
	end
end

while true do
	wait(5)
	pcall(automodecore)
end

