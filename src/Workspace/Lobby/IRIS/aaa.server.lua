print("Boss_IRIS_E")

bossbattle=script.BB
controller=1 --testing=0 ai=1 player=2 
if controller==1 then
	_G.Firing=false
	_G.AllowedToFire=false
elseif controller==2 then
	_G.Firing=false
	_G.AllowedToFire=false
end
---==============================FUNCTIONS==============================----------
function warnmessage(message)
	for _, player in pairs(game.Players:GetPlayers()) do
		player.PlayerGui.ARCGui.TopFrame.WarnPart.Text=message
	end
end

function message(message)
	for _, player in pairs(game.Players:GetPlayers()) do
		player.PlayerGui.ARCGui.TopFrame.WelcomePart.Text=message
	end
end

function clearmessage()
	for _, player in pairs(game.Players:GetPlayers()) do
		player.PlayerGui.ARCGui.TopFrame.WarnPart.Text=""
	end
end

function giveweapon(weaponname)
	for _, player in pairs(game.Players:GetPlayers()) do
		game.ServerStorage[weaponname]:Clone().Parent=player.Backpack
	end
	game.ServerStorage[weaponname]:Clone().Parent=game.StarterPack
end

function giveshield(hea) --noveri on when it gets to the desired health
	for _, player in pairs(game.Players:GetPlayers()) do
		game.Workspace.Main.Value.Value=hea
		player.Character.Humanoid.MaxHealth=100
	end
	hea=hea/100
	for shield=1,hea do
		wait()
		for _, player in pairs(game.Players:GetPlayers()) do
			player.Character.Humanoid.MaxHealth=player.Character.Humanoid.MaxHealth+100
			player.Character.Humanoid.Health=player.Character.Humanoid.Health+100
		end	
	end
end

function removeshield(hea)
for _, player in pairs(game.Players:GetPlayers()) do
game.Workspace.Main.Value.Value=100
player.Character.Humanoid.MaxHealth=(hea+100)
player.Character.Humanoid.Health=(hea+100)

end
	hea=hea/100
	for shield=1,hea do
		wait()
		for _, player in pairs(game.Players:GetPlayers()) do
			_G.lightning(game.Workspace.IRIS_E.Corrupt.Position, player.Character.Head.Position)
			player.Character.Humanoid.MaxHealth=player.Character.Humanoid.MaxHealth-100
			player.Character.Humanoid.Health=player.Character.Humanoid.Health-100
		end	
	end
end

function GetClosestTorso(dist,maxdist) --ty roblox forums
	local closestDist= dist
	local closestPlayer = nil
	for index, player in ipairs(game.Players:GetChildren()) do
	    if player.Character:FindFirstChild("Torso")~=nil then
	        if (player.Character.Torso.Position -mech.Shield.Position).magnitude < closestDist and (player.Character.Torso.Position -mech.Shield.Position).magnitude > maxdist then
	            closestPlayer = player.Character
	            closestDist= (player.Character.Torso.Position - mech.Shield.Position).magnitude 
	        end
	    end
	end
	return closestPlayer
end


