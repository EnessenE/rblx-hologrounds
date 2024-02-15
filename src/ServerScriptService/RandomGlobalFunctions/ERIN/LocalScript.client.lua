local player = game:GetService("Players").LocalPlayer
local tool = player.Character
local mouse = player:GetMouse()
local mech = player.Character
local range=4999
local firerate=0.001 --:P
local abilitytriggered=false

mouse.Icon="http://www.roblox.com/asset/?id=91822850"
mouse.Button1Down:Connect(function()
	mousebuttonreleased=false
	repeat
		wait(firerate)
		local ray = Ray.new(tool.LeftHandle.CFrame.p, (mouse.Hit.p - tool.LeftHandle.CFrame.p).unit * range)
		local part, position = workspace:FindPartOnRay(ray, player.Character, false, true)
 
		local beam = Instance.new("Part", workspace)
		beam.BrickColor = BrickColor.new("Bright red")
		beam.FormFactor = "Custom"
		beam.Material = "Neon"
		beam.Transparency = 0.25
		beam.Anchored = true
		beam.Locked = true
		beam.CanCollide = false
 
		local distance = (tool.LeftHandle.CFrame.p - position).magnitude
		beam.Size = Vector3.new(0.3, 0.3, distance)
		beam.CFrame = CFrame.new(tool.LeftHandle.CFrame.p, position) * CFrame.new(0, 0, -distance / 2)
 
		game:GetService("Debris"):AddItem(beam, 0.1)
 
		if part then
			local humanoid = part.Parent:FindFirstChild("Humanoid")
 
			if not humanoid then
				humanoid = part.Parent.Parent:FindFirstChild("Humanoid")
			end
 
			if humanoid then
				humanoid:TakeDamage(30)
			end
		end
		until mousebuttonreleased==true
	end)
 
mouse.Button1Down:Connect(function()
	mousebuttonreleased=false
		repeat
			wait(firerate)
		local ray = Ray.new(tool.RightHandle.CFrame.p, (mouse.Hit.p - tool.RightHandle.CFrame.p).unit * range)
		local part, position = workspace:FindPartOnRay(ray, player.Character, false, true)
 
		local beam = Instance.new("Part", workspace)
		beam.BrickColor = BrickColor.new("Bright red")
		beam.FormFactor = "Custom"
		beam.Material = "Neon"
		beam.Transparency = 0.25
		beam.Anchored = true
		beam.Locked = true
		beam.CanCollide = false
 
		local distance = (tool.RightHandle.CFrame.p - position).magnitude
		beam.Size = Vector3.new(0.3, 0.3, distance)
		beam.CFrame = CFrame.new(tool.RightHandle.CFrame.p, position) * CFrame.new(0, 0, -distance / 2)
 
		game:GetService("Debris"):AddItem(beam, 0.1)
 
		if part then
			local humanoid = part.Parent:FindFirstChild("Humanoid")
 
			if not humanoid then
				humanoid = part.Parent.Parent:FindFirstChild("Humanoid")
			end
 
			if humanoid then
				humanoid:TakeDamage(30)
			end
		end
		until mousebuttonreleased==true
end)

mouse.Button1Up:Connect(function()
	mousebuttonreleased=true
end)

function onKeyPress(inputObject, gameProcessedEvent)
	if inputObject.KeyCode == Enum.KeyCode.E then
		_G.VoltaWave()
	elseif inputObject.KeyCode == Enum.KeyCode.F then
		_G.Big()
	elseif inputObject.KeyCode == Enum.KeyCode.Q then
		_G.HellFireStrike()
	elseif inputObject.KeyCode == Enum.KeyCode.V then
		_G.VoltaRain()
	end
end

