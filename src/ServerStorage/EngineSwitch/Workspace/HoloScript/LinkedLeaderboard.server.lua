print("LinkedLeaderboard script version 5.00 loaded")

stands = {}
CTF_mode = false


function onHumanoidDied(humanoid, player)
	local stats = player:findFirstChild("leaderstats")
	if stats ~= nil then
		local deaths = stats:findFirstChild("Wipeouts")
		deaths.Value = deaths.Value + 1
if deaths.Value>=game.Workspace.HoloScript.Values.CurrentSimDeath.Value then
			player.TeamColor=game.Teams.Trainees.TeamColor
			end 
		-- do short dance to try and find the killer
		local killer = getKillerOfHumanoidIfStillInGame(humanoid)

		handleKillCount(humanoid, player)
	end
end

function onPlayerRespawn(property, player)
	-- need to Connect to new humanoid
	
	if property == "Character" and player.Character ~= nil then
		local humanoid = player.Character.Humanoid
			local p = player
			local h = humanoid
			humanoid.Died:Connect(function() onHumanoidDied(h, p) end )
	end
end

function getKillerOfHumanoidIfStillInGame(humanoid)
	-- returns the player object that killed this humanoid
	-- returns nil if the killer is no longer in the game

	-- check for kill tag on humanoid - may be more than one - todo: deal with this
	local tag = humanoid:findFirstChild("creator")

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
		local stats = killer:findFirstChild("leaderstats")
		if stats ~= nil then
			local kills = stats:findFirstChild("KOs")
			if killer ~= player then
				kills.Value = kills.Value + 1
				
			else
				kills.Value = kills.Value - 1
				
			end
		end
	end
end


-----------------------------------------------



function findAllFlagStands(root)
	local c = root:children()
	for i=1,#c do
		if (c[i].className == "Model" or c[i].className == "Part") then
			findAllFlagStands(c[i])
		end
		if (c[i].className == "FlagStand") then
			table.insert(stands, c[i])
		end
	end
end

function hookUpListeners()
	for i=1,#stands do
		stands[i].FlagCaptured:Connect(onCaptureScored)
	end
end

function onPlayerEntered(newPlayer)

	if CTF_mode == true then

		local stats = Instance.new("IntValue")
		stats.Name = "leaderstats"

		local captures = Instance.new("IntValue")
		captures.Name = "Captures"
		captures.Value = 0


		captures.Parent = stats

		-- VERY UGLY HACK
		-- Will this leak threads?
		-- Is the problem even what I think it is (player arrived before character)?
		while true do
			if newPlayer.Character ~= nil then break end
			wait(5)
		end

		stats.Parent = newPlayer

	else

		local stats = Instance.new("IntValue")
		stats.Name = "leaderstats"

		local kills = Instance.new("IntValue")
		kills.Name = "KOs"
		kills.Value = 0

		local deaths = Instance.new("IntValue")
		deaths.Name = "Wipeouts"
		deaths.Value = 0

		kills.Parent = stats
		deaths.Parent = stats

		-- VERY UGLY HACK
		-- Will this leak threads?
		-- Is the problem even what I think it is (player arrived before character)?
		while true do
			if newPlayer.Character ~= nil then break end
			wait(5)
		end

		local humanoid = newPlayer.Character.Humanoid

		humanoid.Died:Connect(function() onHumanoidDied(humanoid, newPlayer) end )

		-- start to listen for new humanoid
		newPlayer.Changed:Connect(function(property) onPlayerRespawn(property, newPlayer) end )


		stats.Parent = newPlayer

	end

end


function onCaptureScored(player)

		local ls = player:findFirstChild("leaderstats")
		if ls == nil then return end
		local caps = ls:findFirstChild("Captures")
		if caps == nil then return end
		caps.Value = caps.Value + 1

end


findAllFlagStands(game.Workspace)
hookUpListeners()
if (#stands > 0) then CTF_mode = true end
game.Players.ChildAdded:Connect(onPlayerEntered)


