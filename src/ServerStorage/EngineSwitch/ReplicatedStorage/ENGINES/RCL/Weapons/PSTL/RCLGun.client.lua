-- |RCL 3.0 Gun Framework by BenBonez
--
-- |GROUP
-- |www.roblox.com/Groups/group.aspx?gid=478085
--
-- |README 
-- |Put this script into StarterPack or StarterGui.
-- |Looking for the gun configuraton? Wrong script.
-- |To configure guns open them and edit the Config script inside them. 
--
-- |DEVELOPERS
-- |Feel free to reuse and modify this script to suit your needs.
-- |If you need help with adding a certain feature feel free to contact me.
-- |To implement Ammo GUIs work with the Values (AmmoClip, Reloading, ...) created inside the Config script.
--
-- |DO NOT CHANGE ANYTHING IN THIS SCRIPT UNLESS YOU KNOW WHAT YOU ARE DOING.

repeat wait() until game.Players.LocalPlayer.Character

local player = game.Players.LocalPlayer
local character = player.Character
local backpack = player.Backpack

local debris = game:GetService('Debris')
local create = assert(LoadLibrary('RbxUtility')).Create
local storage = game:GetService('ReplicatedStorage'):findFirstChild("RCLStorage")

local filteringEnabled = workspace.FilteringEnabled
local ignoreModel = nil
local loadedTools = {}
local Connections = {}
local handles = {}

local firing
local mouseDown
local hitSound
local deathConnection
local creatorTag
local leftArmWeld
local rightArmWeld

-- For optimization purposes
local multiShot
local serverDmg
local ammoLimit 

local ray = Ray.new
local cframe = CFrame.new
local mathAbs = math.abs
local vector3 = Vector3.new	
local mathRandom = math.random

local projectilePart = create("Part"){
	Size = vector3(1, 1, 1);
	Anchored = true;
	FormFactor = 0;
	CanCollide = false;
	TopSurface = 0;
	BottomSurface = 0;
	BrickColor = player.TeamColor;
}
					
create("SpecialMesh"){
	Parent = projectilePart;
	MeshType = "Brick";
	Scale = vector3(.2, .2, 1);
}	

if not storage then
	creatorTag = create("ObjectValue"){
		Name = "creator";
		Value = player;
	}
else
	ignoreModel = workspace:findFirstChild("IgnoreContainer") or nil
end

local function getValueClient(tool, name)
	return tool.Config[name].Value
end

local function setValueClient(tool, name, value)
	tool.Config[name].Value = value
end

local function getValueServer(tool, name)
	if filteringEnabled then
		return storage.Remotes.GetFunction:InvokeServer(tool.Config[name])
	end
end

local function setValueServer(tool, name, value)
	if filteringEnabled then
		storage.Remotes.SetEvent:FireServer(tool.Config[name], value)
	end
end

local function waitForChildren(parent, children)
	for _, name in pairs(children) do
		while not parent:findFirstChild(name) do
			wait()
		end
	end
end

local function waitForConfig(tool)
	while not tool:findFirstChild("Config") do
		wait()
	end
end

local function playSound(tool, name)
	if tool and tool:findFirstChild("Handle") then
		local sound = tool.Handle:findFirstChild(name)
		if sound then
			sound:Play()
			if filteringEnabled then
				storage.Remotes.PlayEvent:FireServer(sound)	
			end	
		end
	end
end

local function isPlayerAlive()
	if player.Character and player.Character:findFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
		return true
	else
		return false
	end
end

local function getOverride(name)
	if storage and storage:findFirstChild("Settings") and storage.Settings:findFirstChild(name) then
		return true
	else
		return false
	end
end

local function targetFilter(hitPart, humanoid, config)

	local target = game.Players:GetPlayerFromCharacter(humanoid.Parent)

	local dealDamage = target and (target.TeamColor ~= player.TeamColor or (config.DamageFriendly or getOverride("FriendlyFire"))) or (not target and config.DamageNeutrals)
	
	if dealDamage then
	
		local damage = config.DamageSpecific[hitPart.Name] or config.DamageDefault
		
		if serverDmg then
			storage.Remotes.HitEvent:FireServer(humanoid, damage)
			hitSound:Play()
		else
			humanoid:TakeDamage(damage)
			hitSound:Play()
		end	
		
		if not storage and target then
			if not humanoid:findFirstChild('creator') then 
				local tag = creatorTag:Clone()
				tag.Parent = humanoid
				debris:AddItem(tag, 0.5)
			end	
		end
		
	end		
end

local function raycast(origin, direction, ignore)
	return workspace:FindPartOnRayWithIgnoreList(ray(origin, direction), ignore)
