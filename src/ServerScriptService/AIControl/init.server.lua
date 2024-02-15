print("Started AI control[GEN2]") --"Started crappy AI control"


_G.SpawnAI = function(name,target23,targetb,spawnlocationmap,folder)
	local ai=game.ServerStorage.GlobalAI[name]:Clone()
	ai.Parent=folder
	ai:MoveTo(spawnlocationmap)--["Spawn"..numberfortp]
	--[[if name=="AIW17" then
		print("Compatible")
		_G.FiringAIW17(" --hell no
	end]]
	local sp=ai
	local torso=ai.Torso
	local humanoid=ai.Humanoid
	local curtarget=nil
	local firstrun=true
	local break1=false
	local cur_target = ai.CurTarget
	--val
	local target=target23 --0 none, 1 player, 2 objective
	local syncpath=1 --1 is raw, 2 is smooth
	local curtar=nil
	local reachedmove=false
	local objectivetarget=targetb
	--
	local moving=0
	local looking=0
	local valold=Vector3.new(0,0,0)
	
	humanoid.Died:Connect(function()
		ai.Tool:Destroy()
		break1=true
		ai:Destroy()
	end)
	
local routine = coroutine.create(function()				
		
humanoid.MoveToFinished:Connect(function()
	reachedmove=true
end)

local function GetClosestTorso() --ty roblox forums
	local closest;
	local closestPlayer = nil
	for index, player in ipairs(game.Players:GetChildren()) do
	    if player.Character:FindFirstChild("Torso")~=nil then
	        if (player.Character.Torso.Position -torso.Position).magnitude < 512 and (player.Character.Torso.Position -torso.Position).magnitude > 0 then
	            closestPlayer = player.Character
	            closestDist= (player.Character.Torso.Position - torso.Position).magnitude 
	        end
	    end
	end
	return closestPlayer
end

local function targetp(plr)
	if plr.Character.Humanoid.Health>=1 and humanoid.Health>=1 then  --or reachedmove==false then
		if syncpath==1 then
		path = game:GetService("PathfindingService"):ComputeRawPathAsync(torso.Position, Vector3.new(plr.Character.Torso.Position.X,plr.Character.Torso.Position.Y,plr.Character.Torso.Position.Z), 512)
		elseif syncpath==2 then
		path = game:GetService("PathfindingService"):ComputeSmoothPathAsync(torso.Position, Vector3.new(plr.Character.Torso.Position.X,plr.Character.Torso.Position.Y,plr.Character.Torso.Position.Z), 512)
		end
		points=path:GetPointCoordinates()
		routine = coroutine.create(function() 
			for _, point in ipairs(points) do
				humanoid:MoveTo(Vector3.new(point.X+math.random(-4,4),point.Y+math.random(-4,4),point.Z+math.random(-4,4)),plr.Character)
			end
		end)
		coroutine.resume(routine)
	else
		humanoid:MoveTo(torso.Position,torso)
	end
end

local function targetobj(obj)
--	if reachedmove==false then
	if syncpath==1 then
	path = game:GetService("PathfindingService"):ComputeRawPathAsync(torso.Position,obj.Position, 512)
	elseif syncpath==2 then
	path = game:GetService("PathfindingService"):ComputeSmoothPathAsync(torso.Position, obj.Position, 512)
	end
	points=path:GetPointCoordinates()
	local routine = coroutine.create(function()
		for _, point in ipairs(points) do
			humanoid:MoveTo(point,obj)
		end
	end)
	coroutine.resume(routine)
--	end
end

local function getRandomPlayer()
     local players = game.Players:GetPlayers()
     if #players > 0 then
          return players[math.random(#players)]
     end
end

local function stuckcheck() --Not really needed. 
--[[	if math.floor(valold)== Vector3.new((math.floor(torso.Position.X)),(math.floor(torso.Position.Y)),(math.floor(torso.Position.Z))) then --also dont use math.floor
		humanoid.Jump=true
	end
	valold=torso.Position]] --piece of crap
end

ai.ChildRemoved:Connect(function(instance)
	wait()
	ai:Destroy()
end)

torso.Touched:Connect(function(hitPart)
	if hitPart.CanCollide==true then
		humanoid.Jump=true
	elseif hitPart:FindFirstChild("TargetSet") then
		if hitPart.TargetSet.Value==2 then
			target=hitPart.TargetSet.Value
			objectivetarget=hitPart.TargetSet.Objective.Value
		else
			target=hitPart.TargetSet.Value
		end
	end
end)

while break1==false do
	wait(.2)
	--if search==true then
		--target=2
--	end
	if target==0 then
		--print(script.Parent.Name..": No target set")
	elseif target==1 then --Why did I make the player and the obj seperate? Well I planned to make 'deeper' function for the objective. But if you read this and its pretty empty.. well I never got around to it.
		if tar==nil then
			local tar=getRandomPlayer()
			curtar=tar.Name
			if tar.Character.Humanoid.Health>=1 and humanoid.Health>=1 then
			reachedmove=false
			targetp(tar)
			ai:FindFirstChild("CurTarget").Value=tar.Character 
			end
		elseif tar.Character.Humanoid.Health<=0 then
			tar=nil
			reachedmove=true
		else
			if tar.Character.Humanoid.Health>=1 and humanoid.Health>=1 then
				reachedmove=false
				targetp(tar)
				ai:FindFirstChild("CurTarget").Value=tar.Character 
			end
		end
	elseif target==2 then
	if  humanoid.Health>=1 then
		reachedmove=false
		targetobj(objectivetarget)
		local tar2=getRandomPlayer()
		ai.CurTarget.Value=tar2.Character 
	end
	end
end

	end)
	coroutine.resume(routine)
end