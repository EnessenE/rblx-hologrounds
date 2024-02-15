stands = {}
CTF_mode = false
local passId = 141105633
--x = 1 10*x*10+5*x 

_G.KillMedals = {
['KILL'] = {['NAME']='Kill',['POINTS']=20};
['ASSIST'] = {['NAME']='Assist',['POINTS']=10};
['HEADSHOT'] = {['NAME']='Headshot',['POINTS']=25};
['LONGSHOT'] = {['NAME']='Longshot',['POINTS']=10};
['REVENGE'] = {['NAME']='Revenge',['POINTS']=15};
['AVENGER'] = {['NAME']='Avenger',['POINTS']=10};
['COMEBACK'] = {['NAME']='Comeback',['POINTS']=10};
['DEFIANT'] = {['NAME']='Defiant',['POINTS']=15};
['AFTERLIFE'] = {['NAME']='AfterLife',['POINTS']=5};
['HUNTER'] = {['NAME']='Hunter',['POINTS']=15};
['DENIED'] = {['NAME']='Denied',['POINTS']=15};
['WARLORD']={['NAME']='War Lord',['POINTS']=5};
['CAPTURE'] = {['NAME']='Captured',['POINTS']=50};
	}

_G.KillStreaks = {
{['NAME']='Killing Spree',['POINTS']=10,['REQUIRMENT']=5};
{['NAME']='Killing Frenzy',['POINTS']=10,['REQUIRMENT']=10};
{['NAME']='Running Riot',['POINTS']=20,['REQUIRMENT']=15};
{['NAME']='Rampage',['POINTS']=20,['REQUIRMENT']=20};
{['NAME']='Untouchable',['POINTS']=20,['REQUIRMENT']=25};
{['NAME']='Invincible',['POINTS']=25,['REQUIRMENT']=30};
{['NAME']='Inconceivable',['POINTS']=25,['REQUIRMENT']=35};
{['NAME']='Unfriggenbelievable',['POINTS']=50,['REQUIRMENT']=40};
}

_G.ChainKills = {
{['NAME']='Double Kill',['POINTS']=5};
{['NAME']='Triple KIll',['POINTS']=5};
{['NAME']='Over Kill',['POINTS']=5};
{['NAME']='Killtacular',['POINTS']=10};
{['NAME']='Killtrocity',['POINTS']=10};
{['NAME']='Killamanjaro',['POINTS']=10};
{['NAME']='Killtastrophe',['POINTS']=25};
{['NAME']='Killpocalypse',['POINTS']=25};
{['NAME']='Killionaire',['POINTS']=50};
}


function isAuthenticated(player,id) -- checks to see if the player owns your pass
    return game:GetService("GamePassService"):PlayerHasPass(player,id)
end

_G.createTag = function(n,v,p)
cl=Instance.new("IntValue")
cl.Name=n
cl.Value=v 
cl.Parent=p
end

getAssist = function(assist,killer)
	local assistplrs = {}
	local checkAssist = function(pl)
			for i,v in pairs(assistplrs) do
				if pl.Name==v then return false end
			end
			return true
		end
	for i,tag in pairs(assist) do
		if tag.Name==('creator') then
			local p = tag.Value
			if p~=nil and p.Name~=killer.Name then
				if checkAssist(p)==true then
				table.insert(assistplrs,p.Name)
				_G.createTag(_G.KillMedals['ASSIST']['NAME'],_G.KillMedals['ASSIST']['POINTS'],p.KillFeed)	
				end	
			end
		end
	end
end



Teams = {['Bright orange']=1,['Bright green']=1,['Bright red']=2,['White']=3}

function onHumanoidDied(humanoid, player)
	--local stats = player:findFirstChild("leaderstats")
	--local deaths = stats:findFirstChild("Wipeouts")
	--deaths.Value = deaths.Value + 1
	player.Died.Value=true
	local killer = getKillerOfHumanoidIfStillInGame(humanoid)
	handleKillCount(humanoid, player)
