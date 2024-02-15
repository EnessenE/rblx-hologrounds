--print ("RUNNING")

--Modulescript as replacement for holoscript in future.
trainers = {"enes130","yodapal","Player1",""}
_G["Trainers"] = function (trainers)
	trainers = {"enes130","yodapal","Player1",""}
	return trainers
end

script.Running.Value = false
running=script.Running.Value
opendoor = false
dooractive = false
entryactive = false
entryopen = false
cursimdea=script.Values.CurrentSimDeath
respen=script.Values.RespawnPending
autores=script.Values.Respawn
autoteam=script.Values.AutoTeams
walkspeed=script.Values.WalkSpeed
health=script.Values.Health
PlaceName="IRIS"
currentgen=script.Values.CurrentGen
gamemodes={"Objective[BETA]","TeamDeathMatch[BETA]","Default[BETA]"}
availablegen={"W3","RCL","wARC","W6"} --wARC["Y14"}
engines=game.ReplicatedStorage.ENGINES

currentgen.Changed:Connect(function(NewValue)
script.Values.RespawnPending.Value=true
	for index, child in pairs (game.StarterGui:GetChildren()) do
		if child.Name~="Control" and child.Name~="SimList" and child.Name~="ManiCam" and child.Name~="TEST" then
		child:Destroy()
		end
	end
for i = 1,#availablegen do
	--print(i)
	for index, child in pairs(game.ReplicatedStorage.ENGINES[availablegen[i]].Workspace:GetChildren()) do
		if game.Workspace:FindFirstChild(child.Name)~=nil then
			child:Destroy()
		end
	end
end
for index, child in pairs(engines[currentgen.Value].StarterGui:GetChildren()) do
	child:Clone().Parent=game.StarterGui
end
for index, child in pairs(engines[currentgen.Value].Workspace:GetChildren()) do
	child:Clone().Parent=workspace
	end
end)


currentgen.Value="wARC" --default weapon gen
--print("Set "..currentgen.Value)
script.Values.RespawnPending.Value=false
--weapon gen

--
cursimdea.Value=5


local DataStoreService = game:GetService("DataStoreService")
local gameData = DataStoreService:GetDataStore("GlobalData")
 
local function onPlayerJoin(player) --erin likes to watch <3
	local success, message = pcall(function()	
	--[[	number=gameData:GetAsync("Many")
		--print("GOT ASYNC")
		gameData:SetAsync(number, player.Name) --How many times have you been here?!]]
		--print("Succes for :"..player.Name)
	end)
	if not success then
		warn("Problem accessing DataStore on player join: " .. message)
	end
end



game.Players.PlayerAdded:Connect(function(newPlayer)
	local firstcheck=true
		lazyval=Instance.new("BoolValue",newPlayer)
		lazyval.Value=false
		lazyval.Name="Admin"
		x=newPlayer:GetRankInGroup(3747606)
		for i = 1,#trainers do
			if firstcheck==true then
			if newPlayer.Name == trainers[i] or x>=194 or newPlayer.UserId == 3631258 then
				newPlayer.TeamColor=game.Teams.Trainers.TeamColor
				newPlayer.Chatted:Connect(onSpeakDo)
				lazyval.Value=true
				newPlayer:WaitForDataReady()
				lazyval.Value=true
			end
			firstcheck=false
			end
		end
		repeat wait() until newPlayer.Character:FindFirstChild("Torso")~=nil
		newPlayer:LoadCharacter()
		onPlayerJoin(newPlayer)
		newPlayer.CharacterAdded:Connect(function(character)
			character.Humanoid.WalkSpeed=walkspeed.Value
			character.Humanoid.MaxHealth=health.Value
			character.Humanoid.Health=health.Value
		end)
end)

_G.GameWon=function(team)
	--print("Team "..team.." has won!")
	makeGui("Team "..team.." has won!",10)	
end

function checks(whos)
if whos==1 then return "IRIS" else return "ERIN" end	
end

