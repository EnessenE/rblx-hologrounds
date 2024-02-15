--This script peforms very ugly haxwelds on the players arms.
wait(.1)
-- define --
	local w=Instance.new("Weld")
	sp = script.Parent
-- primary functions --
	_G.weldHandle=function(tool, torso, bool)
		--if tool:findFirstChild("ARC")==nil then _G.IsWelded=true return end
		--handle
		local c=tool:GetChildren()
		for i = 1, #c do
			if c[i]:IsA("Part") then
				local w=w:clone()
				local part=c[i]
				local handle=tool["Handle"]
				w.Part0=handle
				w.Part1=part
				local CC=CFrame.new(handle.Position)
				local C0=handle.CFrame:inverse()*CC
				local C1=part.CFrame:inverse()*CC
				w.C0=C0
				w.C1=C1
				w.Parent=handle
			end
		end
		--arm
		if tool:findFirstChild("ARCnoweld")~=nil then _G.IsWelded=true return end
		local ls,rs=torso["Left Shoulder"],torso["Right Shoulder"]
		local la,ra=torso.Parent["Left Arm"],torso.Parent["Right Arm"]
			if bool then
				ls.Part1=nil rs.Part1=nil
					w1=w:clone()
				w1.Name="Weld1"
				w1.Part0=torso
				w1.Part1=la
				w1.C1=_G.WeldLeftArm
				w1.Parent=torso
				w2=w:clone()
				w2.Name="Weld2"
				w2.Part0=torso
				w2.Part1=ra
				w2.C1=_G.WeldRightArm
				w2.Parent=torso
			elseif not bool and w1 and w2 then
					w1:Destroy() w2:Destroy()
				ls.Part1=la
				rs.Part1=ra
			end
		--done
		_G.IsWelded=true
	end
	
