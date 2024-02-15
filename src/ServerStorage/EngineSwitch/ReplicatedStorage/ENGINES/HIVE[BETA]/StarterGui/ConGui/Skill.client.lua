wait(0.45)
repeat wait(1) until game.Players.LocalPlayer.Character~=nil and _G.FinishLoading~=nil
sp = script.Parent
plr = game.Players.LocalPlayer
chr = plr.Character
camera = workspace.CurrentCamera
mouse = plr:GetMouse()
Sound = sp.Sound
Music = sp.Music
sound = 'http://www.roblox.com/asset/?id='
esmodel = sp.ESModel
energy = 0
_G.class = plr.PlayerStats.Class.Value
_G.MaxAmmo = 6
_G.Active = false
_G.isAiming = false
_G.check = nil
_G.check2 = nil

ClassesStats = {
['ASSAULT']={['HEALTH']=125,['ENERGY']=50,['RECHARGE']=3};
['MEDIC']={['HEALTH']=100,['ENERGY']=100,['RECHARGE']=2};
['RECON']={['HEALTH']=75,['ENERGY']=75,['RECHARGE']=4};	
}

Skills = {
['RECON']=function()
	_G.Active = true
	sp.ArmorMode.Image = sound.._G.Decals['ReconScreen']
	sp.Skill.SoundId =sound.._G.Sounds['Skill'] sp.Skill:Play()
	sp.ArmorMode:TweenSizeAndPosition(UDim2.new(1.1,0,1.1,0),UDim2.new(-0.050,0,-0.050,0),"Out", "Quad",1, true)
	for _,v in pairs(chr:GetChildren()) do
		if v:IsA('Part') then
			v.Transparency=0.97
		elseif v:IsA('Hat') then
			v:FindFirstChild('Handle').Transparency=0.99
		elseif v:IsA('Tool') then
			for _,t in pairs(v:GetChildren()) do
				if t:IsA('Part')and t.Name~='Handle' then
					t.Transparency=0.97
				end
			end
		end
	end
	for _,v in pairs(plr.Backpack:GetChildren()) do
		for _,t in pairs(v:GetChildren()) do
			if t:IsA('Part')and t.Name~='Handle' then
				t.Transparency=0.99
			end
		end
	end
		chr.HumanoidRootPart.Transparency=1
		chr.Head.Transparency=1
	while _G.Active==true and _G.Energy>0 and wait(0.5) and chr.Humanoid.Health>0 do
			_G.Energy = _G.Energy - 1
			_G.updateEnergyBar()
		end
		_G.Active = false
	sp.ArmorMode:TweenSizeAndPosition(UDim2.new(5,0,5,0),UDim2.new(-3,0,-3,0),"Out", "Quad",3, true)
	for _,v in pairs(chr:GetChildren()) do
		if v:IsA('Part') then
			v.Transparency=0
		elseif v:IsA('Hat') then
			v:FindFirstChild('Handle').Transparency=0
		elseif v:IsA('Tool') then
			for _,t in pairs(v:GetChildren()) do
				if t:IsA('Part')and t.Name~='Handle' then
					t.Transparency=0
				end
			end	
		end
	end
	for _,v in pairs(plr.Backpack:GetChildren()) do
		for _,t in pairs(v:GetChildren()) do
			if t:IsA('Part')and t.Name~='Handle' then
				t.Transparency=0
			end
		end
	end
	chr.HumanoidRootPart.Transparency=1
end;

['ASSAULT']=function()
	_G.Active = true
	sp.ArmorMode.Image = sound.._G.Decals['AssaultScreen']
	sp.Skill.SoundId =sound.._G.Sounds['ArmorSkill'] sp.Skill:Play()
	sp.ArmorMode:TweenSizeAndPosition(UDim2.new(1.1,0,1.1,0),UDim2.new(-0.050,0,-0.050,0),"Out", "Quad",1, true)
		for i,v in pairs(chr:GetChildren()) do
			if string.sub(v.Name,1,4)=='Fake' then
				v.Transparency=0.6
			end
		end
	chr.FakeTorso:findFirstChild(_G.class..'Light').Enabled=true
	plr.PlayerStats.Armor.Value=1.9
	chr.Humanoid.WalkSpeed=chr.Humanoid.WalkSpeed-3
		while _G.Active==true and _G.Energy>0 and wait(0.3) and chr.Humanoid.Health>0 do
			_G.Energy = _G.Energy - 1
			_G.updateEnergyBar()
		end
	_G.Active = false
	sp.ArmorMode:TweenSizeAndPosition(UDim2.new(5,0,5,0),UDim2.new(-3,0,-3,0),"Out", "Quad",3, true)
		for i,v in pairs(chr:GetChildren()) do
			if string.sub(v.Name,1,4)=='Fake' then
				v.Transparency=1
			end
		end
	chr.FakeTorso:findFirstChild(_G.class..'Light').Enabled=false
	plr.PlayerStats.Armor.Value=1
	chr.Humanoid.WalkSpeed=chr.Humanoid.WalkSpeed+3
end;

['MEDIC']=function()
	if chr.Humanoid.Health>=chr.Humanoid.MaxHealth then return end
		_G.Active = true
		sp.ArmorMode.Image = sound.._G.Decals['MedicScreen']
		sp.Skill.SoundId =sound.._G.Sounds['Skill'] sp.Skill:Play()
		sp.ArmorMode:TweenSizeAndPosition(UDim2.new(1.1,0,1.1,0),UDim2.new(-0.050,0,-0.050,0),"Out", "Quad",1, true)
		for i,v in pairs(chr:GetChildren()) do
			if string.sub(v.Name,1,4)=='Fake' then
			v.Transparency=0.6
			end
		end
	chr.FakeTorso:findFirstChild(_G.class..'Light').Enabled=true
	sp.ArmorMode.Image = sound.._G.Decals['MedicScreen']
		while _G.Active==true and _G.Energy>0 and wait(0.1) and chr.Humanoid.Health>0 and chr.Humanoid.Health<chr.Humanoid.MaxHealth do
			chr.Humanoid.Health = chr.Humanoid.Health + 1
			_G.Energy = _G.Energy - 1
			_G.updateEnergyBar()
		end
	_G.Active = false
	sp.ArmorMode:TweenSizeAndPosition(UDim2.new(5,0,5,0),UDim2.new(-3,0,-3,0),"Out", "Quad",3, true)
		for i,v in pairs(chr:GetChildren()) do
			if string.sub(v.Name,1,4)=='Fake' then
				v.Transparency=1
			end
		end
	chr.FakeTorso:findFirstChild(_G.class..'Light').Enabled=false
end;	
}