function makeGui(text,time,whos)
	shouted=false
	--print(whos)
	if whos==nil then
		clr=Color3.new(0, 1, 0)--iris
	elseif whos==1 then
		clr=Color3.new(0, 0, 1)--iris
	elseif whos==2 then
		clr=Color3.new(1, 0, 0) --erin
	end
local	p = game.Players:GetChildren()
			if shouted==false then
				for i= 1, #p do
					if p[i].PlayerGui.Engine.Value=="wARC" then
						if whos==2 then
							p[i].PlayerGui.ARCGui.TopFrame.WarnPart.Text=text
							p[i].PlayerGui.ARCGui.TopFrame.WarnPart.Visible=true	
						else
							p[i].PlayerGui.ARCGui.TopFrame.WelcomePart.Text=text
							p[i].PlayerGui.ARCGui.TopFrame.WelcomePart.Visible=true
						end
					elseif p[i].PlayerGui.Engine.Value=="W6" then --Future: Integrate the w6 message system into workspace
						if game.Workspace:FindFirstChild("MessageSystem")~=nil then
							game.Workspace.MessageSystem.PopupTeamMessage.Value=text
							game.Workspace.MessageSystem.PopupTeamMessage.TextColor.Value=clr
							game.Workspace.MessageSystem.PopupTeamMessage.Source.Value=checks(whos)
						else
							--print("Thats a shame!")
						end
					else
						--print("Couldn't find ARCGUI for "..p[i].Name)
					end
				end
				shouted=true
				local waiting = coroutine.create(function()
				wait(time)
				for i= 1, #p do
					if p[i].PlayerGui:FindFirstChild("ARCGui")~=nil then
						p[i].PlayerGui.ARCGui.TopFrame.WelcomePart.Text=""
						p[i].PlayerGui.ARCGui.TopFrame.WarnPart.Text=""
					end
				end
				end)
				coroutine.resume(waiting)

	end
end

_G.makeGui=function(text,time,who)
	if time==nil then
	makeGui(text,3,who)
	else
		makeGui(text,time,who)
	end
end

function specialspawn(n)
	if n==1 then
		for i,child in pairs(game.Workspace.SpawnsMain:GetChildren()) do
			child.Enabled=false
			--print(child.Name)
		end
	else 
	for i,child in pairs(game.Workspace.SpawnsMain:GetChildren()) do
		child.Enabled=true
	end
	end
end

function loadProgram(program)
	if game.ReplicatedStorage.Sims:findFirstChild(program) ~= nil then
		p = game.ReplicatedStorage.Sims[program]:Clone()
		p.Parent = game.Workspace
		p.Name = "Program"
		for i,child in pairs(p:GetChildren()) do
			if p:IsA("BasePart") then
				p[i]:MakeJoints()
			elseif p.ClassName=="Model" then
				q=p
				for i,child in pairs(q:GetChildren()) do
					if q:IsA("BasePart") then
						q[i]:MakeJoints()
					end
				end
			end
		end
		wait()
		makeGui(":ARC//"..PlaceName.."/"..string.upper(game.Workspace.Program.Name).."/LOADING",2.5)
		makeGui(":ARC//"..PlaceName.."/"..string.upper(program).."/READY",5)
	else
		makeGui(":ARC//"..PlaceName.."/ERROR/"..string.upper(program).."/DOESNT_EXIST/ENDING_PROGRAM",5)
	end
end

function giveswords()
tloc = {"Backpack","StarterGear"}
if currentgen.Value=="wARC" then
	set="tkSWD"
elseif currentgen.Value=="W3" then
	set="Stun Stick"
elseif currentgen.Value=="RCL" then
	set="Sword"
elseif currentgen.Value=="TRA" then
	set="Sword"
elseif currentgen.Value=="HIVE" or currentgen.Value=="HIVE[BETA]"  then
	set="KTNA"
elseif currentgen.Value=="TRAOLD" then
	set="Sword"
elseif currentgen.Value=="TurboFusion" then
	set="Sword"
elseif currentgen.Value=="W6" then
	set="Sword"
	for _,v in pairs(game.Players:GetPlayers()) do