_G.doAnimations = function()
	var1 = 0
	var2 = 0
	var3 = 0
	var4 = 0
	var5 = 0
	var6 = 0
	var7 = 0
	if _G.Stats.animationtype=="Rifle" then
		var1 = -10
		var2 = 0.4
		var3 = -90
		var4 = 1
		for i=1,6 do
			if _G.Stats.reloading==false then return end
			var1=var1-5
			var2=var2+0.1
			var3=var3-5
			var4=var4-0.1
			w2.C1=CFrame.new(-0.8,0,0.4)*CFrame.fromEulerAnglesXYZ(math.rad(var3), math.rad(var1), 0)
			w1.C1=CFrame.new(0.7, var4, 0.3)*CFrame.fromEulerAnglesXYZ(math.rad(var3),math.rad(35), 0)
			wait(0.03) 
		end
		_G.Handle.M1:Play()
		wait(0.1)
		var5 = 0.7
		for i=1,8 do
			if _G.Stats.reloading==false then return end
			var3=var3+5
			var5=var5+0.15
			w1.C1=CFrame.new(0.7, var4, -0.1)*CFrame.fromEulerAnglesXYZ(math.rad(var3),math.rad(35), 0)
			wait(0.03)
		end
		wait(0.2)
		for i=1,8 do
			if _G.Stats.reloading==false then return end
			var3=var3-5
			var5=var5-0.15
			w1.C1=CFrame.new(0.7, var4, -0.1)*CFrame.fromEulerAnglesXYZ(math.rad(var3),math.rad(35), 0)
			wait(0.03)
		end
		_G.Handle.M2:Play()
		wait(0.2)
		for i=1,6 do
			if _G.Stats.reloading==false then return end
			var1=var1+6
			var2=var2-0.1
			var3=var3+5
			var4=var4+0.1
			w2.C1=CFrame.new(-0.8,0,0.4)*CFrame.fromEulerAnglesXYZ(math.rad(var3), math.rad(var1), 0)
			w1.C1=CFrame.new(0.7, var4, 0.3)*CFrame.fromEulerAnglesXYZ(math.rad(var3),math.rad(35), 0)
			wait(0.03) 
		end
	elseif _G.Stats.animationtype=="Pistol" then
		var1=270
		var2=40
		var3=280
		for i=1,5 do
		var1=var1-5
		var2=var2-5
		var3=var3+5
		if _G.Stats.reloading==false then return end
		w2.C1=CFrame.new(-1,.4,0.4)*CFrame.Angles(math.rad(var1),math.rad(-5),0)
		w1.C1=CFrame.new(0.8,0.5,0.4)*CFrame.Angles(math.rad(var3),math.rad(var2),0) 
		wait(0.01)
		end
		_G.Handle["M1"]:Play()
		wait(0.2)
		for i=1,5 do
		var1=var1+5
		var2=var2+5
		var3=var3-5
		if _G.Stats.reloading==false then return end
		w2.C1=CFrame.new(-1,.4,0.4)*CFrame.Angles(math.rad(var1),math.rad(-5),0)
		w1.C1=CFrame.new(0.8,0.5,0.4)*CFrame.Angles(math.rad(var3),math.rad(var2),0) 
		wait(0.01)
		end
		_G.Handle["M2"]:Play()
	elseif _G.Stats.animationtype=="Rifle2" then
		var1=-90
		var2=35
		var3=1
		for i=1,5 do
		var2=var2+10
		var3=var3-0.2
		var1=var1+10
		if _G.Stats.reloading==false then return end
		w2.C1=CFrame.new(-0.8,0,0.4)*CFrame.fromEulerAnglesXYZ(math.rad(var1), math.rad(-5), 0) 
		w1.C1=CFrame.new(0.7, var3, 0.3)*CFrame.fromEulerAnglesXYZ(math.rad(-90),math.rad(var2), 0) 
		wait(0.01)
		end
		wait(0.1)
		var4=0.3
		var5=-90
		_G.Handle["M1"]:Play()
		for i=1,5 do
		var4=var4+0.1
		var5=var5-10
		w1.C1=CFrame.new(0.7, var3, var4)*CFrame.fromEulerAnglesXYZ(math.rad(var5),math.rad(var2), 0) 
		wait(0.01)
		end
		wait(0.1)
		for i=1,5 do
		if _G.Stats.reloading==false then return end
		var4=var4-0.1
		var5=var5+10
		w1.C1=CFrame.new(0.7, var3, var4)*CFrame.fromEulerAnglesXYZ(math.rad(var5),math.rad(var2), 0) 
		wait(0.01)
		end
		_G.Handle["M2"]:Play()
		wait(0.5)
		for i=1,5 do
		var2=var2-10
		var3=var3+0.2
		var1=var1-10
		if _G.Stats.reloading==false then return end
		w2.C1=CFrame.new(-0.8,0,0.4)*CFrame.fromEulerAnglesXYZ(math.rad(var1), math.rad(-5), 0) 
		w1.C1=CFrame.new(0.7, var3, 0.3)*CFrame.fromEulerAnglesXYZ(math.rad(-90),math.rad(var2), 0) 
		wait(0.01)
		end
	elseif _G.Stats.animationtype=="Pistol2" then
		var1=-5
		var2=270
		var3=280
		var4=40
		var5=0.5
		w2.C1=CFrame.new(-1,.4,0.4)*CFrame.Angles(math.rad(270),math.rad(-5),0)
		w1.C1=CFrame.new(0.8,0.5,0.4)*CFrame.Angles(math.rad(280),math.rad(40),0)
		for i=1,5 do
		var1=var1-6
		var2=var2+5
		var4=var4+2
		var5=var5-0.1
		if _G.Stats.reloading==false then return end
		w2.C1=CFrame.new(-1,.4,0.4)*CFrame.Angles(math.rad(var2),math.rad(var1),0) 
		w1.C1=CFrame.new(0.8,var5,0.4)*CFrame.Angles(math.rad(280),math.rad(var4),0)
		wait(0.01)
		end
		wait(0.1)
		if _G.Values.ammostored.Value>_G.Values.ammo.MaxValue then
		t =_G.Values.ammo.MaxValue - _G.Values.ammo.Value
		elseif _G.Values.ammostored.Value<_G.Values.ammo.MaxValue and _G.Values.ammostored.Value>1 then
		t = _G.Values.ammostored.Value
		end
		for i=1,t do
		var7=280
		_G.Handle["M1"]:Play()
		for i=1,6 do
			var7=var7-10
			var5=var5+0.1
			if _G.Stats.reloading==false then return end
			w1.C1=CFrame.new(0.8,var5,0.4)*CFrame.Angles(math.rad(var7),math.rad(var4),0)
			wait(0.01)
		end
		sp.weaponFrame.Ammo.Text=_G.Values.ammo.Value+i
		sp.weaponFrame.MaxAmmo.Text=_G.Values.ammostored.Value-i
		wait(0.1)
		for i=1,6 do
			var7=var7+10
			var5=var5-0.1
			if _G.Stats.reloading==false then return end
			w1.C1=CFrame.new(0.8,var5,0.4)*CFrame.Angles(math.rad(var7),math.rad(var4),0)
			wait(0.01)	
		end
		end
		_G.Handle["M2"]:Play()
		wait(0.1)
		for i=1,5 do
		var1=var1+6
		var2=var2-5
		var4=var4-2
		var5=var5+0.1
		if _G.Stats.reloading==false then return end
		w2.C1=CFrame.new(-1,.4,0.4)*CFrame.Angles(math.rad(var2),math.rad(var1),0) 
		w1.C1=CFrame.new(0.8,var5,0.4)*CFrame.Angles(math.rad(280),math.rad(var4),0)
		wait(0.01)
		end
	end
_G.FinishReload=true
end

