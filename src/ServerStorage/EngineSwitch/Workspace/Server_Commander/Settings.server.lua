--THIS IS THE ONLY SCRIPT YOU SHOULD BE MESSING WITH!
--Love, ZeroSpectrum

if not _G.varsfinished==true then
--Edit settings below

--[]PLACE UPDATES[]

_G.Place_Title		="Showcase" --Must be a string "Like this"
_G.Place_Version	=1 --Numbers only
_G.Place_Updated	="02-02-2014" --Must be a string
_G.show_placeupdgui=false
_G.show_adminupdgui=false

_G.placeupdates={
	--Enter your place updates belowF
	
	"I am an update title!", --Not indented
	"- I am update 1", --Indented once
	"- I am update 2",
	"--I am additional update info", --Indented twice, string returns one dash only "- I am" instead of "--I am"
}

--[]ADMIN OPTIONS[]

_G.funcommands		=true

_G.loc				=game.ServerStorage.Weapons 	--WHERE ARE THE TOOLS?

_G.admins			={"enes130","Auhrii","Player1"}
_G.banned			={"Gorehowl", "Maritimes", "davidsantiago123", "rafaanthony1"}
_G.bannedgroups	={}
_G.groups			={	3747606,	}
_G.ranks			={	194,	} --(194 - Lieutenants+)(193 - Sentinels+)
_G.hrteamranks		={	194,	}
_G.hrteam			="nil" --To disable change it to: hrteam = nil

_G.account_age		=2 	--How old does an account need to be (in days) to join? Set to -1 to disable.

_G.confirm_kick		=false

_G.must_be_in_group=0 --Set to 0 to disable.

_G.uniformsupport	=true 	--Set to false if you don't want anything to do with uniforms
_G.autouniform		=false
_G.group_shirts		={98096900,98096776,98096816,109686166}
_G.group_pants		={98096927,98096789,98096836}
_G.shirt1			=98096776
_G.pants1			=98096789

_G.timer			=20 --!gameteleport timer. Set to 0 to disable (infinate time).

_G.team1			="Blue team"
_G.team2			="Red team"

--[[
\\Credits and Info\\

PM or add ZeroSpectrum on XFire if you have any issues with Server_Commander!

	Scripted by:
		-ZeroSpectrum 
		-owen0202 
		-LynixF 
		-Yodapal
	
	SPECIAL THANKS TO: 
		-20wavecaps 
		-CrimsonPact
		-Mike1291
		-Yodapal
		-Epicus
	for helping me test this script!

DO NOT MESS WITH ANYTHING BELOW THIS LINE!
_________________________________________________________________________________________________________________________________

]]
_G.varsfinished=true end

sp=script.Parent
sp.Disabled=false

--[[local model = script.Parent
while not script.Parent:FindFirstChild("Version") do wait(0) end;
local modelVersion = model.Version.Value;
local modelID = 141794205

--Storing a number value in a string ftw
function checkForUpdate()
    local newModel = game:GetService("InsertService"):LoadAsset(modelID)
    if newModel and newModel:children()[1]:FindFirstChild("Version") and newModel:children()[1].Version:IsA("StringValue") and newModel:children()[1].Version.Value ~= modelVersion then
        newModel.Parent = model.Parent
        model:Destroy()
	else
		model.Disabled=false
    end
end
 
checkForUpdate()]]

--My only friend, the end.