if game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(set) then
	local t = game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(set)
		for i = 1,#tloc do
			t:Clone().Parent = v[tloc[i]]
			wait()
		end
end
end
end
for _,v in pairs(game.Players:GetPlayers()) do
	removeTools(v)
if game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(set) then
local t = game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(set)
	for i = 1,#tloc do
		t:Clone().Parent = v[tloc[i]]
		wait()
	end
end
end
end

_G.GiveTools=function()
	giveTools(nil)
end

function giveTools(Program)
if currentgen.Value~="W6"  then
tloc = {"Backpack","StarterGear"}
for _,v in pairs(game.Players:GetPlayers()) do
	removeTools(v)
	if game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Primary.Value) then
		local t = game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Primary.Value)
		for i = 1,#tloc do
			t:Clone().Parent = v[tloc[i]]
			wait()
		end
	end
		if game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Secondary.Value) then
			local t = game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Secondary.Value)
			for i = 1,#tloc do
				t:Clone().Parent = v[tloc[i]]
				wait()
			end
		end
	end
elseif currentgen.Value=="W6" then
tloc = {"Backpack"}
	for _,v in pairs(game.Players:GetPlayers()) do
		removeTools(v)
					if game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Primary.Value) then
					local t = game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Primary.Value)
						for i = 1,#tloc do
							t:Clone().Parent = v[tloc[i]]
							wait()
						end
					end
					if game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Secondary.Value) then
					local t = game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Secondary.Value)
						for i = 1,#tloc do
							t:Clone().Parent = v[tloc[i]]
							wait()
						end
					end
				end

					if game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Primary.Value) then
					local t = game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Primary.Value)
					t:Clone().Parent = game.StarterGui.WIJGui.GuiScript.StarterPack
					end
					if game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Secondary.Value) then
					local t = game.ReplicatedStorage.ENGINES[currentgen.Value].Weapons:FindFirstChild(currentgen.Secondary.Value)
					t:Clone().Parent = game.StarterGui.WIJGui.GuiScript.StarterPack
					end
	--end
end
end

function resetstats()
	for index, child in pairs(game.Players:GetChildren()) do
		if child:FindFirstChild("leaderstats") ~= nil then
		if child.leaderstats:FindFirstChild("Wipeouts")~=nil then
			child.leaderstats.Wipeouts.Value=0
		end
			child.leaderstats.KOs.Value=0
		end
	end
end

function removeTools(Player)
	if currentgen.Value~="W6"  then
		Player.Character.Humanoid:UnequipTools()
		for _,startertool in pairs(Player.StarterGear:GetChildren()) do
		startertool:Destroy()
		end
		for _,backpacktools in pairs(Player.Backpack:GetChildren()) do
		backpacktools:Destroy()
		end
	elseif currentgen.Value=="W6" then
		Player.Character.Humanoid:UnequipTools()
		game.StarterGui.WIJGui.GuiScript.StarterPack:ClearAllChildren()
		for _,startertool in pairs(Player.StarterGear:GetChildren()) do
		startertool:Destroy()
		end
		for _,backpacktools in pairs(Player.Backpack:GetChildren()) do
		backpacktools:Destroy()
		end
	end
end

_G["EndProgramOverride"] = function ()
	endProgram()
end

function endProgram()
	if running==true then
	ambient(0,0,0)
	health.Value=100
	walkspeed.Value=16
	game.Lighting.TimeOfDay="02:00:00"
	ReassignBricks()
	specialspawn()
	resetTeams()
	for _,v in pairs(game.Players:GetPlayers()) do
		removeTools(v)
	end
	Respawn(1)
	if opendoor == true then
			--print("3")
		holoDoors()
			--print("4")
	end
	resetstats()
	if game.Workspace:findFirstChild("Program") ~= nil then
		--print("Check")
		running = true
		makeGui(":ARC//"..PlaceName.."/ENDING_PROGRAM/",2.5)
		game.Workspace.Program:Destroy()
		makeGui(":ARC//"..PlaceName.."/PROGRAM_ENDED/",2.5)
		running = false
	elseif game.Workspace:findFirstChild("Program") == nil then
		--makeGui(""..PlaceName.."://ERROR/COULD_NOT_REMOVE_PROGRAM",5)
		--print("x")
	end
	game.Workspace.FirstSimLoaded.Value=true
		--print("2")
	else
		--print("Not running")
	end