local function onInputEnded(input,gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local keyPressed = input.KeyCode
		if input.KeyCode==Enum.KeyCode.W then
		end
	end
	--[[if gameProcessed then
		print("\tThis input ended on top of a GuiObject!")
	else
		print("\tThis input did not end on top of a GuiObject!")
	end]]
end
 

game:GetService("UserInputService").InputEnded:Connect(onInputEnded)

game:GetService("UserInputService").InputBegan:Connect(onKeyPress)

function bunlight(tar) --bundled lightning
	_G.lightning(mech.LeftVolta1.Position, tar)
	_G.lightning(mech.LeftVolta2.Position, tar) 
	_G.lightning(mech.RightVolta1.Position, tar) 
	_G.lightning(mech.RightVolta2.Position, tar) 
end

_G.VoltaWave = function() --Create's a volta wave and hits everything within 500 studs. If raycast hits the volta wave, all raycast is returned to the place of origin. Damage is applied to those hit.
	if abilitytriggered==false then
		abilitytriggered=true
	_G.AllowedToWalk=false --392838370
	mes={"Circles! I prefer triangles.","How high can you jump?", "Now, with extra lightning effects!","4"}
	warnmessage(mes[math.random(1,3)])
	for angle = 1, 360, 3 do
		local p = Instance.new('Part')
		p.Parent = mech.Volta
		p.Name="VoltaBlock"
		p.Size = Vector3.new(4,1,4)
		p.Anchored = true
		p.Material="Neon"
		p.BrickColor=BrickColor.Black()
		p.Anchored=true
		p.CFrame = CFrame.new(mech.Shield.Position.X, (mech.Shield.Position.Y-29), mech.Shield.Position.Z)        --Start at the center of the circle
		         * CFrame.Angles(0, math.rad(angle), 0) --Rotate the brick
		         * CFrame.new(0, 0, 50)                 --Move it out by 50 units
		p.CanCollide=false
		bunlight(p.Position)
			--[[p.Touched:Connect(function(otherPart)
				local humanoid = otherPart.Parent:FindFirstChild('Humanoid')
				if humanoid then
					if humanoid.Parent.Name~="IRISEBOSS" then
					humanoid:TakeDamage(300)
					end
				end
			end)]]
		--[[bf=Instance.new("BodyThrust",p)
		bf.Force=Vector3.new(2500,2200,0)
		bf.Location=Vector3.new(0,0,0)]]
		
		local bf=Instance.new("BodyPosition")
		bf.Parent=p
		bf.Position=(p.CFrame.p-(p.CFrame.lookVector*250))
		bf.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
		p.TopSurface="Smooth"
		p.BottomSurface="Smooth"
		p.Parent:BreakJoints()
		wait()
	end
	local music=Instance.new("Sound")
		music.Looped=false
		music.SoundId="rbxassetid://392838370"
		music.Parent=script
		music:Play()
		wait(.7)
	
	for index, child in pairs(mech.Volta:GetChildren()) do
		child.Anchored=false
		child.Touched:Connect(function(otherPart)
			local humanoid = otherPart.Parent:FindFirstChild('Humanoid')
			if humanoid then
				if humanoid~=mech.Humanoid then
				humanoid:TakeDamage(300)
				end
			end
		end)
	end
	for index, child in pairs(mech.Volta:GetChildren()) do--[
		if child.Name=="VoltaBlock" then
		local lightning=game.ReplicatedStorage.Lightning:Clone()
		lightning.Parent=mech.Volta
		--lightning.CFrame=CFrame.new(Vector3.new(child.Position.X, (child.Position.Y-80), child.Position.Z))
		--lightning.Position=Vector3.new(child.Position.X, (child.Position.Y-80), child.Position.Z)
		--lightning.CFrame=CFrame.new(lightning.Position, child.Rotation)
		lightning.Name="VoltaLightning"
		lightning.Rotation=child.Rotation
		lightning.Position=Vector3.new(child.Position.X, (child.Position.Y-80), child.Position.Z)
	--	game:GetService("Debris"):AddItem(lightning,5)
		lightning.Touched:Connect(function(otherPart)
				local humanoid=otherPart.Parent:FindFirstChild('Humanoid')
			if humanoid then
				if humanoid~=mech.Humanoid then
				otherPart.Parent.Humanoid:TakeDamage(100)
				end
			end
			
		end)
	local bf=Instance.new("BodyThrust",lightning)
	bf.Force=Vector3.new(25000,70000,0)
	bf.Location=Vector3.new(0,0,0)
	lightning.Anchored=false
	lightning.CanCollide=false
	end
	end--]]
	wait(2)
	for index, child in pairs(mech.Volta:GetChildren()) do
		if child.Name=="VoltaBlock" then
			child.BodyPosition.Position=Vector3.new(mech.Shield.Position.X+(math.random(-75,75)), (mech.Shield.Position.Y-29), mech.Shield.Position.Z+(math.random(-75,75)))
		end
	end
	wait(5)
	for index, child in pairs(mech.Volta:GetChildren()) do
		if child.Name=="VoltaBlock" then
			child.BodyPosition.Position=Vector3.new(mech.Shield.Position.X+(math.random(-250,250)), (mech.Shield.Position.Y-29), mech.Shield.Position.Z+(math.random(-250,250)))
		end
	end
	wait(3)
	for index, child in pairs(mech.Volta:GetChildren()) do
		if child.Name=="VoltaBlock" or child.Name=="VoltaLightning" then
			child:Destroy()
		end
	end
	--mech.Volta:ClearAllChildren()
	_G.AllowedToWalk=true
	abilitytriggered=false
	end
