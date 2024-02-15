--This is the gunscript, it controls firing operations for all guns. Normally I would recommend that if you wanted to pursue a system such as this you store the stats of all your guns in a table. However for ease of use the stats are defined by the individual tools and the gun is linked up by the controller.
wait(.2)
-- define --
	sp=script.Parent
	plr=game.Players.LocalPlayer
	chr=plr.Character
	camera=workspace.CurrentCamera
	debris=game:GetService("Debris")
	heatgui=sp.HeatFrame

	M1Down=false
	Icons={"http://www.roblox.com/asset/?id=91822850", "http://www.roblox.com/asset/?id=91822843"}
	--hires(test)Icons={"http://www.roblox.com/asset/?id=105080423", "http://www.roblox.com/asset/?id=105080548"}

-- parts --
	dmgtag=Instance.new("ObjectValue")
	dmgtag.Name="dmg"
	tagdmg=Instance.new("NumberValue", dmgtag)
	tagdmg.Name="Damage"
	pl=Instance.new("PointLight")
	
-- unofficial warc patch by enes130 --
function Create_Muzzle()
	print("nil")
end
-- misc. functions --
	decloop=(function() --decreases overheat and spread
		repeat wait(.1) until _G.GunStatsLoaded
		while wait(.1) do
			if _G.Values.heat.Value-_G.Stats.cool>0 and _G.Values.canfire then
			_G.Values.heat.Value=_G.Values.heat.Value-_G.Stats.cool
			elseif _G.Values.heat.Value-_G.Stats.cool<=0 and _G.Values.canfire then
			_G.Values.heat.Value=0
			end	
			if _G.Values.recoil.Value-_G.Stats.reposition>0 and _G.Values.recoil.Value-_G.Stats.reposition<150 then
			_G.Values.recoil.Value=_G.Values.recoil.Value-_G.Stats.reposition
			elseif _G.Values.recoil.Value-_G.Stats.reposition<0 then
			_G.Values.recoil.Value=0
			elseif _G.Values.recoil.Value-_G.Stats.reposition>=150 then
			_G.Values.recoil.Value=150
			end
			if _G.IsEquipped then
			heatgui.Overheat.Text=tostring(math.ceil(_G.Values.heat.Value)).."%"
			--heatgui.Bar1.Bar2.Size=UDim2.new((_G.Values.heat.Value/100), 0, 1, 0)
			heatgui.Bar1.Bar2:TweenSize(UDim2.new((_G.Values.heat.Value/100), 0, 1, 0), "Out", "Quad", .1, true)
			end
		end
	end)
		local _co=coroutine.create(decloop)
		coroutine.resume(_co)

	getPlayer=function(hit)
		if hit and hit.Parent then
			if hit.Parent:FindFirstChild("Humanoid") then 
			return hit.Parent["Humanoid"]
			elseif hit.Parent.Parent:FindFirstChild("Humanoid") then
			return hit.Parent.Parent["Humanoid"]
			end
		end
	return nil
	end
	
	--This function controlls which teams are on which side.
	Teams={["Sand blue"]=1,["Bright green"]=1,["Dusty Rose"]=0}
	checkValid=function(hum) 
		if hum and hum.Parent then
		local tplr=game.Players:GetPlayerFromCharacter(hum.Parent)
			if tplr then
				if (Teams[tplr.TeamColor.Name]~=Teams[plr.TeamColor.Name] or (tplr.TeamColor==BrickColor.new("White") and plr.TeamColor==BrickColor.new("White"))) and tplr~=plr then
				return true
				else
				return false
				end
			else
			return true
			end
		end
	return false
	end

	_G.SetBattery=function()
	local b=_G.Values.battery.Value
	heatgui.Battery.Text="Battery "..tostring(b)
			if b>=40 then
				heatgui.Battery.TextColor3=Color3.new(1,1,1)
			elseif b<40 and b>=20 then
				heatgui.Battery.TextColor3=Color3.new(254/255,189/255,13/255) 
			elseif b<20 and b>0 then
				heatgui.Battery.TextColor3=Color3.new(1,43/255,43/255) 
			elseif b<=0 then
				heatgui.Battery.TextColor3=Color3.new(119/255,119/255,119/255) 
				_G.Values.battery.Value=0
			end
	end

