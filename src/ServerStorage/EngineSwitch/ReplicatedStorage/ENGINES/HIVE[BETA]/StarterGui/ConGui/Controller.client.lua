--Controller, this script is the local controller it is responsable for Connecting the functions of each tool. These are peformed using local shared tables (_G), the method used to Connect the tools is very inefficient however is functional. If you are considering on using snippets I would reccomend editing the tool Connection system to be less haxy.
wait(.45)
repeat wait(1) until game.Players.LocalPlayer.Character~=nil
--if game.Players.LocalPlayer.TeamColor==BrickColor.new('White') then game.ReplicatedStorage.GameResource.Gui.IntroGui:clone().Parent=game.Players.LocalPlayer.PlayerGui end
-- pre-define --
	sp=script.Parent
	local plr=game.Players.LocalPlayer
	local camera=game.Workspace.CurrentCamera
	local chr=plr.Character
	local pgui=plr:findFirstChild("PlayerGui")
	local backpack=plr:findFirstChild("Backpack")
	local debris=game:GetService("Debris")
	local lighting=game:GetService("Lighting")
	local stats = false
	repeat wait(.05) until pgui and backpack
	local maxhealth = chr.Humanoid.MaxHealth	
	local Connections={}
	local deb = false
	_G.IsEquipped=false
	_G.CanFire=false
	_G.IsWelded=false
	_G.GunStatsLoaded=false
	local lasthealth=100
	_setmaxhealth=100
	local pointschain=0
	local descpos=-170
	ucdeb = false
	sound = 'http://www.roblox.com/asset/?id='
	Icons={"http://www.roblox.com/asset/?id=102439605", "http://www.roblox.com/asset/?id=102436399"}

Connected={}
-- misc. functions --
	equipTool=function(mouse,tool)
		--script.Parent.weaponFrame:TweenPosition(UDim2.new({1, -180}, {0.850000024, -90}), 'Out', 0, 1,true)
		--equip
		_G.IsWelded=false
		_G.GunStatsLoaded=false
		_G.IsEquipped=true
		tool["Stats"].Disabled=true
		tool["Stats"].Disabled=false
		_G.weldHandle(tool, chr["Torso"], true)
			if tool:findFirstChild("ARC") then --if gun do, if sword dont
				tool["Stats"]["Ammo"].Changed:Connect(_G.SetBattery)
				mouse.Icon=Icons[1]
				--Connect
				mouse.Button1Down:Connect(function() _G.Mouse1Down(mouse) end)
				mouse.Button1Up:Connect(function() _G.Mouse1Up(mouse) end)
				mouse.KeyDown:Connect(function(key)_G.onKeyDown(key,mouse) end)
				_G.updateGui()
				_G.check = _G.Stats.maxaccuracy 
				_G.check2 = _G.Stats.minaccuracy
			end
		end

	unequipTool=function(mouse,tool)
		_G.Stats.reloading=false
		_G.IsEquipped=false
		_G.isAiming = false
		_G.updateGui2()
		_G.weldHandle(tool, chr["Torso"], false)
		game.workspace.CurrentCamera.FieldOfView=70
		plr.CameraMode='Classic'
		sp.Voxel:TweenSizeAndPosition(UDim2.new(5,0,5,0),UDim2.new(-3,0,-3,0),"Out", "Quad",5, true)
		_G.healing=false
		_G.Charging=false
	end


	_G.ConnectTool=function(tool)
		--script.Parent.weaponFrame:TweenPosition(UDim2.new({1, 10}, {0.850000024, -90}), 'Out', 0, 1,true)
		local c1=tool.Equipped:Connect(function(mouse) equipTool(mouse,tool) end)
		local c2=tool.Unequipped:Connect(function(mouse) unequipTool(mouse,tool) end)
		table.insert(Connections, c1) table.insert(Connections, c2)
	end
	

	-- backp. Connect --
	backpack.ChildAdded:Connect(function(child)  --expect new guns
	wait()
	for i = 1, #Connections do
	Connections[i]:Disconnect()
	end
	Connections={}
		local c=backpack:GetChildren()
		for i = 1, #c do
		local tool=c[i]
			if tool:findFirstChild("ARC")~=nil or tool:findFirstChild("ARCnoweld")~=nil then
				_G.ConnectTool(tool)
			end
		end
		local c=chr:GetChildren()
		for i = 1, #c do
		local tool=c[i]
		if tool:IsA("Tool") and (tool:findFirstChild("ARC")~=nil or tool:findFirstChild("ARCnoweld")~=nil) then
			_G.ConnectTool(tool)
		end
		end
	end)

	local c=backpack:GetChildren() --set up
	for i = 1, #c do
	local tool=c[i]
		if tool:findFirstChild("ARC")~=nil or tool:findFirstChild("ARCnoweld")~=nil then
			_G.ConnectTool(tool)
		end
	end
	
	
for i=0,1,0.1 do
	sp.Loading_Frame.BackgroundTransparency=i
	wait(0.0001)
end	


script.Parent.healthFrame.healthBar.text.Text=(math.ceil(chr.Humanoid.Health))		
chr.Humanoid.HealthChanged:Connect(function()
if chr.Humanoid.Health>30 then
	sp.BloodScreen:TweenSizeAndPosition(UDim2.new(10,0,10,0),UDim2.new(-5,0,-5,0),"Out", "Quad",3, true)
	script.Parent.healthFrame.healthBar.Bar.BackgroundColor3=Color3.new(255/255, 119/255, 0/255)
	sp.Breathing:Stop()
elseif sp.Breathing.IsPlaying == false then
	sp.BloodScreen:TweenSizeAndPosition(UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),"Out", "Quad",1, true)
	script.Parent.healthFrame.healthBar.Bar.BackgroundColor3=Color3.new(170/255, 0/255, 0/255)
	sp.Breathing:Play()