end

function warnmessage(message)
	--_G.MakeGui(message,"ERIN",3,"all")
	local msss = coroutine.create(function()
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.PlayerGui:FindFirstChild("ARCGui")~=nil then
		if player:FindFirstChild("PlayerGui")~=nil then
		player.PlayerGui.ARCGui.TopFrame.WarnPart.Text=message
		end end
	end
	wait(3)
	for _, player in pairs(game.Players:GetPlayers()) do
		if player:FindFirstChild("PlayerGui")~=nil then
				if player.PlayerGui:FindFirstChild("ARCGui")~=nil then
		player.PlayerGui.ARCGui.TopFrame.WarnPart.Text=""
		end
		end
	end
	end)
	coroutine.resume(msss)
end

function reporthealth(humanoid)
	firsttime10=true
	repeat wait()
	for _, player in pairs(game.Players:GetPlayers()) do
		if player:FindFirstChild("PlayerGui")~=nil then
			if player.PlayerGui:FindFirstChild("ARCGui")~=nil then
				player.PlayerGui.ARCGui.TopFrame.MessagePart.Text=humanoid.Health
				player.PlayerGui.ARCGui.TopFrame.MessagePart.OwnerPart.Text="Boss health"
			end
		end
	end
	until humanoid.Health<=0
	_G.MakeGui("THE MECH HAS BEEN DESTROYED! THE ATTACKERS WIN!","IRIS",10,"all")
	script.Parent.GameMusic:Destroy()
	local music=Instance.new("Sound")
	music.Looped=true
	music.SoundId="rbxassetid://130761235"
	music.Parent=script.Parent
	music:Play()
	warnmessage()
	for _, player in pairs(game.Players:GetPlayers()) do
		if player:FindFirstChild("PlayerGui")~=nil then
		player.PlayerGui.ARCGui.TopFrame.WarnPart.Text="Good job, I think you are ready."
		end
	end
	wait(5)
	for _, player in pairs(game.Players:GetPlayers()) do
		if player:FindFirstChild("PlayerGui")~=nil then
			player.PlayerGui.ARCGui.TopFrame.WarnPart.Text=""
		end
	end
	mech.Volta:ClearAllChildren()
	wait(2)
	for _, ccc in pairs(mech:GetChildren()) do
		if ccc:IsA("BasePart") then
			ccc.Anchored=true
		end
	end
	_G.EndProgram()
end

function message(message)
	--_G.MakeGui(message,"IRIS",3,"all")
end

function clearmessage()
	--[[for _, player in pairs(game.Players:GetPlayers()) do
		player.PlayerGui.ARCGui.TopFrame.WarnPart.Text=""
	end]]
end

function giveweapon(weapons)
	for i = 1,#weapons do
		for _,v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
			if string.lower(weapons[i])==string.lower(v.Name) then
				v:Clone().Parent=game.StarterPack
				for _,c in pairs(game.Players:GetPlayers()) do
					v:Clone().Parent=c.Backpack
				end
			end
		end
	end
end

function giveshield(hea) --noveri on when it gets to the desired health
	for _, player in pairs(game.Players:GetPlayers()) do
		if player~=game.Players.LocalPlayer then
		player.Character.Humanoid.MaxHealth=100
		player.Character.Humanoid.WalkSpeed=50
		end
	end
	hea=hea/100
	_G.plrwalkspeed=35
	_G.plrhealth=500
	for shield=1,hea do
		wait()
		
		for _, player in pairs(game.Players:GetPlayers()) do
			
			if player~=game.Players.LocalPlayer then
			_G.lightning(mech.Shield.Position, player.Character.Head.Position)
			player.Character.Humanoid.MaxHealth=player.Character.Humanoid.MaxHealth+100
			player.Character.Humanoid.Health=player.Character.Humanoid.Health+100
			end	
		end
	end
end