end

-- Parameter simple is set to true for projectiles replicated through filteringEnabled and for reflected projectiles
local function spawnProjectile(origin, hitPosition, shooter, simple)

	local bulletLength, orientation = (origin - hitPosition).magnitude, cframe(origin, hitPosition)
	
	if simple then
	
		local laser1 = projectilePart:clone()
		
		if shooter then
			laser1.BrickColor = shooter.TeamColor
		else
			laser1.BrickColor = player.TeamColor
		end
		
		laser1.CFrame = orientation * cframe(0,0, -bulletLength*.5)
		laser1.Mesh.Scale = vector3(.2, .2 , bulletLength)
		
		laser1.Parent = ignoreModel == nil and workspace or ignoreModel
		debris:AddItem(laser1, .06)	
		
	else
	
		local laser1, laser2 = projectilePart:clone(), projectilePart:clone()
		
		if shooter then
			laser1.BrickColor = shooter.TeamColor
			laser2.BrickColor = shooter.TeamColor
		else
			laser1.BrickColor = player.TeamColor
			laser2.BrickColor = player.TeamColor
		end
		
		laser1.CFrame = orientation * cframe(0,0,-bulletLength*.75)
		laser2.CFrame = orientation * cframe(0,0, -bulletLength*.25)
		
		laser1.Mesh.Scale = vector3(.2, .2 , bulletLength*.5)
		laser2.Mesh.Scale = vector3(.2, .2, bulletLength*.5)
		
		laser1.Parent = ignoreModel == nil and workspace or ignoreModel
		laser2.Parent = ignoreModel == nil and workspace or ignoreModel
		
		debris:AddItem(laser2, .03)
		debris:AddItem(laser1, .06)			
		
	end						
end

local function getReflectionionDirection(normal, direction)
	local n = normal.unit
	local v = direction.unit
	return 2*(n:Dot(-1*v))*n + v
end

local function getSurfaceNormal(hitPart, hitPosition)

	local relativeObjectSpace = hitPart.CFrame:pointToObjectSpace(hitPosition)/hitPart.Size
	local absoluteObjectSpace = vector3(mathAbs(relativeObjectSpace.x),mathAbs(relativeObjectSpace.y),mathAbs(relativeObjectSpace.z))
	local largestVector
	
	if absoluteObjectSpace.x > absoluteObjectSpace.y and absoluteObjectSpace.x > absoluteObjectSpace.z then
		largestVector = vector3(relativeObjectSpace.x,0,0).unit
	elseif absoluteObjectSpace.y > absoluteObjectSpace.z then
		largestVector = vector3(0,relativeObjectSpace.y,0).unit
	else
		largestVector = vector3(0,0,relativeObjectSpace.z).unit
	end
	
	return (hitPart.CFrame - hitPart.Position):pointToWorldSpace(largestVector)
	
end

local function fire(tool, mouse, origin, direction, config, run)

	local run = run or 1		
	local aimPoint = mouse.hit.p	
	local distance = (origin - aimPoint).magnitude
	local minSpread = -(config.SpreadBase) * distance 
	local maxSpread =  (config.SpreadBase) * distance
	
	if run < 2 then
		direction = (vector3((aimPoint.x) + (mathRandom(minSpread, maxSpread)/100), (aimPoint.y) + (mathRandom(minSpread, maxSpread)/100), (aimPoint.z) + (mathRandom(minSpread, maxSpread)/100)) - origin).unit * 999
	end
	
	local hitPart, hitPosition = raycast(origin, direction, {player.Character, ignoreModel})
	local projectileOrigin = run < 2 and (tool.Handle.CFrame * config.ProjectileOriginOffset).p or origin
	
	spawnProjectile(projectileOrigin, hitPosition, nil, run > 1 and true)
	if filteringEnabled then
		storage.Remotes.FireEvent:FireServer(projectileOrigin, hitPosition)
	end
	
	if hitPart then
	
		local humanoid = hitPart.Parent:FindFirstChild("Humanoid") or hitPart.Parent.Parent:FindFirstChild("Humanoid")
		
		if humanoid then		
			targetFilter(hitPart, humanoid, config)		
		elseif hitPart.Reflectance >= 1 and config.ReflectionEnabled and run < config.ReflectionLimit then	
			local normal = getSurfaceNormal(hitPart, hitPosition)
			local newDirection = getReflectionionDirection(normal, direction)
			fire(tool, mouse, hitPosition, newDirection * 999, config, run + 1)
		end
		
	end	
	
end

