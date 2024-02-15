-- general stats --
	_G.GunName="AT"
	_G.GunDesc=""

	_G.Tool=script.Parent
	_G.Handle=script.Parent["Handle"]

	_G.SoundBase=0.1 _G.SoundDivider=1
	_G.BatteryMin=25 _G.BatteryMax=25
	_G.DepleteShots=1

	_G.WeldRightArm=CFrame.new(-1.2,0.1,0.4)*CFrame.Angles(math.rad(270),math.rad(0),0)
	_G.WeldLeftArm=CFrame.new(0.8,0.75,0.4)*CFrame.Angles(math.rad(265),math.rad(40),0) --CFrame.new(0.8,0.5,0.4)*CFrame.Angles(math.rad(280),math.rad(40),0)

	_G.Stats={["maxaccuracy"]=0.1, ["minaccuracy"]=0.05, ["firerate"]=5,["heat"]=2,["cool"]=0,
	["aimflaw"]=0,["reposition"]=0,["firepos"]=Vector3.new(0,0,0),["firemode"]="AT", ["canscope"]=false, ["scopeid"]=""}
	_G.Origin=script.Parent
	_G.Values={["canfire"]=script.CanFire, ["heat"]=script.Heat, ["overheat"]=script.Overheat, ["recoil"]=script.Recoil, ["battery"]=script.Battery, ["shotsdeplete"]=script.ShotsDeplete}
	
	_G.DMG=(function(range)
	damage=30
		if range<=10 then
		damage=50+(250*(1/range))
		end
	return damage
	end)

-- parts --
	_G.bullet=Instance.new("Part")
	_G.bullet.Material = Enum.Material.Neon
	_G.bullet.Anchored=true
	_G.bullet.CanCollide=false
	_G.bullet.formFactor="Custom"
	_G.bullet.Size=Vector3.new(1,1,1)
	_G.bullet.BrickColor=BrickColor.new("Bright orange")
	_G.bullet.Reflectance=0.3
	mesh=Instance.new("SpecialMesh", _G.bullet)
	mesh.MeshType="Brick"
	mesh.Scale=Vector3.new(0.7,0.7,1)
		_G.rayDisp1=0.1
		_G.rayDisp2=0.2

	_G.explbullet=Instance.new("Part")
	_G.explbullet.formFactor="Symmetric"
	_G.explbullet.Size=Vector3.new(1,1,1)
	_G.explbullet.Anchored=true
	_G.explbullet.CanCollide=false
	_G.explbullet.Transparency=1

	_G.hole=Instance.new("Part")
	_G.hole.Anchored=true
	_G.hole.CanCollide=false
	_G.hole.formFactor="Custom"
	_G.hole.Size=Vector3.new(.2,.2,.2)
	_G.hole.BrickColor=BrickColor.new("Black")
		fire=Instance.new("Fire", _G.hole)
		fire.Color=Color3.new(195/256, 71/256, 0)
		fire.SecondaryColor=Color3.new(1, 0, 0)
		fire.Enabled=true
		fire.Heat=1
		fire.Size=2
		_G.holeDisp=3
		
	_G.muzzle=Instance.new("PointLight")
	_G.muzzle.Color=Color3.new(195/256, 71/256, 0)
	_G.muzzle.Brightness=5
	_G.muzzle.Range=7

-- done --
	_G.GunStatsLoaded=true