function removeshield(hea)
for _, player in pairs(game.Players:GetPlayers()) do
script.Parent.Main.Value.Value=100
player.Character.Humanoid.MaxHealth=(hea+100)
player.Character.Humanoid.Health=(hea+100)
end
	hea=hea/100
	for shield=1,hea do
		wait()
		for _, player in pairs(game.Players:GetPlayers()) do
			_G.lightning(mech.Shield.Position, player.Character.Head.Position)
			player.Character.Humanoid.MaxHealth=player.Character.Humanoid.MaxHealth-100
			player.Character.Humanoid.Health=player.Character.Humanoid.Health-100
		end	
	end
end

function GetClosestTorso(dist,maxdist,why) --ty roblox forums
	local closestDist= dist
	local closestPlayer = nil
	ma=math.random(1,2)
	if ma==1 or why~=nil then
	for index, player in ipairs(game.Players:GetChildren()) do
	    if player.Character:FindFirstChild("Torso")~=nil then
	        if (player.Character.Torso.Position -mech.Shield.Position).magnitude < closestDist and (player.Character.Torso.Position -mech.Shield.Position).magnitude > maxdist then
	            closestPlayer = player.Character
	            closestDist= (player.Character.Torso.Position - mech.Shield.Position).magnitude 
	        end
	    end
	end
	elseif ma==2 then
		repeat 
		local numbers=math.random(1,game.Players.NumPlayers) --idk
		for index, player in ipairs(game.Players:GetChildren()) do
			if index==numbers and player.TeamColor~=game.Teams.Trainees.TeamColor and player.TeamColor~=game.Teams.Trainers.TeamColor then
				closestPlayer=player.Character
			end
		end
		until closestPlayer~=nil
	end
	return closestPlayer
end

function scaleCharacter(model,scale)
	if model:FindFirstChild("Humanoid") then
		rememberhealth=model.Humanoid.Health
		remembermhealth=model.Humanoid.MaxHealth
		rememberwalk=model.Humanoid.WalkSpeed
	end
        if not model or not scale then return end
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
        for _,v in pairs(model:GetChildren()) do
                if v:IsA("BasePart") then
                        table.insert(parts,v)
                        v.Anchored = true;
                        v.FormFactor = "Custom";
                        for _,j in pairs(v:GetChildren()) do
                                if j:IsA("Motor6D") then
                                        local t = {
                                                Name = j.Name;
                                                Parent = v;
                                                Part0 = j.Part0;
                                                Part1 = j.Part1;
                                                C0 = j.C0;
                                                C1 = j.C1;
                                        }
                                        table.insert(joints,t)
                                        j:Destroy()
                                end
                        end
               elseif v:IsA("Hat") then
                        handleHat(v)
                end
        end
        for _,v in pairs(parts) do
                v.Size = v.Size * scale
                v.Anchored = false
        end
        for _,j in pairs(joints) do
                local c0 = {j.C0:components()}
                local c1 = {j.C1:components()}
                for i = 1,3 do
                        c0[i] = c0[i] * scale
                        c1[i] = c1[i] * scale
                end
                j.C0 = CFrame.new(unpack(c0))
                j.C1 = CFrame.new(unpack(c1))
                local n = Instance.new("Motor6D")
                for k,v in pairs(j) do
                        n[k] = v
                end
        end
        model.ChildAdded:Connect(function (c)
                if c:IsA("Hat") then
                       
                end
        end)
        if h then
                h.Parent = model
        end
if model.Humanoid then
	model.Humanoid:Destroy()
end
local human=Instance.new("Humanoid")
human.MaxHealth=remembermhealth
human.Health=remembermhealth
human.WalkSpeed=rememberwalk
human.Parent=model
      --  _G.ScaleCons[model] = con
if model.Animate then
	model.Animate.Disabled=true
	wait()
	model.Animate.Disabled=false
end
human.Died:Connect(function()
	print(human.Parent.Name .. " has died!")
	wait(3)
	local k=game.Players:GetPlayerFromCharacter(human.Parent)
	if k then k:LoadCharacter() end
end)
end

_G.Big=function()
	mes={"FEEL SICK YET?","Maybe a bit too big?","Lets hope you fit!"}
	warnmessage((mes[math.random(1,3)]))
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Character then
			if player.Character:FindFirstChild("Torso")~=nil then
				scaleCharacter(player.Character,(math.random(1.1,2)))
				bunlight(player.Character.Torso.Position)
			end
		end
	end
	wait(3)