end

script.Parent.healthFrame.healthBar.Bar:TweenSizeAndPosition(UDim2.new(chr.Humanoid.Health/chr.Humanoid.MaxHealth,0,1,0),UDim2.new(1-(chr.Humanoid.Health/chr.Humanoid.MaxHealth),5,0,5),"Out", "Quad", 0.2, true)	
	if chr.Humanoid.Health<maxhealth then
		maxhealth=chr.Humanoid.Health
		chr.Humanoid.WalkSpeed=chr.Humanoid.WalkSpeed-4
		script.Parent.FlashPart.Visible=true
		wait(0.2)
		chr.Humanoid.WalkSpeed=chr.Humanoid.WalkSpeed+4
		if _G.class=='ASSAULT' and _G.Active==true then
			_G.Energy=_G.Energy-2
			for i,v in pairs(chr:GetChildren()) do
				if string.sub(v.Name,1,4)=='Fake' then
					v.Reflectance=0.6
				end
			end
			wait(0.05)
			for i,v in pairs(chr:GetChildren()) do
				if string.sub(v.Name,1,4)=='Fake' then
					v.Reflectance=0
				end
			end
		elseif _G.class=='MEDIC' and _G.Active==true then
			_G.Energy=0
			_G.updateEnergyBar()
		elseif _G.class=='RECON' and _G.Active==true then
			_G.Energy=0
			_G.updateEnergyBar()
		end
	end
	maxhealth=chr.Humanoid.Health
	if chr.Humanoid.Health<=0 then script.Parent.FlashPart.Visible=true end
	script.Parent.healthFrame.healthBar.text.Text=(math.ceil(chr.Humanoid.Health))	
end)

--[[workspace.Outpost.Terminal.Point.Owner.Changed:Connect(function()
	local teams = {['Bright orange']='Defender',['Bright green']='Defender',['Bright red']='Attacker',['White']='Neutral'}
	if teams[plr.TeamColor.Name]==workspace.Outpost.Terminal.Point.Owner.Value then
		sp.Sound.SoundId =sound.._G.Sounds[plr.TeamColor.Name][1] sp.Sound:Play()
	elseif teams[plr.TeamColor.Name]~=workspace.Outpost.Terminal.Point.Owner.Value then
		sp.Sound.SoundId =sound.._G.Sounds[plr.TeamColor.Name][2] sp.Sound:Play()
	end
end)

script.Parent.serverFrame.timer.Text = workspace.Outpost.Terminal.Point.bombTime.Value
if workspace.Outpost.isRaid.Value==true then
script.Parent.serverFrame.raid.Text='RAID: ONLINE'
else
script.Parent.serverFrame.raid.Text='RAID: OFFLINE'
end
workspace.Outpost.Terminal.Point.bombTime.Changed:Connect(function()
	script.Parent.serverFrame.timer.Text = workspace.Outpost.Terminal.Point.bombTime.Value
end)
wait()

workspace.Outpost.isRaid.Changed:Connect(function()
if workspace.Outpost.isRaid.Value==true then
script.Parent.serverFrame.raid.Text='RAID: ONLINE'
else
script.Parent.serverFrame.raid.Text='RAID: OFFLINE'
end
end)]] script.Parent.serverFrame.raid.Text='RAID: ONLINE'


plr.LastKill.Changed:Connect(function()
t = 0 
local msg = {'Dominated','Rekt','Killed','Owned','Pwned','Destroyed'}
wait(0.1)
script.Parent.KilledText.Text=(msg[math.random(1,#msg)]..' '..plr.LastKilledPlayer.Value)
script.Parent.KilledText.Visible=true
if deb == true then return end
deb = true
while t<5 and wait(1) do
	t = t + 1
end
script.Parent.KilledText.Visible=false
deb=false
end)
--[[
if game.ReplicatedStorage.Weapons:findFirstChild(plr.PlayerStats.Class[plr.PlayerStats.Class.Value].Weapon1.Value) then wait() game.ReplicatedStorage.Weapons:findFirstChild(plr.PlayerStats.Class[plr.PlayerStats.Class.Value].Weapon1.Value):clone().Parent=plr.Backpack end
wait()		
if game.ReplicatedStorage.Weapons:findFirstChild(plr.PlayerStats.Class[plr.PlayerStats.Class.Value].Weapon2.Value) then wait() game.ReplicatedStorage.Weapons:findFirstChild(plr.PlayerStats.Class[plr.PlayerStats.Class.Value].Weapon2.Value):clone().Parent=plr.Backpack end
wait()		
if game.ReplicatedStorage.Weapons:findFirstChild(plr.PlayerStats.Class[plr.PlayerStats.Class.Value].Weapon3.Value) then wait() game.ReplicatedStorage.Weapons:findFirstChild(plr.PlayerStats.Class[plr.PlayerStats.Class.Value].Weapon3.Value):clone().Parent=plr.Backpack end
	]]
for i,v in pairs(plr.Backpack:GetChildren()) do
	if v:IsA('Tool') then
	v.Stats.AmmoMax.MaxValue = v.Stats.Ammo.MaxValue * _G.MaxAmmo
	v.Stats.AmmoMax.Value = v.Stats.AmmoMax.MaxValue
	end
end
for i,v in pairs(chr:GetChildren()) do
	if v:IsA('Tool') then
	v.Stats.AmmoMax.MaxValue = v.Stats.Ammo.MaxValue * _G.MaxAmmo
	v.Stats.AmmoMax.Value = v.Stats.AmmoMax.MaxValue
	end	
end


--script.Parent.serverFrame.timer.Text = workspace.Outpost.Terminal.Point.bombTime.Value





