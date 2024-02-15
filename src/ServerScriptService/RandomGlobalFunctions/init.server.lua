_G.MechPlayer=function(player)
	player.Character:ClearAllChildren()
	for index, child in pairs(game.ServerStorage.PBOSS:GetChildren()) do
	    child:Clone().Parent=player.Character
	end
	print("Transfer complete, starting weld.")
	local w = Instance.new("ManualWeld") 
	w.Parent = player.Character.Torso
	w.Part0 = player.Character.Head
	w.Part1 = player.Character.Torso
	game.ServerStorage.Weld:Clone().Parent=player.Character
	wait()
	local hum=Instance.new("Humanoid") 
	hum.Parent=player.Character
	hum.MaxHealth=((game.Players.NumPlayers)*15000)
	hum.Health=hum.MaxHealth
	hum.WalkSpeed=40
	script.ERIN:Clone().Parent=player.PlayerGui
	for index, child in pairs(player.Character:GetChildren()) do 
		if child:IsA("BasePart") then 
			child.Anchored=false
		end 	
	end
end


--_G.MechPlayer(game.Players.Player1)

_G.FPS=function()
	for index, child in pairs(game.Players:GetChildren()) do 
		child.PlayerGui.FPSwARC.Disabled=false 
	end
end

_G.NormalCam=function()
	for _, player in pairs(game.Players:GetPlayers()) do --So old and horrible 
		local lol=Instance.new("StringValue",player.PlayerGui.ManiCam)
		lol.Name="camfix"
	end
end

game.Players.PlayerAdded:Connect(function(player)
	local event = Instance.new("RemoteEvent")
	event.Name = "CameraFix"
	event.Parent = player
	local event = Instance.new("RemoteEvent")
	event.Name = "BossCam"
	event.Parent = player
end)


_G.BossName = function(name, part)
	for _, player in pairs(game.Players:GetPlayers()) do
		player.BossCam:FireClient(player,name, part)
	end
	wait(4)
	for _, player in pairs(game.Players:GetPlayers()) do
		player.CameraFix:FireClient(player,name, part)
	end
end


_G.dev = function(player)
	game.ServerStorage.VaktusKiller:Clone().Parent=player.Backpack
	player["SAdmin".._G.valkey].Value=true
	warn("Gave admin weapon and admin rights to "..player.Name)
end

local event1 = Instance.new("RemoteEvent")
event1.Parent = script.Parent
event1.Name = "Respawn"
event1.OnServerEvent:Connect(function()
	script.Parent.Values.RespawnPending.Value=false
			p= game.Players:GetChildren() 
		for i= 1, #p do 
		p[i]:LoadCharacter()
		wait()
		end
end)