end

_G.Small=function()
	mes={"Feel sick yet?","Don't worry, bieng small isn't a bad thing."}
	warnmessage((mes[math.random(1,2)]))
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Character and player.Character~=game.Players.LocalPlayer.Character then
			if player.Character:FindFirstChild("Torso")~=nil then
				scaleCharacter(player.Character,(math.random(0.6,0.6)))
				bunlight(player.Character.Torso.Position)
			end
		end
	end
	wait(3)
end
rain=false

_G.VoltaRain = function()
	if rain==false then
	local routine6 = coroutine.create(function()
		rain=true
	mes={"It may start raining.","Oh my, I would get an umbrella if I were you!", "Seems I have forgotten my umbrella today.","4"}
	warnmessage(mes[math.random(1,3)])
	for angle = 1, (math.random(750,2000)), 3 do
	local q = Instance.new('Part')
	q.Parent = mech.Volta
	q.Name="VoltaRain"
	q.Size = Vector3.new(4,1,4)
	q.Anchored = true
	q.Material="Neon"
	q.BrickColor=BrickColor.Black()
	q.CFrame = CFrame.new(mech.Shield.Position.X+(math.random(-250,250)), (mech.Shield.Position.Y+(math.random(50,250))), mech.Shield.Position.Z+(math.random(-250,250)))        --Start at the center of the circle
	         * CFrame.Angles(0, math.rad(angle), 0) --Rotate the brick
	         * CFrame.new(0, 0, 50)                 --Move it out by 50 units
	q.CanCollide=true
	bunlight(q.Position)

		q.Touched:Connect(function(otherPart)
			if otherPart.Parent:FindFirstChild('Humanoid')~=nil then
				local humanoid=otherPart.Parent:FindFirstChild('Humanoid')
			if humanoid then
				if humanoid~=mech.Humanoid then
				humanoid:TakeDamage(2500)
				end
			end end
		end)
	q.TopSurface="Smooth"
	q.BottomSurface="Smooth"
	q.Anchored=false
	clearmessage()
	wait()
	end
	wait(20)
	for index, child in pairs(mech.Volta:GetChildren()) do
		if child.Name=="VoltaRain" then
			child:Destroy()
		end
	end
	rain=false
	end)
	coroutine.resume(routine6)
	end
end

