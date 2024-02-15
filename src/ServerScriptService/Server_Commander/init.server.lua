--DO NOT EDIT THIS SCRIPT! EDIT THE SETTINGS SCRIPT INSTEAD.

--[[
P.S. I appologize for releasing a broken version of Server_Commander.
The auto updating feature is bugged seemlingly everywhere except for my personal testing place,
so I have discontinued using it for now.

Sincerely,
ZeroSpectrum

]]

Version=1.071
Last_Updated='02-02-2014'

repeat wait(.05) until _G.varsfinished==true

math.randomseed(tick())

Place_Title		=_G.Place_Title
Place_Version	=_G.Place_Version
Place_Updated	=_G.Place_Updated
show_placeupdgui=_G.show_placeupdgui
show_adminupdgui=_G.show_adminupdgui

placeupdates	=_G.placeupdates

loc				=_G.loc

admins			=_G.admins
banned			=_G.banned
bannedgroups	=_G.bannedgroups
groups			=_G.groups
ranks			=_G.ranks
hrteamranks		=_G.hrteamranks
hrteam			=_G.hrteam

account_age		=_G.account_age

confirm_kick	=_G.confirm_kick

must_be_in_group=_G.must_be_in_group

uniformsupport	=_G.uniformsupport
autouniform		=_G.autouniform
group_shirts	=_G.group_shirts
group_pants		=_G.group_pants
shirt1			=_G.shirt1
pants1			=_G.pants1

timer			=_G.timer

team1			=_G.team1
team2			=_G.team2

funcommands=_G.funcommands

_G.placeupdates["title"]=Place_Title.."[v"..Place_Version.."]"
_G.placeupdates["title2"]="Updated "..Place_Updated

_G.adminupdates={
	["title"]="Server_Commander[v"..Version.."]",
	["title2"]="Updated "..Last_Updated,
	'- Added the option to disable "fun" commands',
	'- Added the !doublejump command',
	'- Removed auto updating for now',
	'- Fixed the !doublejump command',
}

_G.commands={
	"Server_Commander[v"..Version.."]",
	"Updated "..Last_Updated,
	"Target Groups",
	"all",
	"others",
	"me",
	"team-red",
	"plr1 plr2",
	"random",
	"By ZeroSpectrum",
	"!commands [OR] !help [OR] !list [OR] !cmds",
	"!updates",
	"!kill player(s)",
	"!explode [OR] !exp player(s)",
	"!lowgrav [OR] !lowgravity player(s)",
	"!grav [OR] !ungrav player(s)",
	"!heal player(s)",
	"!damage [OR] !dmg [OR] !hurt player(s) 20",
	"!freeze [OR] !stop player(s)",
	"!thaw [OR] !unfreeze player(s)",
	"!confuse player(s)",
	"!sit player(s) (requres funcommands to be enabled)",
	"!jump player(s) (requres funcommands to be enabled)",
	"!trip player(s) (requres funcommands to be enabled)",
	"doublejump player(s) (requres funcommands to be enabled)",
	"!speed [OR] !walkspeed player(s) 16",
	"!maxhealth [OR] !max player(s) 100",
	"!kick [OR] !boot [OR] !crash player(s)",
	"!ban player(s)",
	"!unban player1 player2 player3",
	"!admin player(s)",
	"!unadmin player(s)",
	"!load [OR] !respawn [OR] !spawn player(s)",
	"!teleport [OR] !tp player(s) finaltarget",
	"!give [OR] !tool player(s) toolname",
	"!givestarter [OR] !startertool [OR] !starter player(s) toolname",
	"!removetools [OR] !cleartools [OR] !clearbackpack player(s)",
	"!removestarter [OR] !clearstarter [OR] !clearstartergear player(s)",
	"!lock true/1 [OR] !lockserver false/0",
	"!funcommands true/1 [OR] !fc false/0",
	"!team [OR] !changeteam player(s) teamnamehere",
	"!uniform [OR] !uni player(s)",
	"!ununiform [OR] !ununi player(s)",
	"!autouni true/1 [OR] !autouniform false/0",
	"!ff [OR] !unff player(s)",
	"!grouponly 53272 [OR] !ungrouponly [OR] !grouponly clear",
	"!wijonly [OR] !unwijonly [OR] !wijonly clear",
	"!clearstats [OR] !resetstats player(s)",
	"!stats [OR] !leaderstats [OR] !changestats player(s) STAT 10",
	"!outlines true/1 [OR] !outlines false/0",
	"!shadows true/1 [OR] !globalshadows false/0",	
	"By owen0202",
	"!m [OR] !message [OR] !msg Hello [OR] !shout Hello 10 [OR] !m clear",
	"!r [OR] !run [OR] !execute code.here [OR] !r clear",
	"!ls [OR] !localscript code.here [OR] !ls clear",
	"By Lynixf",
	"!ranks [OR] !showranks",
	"!rt [OR] !randomteams",
	"!h [OR] !hint TypeHintHere",
	"!official [OR] !unofficial",
	"By Yodapal",
	"!gtele [OR] !gameteleport PlaceNumber",
	"By Auhrii",
	"!rim player(s)",
	"!unrim",
	"!spacejuice [OR] !sj player(s) [type]",
	"By enes130",
	"Fixed everything",
	"!nil & !spectate, does the same thing"
}