end

function AssignBricks()-------------------------------------------------------------------------------------------------------
	game.Workspace.Program.TelePart.AssignColor1.BrickColor=BrickColor.new("Sand blue")
	p= game.Workspace.Program.TelePart.Spawns.Spawn1:GetChildren() 
	for i= 1, #p do 
	p[i].TeamColor=BrickColor.new("Sand blue")
	p[i].BrickColor=BrickColor.new("Sand blue")
	end
	game.Workspace.Program.TelePart.AssignColor2.BrickColor=BrickColor.new("Dusty Rose")
	x= game.Workspace.Program.TelePart.Spawns.Spawn2:GetChildren() 
	for i= 1, #x do 
	x[i].TeamColor=BrickColor.new("Dusty Rose")
	x[i].BrickColor=BrickColor.new("Dusty Rose")
	end
	c= game.Workspace.Spawns.Red:GetChildren() 
	for i= 1, #c do 
	c[i].TeamColor=BrickColor.new("Earth green")
	c[i].BrickColor=BrickColor.new("Medium stone gray")
	end
	v= game.Workspace.Spawns.Blue:GetChildren() 
	for i= 1, #v do 
	v[i].TeamColor=BrickColor.new("Earth green")
	v[i].BrickColor=BrickColor.new("Medium stone gray")
	end
end

function custassignbricks()
	c= game.Workspace.Spawns.Red:GetChildren() 
	for i= 1, #c do 
	c[i].TeamColor=BrickColor.new("Earth green")
	c[i].BrickColor=BrickColor.new("Medium stone gray")
	end
	v= game.Workspace.Spawns.Blue:GetChildren() 
	for i= 1, #v do 
	v[i].TeamColor=BrickColor.new("Earth green")
	v[i].BrickColor=BrickColor.new("Medium stone gray")
	end
end

function ReassignBricks()
	p= game.Workspace.Spawns.Red:GetChildren() 
	for i= 1, #p do 
	p[i].TeamColor=BrickColor.new("Dusty Rose")
	p[i].BrickColor=BrickColor.new("Dusty Rose")
	end
	z= game.Workspace.Spawns.Blue:GetChildren() 
	for i= 1, #z do 
	z[i].TeamColor=BrickColor.new("Sand blue")
	z[i].BrickColor=BrickColor.new("Sand blue")
	end
end

function Respawn(n)
	respen.Value=false
	if n==1 then
		p=game.Players:GetChildren() 
		for i= 1, #p do 
		p[i]:LoadCharacter()
		wait()
		end
	else
	if autores.Value==true  then
	p= game.Players:GetChildren() 
	for i= 1, #p do 
	p[i]:LoadCharacter()
	wait()
	end
	end
	end
end

function ambient(q,w,e)
	game.Lighting.Ambient=Color3.new(q/255,w/255,e/255)
end

function createteam()
		bluet = Instance.new("Team",game.Teams)
		bluet.Name = "130"
		bluet.AutoAssignable = false
		bluet.TeamColor = BrickColor.new("Sand blue")	
		for _,v in pairs(game.Players:GetPlayers()) do
			v.TeamColor=bluet.TeamColor
		end
end