-- firing functions --
	Raycast=(function(x,b)
	local ray=Ray.new(x,((b-x).Unit)*999)
	local hit,pos=game.Workspace:FindPartOnRayWithIgnoreList(ray,{chr,game.Workspace.RayIgnore, camera},true)
	return hit,pos
	end)

	Fire_Alpha=function(tgt) --regular shot
	-- wallshot check --
		if workspace:FindPartOnRayWithIgnoreList(Ray.new(chr["Head"].Position,((_G.Handle.CFrame*_G.Stats.firepos)-chr["Head"].Position).Unit*(chr["Head"].Position-(_G.Handle.CFrame*_G.Stats.firepos)).magnitude),{chr,workspace.RayIgnore})~=nil then return end
	-- setup --
		local predist=(tgt-(_G.Handle.CFrame*_G.Stats.firepos)).magnitude
		local spread=(_G.Stats.maxaccuracy)*(_G.Values.recoil.Value/100)+(_G.Stats.minaccuracy) 
		local aim=tgt+Vector3.new(math.random(-(spread/10)*predist,(spread/10)*predist),math.random(-(spread/10)*predist,(spread/10)*predist),math.random(-(spread/10)*predist,(spread/10)*predist)) 
		local hit,pos=Raycast(_G.Handle.CFrame*_G.Stats.firepos,aim) 
		local finaldist=(pos-(_G.Handle.CFrame*_G.Stats.firepos)).magnitude 
	-- parts --
		local b1=_G.bullet:clone()
		b1.Mesh.Scale=Vector3.new(0.1, 0.1, finaldist/2)
		b1.CFrame=CFrame.new((_G.Handle.CFrame*_G.Stats.firepos), pos)*CFrame.new(0,0, -finaldist*.25) 
		b1.Parent=workspace["RayIgnore"]
		local b2=_G.bullet:clone()
		b2.Mesh.Scale=Vector3.new(b1.Mesh.Scale.X,b1.Mesh.Scale.Y,finaldist/2)
		b2.CFrame=CFrame.new((_G.Handle.CFrame*_G.Stats.firepos), pos)*CFrame.new(0,0, -finaldist*.75) 
		b2.Parent=workspace["RayIgnore"]		
		debris:AddItem(b1,_G.rayDisp1)
		debris:AddItem(b2,_G.rayDisp2)
			if hit then
			local hum=getPlayer(hit)
				if hum then
					if checkValid(hum) and (_G.DMG(finaldist))>0 then
						--roblox tag--
						--[[local tag=tag:clone()
						tag["Wep"].Value=_G.GunName
						tag.Parent=hum 
						debris:AddItem(tag, 3)--]]
						--hit sound--
						if hum.Health>0 then script.Parent["Hit"]:Play() end
						--damage tag--
						local d=_G.DMG(finaldist)
						local DAMAGE=math.random(d-(d*0.05), d+(d*0.05))
						local dmgtag=dmgtag:clone()
						dmgtag.Value=hum 
						dmgtag["Damage"].Value=DAMAGE
						dmgtag.Parent=script.Parent.GlobalControl
					end
				end
			end
	end

	Fire_Foxtrot=function(tgt) --special flamethrower
	-- wallshot check --
		if workspace:FindPartOnRayWithIgnoreList(Ray.new(chr["Head"].Position,((_G.Handle.CFrame*_G.Stats.firepos)-chr["Head"].Position).Unit*(chr["Head"].Position-(_G.Handle.CFrame*_G.Stats.firepos)).magnitude),{chr,workspace.RayIgnore})~=nil then return end
	-- setup --
		local predist=(tgt-(_G.Handle.CFrame.p)).magnitude
		local spread=(_G.Stats.maxaccuracy)*(_G.Values.recoil.Value/100)+(_G.Stats.minaccuracy) 
		local aim=tgt+Vector3.new(math.random(-(spread/10)*predist,(spread/10)*predist),math.random(-(spread/10)*predist,(spread/10)*predist),math.random(-(spread/10)*predist,(spread/10)*predist)) 
		local hit,pos=Raycast(_G.Handle.CFrame.p,aim) 
		local finaldist=(pos-(_G.Handle.CFrame.p)).magnitude 
	-- parts --
		if hit and finaldist<=12 then
			local hum=getPlayer(hit)
				if hum then
					if checkValid(hum) then
						--roblox tag--
						--[[local tag=tag:clone()
						tag["Wep"].Value=_G.GunName
						tag.Parent=hum 
						debris:AddItem(tag, 3)--]]
						--set on fire--
						local fire=Instance.new("Fire", hit)
						fire.Heat=9
						fire.Size=4
						debris:AddItem(fire, 0.75)
						--hit sound--
						if hum.Health>0 then script.Parent["Hit"]:Play() end
						--damage tag--
						local d=_G.DMG(finaldist)
						local DAMAGE=math.random(d-(d*0.05), d+(d*0.05))
						local dmgtag=dmgtag:clone()
						dmgtag.Value=hum 
						dmgtag["Damage"].Value=DAMAGE
						dmgtag.Parent=script.Parent.GlobalControl
					end
				end
		end
	end

	Fire_Epsilon=function(tgt) --special explosive
	-- wallshot check --
		if workspace:FindPartOnRayWithIgnoreList(Ray.new(chr["Head"].Position,((_G.Handle.CFrame*_G.Stats.firepos)-chr["Head"].Position).Unit*(chr["Head"].Position-(_G.Handle.CFrame*_G.Stats.firepos)).magnitude),{chr,workspace.RayIgnore})~=nil then return end
	-- setup --
		local predist=(tgt-(_G.Handle.CFrame*_G.Stats.firepos)).magnitude
		local spread=(_G.Stats.maxaccuracy)*(_G.Values.recoil.Value/100)+(_G.Stats.minaccuracy) 
		local aim=tgt+Vector3.new(math.random(-(spread/10)*predist,(spread/10)*predist),math.random(-(spread/10)*predist,(spread/10)*predist),math.random(-(spread/10)*predist,(spread/10)*predist)) 
		local hit,pos=Raycast(_G.Handle.CFrame*_G.Stats.firepos,aim) 
		local finaldist=(pos-(_G.Handle.CFrame*_G.Stats.firepos)).magnitude 
	-- parts --
		local b1=_G.bullet:clone()
		b1.Mesh.Scale=Vector3.new(b1.Mesh.Scale.X,b1.Mesh.Scale.Y,finaldist)
		b1.CFrame=CFrame.new((_G.Handle.CFrame*_G.Stats.firepos), pos)*CFrame.new(0,0, -finaldist/2) --CFrame.new((_G.Handle.CFrame*CFrame.new(_G.Stats.firepos.x,_G.Stats.firepos.y,_G.Stats.firepos.z)).p,pos)*CFrame.new(0,0,(-0.25*finaldist)-0.1)
		b1.Parent=workspace["RayIgnore"]
		debris:AddItem(b1,_G.rayDisp1)

			if hit and pos then
			local b2=_G.explbullet:clone()
			b2.Parent=workspace["RayIgnore"]
			b2.CFrame=CFrame.new(pos)
			local explSound=_G.Handle["Explosion"]:clone()
			explSound.Parent=b2
			explSound:Play()
			debris:AddItem(b2, 2)

			local expl=Instance.new("Explosion", workspace)
			expl.BlastRadius=5
			expl.BlastPressure=0
			expl.Position=pos

				expl.Hit:Connect(function(hit, finaldist)
					if hit and hit.Name=="Torso" then
						local hum=hit.Parent:findFirstChild("Humanoid")
						if checkValid(hum) then
						--roblox tag--
						--[[local tag=tag:clone()
						tag["Wep"].Value=_G.GunName
						tag.Parent=hum 
						debris:AddItem(tag, 3)--]]
						--hit sound--
						if hum.Health>0 then script.Parent["Hit"]:Play() end
						--damage tag--
						local d=_G.DMG(finaldist)
						local DAMAGE=math.random(d-(d*0.05), d+(d*0.05))
						local dmgtag=dmgtag:clone()
						dmgtag.Value=hum 
						dmgtag["Damage"].Value=DAMAGE
						dmgtag.Parent=script.Parent.GlobalControl
						end
					end
				end)
		end
	end

