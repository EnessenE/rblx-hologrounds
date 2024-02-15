print("Started AI control")

_G.SpawnAI = function(name)
	local ai=game.ServerStorage.Testing[name]:Clone()
	ai.Parent=game.Workspace.Challenge
	numberfortp=math.random(1,10)
	ai:MoveTo(game.Workspace.Spawn["Spawn"..numberfortp].Position)
	local sp=ai
	local torso=ai.Torso
	local humanoid=ai.Humanoid
	local curtarget=nil
	local firstrun=true
	
	--val
	local target=0 --0 none, 1 player, 2 objective
	local syncpath=1 --1 is raw, 2 is smooth
	local curtar=nil
	local reachedmove=false
	local objectivetarget=nil
	--
	local moving=0
	local looking=0
	local valold=Vector3.new(0,0,0)
	humanoid.Died:Connect(function()
		wait(.5)
		ai:Destroy()
	end)
	local routine = coroutine.create(function()				
		
humanoid.MoveToFinished:Connect(function()
	reachedmove=true
	wait()
	reachedmove=false
end)

local function GetClosestTorso() --ty roblox forums
	local closest;
	local closestdist;
	for i,v in pairs(game.Players:GetPlayers()) do
		if v.Character and v.Character:FindFirstChild("Torso") then
		local mag = (v.Character.Torso.Position - v.Character.Torso.Position).magnitude
		local comparison = (closestdist or 1000)
			if mag <= comparison then
			closest = v.Character.Torso
			closestdist  = mag;
			end
		end
	end
	return closest
end

local function targetp(plr)
	if syncpath==1 then
	path = game:GetService("PathfindingService"):ComputeRawPathAsync(torso.Position, plr.Character.Torso.Position, 512)
	elseif syncpath==2 then
	path = game:GetService("PathfindingService"):ComputeSmoothPathAsync(torso.Position, plr.Character.Torso.Position, 512)
	end
	points=path:GetPointCoordinates()
	routine = coroutine.create(function() --Thank you Auhrii
		for _, point in ipairs(points) do
			humanoid:MoveTo(point,plr.Character)
		end
	end)
	coroutine.resume(routine)
end

local function targetobj(obj)
	if syncpath==1 then
	path = game:GetService("PathfindingService"):ComputeRawPathAsync(torso.Position,obj.PrimaryPart.Position, 512)
	elseif syncpath==2 then
	path = game:GetService("PathfindingService"):ComputeSmoothPathAsync(torso.Position, obj.PrimaryPart.Position, 512)
	end
	points=path:GetPointCoordinates()
	local routine = coroutine.create(function()
		for _, point in ipairs(points) do
			humanoid:MoveTo(point,obj.PrimaryPart)
		end
	end)
	coroutine.resume(routine)
	stuckcheck()
end

local function stuckcheck() --Not really needed. but hey
--[[	if math.floor(valold)== Vector3.new((math.floor(torso.Position.X)),(math.floor(torso.Position.Y)),(math.floor(torso.Position.Z))) then
		humanoid.Jump=true
	end
	valold=torso.Position]] --piece of crap
end

torso.Touched:Connect(function(hitPart)
	if hitPart.CanCollide==true then
		humanoid.Jump=true
	end
end)

while true do
	wait(.2)--Needs to be *decently* *high* due to roblox getting a bit overloaded if I set it to low (at the present time, may be fixed in the future). Overload is only noticable when jumping and moving alot. Otherwise not
	--if search==true then
		target=1
--	end
	if target==0 then
		--print(script.Parent.Name..": No target set")
	elseif target==1 then --Why did I make the player and the obj seperate? Well I planned to make 'deeper' function for the objective. But if you read this and its pretty empty.. well I never got around to it.
	if tar==nil then
		tar=game.Players[GetClosestTorso().Parent.Name]
	else
		if tar.Character.Humanoid.Health==0 then
			tar=nil
		end
	end
		curtar=tar.Name
		targetp(tar)
	elseif target==2 then
		targetobj(objectivetarget)
	end
end






	end)
	
	coroutine.resume(routine)
	print("PASSED")
end