function randomiseTeams()
	
		redt = Instance.new("Team",game.Teams)
		redt.Name = "Red team"
		redt.AutoAssignable = false
		redt.TeamColor = BrickColor.new("Dusty Rose")
		bluet = Instance.new("Team",game.Teams)
		bluet.Name = "Blue team"
		bluet.AutoAssignable = false
		bluet.TeamColor = BrickColor.new("Sand blue")
	if autoteam.Value==true then
		colors = {"Dusty Rose","Sand blue"}
		count = {
			["Sand blue"]	= 0;
			["Dusty Rose"]		= 0;
		}
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.TeamColor ~= BrickColor.new("Bright violet") then
				random = math.random(1,2)
				v.TeamColor = BrickColor.new(colors[random])
				count[colors[random]] = count[colors[random]] +1
			end
		end
		repeat
		wait()
		if count["Dusty Rose"] > count["Sand blue"] then
			p = game.Players:GetPlayers()
			for i = 1,#p do
				if p[i].TeamColor == BrickColor.new("Dusty Rose") then
					p[i].TeamColor = BrickColor.new("Sand blue")
					count["Dusty Rose"] = count["Dusty Rose"] -1
					count["Sand blue"] = count["Sand blue"] +1
					break
				end
			end
		elseif count["Sand blue"] > count["Dusty Rose"] then
			p = game.Players:GetPlayers()
			for i = 1,#p do
				if p[i].TeamColor == BrickColor.new("Sand blue") then
					p[i].TeamColor = BrickColor.new("Dusty Rose")
					count["Sand blue"] = count["Sand blue"] -1
					count["Dusty Rose"] = count["Dusty Rose"] +1
					break
				end
			end
		end
		until 
		count["Dusty Rose"] - count["Sand blue"] <= 1 and count["Sand blue"] - count["Dusty Rose"] <= 1
	end
end

function resetTeams()
	for _,v in pairs(game.Players:GetPlayers()) do
		if v.TeamColor ~= BrickColor.new("Bright violet") then
		v.TeamColor = BrickColor.new("Bright blue")
		end
	end
	for _,v in pairs(game.Teams:GetChildren()) do
		if v.TeamColor == BrickColor.new("Dusty Rose") then
			v:Destroy()
		elseif v.TeamColor == BrickColor.new("Sand blue") then
			v:Destroy()
		end
	end
end


function holoDoors()
		hl=game.Workspace.MainHoloDoors.Left
		hr=game.Workspace.MainHoloDoors.Right
	if opendoor==true then
		opendoor=2
		for z=1,150 do
			wait()
			for _,v in pairs(hl:GetChildren()) do
				v.CFrame=v.CFrame+Vector3.new(0,0,0.1)
			end
			for _,v in pairs(hr:GetChildren()) do
				v.CFrame=v.CFrame+Vector3.new(0,0,-0.1)
			end
		end
		opendoor=false
	else
		opendoor=2
		for z=1,150 do
			wait()
			for _,v in pairs(hl:GetChildren()) do
				v.CFrame=v.CFrame+Vector3.new(0,0,-0.1)
			end
			for _,v in pairs(hr:GetChildren()) do
				v.CFrame=v.CFrame+Vector3.new(0,0,0.1)
			end
		end
		opendoor=true
	end
end

function TimeChange(Dest)
	Current=game.Lighting.TimeOfDay
	repeat
		wait(0.1)
		Current=Current+"00.10.00"
	until Current==Dest
end

function entryDoors()
--INSERT YOUR ENTRY DOORS SCRIPT HERE
end
			
function teleport()
	for _,v in pairs(game.Players:GetPlayers()) do
		loc=Vector3.new(game.Workspace.EndTele.Position)+Vector3.new(math.random(-4, 4), math.random(2, 4), math.random(-4, 4))
		v.Character.Torso.CFrame = CFrame.new(loc)
		wait(0.1)
	end
end