local function shoot(tool, mouse, config)

	local origin = (player.Character.Head.CFrame * config.RayOriginOffset).p
	local direction = (mouse.hit.p - origin).unit * 999
	
	if multiShot then		
		for i = 1, config.FireBurst and 3 or config.FireMulti do
			spawn(fire(tool, mouse, origin, direction, config))			
		end		
	else
		fire(tool, mouse, origin, direction, config)
	end	
	
end

local lastReloadAttempt = time()

local function reload(tool, mouse, config)
	
	-- Prevents spamming the server
	if filteringEnabled then
		if (time() - lastReloadAttempt) < 1 then
			return
		else
			lastReloadAttempt = time()
		end
	end

	if not getValueClient(tool, "Reloading") and getValueClient(tool, "AmmoClip") ~= config.AmmoClip then
		
		if ammoLimit and getValueClient(tool, "AmmoStored") <= 0 then	
			playSound(tool, "Empty")
			return
		end

		setValueClient(tool, "Reloading", true)		
		setValueClient(tool, "Firing", false)
		
		playSound(tool, "Reload")
		
		mouse.Icon = player:findFirstChild("CursorReloading") and player.CursorReloading.Value or config.CursorReloading	
		
		if not config.ToolName then
			tool.Name = "[REL]"
		end	
		
		local ammoStored = nil
		
		if ammoLimit and filteringEnabled then
			spawn(function()
				ammoStored = getValueServer(tool, "AmmoStored")
			end)
		else
			ammoStored = getValueClient(tool, "AmmoStored")
		end

		wait(config.ReloadDuration)	
		
		if not config.ReloadUnequipped and not getValueClient(tool, "Equipped") then
			return
		end	

		if not ammoLimit then
			
			setValueClient(tool, "AmmoClip", config.AmmoClip)
			
		else
			
			while not ammoStored do
				wait()
			end
			
			local ammoClip = getValueClient(tool, "AmmoClip")
			
			if ammoStored < config.AmmoClip then
				
				if ammoClip + ammoStored > config.AmmoClip then
					
					setValueClient(tool, "AmmoClip", config.AmmoClip) 
					
					if filteringEnabled then
						setValueServer(tool, "AmmoStored", ammoStored - (config.AmmoClip - ammoClip))
					else
						setValueClient(tool, "AmmoStored", ammoStored - (config.AmmoClip - ammoClip))
					end
					
				else	
					
					setValueClient(tool, "AmmoClip", ammoClip + ammoStored) 
					
					if filteringEnabled then
						setValueServer(tool, "AmmoStored", 0)
					else
						setValueClient(tool, "AmmoStored", 0)
					end					
					
				end
				
			else
				
				setValueClient(tool, "AmmoClip", config.AmmoClip) 
				
				if filteringEnabled then
					setValueServer(tool, "AmmoStored", ammoStored - (config.AmmoClip - ammoClip))
				else
					setValueClient(tool, "AmmoStored", ammoStored - (config.AmmoClip - ammoClip))
				end
				
			end
			
		end
		
		mouse.Icon = player:findFirstChild("CursorEquipping") and player.CursorEquipping.Value or config.CursorEquipping
		
		if not config.ToolName then
			tool.Name = "["..getValueClient(tool, "AmmoClip").."]"
		end
		
		setValueClient(tool, "Reloading", false)	
		
	end
	
end

local function button1Down(tool, mouse, config)
	
	mouseDown = true
	
	if not isPlayerAlive() then
		return
	end
	
	waitForConfig(tool)
	
	if not getValueClient(tool, "Firing") then
	
		-- Auto
		if config.FireAuto then
		
			setValueClient(tool, "Firing", true)
			
			while mouseDown and not getValueClient(tool, "Reloading") and getValueClient(tool, "AmmoClip")>0 do	
			
				setValueClient(tool, "AmmoClip", getValueClient(tool, "AmmoClip") - 1)
				
				shoot(tool, mouse, config)		
				
				if not config.ToolName then
					tool.Name = "["..getValueClient(tool, "AmmoClip").."]"
				end		
				
				playSound(tool, "Fire")	
				
				wait(config.FireRate)
				
			end 
			
			setValueClient(tool, "Firing", false)
			
			if getValueClient(tool, "AmmoClip") <= 0 then	
				if config.ReloadWhenEmpty then	
					reload(tool, mouse, config)
				else
					playSound(tool, "Empty")
				end
			end		

		-- Semi
		else	
		
			if not getValueClient(tool, "Firing") and not getValueClient(tool, "Reloading") and getValueClient(tool, "AmmoClip") > 0 then
			
				setValueClient(tool, "Firing", true)		
				
				setValueClient(tool, "AmmoClip", getValueClient(tool, "AmmoClip") - 1)
				
				shoot(tool, mouse, config)			
				
				if not config.ToolName then
					tool.Name = "["..getValueClient(tool, "AmmoClip").."]"
				end		
				
				playSound(tool, "Fire")		
				
				wait(config.FireRate)	
				
				setValueClient(tool, "Firing", false)	
				
			elseif getValueClient(tool, "AmmoClip")<=0 and not getValueClient(tool, "Firing") then
				
				if config.ReloadWhenEmpty then	
					reload(tool, mouse, config)
				else
					playSound(tool, "Empty")
				end
				
			end	
			
		end		
		
	end