end

function onPlayerRespawn(property, player)
	if property == "Character" and player.Character ~= nil then
		local humanoid = player.Character.Humanoid
		local p = player
		local h = humanoid
		p.Streak.Value=0
		SaveData(p)
		humanoid.Died:Connect(function() onHumanoidDied(h, p) end )
	end
end

function getKillerOfHumanoidIfStillInGame(humanoid)
		local tags = humanoid:GetChildren()
	if tags[#tags]~=nil then 
		if tags[#tags].Name==("creator") then 
			tag = tags[#tags] else tag=nil 
		end 
	else tag=nil 
	end

	-- find player with name on tag
	if tag ~= nil then
		
		local killer = tag.Value
		if killer.Parent ~= nil then -- killer still in game
			return killer
		end
	end

	return nil
end

function handleKillCount(humanoid, player)
	local killer = getKillerOfHumanoidIfStillInGame(humanoid)
	if killer ~= nil then
		if killer:findFirstChild("leaderstats") then
			---------------Setting Variables
			local stats =	killer:findFirstChild("leaderstats")
			local kills =	stats:findFirstChild("KOs")
			local assist = humanoid:GetChildren()
			------------------------------------------------
			kills.Value = kills.Value+1 --add 1 kill to player
			killer.Streak.Value=killer.Streak.Value+1
			----
			_G.createTag(_G.KillMedals['KILL']['NAME'],_G.KillMedals['KILL']['POINTS'],killer.KillFeed)
			if (tick()-killer.LastKill.Value)<=10 or killer.Chain.Value==0 then killer.Chain.Value = killer.Chain.Value + 1 if killer.Chain.Value>1 and killer.Chain.Value<10 then _G.createTag(_G.ChainKills[killer.Chain.Value-1]['NAME'],_G.ChainKills[killer.Chain.Value-1]['POINTS'],killer.KillFeed) end elseif (tick()-killer.LastKill.Value)>10 or chain.Value~=0 then killer.Chain.Value=0 end
			for i,v in pairs(_G.KillStreaks) do if killer.Streak.Value == v['REQUIRMENT'] then _G.createTag(v['NAME'],v['POINTS'],killer.KillFeed) end end			
			if (killer.Character.Torso.Position-player.Character.Torso.Position).magnitude>=200 then _G.createTag(_G.KillMedals['LONGSHOT']['NAME'],_G.KillMedals['LONGSHOT']['POINTS'],killer.KillFeed) end 					
			if killer.Revenge.Value==player.Name then _G.createTag(_G.KillMedals['REVENGE']['NAME'],_G.KillMedals['REVENGE']['POINTS'],killer.KillFeed) killer.Revenge.Value='' end player.Revenge.Value=killer.Name
			if game.Players:findFirstChild(player.LastKilledPlayer.Value) and player.LastKilledPlayer.Value~=killer.Name and Teams[game.Players:findFirstChild(player.LastKilledPlayer.Value).TeamColor.Name]==Teams[killer.TeamColor.Name] and (tick()-player.LastKill.Value)<15 then _G.createTag(_G.KillMedals['AVENGER']['NAME'],_G.KillMedals['AVENGER']['POINTS'],killer.KillFeed) end
			if player.Name==killer.LastKilledPlayer.Value and tick()-killer.LastKill.Value<120 then _G.createTag(_G.KillMedals['HUNTER']['NAME'],_G.KillMedals['HUNTER']['POINTS'],killer.KillFeed) end	
			for i,v in pairs(_G.KillStreaks) do if player.Streak.Value == v['REQUIRMENT']-1 then _G.createTag(_G.KillMedals['DENIED']['NAME'],_G.KillMedals['DENIED']['POINTS'],killer.KillFeed) end end				
			if killer.DeathStreak.Value>=3 then _G.createTag(_G.KillMedals['COMEBACK']['NAME'],_G.KillMedals['COMEBACK']['POINTS'],killer.KillFeed) end			
			if killer.Character.Humanoid.Health<=15 then _G.createTag(_G.KillMedals['DEFIANT']['NAME'],_G.KillMedals['DEFIANT']['POINTS'],killer.KillFeed) end
			getAssist(assist,killer)			
			----		
			killer.LastKill.Value=tick()		
			killer.LastKilledPlayer.Value=player.Name
			killer.DeathStreak.Value=0	
			player.Revenge.Value=killer.Name
			player.DeathStreak.Value=player.DeathStreak.Value+1	
			local msg = {'Dominated','Rekt','Killed','Owned','Pwned','Destroyed'}
			player.PlayerGui:findFirstChild('PlayerGui').KillerText.Text=('You were '..msg[math.random(1,#msg)]..' by '..killer.Name)
			player.PlayerGui:findFirstChild('PlayerGui').KillerText.Visible=true
		end
	end
end
-----------------------------------------------

LoadData = function(p)
p:WaitForDataReady()
local stats = p:findFirstChild('PlayerStats')
if not stats then return end

local level = stats:findFirstChild('Level')
if not level then return end

local EXp = stats:findFirstChild('Exp')
if not EXp then return end

level.Value = p:LoadNumber('LVL')
EXp.Value = p:LoadNumber('EXP')
end

SaveData = function(p)
p:WaitForDataReady()
local stats = p:findFirstChild('PlayerStats')
if not stats then return end

local level = stats:findFirstChild('Level')
if not level then return end

local EXp = stats:findFirstChild('Exp')
if not EXp then return end

p:SaveNumber('LVL',level.Value)
p:SaveNumber('EXP',EXp.Value)
end

function onPlayerEntered(newPlayer)
	newPlayer:WaitForDataReady()
	--local stats = Instance.new('IntValue')
	--stats.Name=('leaderstats') stats.Parent = newPlayer
	--stats=newPlayer.leaderstats
	for i,v in pairs(script:GetChildren()) do
		wait()
		v:clone().Parent=newPlayer
	end
	LoadData(newPlayer)
	
	--[[local value = Instance.new('IntValue')
	value.Name=('KOs') value.Value = 0 value.Parent = stats]]
	
	
	local value = Instance.new('IntValue')
	value.Name=('KillFeed') value.Parent = newPlayer
	
	local value = Instance.new('StringValue')
	value.Name=('Revenge') value.Value = '' value.Parent = newPlayer
	
	local value = Instance.new('StringValue')
	value.Name=('LastKilledPlayer') value.Value = '' value.Parent = newPlayer
	
	local value = Instance.new('IntValue')
	value.Name=('LastKill') value.Value = 999 value.Parent = newPlayer
	
	local value = Instance.new('IntValue')
	value.Name=('Streak') value.Value = 0 value.Parent = newPlayer
	
	local value = Instance.new('IntValue')
	value.Name=('Chain') value.Value = 0 value.Parent = newPlayer
	
	local value = Instance.new('IntValue')
	value.Name=('DeathStreak') value.Value = 0 value.Parent = newPlayer
	
	if isAuthenticated(newPlayer,141105633) then newPlayer.PlayerStats.expVIP.Value=true end	
	if isAuthenticated(newPlayer,141283760) then newPlayer.PlayerStats.NanoVIP.Value=true end	
		
	
	while true do
		if newPlayer.Character ~= nil then break end
		wait(5)
	end
	local humanoid = newPlayer.Character.Humanoid
	humanoid.Died:Connect(function() onHumanoidDied(humanoid, newPlayer) end )
	newPlayer.Changed:Connect(function(property) onPlayerRespawn(property, newPlayer) end )
	--stats.Parent = newPlayer
end



game.Players.PlayerAdded:Connect(onPlayerEntered)
game.Players.PlayerRemoving:Connect(SaveData)





