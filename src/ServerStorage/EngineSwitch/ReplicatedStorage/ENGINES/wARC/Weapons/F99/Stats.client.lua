-- general stats --
	_G.GunName="F99"
	_G.GunDesc=""

	_G.Tool=script.Parent
	_G.Handle=script.Parent["Handle"]

	_G.SoundBase=0.9 _G.SoundDivider=1.7
	_G.BatteryMin=3 _G.BatteryMax=4
	_G.DepleteShots=20

	_G.WeldRightArm=CFrame.new(-1.2,0.1,0.4)*CFrame.Angles(math.rad(270),math.rad(0),0)
	_G.WeldLeftArm=CFrame.new(0.8,0.75,0.4)*CFrame.Angles(math.rad(265),math.rad(40),0) --CFrame.new(0.8,0.5,0.4)*CFrame.Angles(math.rad(280),math.rad(40),0)

	_G.Stats={["maxaccuracy"]=0.5, ["minaccuracy"]=0.15, ["firerate"]=0.04,["heat"]=1,["cool"]=1,
	["aimflaw"]=50,["reposition"]=60,["firepos"]=Vector3.new(0.15,0, 1.75),["firemode"]="Flame", ["canscope"]=false, ["scopeid"]=""}
	_G.Origin=script.Parent
	_G.Values={["canfire"]=script.CanFire, ["heat"]=script.Heat, ["overheat"]=script.Overheat, ["recoil"]=script.Recoil, ["battery"]=script.Battery, ["shotsdeplete"]=script.ShotsDeplete}
	
	_G.DMG=(function(range) damage=15 return damage end)

-- parts --
	_G.bullet=Instance.new("Part")
	_G.bullet.Material = Enum.Material.Neon
	_G.bullet.Anchored=true
	_G.bullet.CanCollide=false
	_G.bullet.formFactor="Custom"
	_G.bullet.Size=Vector3.new(1,1,1)
	_G.bullet.BrickColor=BrickColor.new("Navy blue")
	_G.bullet.Reflectance=0.4
	mesh=Instance.new("SpecialMesh", _G.bullet)
	mesh.MeshType="Brick"
	mesh.Scale=Vector3.new(0.15,0.15,1)
		_G.rayDisp1=0.03
		_G.rayDisp2=0.08

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