end

local function button1Up(tool, mouse, config)
	mouseDown = false
end

local function keyDown(tool, mouse, key, config)
	if key:lower() == 'r' then
		reload(tool, mouse, config)
	end
end

local function unequipped(tool, config)
	
	if not isPlayerAlive() then
		return
	end
	
	waitForConfig(tool)

	mouseDown = false
	
	setValueClient(tool, "Firing", false)	
	
	if deathConnection then
		deathConnection:Disconnect()
	end
	
	if (not config.ToolName and not getValueClient(tool, "Reloading")) or not config.ReloadUnequipped then
		tool.Name = "["..getValueClient(tool, "AmmoClip").."]"
	end
	
	setValueClient(tool, "Equipped", false)	
	
end

local function equipped(tool, mouse, config)

	if not isPlayerAlive() then
		return
	end
	
	waitForConfig(tool)
	
	deathConnection = character.Humanoid.Died:Connect(function()
		tool:Destroy()
		for _, Connection in pairs(Connections) do
			pcall(function()
				Connection:Disconnect()
			end)
		end
		for _, remainingTool in pairs(backpack:GetChildren()) do
			remainingTool:Destroy()
		end
	end)

	-- Optimization
	multiShot = config.FireMulti > 1 and true or config.FireBurst	
	serverDmg = storage and storage.Remotes:findFirstChild("HitEvent") and true or false
	
	if getOverride("InfiniteAmmo") then
		ammoLimit = false
	else
		ammoLimit = config.AmmoLimited
	end		 			
	
	if hitSound then
		hitSound.Volume = getOverride("HitSoundsEnabled") and 1 or (config.HitSoundsOn and 1 or 0);
		hitSound.SoundId = player:findFirstChild("HitSoundAsset") and player.HitSoundAsset.Value or config.HitSoundAsset;
	else
		hitSound = create("Sound"){
			Name = "HitSound";
			Volume = getOverride("HitSoundsEnabled") and 1 or (config.HitSoundsOn and 1 or 0);
			SoundId = player:findFirstChild("HitSoundAsset") and player.HitSoundAsset.Value or config.HitSoundAsset;
			Pitch = 1;
			Parent = player.PlayerGui
		}	
	end

	if not config.ToolName and not getValueClient(tool, "Reloading") then
		tool.Name = "["..getValueClient(tool, "AmmoClip").."]"
	end	
	
	if config.ToolIcon then
		tool.TextureId = config.ToolIcon
	end
	
	if config.ToolDesc then
		tool.ToolTip = config.ToolDesc
	end
	
	mouse.Icon = player:findFirstChild("CursorEquipping") and player.CursorEquipping.Value or config.CursorEquipping
	
	mouse.Button1Down:Connect(function()  button1Down(tool, mouse, config) end)
	mouse.Button1Up:Connect(function() button1Up(tool, mouse, config) end)
	mouse.KeyDown:Connect(function(key) keyDown(tool, mouse, key, config) end)
	
	setValueClient(tool, "Equipped", true)	
	
end

local function isToolLoaded(parent)
	for _, child in pairs(loadedTools) do
		if parent == child then
			return true
		end
	end
	return false
end