Perks = {
['Energy Boost+']=function() energy = energy + 50 end;
['Health Boost+']=function() chr.Humanoid.MaxHealth = chr.Humanoid.MaxHealth + 50 wait(.01) chr.Humanoid.Health=chr.Humanoid.MaxHealth end;	
['Ninja+']=function() chr.Humanoid.WalkSpeed=chr.Humanoid.WalkSpeed+3  end;	
['Extra Ammo+']=function()_G.MaxAmmo = 8 end;
['Blood Fusion+']=function() game.ReplicatedStorage.HealthRegen:clone().Parent=chr wait() chr.HealthRegen.Disabled=false  end;		
['None']=function() print('No Perk') end
}

_G.updateEnergyBar = function()
	sp.healthFrame.energyBar.Bar:TweenSizeAndPosition(UDim2.new(_G.Energy/energy,0,1,0),UDim2.new(1-(_G.Energy/energy),5,0,5),"Out", "Quad",1, true)
	sp.healthFrame.energyBar.text.Text=(_G.Energy)
	if _G.Energy>=20 then
		sp.healthFrame.energyBar.Bar.BackgroundColor3=Color3.new(85/255, 170/255, 255/255)
	else
		sp.healthFrame.energyBar.Bar.BackgroundColor3=Color3.new(170/255, 0/255, 0/255)	
	end	
end

_G.Weld = function(x,y)
local W = Instance.new("Weld")
W.Part0 = x
W.Part1 = y
local CJ = CFrame.new(x.Position)
local C0 = x.CFrame:inverse()*CJ
local C1 = y.CFrame:inverse()*CJ
W.C0 = C0
W.C1 = C1
W.Parent = x
end

_G.shieldWeld = function(color)
	for i,v in pairs(chr:GetChildren()) do
		if v:IsA('Part') then
			if v.Name==('Left Leg') or v.Name==('Right Leg') or v.Name==('Left Arm') or v.Name==('Right Arm') then
			local cl = esmodel.FakeLimb:clone()
			cl.Parent=chr
			cl.CFrame=v.CFrame
			_G.Weld(cl, v)
			cl.BrickColor=BrickColor.new(color)
			elseif v.Name==('Head') then
			local cl = esmodel.FakeHead:clone()
			cl.Parent=chr
			cl.CFrame=v.CFrame
			_G.Weld(cl, v)	
			cl.BrickColor=BrickColor.new(color)	
			elseif v.Name==('Torso') then
			local cl = esmodel.FakeTorso:clone()
			cl.Parent=chr
			cl.CFrame=v.CFrame
			_G.Weld(cl, v)	
			cl.BrickColor=BrickColor.new(color)		
			end
		end
	end