_G.VoltaWave = function() --Create's a volta wave and hits everything within 500 studs. If raycast hits the volta wave, all raycast is returned to the place of origin. Damage is applied to those hit.
	_G.AllowedToWalk.Value=false
	message("WARNING: ENERGY SPIKE DETECTED")
	wait(2)
	message(" ")
	mes={"Circles! I prefer triangles.","How high can you jump?", "You spin my head right round right now","4"}
	warnmessage(mes[math.random(1,2)])
	for angle = 1, 360, 3 do
	p = Instance.new('Part')
	p.Parent = script.Parent.Volta
	p.Name="VoltaBlock"
	p.Size = Vector3.new(4,1,4)
	p.Anchored = true
	p.BrickColor=BrickColor.Black()
	p.CFrame = CFrame.new(script.Parent.Corrupt.Position.X, (script.Parent.Corrupt.Position.Y-29), script.Parent.Corrupt.Position.Z)        --Start at the center of the circle
	         * CFrame.Angles(0, math.rad(angle), 0) --Rotate the brick
	         * CFrame.new(0, 0, 50)                 --Move it out by 50 units
	p.CanCollide=false
	bunlight(p.Position)
		p.Touched:Connect(function(otherPart)
			local humanoid = otherPart.Parent:FindFirstChild('Humanoid')
			if humanoid then
				otherPart.Parent.Humanoid:TakeDamage(300)
			end
		end)
	--[[bf=Instance.new("BodyThrust",p)
	bf.Force=Vector3.new(2500,2200,0)
	bf.Location=Vector3.new(0,0,0)]]
	
	bf=Instance.new("BodyPosition",p)
	bf.Position=(p.CFrame.p-(p.CFrame.lookVector*1000))
	bf.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
	
	p.Anchored=false
	p.TopSurface="Smooth"
	p.BottomSurface="Smooth"
		wait()
	end
	clearmessage()
	p.Parent:BreakJoints()
	--[[for index, child in pairs(script.Parent.Volta:GetChildren()) do
		lightning=game.ServerStorage.Lightning:Clone()
		lightning.Parent=script.Parent.Volta
		--lightning.CFrame=CFrame.new(Vector3.new(child.Position.X, (child.Position.Y-80), child.Position.Z))
		--lightning.Position=Vector3.new(child.Position.X, (child.Position.Y-80), child.Position.Z)
		--lightning.CFrame=CFrame.new(lightning.Position, child.Rotation)
		lightning.Rotation=child.Rotation
		lightning.Position=Vector3.new(child.Position.X, (child.Position.Y-80), child.Position.Z)
		lightning.Touched:Connect(function(otherPart)
			local humanoid = otherPart.Parent:FindFirstChild('Humanoid')
			if humanoid then
				otherPart.Parent.Humanoid:TakeDamage(30)
			end
		end)
	bf=Instance.new("BodyThrust",lightning)
	bf.Force=Vector3.new(25000,70000,0)
	bf.Location=Vector3.new(0,0,0)
	lightning.Anchored=false
	lightning.CanCollide=false
	end]]
	wait(2)
	for index, child in pairs(script.Parent.Volta:GetChildren()) do
		if child.Name=="VoltaBlock" then
			print("SET")
			child.BodyPosition.Position=Vector3.new(script.Parent.Corrupt.Position.X+(math.random(-75,75)), (script.Parent.Corrupt.Position.Y-29), script.Parent.Corrupt.Position.Z+(math.random(-75,75)))
		end
	end
	wait(5)
	for index, child in pairs(script.Parent.Volta:GetChildren()) do
		if child.Name=="VoltaBlock" then
			print("SET")
			child.BodyPosition.Position=Vector3.new(script.Parent.Corrupt.Position.X+(math.random(-1000,1000)), (script.Parent.Corrupt.Position.Y-29), script.Parent.Corrupt.Position.Z+(math.random(-1000,1000)))
		end
	end
	wait(3)
	_G.EndRecordingRayCast()
	script.Parent.Volta:ClearAllChildren()
	_G.AllowedToWalk.Value=true
	p=nil
end

function Rusher() --The Miniguns recieves full power and increase their firespeed to 0.03 bullets a second for 10 seconds. Accurecy is stays the same
	
end

