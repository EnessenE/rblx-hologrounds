-- general stats --
	_G.GunName="SR10 Devoul Rifle"
	_G.GunDesc=""
	_G.Tool=script.Parent
	_G.Handle=script.Parent["Handle"]
	_G.Light=script.Parent["Light"]
	_G.SoundBase=0.9 _G.SoundDivider=1.7
	_G.WeldRightArm=CFrame.new(-0.8,0,0.4)*CFrame.fromEulerAnglesXYZ(math.rad(-90), math.rad(-5), 0) 
	_G.WeldLeftArm=CFrame.new(0.7, 1, 0.3)*CFrame.fromEulerAnglesXYZ(math.rad(-90),math.rad(35), 0)
	_G.Stats={
	["maxaccuracy"]=0.303; 
	["minaccuracy"]=0.201;
	["amaxaccuracy"]=0.003; 
	["aminaccuracy"]=0.001;
	["animationtype"]="Rifle2";
	["firerate"]=2.1;
	["aimflaw"]=2;
	["reposition"]=33;
	["focuscamera"]=45;
	["firepos"]=Vector3.new(-0.1,0,-1.4);
	["firemode"]="Semi";
	["reloading"]=false;
	["Audio"]=0.5;
	["CanAim"] = true;
	}
	_G.Origin=script.Parent
	_G.Values={
	["canfire"]=script.CanFire; 
	["ammo"]=script.Ammo; 
	["ammostored"]=script.AmmoMax;
	["recoil"]=script.Recoil; 
	}
	
	_G.DMG=(function(range)
	damage=50
		if range>=150 then
		damage=40+(100*(1/range+.6))
		end
	return damage
	end)
	
-- parts --
	_G.bullet=Instance.new("Part")
	_G.bullet.Anchored=true
	_G.bullet.CanCollide=false
	_G.bullet.formFactor="Custom"
	_G.bullet.Size=Vector3.new(1,1,1)
	_G.bullet.BrickColor=BrickColor.new("Cyan")
	_G.bullet.Reflectance=0.01
	mesh=Instance.new("SpecialMesh", _G.bullet)
	mesh.MeshType="Brick"
	mesh.Scale=Vector3.new(0.07,0.07,1)
		_G.rayDisp1=0.03
		_G.rayDisp2=0.08

	_G.impact=Instance.new("Part")
	_G.impact.Anchored=true
	_G.impact.Transparency=0.1
	_G.impact.CanCollide=false
	_G.impact.formFactor="Custom"
	_G.impact.Size=Vector3.new(0.1,0.1,0.1)
	fire=Instance.new("Fire", _G.impact)
	fire.Color=Color3.new(0, 0, 256-153)
	fire.SecondaryColor=Color3.new(1, 0, 0)
	fire.Enabled=true
	fire.Heat=1
	fire.Size=2
		_G.impDisp=0.05

	_G.hole=Instance.new("Part")
	_G.hole.Anchored=true
	_G.hole.CanCollide=false
	_G.hole.formFactor="Custom"
	_G.hole.Size=Vector3.new(.2,.2,.2)
	_G.hole.BrickColor=BrickColor.new("Black")
	_G.holeDisp=3

-- done --
	_G.GunStatsLoaded=true