end

chr.Humanoid.MaxHealth = ClassesStats[_G.class]['HEALTH']
wait(0.01)
chr.Humanoid.Health = chr.Humanoid.MaxHealth
energy =  ClassesStats[_G.class]['ENERGY']
Perks[plr.PlayerStats.Class:findFirstChild(_G.class).Perk.Value]()
_G.Energy = energy
mouse.KeyDown:Connect(function(key)
	if key==('f') then
		if _G.Active == false and _G.Energy>20 and chr.Humanoid.Health>0 then
			Skills[_G.class]()
		else
		_G.Active = false
		sp.ArmorMode:TweenSizeAndPosition(UDim2.new(5,0,5,0),UDim2.new(-3,0,-3,0),"Out", "Quad",3, true)
		end
	elseif key == 'q' then
		if not _G.isAiming and _G.IsEquipped and _G.Stats['CanAim'] and _G.Energy>20 and chr.Humanoid.Health>0 then
			_G.isAiming = true
			if _G.class == 'RECON' then _G.check = _G.Stats.amaxaccuracy _G.check2 = _G.Stats.aminaccuracy end
			sp.Voxel:TweenSizeAndPosition(UDim2.new(1.1,0,1.1,0),UDim2.new(-0.050,0,-0.050,0),"Out", "Quad",0.3, true)						
			sp.Zoom:Play()			
			game.workspace.CurrentCamera.FieldOfView=_G.Stats['focuscamera']
			plr.CameraMode='LockFirstPerson'
			while _G.isAiming and _G.Energy>0 and wait(0.5) and chr.Humanoid.Health>0 do
				_G.Energy = _G.Energy - 1
				_G.updateEnergyBar()	
			end					
			_G.isAiming = false
			if _G.class == 'RECON' then _G.check = _G.Stats.maxaccuracy _G.check2 = _G.Stats.minaccuracy end
			game.workspace.CurrentCamera.FieldOfView=70
			plr.CameraMode='Classic'
			sp.Voxel:TweenSizeAndPosition(UDim2.new(5,0,5,0),UDim2.new(-3,0,-3,0),"Out", "Quad",5, true)
		elseif _G.isAiming==true and _G.IsEquipped and _G.Stats['CanAim'] then
			_G.isAiming = false	
		end
	end
end)

RegenEnergy = function()
	while wait(1/ClassesStats[_G.class]['RECHARGE']) and chr.Humanoid.Health>0 do
		if _G.Active==false and _G.Energy<energy and _G.healing==false and _G.Charging==false and _G.isAiming == false then
			_G.Energy=_G.Energy+1
			_G.updateEnergyBar()		
		end
	end
end

pcall(coroutine.resume(coroutine.create(RegenEnergy)))
_G.updateEnergyBar()

chr.Humanoid.Jumping:Connect(function()
	if gdeb == true then return end
	gdeb = true
	sp.weaponFrame:TweenPosition(UDim2.new(1,-180,0.87,-90),"Out", "Quad",0.4, true)
	sp.healthFrame:TweenPosition(UDim2.new(1,-300,0.87,0),"Out", "Quad",0.4, true)
	sp.serverFrame:TweenPosition(UDim2.new(0,10,0.87,-90),"Out", "Quad",0.4, true)
	wait(0.4)
	sp.weaponFrame:TweenPosition(UDim2.new(1,-180,0.85,-90),"Out", "Quad",0.4, true)
	sp.healthFrame:TweenPosition(UDim2.new(1,-300,0.85,0),"Out", "Quad",0.4, true)
	sp.serverFrame:TweenPosition(UDim2.new(0,10,0.85,-90),"Out", "Quad",0.4, true)
	wait(0.4)
	gdeb=false
end)

if plr.PlayerStats.Class.Value == 'ASSAULT' then
	sp.Skill.Pitch=0.5
	_G.shieldWeld('Bright orange')
elseif plr.PlayerStats.Class.Value == 'MEDIC' then
	sp.Skill.Pitch=0.7
	_G.shieldWeld('Bright green')
elseif plr.PlayerStats.Class.Value==('RECON') then
	sp.Skill.Pitch=2
	chr.Head.face.Transparency=1
end