_G.HellFireStrike = function() --Volta manipulates its surroundings, steals the bricks, converts them into compressed plasma and shoots them up in the air. 
	--Whole map is hit by its (rain) effect. All hit take ? damage. ALL battery based weapons are disabled for 20 seconds and the battery is drained of ALL players.
	_G.AllowedToWalk.Value=false
	for i=1,10 do
		wait(0.25)
		_G.lightning(mech.LeftVolta1.Position, (Vector3.new(script.Parent.Corrupt.Position.X+(math.random(-100,100)), (script.Parent.Corrupt.Position.Y-29), script.Parent.Corrupt.Position.Z+(math.random(-100,100))))) --I for one payed attention in math lessons
		_G.lightning(mech.LeftVolta2.Position, (Vector3.new(script.Parent.Corrupt.Position.X+(math.random(-100,100)), (script.Parent.Corrupt.Position.Y-29), script.Parent.Corrupt.Position.Z+(math.random(-100,100))))) 
		_G.lightning(mech.RightVolta1.Position, (Vector3.new(script.Parent.Corrupt.Position.X+(math.random(-100,100)), (script.Parent.Corrupt.Position.Y-29), script.Parent.Corrupt.Position.Z+(math.random(-100,100))))) 
		_G.lightning(mech.RightVolta2.Position, (Vector3.new(script.Parent.Corrupt.Position.X+(math.random(-100,100)), (script.Parent.Corrupt.Position.Y-29), script.Parent.Corrupt.Position.Z+(math.random(-100,100))))) 
	end
	message("WARNING: UNSTABLE GROUND")
	for i=1,10 do --10 are spawned
	local ball=Instance.new("Part", script.Parent.Volta)
	ball.Shape="Ball"
	ball.Position=(Vector3.new(script.Parent.Corrupt.Position.X+(math.random(-100,100)), (script.Parent.Corrupt.Position.Y-40), script.Parent.Corrupt.Position.Z+(math.random(-100,100))))
	ball.Anchored=true
	ball.TopSurface="Smooth"
	ball.BottomSurface="Smooth"
	ball.Size=Vector3.new(5,5,5)
		for i=1,math.random(50,80) do
			ball.Position=(Vector3.new(ball.Position.X, (ball.Position.Y+1), ball.Position.Z))
		--[[_G.lightning(ball.Position, (Vector3.new(ball.Position.X+(math.random(-25,25)), (script.Parent.Corrupt.Position.Y-29), ball.Position.Z+(math.random(-25,25))))) 
		_G.lightning(ball.Position, (Vector3.new(ball.Position.X+(math.random(-25,25)), (script.Parent.Corrupt.Position.Y-29), ball.Position.Z+(math.random(-25,25))))) 
		_G.lightning(ball.Position, (Vector3.new(ball.Position.X+(math.random(-25,25)), (script.Parent.Corrupt.Position.Y-29), ball.Position.Z+(math.random(-25,25))))) 
		_G.lightning(ball.Position, (Vector3.new(ball.Position.X+(math.random(-25,25)), (script.Parent.Corrupt.Position.Y-29), ball.Position.Z+(math.random(-25,25)))))
		--wait()]]
		end
	end
	message("")
	wait(2)
	for index, child in pairs(script.Parent.Volta:GetChildren()) do
		bunlight(child.Position) 
		child.BrickColor=BrickColor.White()
		child.Material="Neon"
		wait(.1)
	end
	mes={"It may start raining.","Oh my, I would get an umbrella if I were you!", "Seems I have forgotten my umbrella today.","4"}
	warnmessage(mes[math.random(1,3)])
	for index, child in pairs(script.Parent.Volta:GetChildren()) do
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
	for index, child in pairs(script.Parent.Volta:GetChildren()) do
		deadly=Instance.new("Part",script.Parent.Volta)
		deadly.Size=Vector3.new(1,10,1)
		deadly.BrickColor=BrickColor.White()
		deadly.Anchored=false
		deadly.CanCollide=false
		deadly.Position=child.Position
		bf=Instance.new("BodyForce",deadly)
		bf.Force=Vector3.new(0,100,0)
		child:Destroy()
		deadly.Touched:Connect(function(otherPart)
			boom=Instance.new("Explosion", deadly)
			boom.Position=deadly.Position
			print("Boom.")
		end)
		--[[floaty=Instance.new("BodyPosition",deadly)
		floaty.Position=Vector3.new(child.Position.X, child.Position.Y+4000, child.Position.Z)
		floaty.MaxForce=Vector3.new(math.huge,100000,math.huge)]]
		
	end
	
	wait(5)
	script.Parent.Volta:ClearAllChildren()
	game.Lighting.Ambient=Color3.new(0,0,0)
	--game.Lighting.Brightness.Brightness=1
	wait(2)
	clearmessage()
----------------===================
	for _,v in pairs(game.Players:GetPlayers()) do
	 	for index, child in pairs(v.Backpack:GetChildren()) do
		child.Stats.Battery.Value=0
		end
		 for index, child in pairs(v.Character:GetChildren()) do
			if child.ClassName=="Tool" or child.ClassName=="Hopperbin" then
				child.Stats.Battery.Value=0
			end
		end
	end
	_G.AllowedToWalk.Value=true
	wait(10)
	script.Parent.Volta:ClearAllChildren()
end

function bunlight(tar) --bundled lightning
	_G.lightning(mech.LeftVolta1.Position, tar)
	_G.lightning(mech.LeftVolta2.Position, tar) 
	_G.lightning(mech.RightVolta1.Position, tar) 
	_G.lightning(mech.RightVolta2.Position, tar) 
end

function DreamSequence() --IRIS manipulates the augmented helmets and loads all players into a different WIJ map (local parts implenatation). Players are to find the escape in their map to escape while encountering enemies/obstacles. 
	
end