chars={[[!]],[[:]]} --chars[2] unused for now
local serverlocked=false
mods={}
uniformplrs={}

--Join check
function checkbanned(p)
	local bannedplr=false
	if serverlocked then
		bannedplr=true
	end
	if not bannedplr then
		for k, v in pairs (bannedgroups) do
			if p:IsIngroup(v) then
				bannedplr=true
				break
			end
		end
	end
	if not bannedplr then
		for k, v in pairs (banned) do
			if string.lower(v)==string.lower(p.Name) then
				bannedplr=true
				break
			end
		end
	end
	return bannedplr
end

function checkhr(p)
	local x=game:FindFirstChild('Teams')
	if x and hrteamranks[1]~=nil and hrteam~=(nil or "" or '') and game.Teams:FindFirstChild(hrteam) then
		for i=1,#groups do
			if p:GetRankInGroup(groups[i])>=hrteamranks[i] then
				p.TeamColor=game.Teams[hrteam].TeamColor
				break
			end
		end
	end
end

function checkuni(p)
	local giveuni=true
	local shirtfound=false
	local pantsfound=false
	if p.Character~=nil then
		for k,v in pairs(group_shirts) do
			if p.Character.Shirt.ShirtTemplate=="http://www.roblox.com/asset/?id="..tostring(v) then
				shirtfound=true
				break
			end
		end
		if shirtfound then
			for k,v in pairs(group_pants) do
				if p.Character.Pants.PantsTemplate=="http://www.roblox.com/asset/?id="..tostring(v) then
					pantsfound=true
					break
				end
			end
		end
		if shirtfound and pantsfound then
			giveuni=false
		end
	end
	return giveuni
end


--Admin check
function checkadmin(p)
	if p:FindFirstChild("Admin".._G.valkey) ~=nil then
		if p["Admin".._G.valkey].Value==true or p["SAdmin".._G.valkey].Value==true then
			return true
		else
			return false
		end
	end
	--[[local admin=false
	for k, v in pairs (admins) do
		if string.lower(v)==string.lower(p.Name) or p.UserId == 3631258 then
			admin=true
			break
		end
	end
	if not admin then
		for i=1,#groups do
			if p:IsInGroup(groups[i]) then 
				if p:GetRankInGroup(groups[i])>=ranks[i] then	
					admin=true
					break
				end
			end
		end
	end
	if not admin then
		for k, v in pairs (mods) do
			if string.lower(v)==string.lower(p.Name) then
				admin=true
				break
			end
		end
	end
	return admin]]
end

--Player matching
function matchplayer(word)
	local result=nil
	for k, v in pairs (game.Players:GetPlayers()) do
		if (string.find(string.lower(v.Name), word) == 1) then
			if (result ~= nil) then return nil end
			result = v
		end
	end
	return result
	
end

--Tool matching
function matchtool(word,location)
	local result=nil
	for k, v in pairs (location:GetChildren()) do
		if v:IsA("Tool") or v:IsA("HopperBin") then
			if (string.find(string.lower(v.Name), word) == 1) then
				if (result ~= nil) then return nil end
				result = v
			end
		end
	end
	return result
end

--Table matching
function checktable(tbl,word)
	local result=nil
	for k, v in pairs (tbl) do
		if (string.find(string.lower(v), word) == 1) then
			if (result ~= nil) then return nil end
			result = v
		end
	end
	return result
end

--Team matching
function matchteam(word)
	local result=nil
	if game:FindFirstChild("Teams") then
		for k, v in pairs (game.Teams:GetChildren()) do
			if (string.find(string.lower(v.Name), word) == 1) then
				if (result ~= nil) then return nil end
				result = v
			end
		end
	else return nil
	end
	return result
end

--leaderstats matching
function matchstat(word,p)
	local result=nil
	if p:FindFirstChild("leaderstats") then
		for k, v in pairs (p.leaderstats:GetChildren()) do
			if (string.find(string.lower(v.Name), word) == 1) then
				if (result ~= nil) then return nil end
				result = v
			end
		end
	else return nil
	end
	return result
end