local function scanTool(parent, dropped)

	if parent:IsA("Tool") then
	
		local configModule = parent:findFirstChild("Config")
		
		if configModule and configModule:IsA("ModuleScript") and not isToolLoaded(parent) then	
			
			spawn(function()
		
				table.insert(loadedTools, parent)
				
				local tool = parent
				local config = require(configModule)
				
				tool.CanBeDropped = false
				table.insert(handles, tool:WaitForChild("Handle"))
				
				waitForChildren(tool:WaitForChild("Config"), {"AmmoClip","AmmoStored","AmmoTotal"})
				
				setValueClient(tool, "AmmoClip", config.AmmoClip)
				
				setValueServer(tool, "AmmoStored", config.AmmoTotal)
				setValueClient(tool, "AmmoStored", config.AmmoTotal)
				
				setValueServer(tool, "AmmoTotal", config.AmmoTotal)
				setValueClient(tool, "AmmoTotal", config.AmmoTotal)
				
				-- Equip routine
				table.insert(Connections, tool.Equipped:Connect(function(mouse)
					waitForChildren(tool:WaitForChild("Config"), {"AmmoClip","AmmoStored","AmmoTotal","Equipped","Reloading","Firing"})
					equipped(tool, mouse, config)		
				end))
				
				-- Unequip routine
				table.insert(Connections, tool.Unequipped:Connect(function() 
					unequipped(tool, config) 
				end))
				
				-- Adding arm welds
				table.insert(Connections, tool.Equipped:Connect(function()
		
					waitForChildren(character, {"Torso", "Left Arm", "Right Arm"})
					
					local torso = character:findFirstChild("Torso")
					local leftArm = character:findFirstChild("Left Arm")
					local rightArm = character:findFirstChild("Right Arm")
					
					waitForChildren(torso, {"Left Shoulder", "Right Shoulder"})					
	
					local leftShoulder = torso:findFirstChild("Left Shoulder")
					local rightShoulder = torso:findFirstChild("Right Shoulder")
					
					leftShoulder.Part1	 = nil
					rightShoulder.Part1	 = nil
					
					if filteringEnabled then
						if config.LeftArmWeldC1 or config.RightArmWeldC1 then
							storage.Remotes.WeldEvent:FireServer(false, true, config.LeftArmWeldC1, config.RightArmWeldC1)
						else
							storage.Remotes.WeldEvent:FireServer(false)
						end	
					end
					
					local Weld = Instance.new("Weld")
					
					leftArmWeld = Weld:Clone()
					leftArmWeld.Name = "LocalLeftArmWeld"
					leftArmWeld.Part0 = torso
					leftArmWeld.Part1 = leftArm
					leftArmWeld.C1 = config.LeftArmWeldC1 or cframe(0.8,0.5,0.4) * CFrame.Angles(math.rad(270), math.rad(40), 0)
					leftArmWeld.Parent = torso
						
					rightArmWeld = Weld:Clone()
					rightArmWeld.Name = "LocalRightArmWeld"
					rightArmWeld.Part0 = torso
					rightArmWeld.Part1 = rightArm
					rightArmWeld.C1 = config.RightArmWeldC1 or cframe(-1.2,0.5,0.4) * CFrame.Angles(math.rad(270), math.rad(-5), 0)
					rightArmWeld.Parent = torso	
			
				end))		
				
				-- Removing arm welds
				table.insert(Connections, tool.Unequipped:Connect(function() 
					
					waitForChildren(character, {"Torso", "Left Arm", "Right Arm"})
					
					local torso = character:findFirstChild("Torso")
					local leftArm = character:findFirstChild("Left Arm")
					local rightArm = character:findFirstChild("Right Arm")
					
					waitForChildren(torso, {"Left Shoulder", "Right Shoulder"})		
					
					local leftShoulder = torso:findFirstChild("Left Shoulder")
					local rightShoulder = torso:findFirstChild("Right Shoulder")
				
					if filteringEnabled then
						storage.Remotes.WeldEvent:FireServer(true)
						if torso:findFirstChild("LeftArmWeld") then
							torso["LeftArmWeld"].Part1 = nil
						end
						if torso:findFirstChild("RightArmWeld") then
							torso["RightArmWeld"].Part1 = nil
						end
					end
						
					leftArmWeld.Part1 = nil
					rightArmWeld.Part1 = nil
						
					leftShoulder.Part1 = leftArm
					rightShoulder.Part1 = rightArm
							
					if leftArmWeld then 
						leftArmWeld:Destroy()
					end
						
					if rightArmWeld then
						rightArmWeld:Destroy()
					end	
							
				end))	
			
			end)
		end	  
	end
end

if filteringEnabled then
	
	storage.Remotes.FireEvent.OnClientEvent:Connect(function(shooter, origin, hitPosition)
		if shooter.Name ~= player.Name then
			spawnProjectile(origin, hitPosition, shooter, true)
		end
	end)			
	
	storage.Remotes.PlayEvent.OnClientEvent:Connect(function(shooter, sound)
		if shooter.Name ~= player.Name and sound then
			sound:Play()
		end
	end)	
	
end

player:WaitForChild("Backpack").ChildAdded:Connect(function(child) 
	scanTool(child, true) 
end)

for _, parent in pairs(player.Backpack:GetChildren()) do
	scanTool(parent)
end