-- mouse functions --
	_G.Mouse1Down=function(mouse)
	chr=plr.Character
	if not _G.GunStatsLoaded or not _G.IsEquipped or M1Down or not _G.Values.canfire or _G.Values.overheat.Value or _G.Values.battery.Value<=0 then return end
	M1Down=true
		if _G.Stats.firemode=="Auto" then
			while M1Down and chr["Humanoid"].Health>0 and _G.Values.heat.Value<100 and not _G.Values.overheat.Value and _G.Values.canfire and _G.Values.battery.Value>0 do
				_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
				_G.Handle["Fire"]:Play()
					Create_Muzzle(_G.Handle.CFrame*_G.Stats.firepos)
					Fire_Alpha(mouse.hit.p)
				_G.Values.heat.Value=_G.Values.heat.Value+_G.Stats.heat
				_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
				_G.Values.shotsdeplete.Value=_G.Values.shotsdeplete.Value+1
					if _G.Values.shotsdeplete.Value>=_G.DepleteShots then
					_G.Values.shotsdeplete.Value=0
					_G.Values.battery.Value=_G.Values.battery.Value-math.random(_G.BatteryMin, _G.BatteryMax)
					end
				_G.Values.canfire=false
				wait(_G.Stats.firerate)
				_G.Values.canfire=true
			end
			if _G.Values.heat.Value>=100 then --overheat
				local oh=_G.Values.overheat
				local he=_G.Values.heat
				oh.Value=true
				heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
				mouse.Icon=Icons[2]	
				_G.Handle["Overheat"]:Play()
				local pl=pl:clone()
				pl.Color=Color3.new(230/256, 30/256, 0)
				pl.Brightness=3
				pl.Range=6.5
				pl.Parent=_G.Handle
				debris:AddItem(pl, 0.5)
				wait(0.1*(100/_G.Stats.cool))
				_G.Values.canfire=true
				he.Value=0
				oh.Value=false
				heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
				mouse.Icon=Icons[1]
			end
		elseif _G.Stats.firemode=="Semi" then
				_G.Values.canfire=false
				_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
				_G.Handle["Fire"]:Play()
					Create_Muzzle(_G.Handle.CFrame*_G.Stats.firepos)
					Fire_Alpha(mouse.hit.p)
				_G.Values.heat.Value=_G.Values.heat.Value+_G.Stats.heat
				_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
				_G.Values.shotsdeplete.Value=_G.Values.shotsdeplete.Value+1
					if _G.Values.shotsdeplete.Value>=_G.DepleteShots then
					_G.Values.shotsdeplete.Value=0
					_G.Values.battery.Value=_G.Values.battery.Value-math.random(_G.BatteryMin, _G.BatteryMax)
					end
					if _G.Values.heat.Value>=100 then --overheat
					local oh=_G.Values.overheat
					local he=_G.Values.heat
					oh.Value=true
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
					mouse.Icon=Icons[2]	
					_G.Handle["Overheat"]:Play()
					local pl=pl:clone()
					pl.Color=Color3.new(230/256, 30/256, 0)
					pl.Brightness=3
					pl.Range=6.5
					pl.Parent=_G.Handle
					debris:AddItem(pl, 0.5)
					_G.Values.canfire=true
					wait(0.1*(100/_G.Stats.cool))
					he.Value=0
					oh.Value=false
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
					mouse.Icon=Icons[1]
					end
				wait(_G.Stats.firerate)
				_G.Values.canfire=true
		elseif _G.Stats.firemode=="Burst" then
				_G.Values.canfire=false
				_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
				_G.Handle["Fire"]:Play()
				Create_Muzzle(_G.Handle.CFrame*_G.Stats.firepos)
				Fire_Alpha(mouse.hit.p)
					wait(.05)
				_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
				_G.Handle["Fire"]:Play()
				Create_Muzzle(_G.Handle.CFrame*_G.Stats.firepos)
				Fire_Alpha(mouse.hit.p)
					wait(.05)
				_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
				_G.Handle["Fire"]:Play()
				Create_Muzzle(_G.Handle.CFrame*_G.Stats.firepos)
				Fire_Alpha(mouse.hit.p)
					_G.Values.heat.Value=_G.Values.heat.Value+_G.Stats.heat
					_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
					_G.Values.shotsdeplete.Value=_G.Values.shotsdeplete.Value+1
					if _G.Values.shotsdeplete.Value>=_G.DepleteShots then
					_G.Values.shotsdeplete.Value=0
					_G.Values.battery.Value=_G.Values.battery.Value-math.random(_G.BatteryMin, _G.BatteryMax)
					end
					if _G.Values.heat.Value>=100 then --overheat
					local oh=_G.Values.overheat
					local he=_G.Values.heat
					oh.Value=true
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
					mouse.Icon=Icons[2]	
					_G.Handle["Overheat"]:Play()
					local pl=pl:clone()
					pl.Color=Color3.new(230/256, 30/256, 0)
					pl.Brightness=3
					pl.Range=6.5
					pl.Parent=_G.Handle
					debris:AddItem(pl, 0.5)
					_G.Values.canfire=true
					wait(0.1*(100/_G.Stats.cool))
					he.Value=0
					oh.Value=false
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
					mouse.Icon=Icons[1]
					end
				wait(_G.Stats.firerate)
				_G.Values.canfire=true
		elseif _G.Stats.firemode=="Shot" then
			_G.Values.canfire=false
			_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
			_G.Handle["Fire"]:Play()
			Create_Muzzle(_G.Handle.CFrame*_G.Stats.firepos)
				Fire_Alpha(mouse.hit.p)
			_G.Handle["Fire"]:Play()
				Fire_Alpha(mouse.hit.p)
			_G.Handle["Fire"]:Play()
				Fire_Alpha(mouse.hit.p)
			_G.Handle["Fire"]:Play()
				Fire_Alpha(mouse.hit.p)
					_G.Values.heat.Value=_G.Values.heat.Value+_G.Stats.heat
					_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
					_G.Values.shotsdeplete.Value=_G.Values.shotsdeplete.Value+1
					if _G.Values.shotsdeplete.Value>=_G.DepleteShots then
					_G.Values.shotsdeplete.Value=0
					_G.Values.battery.Value=_G.Values.battery.Value-math.random(_G.BatteryMin, _G.BatteryMax)
					end
					if _G.Values.heat.Value>=100 then --overheat
					local oh=_G.Values.overheat
					local he=_G.Values.heat
					oh.Value=true
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
					mouse.Icon=Icons[2]	
					_G.Handle["Overheat"]:Play()
					local pl=pl:clone()
					pl.Color=Color3.new(230/256, 30/256, 0)
					pl.Brightness=3
					pl.Range=6.5
					pl.Parent=_G.Handle
					debris:AddItem(pl, 0.5)
					_G.Values.canfire=true
					wait(0.1*(100/_G.Stats.cool))
					he.Value=0
					oh.Value=false
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
					mouse.Icon=Icons[1]
					end
				wait(.385)
				_G.Handle["Ready"]:Play()
				wait(_G.Stats.firerate-0.385)
				_G.Values.canfire=true
		elseif _G.Stats.firemode=="Lock" then
			_G.Values.canfire=false
			_G.SHOT=_G.SHOT+1
			if _G.SHOT>2 then _G.SHOT=1 end
			local frate=_G.Stats.firerate
				if _G.SHOT==1 or _G.SHOT>2 then
				_G.SHOT=1
				_G.Stats.firepos=_G.Stats.firepos1
				_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
				_G.Handle["Fire"]:Play()
				frate=0.01
				else
				_G.Stats.firepos=_G.Stats.firepos2
				_G.Handle2["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
				_G.Handle2["Fire"]:Play()
				end
			Create_Muzzle(_G.Handle.CFrame*_G.Stats.firepos)
			Fire_Alpha(mouse.hit.p)
			Fire_Alpha(mouse.hit.p)
			Fire_Alpha(mouse.hit.p)
				--
					_G.Values.heat.Value=_G.Values.heat.Value+_G.Stats.heat
					_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
					_G.Values.shotsdeplete.Value=_G.Values.shotsdeplete.Value+1
					if _G.Values.shotsdeplete.Value>=_G.DepleteShots then
					_G.Values.shotsdeplete.Value=0
					_G.Values.battery.Value=_G.Values.battery.Value-math.random(_G.BatteryMin, _G.BatteryMax)
					end
				--
					if _G.Values.heat.Value>=100 then --overheat
					local oh=_G.Values.overheat
					local he=_G.Values.heat
					oh.Value=true
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
					mouse.Icon=Icons[2]	
					_G.Handle["Overheat"]:Play()
					local pl=pl:clone()
					pl.Color=Color3.new(230/255, 30/255, 0)
					pl.Brightness=3
					pl.Range=6.5
					pl.Parent=_G.Handle
					debris:AddItem(pl, 0.5)
					_G.Values.canfire=true
					wait(0.1*(100/_G.Stats.cool))
					he.Value=0
					oh.Value=false
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
					mouse.Icon=Icons[1]
					end
			wait(frate-0.35)
				if _G.SHOT==2 then
				_G.Handle["Ready"]:Play()
				wait(frate-0.25)
				_G.Handle2["Ready"]:Play()
				end
			wait(frate-0.4)
			_G.Values.canfire=true
		elseif _G.Stats.firemode=="Flame" then
			while M1Down and chr["Humanoid"].Health>0 and _G.Values.heat.Value<100 and not _G.Values.overheat.Value and _G.Values.canfire and _G.Values.battery.Value>0 do
				--_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
				_G.Handle["Fire"]:Play()
					Fire_Foxtrot(_G.Handle.Position+_G.Handle.CFrame.lookVector*5)
				_G.Values.heat.Value=_G.Values.heat.Value+_G.Stats.heat
				_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
				_G.Values.shotsdeplete.Value=_G.Values.shotsdeplete.Value+1
					if _G.Values.shotsdeplete.Value>=_G.DepleteShots then
					_G.Values.shotsdeplete.Value=0
					_G.Values.battery.Value=_G.Values.battery.Value-math.random(_G.BatteryMin, _G.BatteryMax)
					end
				_G.Values.canfire=false
				_G.Tool["FirePart"].Fire.Enabled=true
				_G.Tool["FirePart"].PointLight.Enabled=true
				wait(_G.Stats.firerate)
				_G.Values.canfire=true
				_G.Tool["FirePart"].Fire.Enabled=false
				_G.Tool["FirePart"].PointLight.Enabled=false
			end
			if _G.Values.heat.Value>=100 then --overheat
				local oh=_G.Values.overheat
				local he=_G.Values.heat
				oh.Value=true
				heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
				mouse.Icon=Icons[2]	
				_G.Handle["Overheat"]:Play()
				local pl=pl:clone()
				pl.Color=Color3.new(230/255, 30/255, 0)
				pl.Brightness=3
				pl.Range=6.5
				pl.Parent=_G.Handle
				debris:AddItem(pl, 0.5)
				_G.Values.canfire=true
				wait(0.1*(100/_G.Stats.cool))
				he.Value=0
				oh.Value=false
				heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
				mouse.Icon=Icons[1]
			end
		elseif _G.Stats.firemode=="TargetDesignator" then --special D01 one
		local Charge=0
		local Ready=false
		local Total=5
		local WAIT=0.2
			while M1Down and chr["Humanoid"].Health>0 and not _G.Values.overheat.Value and _G.Values.canfire and _G.Values.battery.Value>0 and _G.IsEquipped do
			Charge=Charge+WAIT
			_G.Values.heat.Value=_G.Values.heat.Value+(WAIT/Total*100)
			Ready=false
			if Charge>=Total then Ready=true break end
			Fire_Alpha(mouse.hit.p)
			wait(WAIT)
			end
				if Ready then
				_G.Values.canfire=false
				_G.Values.shotsdeplete.Value=_G.Values.shotsdeplete.Value+1
					if _G.Values.shotsdeplete.Value>=_G.DepleteShots then
					_G.Values.shotsdeplete.Value=0
					_G.Values.battery.Value=_G.Values.battery.Value-math.random(_G.BatteryMin, _G.BatteryMax)
					end
					local TORPEDO=game.Lighting["TORPEDO"]:clone()
					TORPEDO.Parent=workspace
					TORPEDO["Destination"].Value=mouse.hit.p
					TORPEDO["Creator"].Value=plr
					TORPEDO["TORPEDOSCRIPT"].Disabled=false
					TORPEDO.CFrame=CFrame.new(mouse.hit.p+Vector3.new(math.random(-100, 100), 2500, math.random(-100, 100)))
					if _G.Values.heat.Value>=100 then --overheat
					local oh=_G.Values.overheat
					local he=_G.Values.heat
					oh.Value=true
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
					mouse.Icon=Icons[2]	
					_G.Handle["Overheat"]:Play()
					local pl=pl:clone()
					pl.Color=Color3.new(230/255, 30/255, 0)
					pl.Brightness=3
					pl.Range=6.5
					pl.Parent=_G.Handle
					debris:AddItem(pl, 0.5)
					_G.Values.canfire=true
					wait(3)
					he.Value=0
					oh.Value=false
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
					mouse.Icon=Icons[1]
					wait(_G.Stats.firerate)
					_G.Values.canfire=true
					end
			elseif not Ready then
				_G.Values.heat.Value=0
				_G.Values.canfire=true
			end
		elseif _G.Stats.firemode=="Explosive" then --R87
			_G.Values.canfire=false
			_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
			_G.Handle["Fire"]:Play()
				Create_Muzzle(_G.Handle.CFrame*_G.Stats.firepos)
				Fire_Epsilon(mouse.hit.p)
					_G.Values.heat.Value=_G.Values.heat.Value+_G.Stats.heat
					_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
					_G.Values.shotsdeplete.Value=_G.Values.shotsdeplete.Value+1
					if _G.Values.shotsdeplete.Value>=_G.DepleteShots then
					_G.Values.shotsdeplete.Value=0
					_G.Values.battery.Value=_G.Values.battery.Value-math.random(_G.BatteryMin, _G.BatteryMax)
					end
					if _G.Values.heat.Value>=100 then --overheat
					local oh=_G.Values.overheat
					local he=_G.Values.heat
					oh.Value=true
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
					mouse.Icon=Icons[2]	
					local pl=pl:clone()
					pl.Color=Color3.new(230/256, 30/256, 0)
					pl.Brightness=3
					pl.Range=6.5
					pl.Parent=_G.Handle
					debris:AddItem(pl, 0.5)
					_G.Handle["Overheat"]:Play()
					_G.Values.canfire=true
					wait(0.1*(100/_G.Stats.cool))
					he.Value=0
					oh.Value=false
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
					mouse.Icon=Icons[1]
					end
				wait(_G.Stats.firerate)
				_G.Values.canfire=true
		elseif _G.Stats.firemode=="AT" then
		local Charge=0
		local Ready=false
		local Total=4
		local WAIT=0.2
		_G.Handle["Charge"]:Play()
		_G.Handle["FireEffect"].Enabled=true
			while M1Down and chr["Humanoid"].Health>0 and not _G.Values.overheat.Value and _G.Values.canfire and _G.Values.battery.Value>0 and _G.IsEquipped do
			Charge=Charge+WAIT
			_G.Values.heat.Value=_G.Values.heat.Value+(WAIT/Total*100)
			Ready=false
			if Charge>=Total then Ready=true break end
			wait(WAIT)
			end
			_G.Handle["FireEffect"].Enabled=false
			_G.Handle["Charge"]:Stop()
			_G.Values.canfire=true
			_G.Values.heat.Value=0
			if Ready then
			_G.Values.canfire=false
			_G.Values.heat.Value=100
			_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
			_G.Handle["Fire"]:Play()
				Create_Muzzle(_G.Handle.CFrame*_G.Stats.firepos)
				Fire_Epsilon(mouse.hit.p)
					_G.Values.shotsdeplete.Value=_G.Values.shotsdeplete.Value+1
					if _G.Values.shotsdeplete.Value>=_G.DepleteShots then
					_G.Values.shotsdeplete.Value=0
					_G.Values.battery.Value=_G.Values.battery.Value-math.random(_G.BatteryMin, _G.BatteryMax)
					end
					if _G.Values.heat.Value>=100 then --overheat
					local oh=_G.Values.overheat
					local he=_G.Values.heat
					oh.Value=true
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
					mouse.Icon=Icons[2]	
					_G.Values.canfire=true
					_G.Stats.cool=2
					local pl=pl:clone()
					pl.Color=Color3.new(230/256, 30/256, 0)
					pl.Brightness=3
					pl.Range=6.5
					pl.Parent=_G.Handle
					debris:AddItem(pl, 0.5)
					wait(0.1*(100/_G.Stats.cool))
					_G.Stats.cool=0
					he.Value=0
					oh.Value=false
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
					mouse.Icon=Icons[1]
					end
				wait(_G.Stats.firerate)
				_G.Values.canfire=true
			end
		elseif _G.Stats.firemode=="REX" then
			--spinning..
		local Charge=0
		local Ready=false
		local Total=1
		local WAIT=0.2
		local Barrel=1
		_G.Handle["SpinUp"]:Play()
			while M1Down and chr["Humanoid"].Health>0 and not _G.Values.overheat.Value and _G.Values.canfire and _G.Values.battery.Value>0 and _G.IsEquipped do
			Charge=Charge+WAIT
			Ready=false
			if Charge>=Total then Ready=true break end
			wait(WAIT)
			end
			_G.Handle["SpinUp"]:Stop()
			_G.Values.canfire=true
			--firing..
			if Ready then
				while M1Down and chr["Humanoid"].Health>0 and _G.Values.heat.Value<100 and not _G.Values.overheat.Value and _G.Values.canfire and _G.Values.battery.Value>0 and _G.IsEquipped do
				_G.Handle["Fire"].Pitch=(_G.SoundBase)+((_G.Values.heat.Value/100)/(_G.SoundDivider))
				_G.Handle["Fire"]:Play()
				_G.Stats.firepos=_G.Barrels[Barrel]
					Create_Muzzle(_G.Handle.CFrame*_G.Stats.firepos)
					Fire_Alpha(mouse.hit.p)
				_G.Values.heat.Value=_G.Values.heat.Value+_G.Stats.heat
				_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
				_G.Values.shotsdeplete.Value=_G.Values.shotsdeplete.Value+1
					if _G.Values.shotsdeplete.Value>=_G.DepleteShots then
					_G.Values.shotsdeplete.Value=0
					_G.Values.battery.Value=_G.Values.battery.Value-math.random(_G.BatteryMin, _G.BatteryMax)
					end
					Barrel=Barrel+1 if Barrel>3 then Barrel=1 end
				_G.Values.canfire=false
				wait(_G.Stats.firerate)
				_G.Values.canfire=true
			end
			if _G.Values.heat.Value>=100 then --overheat
				local oh=_G.Values.overheat
				local he=_G.Values.heat
				oh.Value=true
				heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
				mouse.Icon=Icons[2]	
				_G.Handle["Overheat"]:Play()
				local pl=pl:clone()
				pl.Color=Color3.new(230/255, 30/255, 0)
				pl.Brightness=3
				pl.Range=6.5
				pl.Parent=_G.Handle
				debris:AddItem(pl, 0.5)
				wait(0.1*(100/_G.Stats.cool))
				_G.Values.canfire=true
				he.Value=0
				oh.Value=false
				heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
				mouse.Icon=Icons[1]
			end	
			end
		end
	_G.SetBattery()
	end

	_G.Mouse1Up=function(mouse)
		M1Down=false
	end


	