--Check for certain target groups
function targetgroups(word,p)
	if word=='all' then
		for k, v in pairs (game.Players:GetPlayers()) do
			table.insert(targets, v)
		end
		return true
	elseif word=='others' then
		for k, v in pairs (game.Players:GetPlayers()) do
			if v ~= p then
				table.insert(targets, v)
			end
		end
		return true
	elseif word=='me' then
		table.insert(targets, p)
		return true
	elseif string.sub(word,1,string.len('team-'))=='team-' then
		teamtgt=matchteam(string.sub(word,string.len('team-')+1))
		if teamtgt~=nil then
			for k, v in pairs (game.Players:GetPlayers()) do
				if v.TeamColor==teamtgt.TeamColor then
					table.insert(targets, v)
				end
			end
		end
		return true
	elseif word=='random' then
		table.insert(targets,game.Players:children()[math.random(#game.Players:children())])
	else
		return false
	end
end

--Sections (Thank you owen0202)
function explode(div,str)
	if (div=='') then return false end
	local pos,arr = 0,{}
	for st,sp in function() return string.find(str,div,pos,true) end do 
		table.insert(arr,string.sub(str,pos,st-1))
		pos = sp + 1 
	end 
	table.insert(arr,string.sub(str,pos))
	return arr
end

--Kick plr
function kick(victim)
	if victim.Name~="enes130" then 
		victim:WaitForChild("PlayerGui")
		victim:kick("You have been kicked")
	end
end

--Fix camera for newly loaded players
function fixcam(target)
	target:WaitForChild("Backpack")
	local x=script.FixCamera:Clone()
	x.Parent=target:FindFirstChild("Backpack")
	x.Disabled=false
end

function checkuniplr(v) local giveuni=false for key, value in pairs (uniformplrs) do if value==v.Name then giveuni=true break end end return giveuni end

function telladmin(p) 
	repeat wait(.05) until p.PlayerGui~=nil
	repeat wait(.05) until p.Character~=nil
	local na=script.newadmin:Clone()
	na.Parent=p.PlayerGui
	na.Script.Disabled=false
end

function cmd_setup(plr,msg)
	local confirmationmode=""
	local subadmin=false
	if (checkadmin(plr) and string.sub(msg,1,1)==chars[1]) then
		cmd=string.lower(string.sub(msg,2))
		sections=explode(' ',cmd)
		
		--Search for players
		function findalltargets(start,finish)
			for i=start,finish do
				if targetgroups(sections[i],plr) then
				else
					local tgt=matchplayer(sections[i])
					if tgt~=nil then
						table.insert(targets,tgt)
					end
				end
			end
		end
		
		if confirmationmode=="" then targets={} end
		if (sections[1]=="commands" or sections[1]=="help" or sections[1]=="list" or sections[1]=="cmds") then
			plr:WaitForChild("PlayerGui")
			if game.Players:FindFirstChild(plr.Name) and not plr.PlayerGui:FindFirstChild("cl") then
				local gui=script.cl:Clone()
				gui.Parent=plr.PlayerGui
				gui.Script.Disabled=false
			else 
				local x=plr.PlayerGui:FindFirstChild("cl")
				if x then x:Destroy() end
			end
		elseif sections[1]=="updates" then
			if show_placeupdgui then
				plr:WaitForChild("PlayerGui")
				if game.Players:FindFirstChild(plr.Name) and not plr.PlayerGui:FindFirstChild("ud") then
					local gui=script.ud:Clone()
					gui.Parent=plr.PlayerGui
					gui.Script.Disabled=false
				else 
					local x=plr.PlayerGui:FindFirstChild("ud")
					if x then x:Destroy() end
				end
			end
		elseif sections[1]=="kill" then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.Health=0
					end
				end
			end
		elseif (sections[1]=="explode" or sections[1]=="exp") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						local expl=Instance.new("Explosion")
						expl.DestroyJointRadiusPercent=0
						expl.Position=v.Character.Torso.Position
						expl.Parent=v.Character
						v.Character:BreakJoints()
					end
				end
			end
		elseif (sections[1]=="lowgrav" or sections[1]=="lowgravity") then
			--Thanks khol! Heheheh
			--No but seriously, I didn't know where to start with this command
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						if not v.Character:FindFirstChild('bforce') then
							local bforce = Instance.new("BodyForce", v.Character.Torso) 
							bforce.Name = 'bforce' 
							bforce.force = Vector3.new(0,0,0)
							for k, p in pairs(v.Character:children()) do 
								if p:IsA("BasePart") then 
									bforce.force = bforce.force + Vector3.new(0,p:GetMass()*196.25,0) 
								elseif p:IsA("Hat") then 
									bforce.force = bforce.force + Vector3.new(0,p.Handle:GetMass()*196.25,0) 
								end 
							end
						end
					end
				end
			end
		elseif (sections[1]=="ungrav" or sections[1]=="grav") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						if v.Character.Torso:FindFirstChild('bforce')~=nil then
							v.Character.Torso.bforce:Destroy()
						end
					end
				end
			end
		elseif sections[1]=="heal" then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.Health=v.Character.Humanoid.MaxHealth
					end
				end
			end
		elseif (sections[1]=="damage" or sections[1]=="dmg" or sections[1]=="hurt") then
			if sections[3]~=nil and tonumber(sections[#sections])~=nil then
				findalltargets(2,#sections-1)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid:TakeDamage(sections[#sections])
					end
				end
			end
		elseif (sections[1]=="freeze" or sections[1]=="stop") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.WalkSpeed=0
					end
				end
			end
		elseif (sections[1]=="thaw" or sections[1]=="unfreeze") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.WalkSpeed=16
					end
				end
			end
		elseif sections[1]=="confuse" then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.WalkSpeed=-v.Character.Humanoid.WalkSpeed
					end
				end
			end
		elseif sections[1]=="sit" and funcommands then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.Sit=true
					end
				end
			end
		elseif sections[1]=="jump" and funcommands then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.Jump=true
					end
				end
			end
		elseif sections[1]=="trip" then
			--This has to be the most complicated trip command of all time
			if sections[2]~=nil and tonumber(sections[#sections])~=nil and funcommands then
				findalltargets(2,#sections-1)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.PlatformStand=true
					end
				end
				wait(tonumber(sections[#sections]))
			elseif sections[2]~=nil and tonumber(sections[#sections])==nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.PlatformStand=true
					end
				end
				wait(0.5)
			end
			for k, v in pairs (targets) do
				if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
					v.Character.Humanoid.PlatformStand=false
				end
			end
		elseif sections[1]=="doublejump" then
			if sections[2]~=nil and funcommands then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						if not v.Backpack:FindFirstChild('double') then
							local d=script.double:Clone()
							d.Parent=v.Backpack
							d.Disabled=false
						end
					end
				end
			end
		elseif (sections[1]=="speed" or sections[1]=="walkspeed") then
			if sections[3]~=nil and tonumber(sections[#sections])~=nil then
				findalltargets(2,#sections-1)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.WalkSpeed=tonumber(sections[#sections])
					end
				end
			end
		elseif (sections[1]=="maxhealth" or sections[1]=="max") then
			if sections[3]~=nil and tonumber(sections[#sections])~=nil then
				findalltargets(2,#sections-1)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid.MaxHealth=tonumber(sections[#sections])
						wait()
						v.Character.Humanoid.Health=v.Character.Humanoid.MaxHealth
					end
				end
			end
		elseif (sections[1]=="kick" or sections[1]=="boot" or sections[1]=="crash") then
			if checktable(mods,plr.Name) then subadmin=true end 
			if sections[2]~=nil and confirmationmode=="" and not subadmin and confirm_kick then
				findalltargets(2,#sections)
				local h=plr.PlayerGui:FindFirstChild("Message")
				if h then h:Destroy() end
				h=Instance.new("Message",plr.PlayerGui)
				local names={}
				for k, v in pairs (targets) do
					table.insert(names,v.Name)
				end
				h.Text='Kick '..table.concat(names, ' ')..'? Type (!yes/!no) to confirm.'
				confirmationmode="kick"
			elseif sections[2]~=nil and not subadmin and not confirm_kick then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if #targets<=3 then
					if game.Players:FindFirstChild(v.Name) then
						kick(v)
					end
					end
				end
			end
		elseif sections[1]=="ban" then
			if checktable(mods,plr.Name) then subadmin=true end
			if sections[2]~=nil and confirmationmode=="" and not subadmin then
				findalltargets(2,#sections)
				local h=plr.PlayerGui:FindFirstChild("Message")
				if h then h:Destroy() end
				h=Instance.new("Message",plr.PlayerGui)
				local names={}
				for k, v in pairs (targets) do
					table.insert(names,v.Name)
				end
				h.Text='Ban '..table.concat(names, ' ')..'? Type (!yes/!no) to confirm.'
				confirmationmode="ban"
			end
		elseif sections[1]=="unban" then
			if checktable(mods,plr.Name) then subadmin=true end 
			if sections[2]~=nil and confirmationmode=="" and not subadmin then
				for i=2,#sections do
					local tgt=checktable(banned,sections[i])
					if tgt~=nil then
						table.insert(targets,tgt)
					end
				end
				local h=plr.PlayerGui:FindFirstChild("Message")
				if h then h:Destroy() end
				h=Instance.new("Message",plr.PlayerGui)
				h.Text='Retrieve '..table.concat(targets, ' ')..' from banland? Type (!yes/!no) to confirm.'
				confirmationmode="unban"
			end
		elseif sections[1]=="adminxxxxx" then
			if checktable(mods,plr.Name) then subadmin=true end 
			if sections[2]~=nil and confirmationmode=="" and not subadmin then
				findalltargets(2,#sections)
				local h=plr.PlayerGui:FindFirstChild("Message")
				if h then h:Destroy() end
				h=Instance.new("Message",plr.PlayerGui)
				local names={}
				for k, v in pairs (targets) do
					table.insert(names,v.Name)
				end
				h.Text='Make '..table.concat(names, ' ')..' mods? Type (!yes/!no) to confirm.'
				confirmationmode="admin"
			end
		elseif sections[1]=="unadminxxxx" then
			if checktable(mods,plr.Name) then subadmin=true end 
			if sections[2]~=nil and confirmationmode=="" and not subadmin then
				for i=2,#sections do
					local tgt=checktable(mods,sections[i])
					if tgt~=nil then
						table.insert(targets,tgt)
					end
				end
				local h=plr.PlayerGui:FindFirstChild("Message")
				if h then h:Destroy() end
				h=Instance.new("Message",plr.PlayerGui)
				h.Text='Take away admin from '..table.concat(targets, ' ')..'? Type (!yes/!no) to confirm.'
				confirmationmode="unadmin"
			end
		elseif sections[1]=="yes" then
			if confirmationmode=="kick" or confirmationmode=="ban" then
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) then
						if confirmationmode=="ban" then
							table.insert(banned, v.Name)
						end
						kick(v)
					end
				end
			else if confirmationmode=="unban" then
				for i, v in ipairs (banned) do
					for key, value in pairs (targets) do
						if v==value then
							table.remove(banned,i)
						end
					end
				end
			else if confirmationmode=="unadmin" then
				for i, v in ipairs (mods) do
					for key, value in pairs (targets) do
						if string.lower(v)==string.lower(value) then
							table.remove(mods,i)
						end
					end
				end
			else if confirmationmode=="admin" then
				for k, v in pairs (targets) do
					local alreadymod=false
					if game.Players:FindFirstChild(v.Name) then
						for key, value in pairs (mods) do
							if value==v.Name then
								alreadymod=true
								break
							end
						end
						if not alreadymod then
							for key, value in pairs (admins) do
								if value==v.Name then
									alreadymod=true
									break
								end
							end
						end
						if not alreadymod then
							table.insert(mods,v.Name)
							telladmin(v)
						end
					end
				end
			end
			end
			end
			end
			local h=plr.PlayerGui:FindFirstChild("Message")
			if h then h:Destroy() end
			confirmationmode=""
		elseif sections[1]=="no" then
			local h=plr.PlayerGui:FindFirstChild("Message")
			if h then h:Destroy() end
			confirmationmode=""
		elseif (sections[1]=="respawn" or sections[1]=="spawn") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
			end
			for k, v in pairs (targets) do
				if game.Players:FindFirstChild(v.Name) then
					v:LoadCharacter()
					fixcam(v)
				end
			end
		elseif (sections[1]=="teleport" or sections[1]=="tp") then
			--Lol i'm using a table to store 1 name
			local dest={}
			if sections[3]~=nil then
				findalltargets(2,#sections-1)
				local tgt=matchplayer(sections[#sections])
					if tgt~=nil then
						table.insert(dest,tgt)
					end
				if dest[1]~=nil then
					for k, v in pairs (targets) do
						if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
							v.Character:MoveTo(dest[1].Character.Torso.CFrame.p+Vector3.new(0,7,0))
						end
					end
				end
			end
		elseif (sections[1]=="give" or sections[1]=="tool") then
			--Lol i'm using a table to store 1 weapon
			local tool={}
			if sections[3]~=nil then
				findalltargets(2,#sections-1)
				local tgt=matchtool(sections[#sections],loc)
				if tgt~=nil then
					table.insert(tool,tgt)
				end
				if tool[1]~=nil then
					for k, v in pairs (targets) do
						if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
							tool[1]:Clone().Parent=v.Backpack
						end
					end
				end
			end
		elseif (sections[1]=="givestarter" or sections[1]=="startertool" or sections[1]=="starter") then
			--Lol i'm using a table to store 1 weapon
			local tool={}
			if sections[3]~=nil then
				findalltargets(2,#sections)
				local tgt=matchtool(sections[#sections],loc)
				if tgt~=nil then
					table.insert(tool,tgt)
				end
				tool[1]:Clone().Parent=game.StarterPack
				if tool[1]~=nil then
					for k, v in pairs (targets) do
						if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
							tool[1]:Clone().Parent=v.Backpack
						end
					end
				end
			end
		elseif (sections[1]=="removetools" or sections[1]=="cleartools" or sections[1]=="clearbackpack") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.Character.Humanoid:UnequipTools()
						v.Backpack:ClearAllChildren()
					end
				end
			end
		elseif (sections[1]=="removestarter" or sections[1]=="clearstarter" or sections[1]=="clearstartergear") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						v.StarterGear:ClearAllChildren()
					end
				end
			end
		elseif (sections[1]=="lock" or sections[1]=="lockserver") then
			if checktable(mods,plr.Name) then subadmin=true end
			if (sections[2]=="true" or sections[2]=="1") and not subadmin then
				serverlocked=true
				if not game.Workspace:FindFirstChild("LockHint") then
					h=Instance.new("Hint",game.Workspace)
					h.Name="LockHint"
					h.Text='The server is locked. Type (!lock false) to unlock.'
				end
			elseif (sections[2]=="false" or sections[2]=="0") and not subadmin then
				serverlocked=false
				local lh=game.Workspace:FindFirstChild("LockHint")
				if lh then lh:Destroy() end 
			end
		elseif (sections[1]=="fc" or sections[1]=="funcommands") then
			if checktable(mods,plr.Name) then subadmin=true end
			if (sections[2]=="true" or sections[2]=="1") and not subadmin then
				funcommands=true
			elseif (sections[2]=="false" or sections[2]=="0") and not subadmin then
				funcommands=false
			end
		elseif sections[1]=="nil" or sections[1]=="spectate" then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						script.CameraGui:Clone().Parent=v.PlayerGui
					end
				end
			end
		elseif (sections[1]=="uniform" or sections[1]=="uni") then
			if uniformsupport and sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) then
						if v.Character~=nil then
							local ch=v.Character
							repeat wait(.05) until ch:FindFirstChild('Shirt')~=nil
							repeat wait(.05) until ch:FindFirstChild('Pants')~=nil
							if checkuni(v) then
								ch.Shirt:Destroy()
								ch.Pants:Destroy()
								local s=Instance.new('Shirt')
								local p=Instance.new('Pants')
								s.ShirtTemplate="http://www.roblox.com/asset/?id="..tostring(shirt1)
								p.PantsTemplate="http://www.roblox.com/asset/?id="..tostring(pants1)
								s.Parent=ch
								p.Parent=ch
							end
						end
						local alreadyuni=false
						for key, value in pairs (uniformplrs) do
							if value==v.Name then
								alreadyuni=true
								break
							end
						end
						if not alreadyuni then
							table.insert(uniformplrs,v.Name)
						end
					end
				end
			end
		elseif (sections[1]=="ununi" or sections[1]=="ununiform") then
			if uniformsupport and sections[2]~=nil then
				findalltargets(2,#sections)
				for i, v in ipairs (uniformplrs) do
					for key, value in pairs (targets) do
						if v==value.Name then
							table.remove(uniformplrs,i)
						end
					end
				end
			end
		elseif (sections[1]=="autouniform" or sections[1]=="autouni") then
			if checktable(mods,plr.Name) then subadmin=true end
			if uniformsupport and sections[2]~=nil and not subadmin then
				if (sections[2]=="true" or sections[2]=="1") then
					autouniform=true
					for k, v in pairs (game.Players:GetPlayers()) do
						if game.Players:FindFirstChild(v.Name) then
							if v.Character~=nil then
								local ch=v.Character
								repeat wait(.05) until ch:FindFirstChild('Shirt')~=nil
								repeat wait(.05) until ch:FindFirstChild('Pants')~=nil
								if checkuni(v) then
									ch.Shirt:Destroy()
									ch.Pants:Destroy()
									local s=Instance.new('Shirt')
									local p=Instance.new('Pants')
									s.ShirtTemplate="http://www.roblox.com/asset/?id="..tostring(shirt1)
									p.PantsTemplate="http://www.roblox.com/asset/?id="..tostring(pants1)
									s.Parent=ch
									p.Parent=ch
								end
							end
							local alreadyuni=false
							for key, value in pairs (uniformplrs) do
								if value==v.Name then
									alreadyuni=true
									break
								end
							end
							if not alreadyuni then
								table.insert(uniformplrs,v.Name)
							end
						end
					end
				elseif (sections[2]=="false" or sections[2]=="0") then
					autouniform=false
				end
			end
		elseif (sections[1]=="ff" or sections[1]=="forcefield") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						local ff=Instance.new("ForceField",v.Character)
					end
				end
			end
		elseif (sections[1]=="unff" or sections[1]=="unforcefield") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v.Character~=nil then
						for key, value in pairs (v.Character:GetChildren()) do
							if value:IsA("ForceField") then
								value:Destroy()
							end
						end
					end
				end
			end
		elseif (sections[1]=="team" or sections[1]=="changeteam") then
			--Lol i'm using a table to store 1 team
			local teem={}
			if sections[3]~=nil then
				findalltargets(2,#sections-1)
				local tgt=matchteam(sections[#sections])
				if tgt~=nil then
					table.insert(teem,tgt)
				end
				if teem[1]~=nil then
					for k, v in pairs (targets) do
						if game.Players:FindFirstChild(v.Name) then
							v.TeamColor=teem[1].TeamColor
						end
					end
				end
			end
		elseif (sections[1]=="grouponly" or sections[1]=="ungrouponly" or sections[1]=="wijonly" or sections[1]=="unnwijonly") then
			if checktable(mods,plr.Name) then subadmin=true end
			if not subadmin then
				if sections[1]=="grouponly" and sections[2]~=nil and tonumber(sections[2])~=nil then
					must_be_in_group=tonumber(sections[2])
				elseif (sections[1]=="grouponly" and sections[2]=="clear") or (sections[1]=="ungrouponly") or (sections[1]=="wijonly" and sections[2]=="clear") or (sections[1]=="unwijonly") then
					must_be_in_group=0
				elseif (sections[1]=="wijonly" and sections[2]==nil) then
					must_be_in_group=3747606
				end
			end
		elseif (sections[1]=="clearstats" or sections[1]=="resetstats") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) and v:FindFirstChild("leaderstats") then
						for key, stat in pairs (v.leaderstats:GetChildren()) do
							if stat:IsA("IntValue") then
								stat.Value=0
							end
						end
					end
				end
			end
		elseif (sections[1]=="stats" or sections[1]=="changestats" or sections[1]=="leaderstats") then
			--Lol i'm using a table to store 1 leaderstat
			local stat={}
			if sections[4]~=nil and tonumber(sections[#sections])~=nil then
				findalltargets(2,#sections-2)
				local tgt=matchstat(sections[#sections-1],plr)
				if tgt~=nil then
					table.insert(stat,tgt)
				end
				if stat[1]~=nil and stat[1]:IsA("IntValue") then
					for k, v in pairs (targets) do
						if game.Players:FindFirstChild(v.Name) then
							v.leaderstats[stat[1].Name].Value=tonumber(sections[#sections])
						end
					end
				end
			end
		elseif sections[1]=="outlines" then
			if (sections[2]=="true" or sections[2]=="1") then
				game.Lighting.Outlines=true
			elseif (sections[2]=="false" or sections[2]=="0") then
				game.Lighting.Outlines=false
			end
		elseif (sections[1]=="shadows" or sections[1]=="globalshadows") then
			if (sections[2]=="true" or sections[2]=="1") then
				game.Lighting.GlobalShadows=true
				game.Lighting.Ambient=Color3.new(0/255,0/255,0/255)
				game.Lighting.ColorShift_Bottom=Color3.new(0/255,0/255,0/255)
				game.Lighting.ColorShift_Top=Color3.new(0/255,0/255,0/255)
			elseif (sections[2]=="false" or sections[2]=="0") then
				game.Lighting.GlobalShadows=false
				game.Lighting.Ambient=Color3.new(120/255,120/255,120/255)
				game.Lighting.ColorShift_Bottom=Color3.new(100/255,100/255,100/255)
				game.Lighting.ColorShift_Top=Color3.new(100/255,100/255,100/255)
			end
		elseif (sections[1]=="msg" or sections[1]=="m" or sections[1]=="message" or sections[1]=="shout") and sections[2]~=nil then
			--owen0202
			basecmd=string.sub(msg,2)
			sections=explode(' ',basecmd)
			if string.lower(sections[2])=="clear" then
				local g=game.Workspace:GetChildren()
				for i=1,#g do
					if (g[i]:IsA("Message")) and (g[i].Name=="adminMessage") then
					g[i]:Destroy()
					end
				end
			elseif string.lower(sections[2])~="clear" then
				local msg=Instance.new("Message",game.Workspace)
				msg.Name="adminMessage"
				if tonumber(sections[#sections])==nil then
					msg.Text=table.concat(sections,' ',2,#sections)
					wait(#msg.Text/7.5)
				elseif tonumber(sections[#sections])~=nil then
					msg.Text=table.concat(sections,' ',2,#sections-1)
					wait(tonumber(sections[#sections]))
				end
				msg:Destroy()
			end
		elseif (sections[1]=="execute" or sections[1]=="run" or sections[1]=="r" or sections[1]=="script" or sections[1]=="s") and sections[2]~=nil then
			--owen0202
			basecmd=string.sub(msg,2)
			sections=explode(' ',basecmd)
			if string.lower(sections[2])=="clear" then
				local d=game.Workspace:GetChildren()
				for i=1,#d do
					if (d[i]:IsA("Script") and d[i].Name=="custom_Script") then
					d[i].Disabled=true
					d[i]:Destroy()
					end
				end
			elseif sections[2]~=nil then
				local code=table.concat(sections,' ',2,#sections)
				local newscript=script["custom_Script"]:clone()
				newscript.runCode.Value=code
				newscript.Disabled=false
				newscript.Parent=game.Workspace
			end
		elseif (sections[1]=="ls" or sections[1]=="localscript") and sections[2]~=nil then
			--owen0202
			basecmd=string.sub(msg,2)
			sections=explode(' ',basecmd)
			if string.lower(sections[2])=="clear" and plr.Character~=nil then
				local d=plr.Character:GetChildren()
				for i=1,#d do
					if (d[i]:IsA("Script") and d[i].Name=="custom_Local") then
					d[i].Disabled=true
					d[i]:Destroy()
					end
				end
			elseif sections[2]~=nil and plr.Character~=nil then
				local code=table.concat(sections,' ',2,#sections)
				local newscript=script["custom_Local"]:clone()
				newscript.runCode.Value=code
				newscript.Disabled=false
				newscript.Parent=plr.Character
			end
		elseif (sections[1]=="checkranks" or sections[1]=="showranks" or sections[1]=="getranks" or sections[1]=="ranks") then
			--Lynixf
			for _, v in pairs(game.Players:GetChildren()) do
				if v:IsInGroup(groups[1]) and v.Character:findFirstChild("Head") then
					local c=script.RankGui:clone()
					c.Parent=v.Character.Head
					c.Frame.TextLabel.Text=v:GetRoleInGroup(groups[1])
					c.Adornee=v.Character.Head
					c.Enabled=true
				end
			end
			wait(6)
			for _, v in pairs(game.Players:GetChildren()) do
				if v.Character:findFirstChild("Head") and v.Character.Head:findFirstChild("RankGui") then
					v.Character.Head.RankGui:Destroy()
				end
			end
		elseif (sections[1]=="randomteams" or sections[1]=="rt") then
			--Lynixf
			local tab={};
				if game.Teams:FindFirstChild(team1) and game.Teams:FindFirstChild(team2) then
					for _,v in pairs(game.Players:GetChildren()) do
						if v.Name==plr.Name then
							print("notthisguy")
						else 
							table.insert(tab,math.random(#tab+1),v);
						end
					end
				end
			for i,v in pairs(tab) do
				if i%2==0 then
					v.TeamColor=game.Teams[team1].TeamColor;
				else
					v.TeamColor=game.Teams[team2].TeamColor;
				end 
			end
		elseif (sections[1]=="h" or sections[1]=="hint") and (sections[2]~=nil) then
			--Lynixf
			local actualmessage=string.sub(msg, 4, string.len(msg))
			pcall(function() game.StarterGui.ARCGui.TopFrame.MessagePart.Text=actualmessage for _, v in pairs(game.Players:GetChildren()) do v.PlayerGui.ARCGui.TopFrame.MessagePart.Text=actualmessage end end)
		elseif (sections[1]=="un" or sections[1]=="unofficial" or sections[1]=="unofficialize") then
			--Lynixf
			game.StarterGui.ARCGui.TopFrame.RankPart.Text="UNOFFICIAL" for _, v in pairs(game.Players:GetChildren()) do v.PlayerGui.ARCGui.TopFrame.RankPart.Text="UNOFFICIAL" end
		elseif (sections[1]=="of" or sections[1]=="official" or sections[1]=="officialize") then
			--Lynixf
			game.StarterGui.ARCGui.TopFrame.RankPart.Text="OFFICIAL" for _, v in pairs(game.Players:GetChildren()) do v.PlayerGui.ARCGui.TopFrame.RankPart.Text="OFFICIAL" end
		elseif (sections[1]=="gameteleport" or sections[1]=="gtele") then
			--Yodapal
			if checktable(mods,plr.Name) then subadmin=true end
			if sections[2]~=nil and not subadmin then
				for i, v in pairs(game.Players:GetChildren()) do
					if not plr.PlayerGui:FindFirstChild('tg') then
						local tg=script.tg:Clone()
						tg.Parent = v.PlayerGui
						tg.TeleportScript.PlaceId.Value = sections[2]
						tg.Script.Disabled=false
					end
				end
			end
		elseif sections[1]=="rim" then
			if not game.Teams:FindFirstChild("RIM") then
				local rim = Instance.new("Team")
				rim.Name = "RIM"
				rim.AutoAssignable = false
				rim.TeamColor = BrickColor.new("Crimson")
				rim.Parent = game.Teams
			end
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) then
						game.Players[v.Name].TeamColor = BrickColor.new("Crimson")
						game.Players[v.Name]:LoadCharacter()
					end
				end
			end
		elseif sections[1]=="unrim" then
			if game.Teams:FindFirstChild("RIM") then
				game.Teams.RIM:Destroy()
			end
			for number,data in pairs(game.Players:GetChildren()) do
				if data.TeamColor == BrickColor.new("Crimson") then
					data.TeamColor = BrickColor.new("Bright blue")
					data:LoadCharacter()
				end
			end
		elseif sections[1]=="weapondrop" then
			local tgt=nil
			for number,data in pairs(game.Players:GetChildren()) do
			if sections[2] then
				tgt = matchtool(sections[2],game.ServerStorage.Weapons)
					if tgt then
						if data.Backpack then
							tgt:Clone().Parent=data.Backpack
						end
					end
				end
			end
			if tgt~=nil then
				_G.Talk111("[IRIS]: !WEAPONDROP! THIS LIFE ONLY!","IRIS")
			end
		elseif sections[1]=="starterdrop" then
			local tgt=nil
			for number,data in pairs(game.Players:GetChildren()) do
			if sections[2] then
				 tgt = matchtool(sections[2],game.ServerStorage.Weapons)
					if tgt then
						if data.Backpack then
							tgt:Clone().Parent=data.Backpack
						end
					end
				end
			end
			tgt:Clone().Parent=game.StarterPack
			if tgt~=nil then
				warn("WEAPONDROP! FOR THE WHOLE MATCH!")
				_G.Talk111("[IRIS]: !WEAPONDROP! FOR THE WHOLE MATCH!","IRIS")
			end
		elseif (sections[1]=="spacejuice" or sections[1]=="sj") then
			if sections[2]~=nil then
				findalltargets(2,#sections)
				for k, v in pairs (targets) do
					if game.Players:FindFirstChild(v.Name) then
						local sj
						if sections[3] then
							local tgt = matchtool(sections[3],game.ServerStorage.SpaceJuice)
							if tgt then
								sj = tgt:Clone()
							end
						else
							local rand = math.random(1,#game.ServerStorage.SpaceJuice:GetChildren())
							sj = game.ServerStorage.SpaceJuice:GetChildren()[rand]:Clone()
						end
						if sj then
							sj.Parent = v.Backpack
						end
					end
				end
			end
		end
	end
end

game.Players.PlayerAdded:Connect(function(plr)
	initPlayer(plr)
end)

initPlayer = function(plr)
		warn("Player: "..plr.Name.." added according to server_commander")
	if checkbanned(plr) then
		repeat wait(.05) until (plr.PlayerGui~=nil and plr.Character~=nil)
		kick(plr)
	else
		checkhr(plr)
		if checkadmin(plr) then
			telladmin(plr)
		end
	end
	
	--Optional uniform on respawn
	plr.CharacterAdded:Connect(function(char)
		if uniformsupport and checkuniplr(plr) or autouniform then
			repeat wait(.05) until char:FindFirstChild('Shirt')~=nil
			repeat wait(.05) until char:FindFirstChild('Pants')~=nil
			if checkuni(plr) then
				char.Shirt:Destroy()
				char.Pants:Destroy()
				local s=Instance.new('Shirt')
				local p=Instance.new('Pants')
				s.ShirtTemplate="http://www.roblox.com/asset/?id="..tostring(shirt1)
				p.PantsTemplate="http://www.roblox.com/asset/?id="..tostring(pants1)
				s.Parent=char
				p.Parent=char
			end
		end
	end)
	
	--Place Update GUI
	if show_placeupdgui then
		val = "pU"
		plr:WaitForDataReady()
		local score = Instance.new("NumberValue")
		score.Name = "PlaceVersion"
		score.Parent = plr
		local ok, ret = pcall(function() return plr:LoadNumber(val) end)
		if ok then
			if ret ~= nil then
				score.Value = ret
				if score.Value~=Place_Version then
					plr:WaitForChild("PlayerGui")
					local gui=script.ud:Clone()
					if not show_adminupdgui then
						gui.main.admintab:Destroy()
					end
					gui.Parent=plr.PlayerGui
					gui.Script.Disabled=false
				end
			end
		end
	end
	
	
	plr.Chatted:Connect(function(msg)
		cmd_setup(plr,msg)
	end)
end



local Http = game:GetService("HttpService")
local webHook = require(game.ServerScriptService.WebhookAPI)
local myWebHook = webHook.new("333704450533359647","SLeVGUFsxt6od0X5RGrPW7pibr0lUTN_5Sd2OXG56ivCkmPgzvinqNBCY_kuWiFYxXyj")

game.Players.PlayerRemoving:Connect(function(plr)
	local succ, ret = pcall(function() plr:SaveNumber(val,Place_Version) end) 
end)

--for all players that loaded in before the code
for _, player in pairs(game.Players:GetPlayers()) do
	initPlayer(player)
end
warn("Starter the server commander")

--My only friend, the end.