function onSpeakDo(msg,recip)
	keywords = {
		programs = {"computer","load","begin","run","end","program","miningoutpost","outpostterra","laboutpost","erin","wijbase","radiostation","vermillion","bricktops","indigo 1","cerulean 1","narrowgill","pitgrounds","obstacles 1","obstacles 2","swordfight","fairriver","ammobox","holo","doors","holodoor","entry","on","off","forcefield"}; --ADD MORE KEYWORDS HERE
	}
	mainvals = {
		["computer"]		= false;
		["load"]			= false;
		["begin"]			= false;
		["run"]				= false;
		["end"]				= false;
		["program"]			= false;
		["obstacles 1"]		= false;
		["obstacles 2"]		= false;
		["wijbase"]			= false;
		["miningoutpost"]	= false;
		["laboutpost"]		= false;
		["outpostterra"]	= false;
		["erin"]			= false;
		["radiostation"]	= false;
		["fairriver"]		= false;
		["bricktops"]		= false;
		["vermillion"]		= false;
		["pitgrounds"]		= false;
		["narrowgill"]		= false;
		["swordfight"]		= false;
		["ammobox"]			= false;
		["indigo 1"]		= false;
		["cerulean 1"]		= false;
		["holo"]			= false;
		["doors"]			= false;
		["holodoor"]		= false;
		["entry"]			= false;
		["on"]				= false;
		["off"]				= false;
		["forcefield"]		= false;
	}
	for _,v in pairs(keywords) do
		for i = 1,#v do
		a,b=string.lower(msg):find(v[i])
			if a ~= nil and b ~= nil then
				if a == b-(v[i]:len()-1) then
				mainvals[v[i]]=true
				end
			end
		end
	end
	wait()
	if (mainvals["computer"]==true and mainvals["load"]==true and mainvals["program"]==true) or (mainvals["computer"]==true and mainvals["run"]==true and mainvals["program"]==true) or (mainvals["computer"]==true and mainvals["begin"]==true and mainvals["program"]==true) then
		resetstats()
		if (mainvals["obstacles 1"]==true) then
			if running == false then
				running = true
				loadProgram("Obstacles1")
				--TimeChange("12.00.00")
			end
		elseif (mainvals["obstacles 2"]==true) then
			if running == false then
				running = true
				loadProgram("Obstacles2")
				--TimeChange("12.00.00")
			end
		elseif (mainvals["wijbase"]==true) then
			if running == false then
				running = true
				loadProgram("WIJBase")
				specialspawn(1)
				game.Lighting.TimeOfDay="12:00:00"
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["fairriver"] == true) then
			if running == false then
				running = true
				loadProgram("FairRiver")
				giveTools("FairRiver")
				randomiseTeams()
				AssignBricks()
				holoDoors()
				makeGui("You have "..cursimdea.Value.." lives.",5)
			end --specialspawn
		elseif (mainvals["erin"] == true) then
			if running == false then
				running = true
				loadProgram("Erin")
				if currentgen.Value=="W6" then
					makeGui("WARNING TO TRAINER: This simulation isn't fully compatible with W6 at the present time")
					wait(6)
				end
				giveTools("Erin")
				createteam()
				custassignbricks()
				Respawn(1)
				game.Lighting.TimeOfDay="12:00:00"
				wait(5)
				--print("LETS GO BABE")
				game.Workspace.Program.IRIS_E.Boss_IRIS_E.Disabled=false
			end
		elseif (mainvals["bricktops"] == true) then
			if running == false then
				running = true
				loadProgram("Bricktops")
				giveTools("Bricktops")
				randomiseTeams()
				custassignbricks()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["indigo 1"] == true) then
			if running == false then
				running = true
				makeGui("WARNING://SOME_STUTTER_MAY_OCCUR_DURING_LOAD")
				loadProgram("IndigoI")
				giveTools("IndigoI")
				randomiseTeams()
				custassignbricks()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				makeGui("The red team has to attack the base and get the terminal")
				makeGui("Blue defends. The trainer(s) calls a win.")
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["outpostterra"] == true) then
			if running == false then
				running = true
				makeGui("WARNING://SOME_STUTTER_MAY_OCCUR_DURING_LOAD")
				loadProgram("OutpostTerra")
				giveTools("OutpostTerra")
				randomiseTeams()
				custassignbricks()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				makeGui("The red team has to attack the base and get the terminal")
				makeGui("Blue defends. The trainer(s) calls a win.")
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["laboutpost"] == true) then
			if running == false then
				running = true
				makeGui("WARNING://SOME_STUTTER_MAY_OCCUR_DURING_LOAD")
				loadProgram("LabOutpost")
				giveTools("LabOutpost")
				randomiseTeams()
				custassignbricks()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				makeGui("The red team has to attack the base and get the terminal")
				makeGui("Blue defends. The trainer(s) calls a win.")
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["miningoutpost"] == true) then
			if running == false then
				running = true
				makeGui("WARNING://SOME_STUTTER_MAY_OCCUR_DURING_LOAD")
				loadProgram("MiningOutpost")
				giveTools("MiningOutpost")
				randomiseTeams()
				custassignbricks()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				makeGui("The red team has to attack the base and get the terminal")
				makeGui("Blue defends. The trainer(s) calls a win.")
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["cerulean 1"] == true) then
			if running == false then
				running = true
				makeGui("WARNING://SOME_STUTTER_MAY_OCCUR_DURING_LOAD")
				loadProgram("CeruleanI")
				for index, child in pairs(game.Workspace.Program.Lighting:GetChildren()) do
					child.Parent=game.Lighting
					--print("Set: "..child.Name)
				end
				giveTools("CeruleanI")
				randomiseTeams()
				custassignbricks()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				makeGui("The red team has to attack the base and get the terminal")
				makeGui("Blue defends. The trainer(s) calls a win.")
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["vermillion"] == true) then
			if running == false then
				running = true
				makeGui("WARNING://SOME_STUTTER_MAY_OCCUR_DURING_LOAD")
				wait(5)
				loadProgram("Vermillion")
				for index, child in pairs(game.Workspace.Program.Lighting:GetChildren()) do
					child.Parent=game.Lighting
					--print("Set: "..child.Name)
				end
				giveTools("Vermillion")
				randomiseTeams()
				custassignbricks()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				makeGui("The red team has to attack the base and steal the core")
				makeGui("Blue defends. The trainer(s) calls a win.")
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["narrowgill"] == true) then
			if running == false then
				running = true
				loadProgram("Narrowgill")
				giveTools("Narrowgill")
				randomiseTeams()
				custassignbricks()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["radiostation"] == true) then
			if running == false then
				running = true
				loadProgram("RadioStation")
				giveTools("radiostation")
				randomiseTeams()
				custassignbricks()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["pitgrounds"] == true) then
			if running == false then
				running = true
				loadProgram("Pitgrounds")
				giveTools("Pitgrounds")
				randomiseTeams()
				custassignbricks()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				ambient(166,166,166)
				Respawn()
			end
		elseif (mainvals["swordfight"] == true) then
			if running == false then
				running = true
				loadProgram("Swordfight")
				giveswords()
				holoDoors()
			end
		elseif (mainvals["ammobox"] == true) then
			if running == false then
				running = true
				loadProgram("AmmoBox")
				giveTools("AmmoBox")
				randomiseTeams()
				AssignBricks()
				holoDoors()
				makeGui("You have "..cursimdea.Value.." lives.",5)
				makeGui('The objective of the red team is to capture the "Ammobox" located in the blue armory.',5)
				makeGui('Blue has to defend. The simulation ends when the Ammobox is brought to the "cave" by red or the trainer(s) calls a win.',5)
				--Respawn()
			end
		end
	end
	if (mainvals["computer"]==true and mainvals["holodoor"]==true) then
		holoDoors()
	end
	if (mainvals["computer"]==true and mainvals["forcefield"]==true) then	
		if (mainvals["on"]==true) then
			game.Workspace.MainHoloDoors.ForceField.Transparency = 0.6
			game.Workspace.MainHoloDoors.ForceField.CanCollide = true
		elseif (mainvals["off"]==true) then
			game.Workspace.MainHoloDoors.ForceField.Transparency = 1
			game.Workspace.MainHoloDoors.ForceField.CanCollide = false
		end
	end
	if (mainvals["computer"]==true and mainvals["end"]==true and mainvals["program"]==true) then
		if running == true then
			for _,v in pairs(keywords) do
				for i = 1,#v do
					mainvals[v[i]]=false
				end
			end
			endProgram()
		end
	end
end