function WhereAmI() --IRIS goes nearly fully invisible and sneaks up on a random player. 
	_G.AllowedToWalk.Value=false
	for _,v in pairs(mech:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
			_G.lightning(game.Workspace.IRIS_E.Corrupt.Position, v.Position)
			wait()
		end
	end
	_G.AllowedToWalk.Value=true
	mech.Humanoid.WalkSpeed=150
	targ=GetClosestTorso(10000,80)
	if targ~=nil then
		_G.GoTo(targ.Torso.Position, targ.Torso)
		_G.MoveFin=false
		count=0
		repeat 
			count=count+1
		if count==100 then
			break
		else 
			wait(.1) 
		end 
		until _G.MoveFin==true 	
	_G.AllowedToWalk.Value=false
	for _,v in pairs(mech:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency = game.ServerStorage.IRISEBOSS[v.Name].Transparency
			_G.lightning(game.Workspace.IRIS_E.Corrupt.Position, v.Position)
			wait()
		end
	end end
	_G.AllowedToWalk.Value=true
	mech.Humanoid.WalkSpeed=40
end

_G.HeCanFly=function() --After sneaking up on a player, she takes and throws him off the map.
	local target=GetClosestTorso(75,0)
	print("Nope")
	if target ~=nil and target.Humanoid.Health>=1 then
	_G.AllowedToWalk.Value=false
	mes={"Oh darling, you shouldn't be that close to me!","I am gonna hit you so bad, you are gonna see them flying.", "I once saw a seagull. It was so amazing!","Look at this, it looks like you are about to get your wings."}
	warnmessage(mes[math.random(1,3)])
	local floaty=Instance.new("BodyPosition")
	floaty.Parent=target.Torso
	floaty.Position=Vector3.new(script.Parent.Corrupt.Position.X+40, script.Parent.Corrupt.Position.Y, script.Parent.Corrupt.Position.Z)
	floaty.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
	bunlight(target.Torso.Position)
	wait(2)
	local punchSound = script:FindFirstChild('PunchSound')
	floaty:Destroy()
	if punchSound then punchSound:Play() end
		local direction = (target.Torso.Position - script.Parent.Corrupt.Position).unit
		local bodyForce = Instance.new('BodyForce')
		bodyForce.force = 999999 * direction --999 = upside down devil
		bodyForce.Parent = target.Torso
		wait(0.3)
		bodyForce:Destroy()
	end
end

_G.Tearing=function() --After sneaking up on a player or a player gets to close. IRIS grabs him and tears him apart. (literally)
	local target=GetClosestTorso(75,0)
	if target ~=nil and target.Humanoid.Health>=1 then
			_G.AllowedToWalk.Value=false
		mes={"Oh darling, you shouldn't be that close to me!","You are standing so close, I would almost think you arent scared of me.", "Ha! Trying to tickle me?","4"}
		warnmessage(mes[math.random(1,3)])
		local floaty=Instance.new("BodyPosition")
		floaty.Parent=target.Torso
		floaty.Position=Vector3.new(script.Parent.Corrupt.Position.X+40, script.Parent.Corrupt.Position.Y, script.Parent.Corrupt.Position.Z)
		floaty.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
		bunlight(target.Torso.Position)
		wait(2)
		for index, child in pairs(target:GetChildren()) do
			if child:IsA("BasePart") and child.Name~="Torso" and child.Name~="HumanoidRootPart" and child.Name~="Head" and child.ClassName~="Hat" then
				bunlight(child.Position)
				child:BreakJoints()
				local floaty=Instance.new("BodyPosition")
				floaty.Parent=child
				floaty.Position=Vector3.new(target.Torso.Position.X, target.Torso.Position.Y+5, target.Torso.Position.Z)
				floaty.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
				--Float away?
				wait(0.3)
			end
		end
		mes={"What is it, lost your limbs?","Ouch, that must have hurt!", "All just useless parts in the end anyway.","4"}
		warnmessage(mes[math.random(1,3)]) 
		wait(2)
		bunlight(target.Torso.Position) 
		target.Torso:BreakJoints()
		for index, child in pairs(target:GetChildren()) do
			if child:IsA("BasePart") and child.Name~="Torso" and child.Name~="HumanoidRootPart" and child.Name~="Head" and child.ClassName~="Hat" then
				child.BodyPosition:Destroy()
			end
		end
		--_G.AllowedToWalk.Value=true
	else
		print("None")
	end
end

function TheWall() --Destroy the Cerulean I wall. 
	
end
---=================================================================================----------
---==============================TESTING  UNCOMMENT FOR TESTS==============================----------
if controller==2 then
	mech=game.Workspace.IRISEBOSS
	humanoid=Instance.new("Humanoid",mech)
	humanoid.MaxHealth=10000
	humanoid.WalkSpeed=40
	humanoid.Health=humanoid.MaxHealth
	humanoid.DisplayDistanceType="None"
	message("Humanoid loaded")
	wait(.2)
	message("Starting Volta v0.031")
	wait(.2)
	message("Starting Mini Guns")
	--enable miniguns
	mech.LeftMini.Disabled=false
	wait(.2)
	message("Starting Animations")
	_G.AllowedToWalk=mech.IRISAnimations.AW
	mech.IRISAnimations.Disabled=false
	wait(.2)
	message("Starting Alra Control")
	wait(.2)
	message("Finished Insertion")
	wait(.2)
	message("ALL_SYSTEMS_CLEAR")
	wait(2)
	message("")
	wait(2)
	warnmessage("")
---=================================================================================----------
---==============================START OF BOSS==============================------------
elseif controller==1 then
	warnmessage("ENOUGH")
	if game.Workspace:FindFirstChild("Irisdev") ~=nil then
		for index, child in pairs(workspace.Irisdev:GetChildren()) do
			wait()
			_G.lightning(game.Workspace.IRIS_E.Corrupt.Position, child.Position)
			child:Destroy()
		end
		game.Workspace.Irisdev:Destroy()
	end
	wait(1)
	warnmessage("I can see that the AI's are no challenge for you.")
	wait(4)
	warnmessage("So, I will give you a challenge.")
	for index, child in pairs(game.StarterPack:GetChildren()) do
	child:Destroy()
	end
	for _,v in pairs(game.Players:GetPlayers()) do
	    v.Backpack:ClearAllChildren() 
		 for index, child in pairs(v.Character:GetChildren()) do
			if child.ClassName=="Tool" or child.ClassName=="Hopperbin" then
				child:Destroy()
			end
		end
	end
	
	removeshield(9900) ------RE-ENABLE
	clearmessage()
	message("WARNING: Respawn limit changed to 5")
	wait(2)
	message("WARNING: Dev rule changed")
	wait(2)
	message("")
	
	---==================================================================================----------
	
	--
	---==============================FLOATY TO RIGHT POS==============================----------
	game.Workspace.IRIS_E.PrimaryPart.Anchored=false
	countmax=26.4
		
	
	game.ServerStorage.IRISEBOSS:Clone().Parent=game.Workspace
	game.Workspace.IRISEBOSS.Torso.CFrame = CFrame.new(Vector3.new(script.Parent.Corrupt.Position.X-75, (script.Parent.Corrupt.Position.Y-28.4), script.Parent.Corrupt.Position.Z))
	mech = game.Workspace.IRISEBOSS
	mech.Shield.CanCollide=false
	mech.Torso.Transparency = 1
	mech.Head.Transparency = 1
	for _,v in pairs(mech:GetChildren()) do
		if v:IsA("BasePart") and v.Name~="Torso" and v.Name~="Head" then
			v.Transparency = 1
			v.CanCollide=false
		end 
	end
	wait(0.5) 
	---Floating to position
	floaty=Instance.new("BodyPosition")
	floaty.Parent=script.Parent.Corrupt
	print(floaty.Position)
	floaty.Position=mech.Shield.Position
	usefullloc=mech.Shield.Position
	print(floaty.Position)
	floaty.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
	irisprim=game.Workspace.IRIS_E.PrimaryPart
	sx=math.floor(mech.Shield.Position.X)
	sy=math.floor(mech.Shield.Position.Y)
	sz=math.floor(mech.Shield.Position.Z)
	count=0 --wait for 5 seconds before it overrides
	repeat 
		if count==50 then
			break
		else
			wait(0.1) 
			count=count+1
			print(math.floor(irisprim.Position.X),math.floor(irisprim.Position.Y),math.floor(irisprim.Position.Z).."vs"..sx,sy,sz) 
		end
		until math.floor(irisprim.Position.X)==sx and math.floor(irisprim.Position.Z)==sz
	w = Instance.new("ManualWeld") 
	w.Parent = mech.Shield
	w.Part0 = mech.Shield
	w.Part1 = script.Parent.Corrupt
	--game.Workspace.IRIS_E.PrimaryPart.Anchored=true
	--game.Workspace.IRIS_E:MoveTo(Vector3.new(game.Workspace.IRISEBOSS.Shield.Position.X, (game.Workspace.IRISEBOSS.Shield.Position.Y), game.Workspace.IRISEBOSS.Shield.Position.Z))
	mech.Shield.CanCollide=true
	floaty:Destroy()
	
	---==========================================================================----------
	
	---==============================BODY GENERATION==============================----------
	
	--game.Workspace.IRIS_E.IRISEBOSS:MoveTo(game.Workspace.IRIS_E.PrimaryPart.Position)
	--game.Workspace.IRIS_E.PrimaryPart.Position=game.Workspace.IRIS_E.IRISEBOSS.Shield.Position
	message("GENERATING_BODY")
	wait(.2)
	mech.Torso.Transparency = 1
	mech.Head.Transparency = 1
	for _,v in pairs(mech:GetChildren()) do
		if v:IsA("BasePart") and v.Name~="Torso" and v.Name~="Head" then
		x = Instance.new("SelectionBox",v)
		x.Color = BrickColor.new("Bright blue")
		v.CanCollide=true
		x.Adornee = v
			v.Transparency = game.ServerStorage.IRISEBOSS[v.Name].Transparency
		_G.lightning(game.Workspace.IRIS_E.Corrupt.Position, v.Position)
			wait()
		x:Destroy()
		end
	end
	warnmessage("And I will make sure you won't survive.")
	humanoid=Instance.new("Humanoid",mech)
	humanoid.MaxHealth=10000
	humanoid.WalkSpeed=40
	humanoid.Health=humanoid.MaxHealth
	humanoid.DisplayDistanceType="None"
	message("Humanoid loaded")
	wait(.2)
	message("Starting Volta v0.031")
	wait(.2)
	message("Starting Mini Guns")
	--enable miniguns
	mech.LeftMini.Disabled=false
	mech.RightMini.Disabled=false
	wait(.2)
	message("Starting Animations")
	_G.AllowedToWalk=mech.IRISAnimations.AW
	mech.IRISAnimations.Disabled=false
	wait(.2)
	message("Starting Alra Control")
	wait(.2)
	message("Finished Insertion")
	wait(.2)
	message("ALL_SYSTEMS_CLEAR")
	wait(2)
	message("")
	warnmessage("Let's go.")
	wait(2)
	warnmessage("")
	---==============================Let's go.==============================----------
	_G.BossName("ERIN", script.Parent)
	dead=false
	routine = coroutine.create(function() --used to be a seperate loop
		 --very advanced system that keeps breaking 10/10
		repeat
			wait(2)
			howtodie=math.random(1,2)
			if howtodie==1 then			
				_G.Tearing()
			elseif howtodie==2 then
				_G.HeCanFly()
			end
			targ=GetClosestTorso(10000,80)
			if targ~=nil and _G.MoveFin==true then
				_G.GoTo(targ.Torso.Position, targ.Torso)--nearestplayer
			elseif targ~=nil then
				print("No target")
			else
			--_G.AllowedToWalk.Value=false
			end
		until dead==true
	end)
	routine2 = coroutine.create(function()
		repeat
			wait(2)
			if _G.AllowedToWalk.Value==true then
			_G.curlefttarget=GetClosestTorso(10000,80)
			if _G.curlefttarget==nil then
				_G.AllowedToFire=false
			end
			_G.AllowedToFire=true
			end
		until dead==true
	end)
	coroutine.resume(routine) --dont try this at home kids
	coroutine.resume(routine2) --this is bad and lazy scripting
	--
	_G.VoltaWave()
	message("ERIN, you should make it atleast a bit fair.")
	wait(2)
	warnmessage("Fine.")
	wait(1)
	giveshield(1000)
	giveweapon("Y14")
	giveweapon("W17")
	clearmessage()
	warnmessage("Are you happy now?")
	wait(1.5)
	message("No, but it should be fine.")
	wait(2)
	message("")
	clearmessage()
	--_G.HellFireStrike() 
	--
	oldchance=3
	while true do --VERY ADVANCED SYSTEM--
		nchance=math.random(1,5)
		if oldchance~=4 then
			chance=4 --1 ability > iris wander for 20sec > 1 ability > etc
		else
		repeat nchance=math.random(1,5) until nchance~=oldchance
		end
		chance=nchance
		print("Chance: "..chance)
	   if chance==1 then
			WhereAmI()
		elseif chance==2 then
		--_G.HellFireStrike() 
		_G.VoltaWave()
		elseif chance==3 then
			_G.VoltaWave()
	elseif chance==4 then
		--wait(10)--let iris wander around for ? seconds?
		for i=1,40 do
			wait(.5)
			targ=GetClosestTorso(10000,80)
			if targ~=nil then
				_G.GoTo(targ.Torso.Position, targ.Torso)--nearestplayer
			end
		end
	end
	oldchance=chance
	wait(5)
	end
end