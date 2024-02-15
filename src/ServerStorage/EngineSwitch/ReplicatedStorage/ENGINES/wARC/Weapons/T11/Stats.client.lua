-- general stats --
	_G.GunName="T11"
	_G.GunDesc=""

	_G.Tool=script.Parent
	_G.Handle=script.Parent["Handle"]

	_G.SoundBase=0.5 _G.SoundDivider=1.3
	_G.BatteryMin=3 _G.BatteryMax=4
	_G.DepleteShots=1

	_G.WeldRightArm=CFrame.new(-0.92, 0.05, 0.45)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), math.rad(0))
	_G.WeldLeftArm=CFrame.new(-0.35, 1, 0.6)*CFrame.fromEulerAnglesXYZ(math.rad(295), math.rad(0), math.rad(-90))

	_G.Stats={["maxaccuracy"]=0.3, ["minaccuracy"]=0.12, ["firerate"]=1,["heat"]=28,["cool"]=4,
	["aimflaw"]=35,["reposition"]=35,["firepos"]=Vector3.new(-0.1,0,-2.88),["firemode"]="Shot", ["canscope"]=false, ["scopeid"]=""}
	_G.Origin=script.Parent
	_G.Values={["canfire"]=script.CanFire, ["heat"]=script.Heat, ["overheat"]=script.Overheat, ["recoil"]=script.Recoil, ["battery"]=script.Battery, ["shotsdeplete"]=script.ShotsDeplete}
	
	_G.DMG=(function(range)
	damage=5
		if range<=25 then
		damage=20+(95*(1/range+.6))
		damage=damage/4
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
	_G.bullet.BrickColor=BrickColor.new("Bright blue")
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
		fire.Color=Color3.new(0, 0, 256-153)
		fire.SecondaryColor=Color3.new(1, 0, 0)
		fire.Enabled=true
		fire.Heat=1
		fire.Size=2
		_G.holeDisp=3
		
	_G.muzzle=Instance.new("PointLight")
	_G.muzzle.Color=Color3.new(14/256, 18/256, 256/256)
	_G.muzzle.Brightness=5
	_G.muzzle.Range=7

-- done --
	_G.GunStatsLoaded=true