_G.HellFireStrike = function() --Volta manipulates its surroundings, steals the bricks, converts them into compressed plasma and shoots them up in the air.  12222019
	--Whole map is hit by its (rain) effect. All hit take ? damage. ALL battery based weapons are disabled for 20 seconds and the battery is drained of ALL players.
	if abilitytriggered==false then
		abilitytriggered=true
	_G.AllowedToWalk=false
	for i=1,10 do
		wait(0.25)
		_G.lightning(mech.LeftVolta1.Position, (Vector3.new(mech.Shield.Position.X+(math.random(-100,100)), (mech.Shield.Position.Y-29), mech.Shield.Position.Z+(math.random(-100,100))))) --I for one payed attention in math lessons
		_G.lightning(mech.LeftVolta2.Position, (Vector3.new(mech.Shield.Position.X+(math.random(-100,100)), (mech.Shield.Position.Y-29), mech.Shield.Position.Z+(math.random(-100,100))))) 
		_G.lightning(mech.RightVolta1.Position, (Vector3.new(mech.Shield.Position.X+(math.random(-100,100)), (mech.Shield.Position.Y-29), mech.Shield.Position.Z+(math.random(-100,100))))) 
		_G.lightning(mech.RightVolta2.Position, (Vector3.new(mech.Shield.Position.X+(math.random(-100,100)), (mech.Shield.Position.Y-29), mech.Shield.Position.Z+(math.random(-100,100))))) 
	end
	for i=1,5 do --10 are spawned
	local ball=Instance.new("Part")
	ball.Shape="Ball"
	ball.Parent=mech.Volta
	ball.Position=(Vector3.new(mech.Shield.Position.X+(math.random(-100,100)), (mech.Shield.Position.Y-40), mech.Shield.Position.Z+(math.random(-100,100))))
	ball.Anchored=true
	ball.Name="Matter"
	ball.TopSurface="Smooth"
	ball.BottomSurface="Smooth"
	ball.Size=Vector3.new(5,5,5)
		for i=1,math.random(50,80) do
			ball.Position=(Vector3.new(ball.Position.X, (ball.Position.Y+1), ball.Position.Z))
		_G.lightning(ball.Position, (Vector3.new(ball.Position.X+(math.random(-25,25)), (mech.Shield.Position.Y-29), ball.Position.Z+(math.random(-25,25))))) 
		_G.lightning(ball.Position, (Vector3.new(ball.Position.X+(math.random(-25,25)), (mech.Shield.Position.Y-29), ball.Position.Z+(math.random(-25,25))))) 
		_G.lightning(ball.Position, (Vector3.new(ball.Position.X+(math.random(-25,25)), (mech.Shield.Position.Y-29), ball.Position.Z+(math.random(-25,25))))) 
		_G.lightning(ball.Position, (Vector3.new(ball.Position.X+(math.random(-25,25)), (mech.Shield.Position.Y-29), ball.Position.Z+(math.random(-25,25)))))
		wait()
		end
	end
	--message("")
	wait(2)
	for index, child in pairs(mech.Volta:GetChildren()) do
		if child.Name=="Matter" then
			bunlight(child.Position) 
			child.BrickColor=BrickColor.White()
			child.Material="Neon"
			wait(.1)
		end
	end
	local music=Instance.new("Sound")
		music.Looped=false
		music.SoundId="rbxassetid://12222019"
		music.Parent=script
		music:Play()
	for index, child in pairs(mech.Volta:GetChildren()) do
		child.Anchored=false
		floaty=Instance.new("BodyPosition",child)
		floaty.Position=Vector3.new(child.Position.X, child.Position.Y+2000, child.Position.Z)
		floaty.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
	end
	wait(1)
	for i=1,40 do
		ambient=math.random(100,255)
		game.Lighting.Ambient=Color3.new(ambient/255,ambient/255,ambient/255)
		--game.Lighting.Brightness=math.random(0,1)
		wait(0.1)
	end
	--[[for index, child in pairs(mech.Volta:GetChildren()) do
		deadly=Instance.new("Part")
		deadly.Parent=mech.Volta
		deadly.Size=Vector3.new(1,10,1)
		deadly.BrickColor=BrickColor.White()
		deadly.Anchored=false
		deadly.CanCollide=false
		deadly.Position=child.Position
		bf=Instance.new("BodyForce",deadly)
		bf.Force=Vector3.new(0,100,0)
		child:Destroy()
		deadly.Touched:Connect(function(otherPart)
			
		end)]]
		
		--floaty=Instance.new("BodyPosition",deadly)
		--floaty.Position=Vector3.new(child.Position.X, child.Position.Y+4000, child.Position.Z)
		--floaty.MaxForce=Vector3.new(math.huge,100000,math.huge)
		
	--end
	message("WARNING: EMP")
	game.Lighting.Ambient=Color3.new(0,0,0)
	for _,v in pairs(game.Players:GetPlayers()) do
	 	for index, child in pairs(v.Backpack:GetChildren()) do
		if child:FindFirstChild("Stats")~=nil then 
			if child.Stats:FindFirstChild("Battery") ~=nil then
			child.Stats.Battery.Value=0
			end
		end
		end
		 for index, child in pairs(v.Character:GetChildren()) do
			if child.ClassName=="Tool" or child.ClassName=="Hopperbin" then
				if child:FindFirstChild("Stats")~=nil then 
			if child.Stats:FindFirstChild("Battery") ~=nil then
			child.Stats.Battery.Value=0
			end
				end
			end
		end
	end
	mech.Volta:ClearAllChildren()
	--game.Lighting.Brightness.Brightness=1
	clearmessage()
----------------===================
	_G.AllowedToWalk=true
	abilitytriggered=false
	end
end


	giveshield(1000)
	--giveweapon({"Y14","W17","L95","T11","SKP"})
	clearmessage()
	local music=Instance.new("Sound")
	music.Looped=true
	music.SoundId="rbxassetid://195372981"
	music.Name="GameMusic"
	music.Parent=script.Parent
	music:Play()
	routine3 = coroutine.create(function() 
		reporthealth(mech.Humanoid)
	end) 
	coroutine.resume(routine3)
	
	routine4 = coroutine.create(function() 
		while true do
			wait()
		if _G.AllowedToWalk==true then
			mech.Humanoid.WalkSpeed=40
		elseif _G.AllowedToWalk==false then
			mech.Humanoid.WalkSpeed=0
		end
		end
	end) 
	coroutine.resume(routine4)