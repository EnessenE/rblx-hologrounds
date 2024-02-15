wait(.2)
-- define --
	sp=script.Parent
	plr=game.Players.LocalPlayer
	chr=plr.Character
	camera=workspace.CurrentCamera
	reloading = false
	debris=game:GetService("Debris")
	M1Down=false
	Icons={"http://www.roblox.com/asset/?id=102439605", "http://www.roblox.com/asset/?id=102436399"}
	heal = 0
-- parts --
	dmgtag=Instance.new("ObjectValue")
	dmgtag.Name="dmg"
	tagdmg=Instance.new("NumberValue", dmgtag)
	tagdmg.Name="Damage"
	_G.healing=false
	_G.FinishReload=false
	_G.Charging=false
-- misc. functions --
if chr:FindFirstChild("HealthScript v3.1") then game.Debris:AddItem(chr:FindFirstChild("HealthScript v3.1"),0.1)end
if chr:FindFirstChild("Health") then game.Debris:AddItem(chr:FindFirstChild("Health"),0.1) end
	
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

_G.updateGui = function()
sp.weaponFrame.Ammo.Text=(_G.Values.ammo.Value)
sp.weaponFrame.MaxAmmo.Text=(_G.Values.ammostored.Value)
end

_G.updateGui2 = function()
sp.weaponFrame.Ammo.Text=("--")
sp.weaponFrame.MaxAmmo.Text=("--")
end

_G.reload = (function()
		_G.Stats.reloading=true
		if _G.Values.ammo.Value < _G.Values.ammo.MaxValue and _G.Values.ammostored.Value >= 1 and _G.Stats.reloading then
		_G.doAnimations()
		repeat wait() until _G.FinishReload==true or _G.IsEquipped==false
		if _G.FinishReload==true then
	    	 _G.Values.ammostored.Value = _G.Values.ammostored.Value + _G.Values.ammo.Value
			if _G.Values.ammostored.Value >= _G.Values.ammo.MaxValue then
				_G.Values.ammostored.Value = _G.Values.ammostored.Value - _G.Values.ammo.MaxValue
				_G.Values.ammo.Value = _G.Values.ammo.MaxValue
			elseif  _G.Values.ammostored.Value < _G.Values.ammo.MaxValue and _G.Values.ammostored.Value >= 1 then
	         _G.Values.ammo.Value = _G.Values.ammostored.Value
				_G.Values.ammostored.Value = 0
			end
			_G.Stats.reloading=false
			_G.FinishReload=false
			_G.updateGui()
			end
		end
	_G.Stats.reloading=false
end)
	
_G.onKeyDown = (function(key,mouse)
	key=key:lower()
	if key=="r" and not _G.Stats.reloading and M1Down==false then
		_G.reload(mouse)
	end
end)	

	--This function controlls which teams are on which side.
	Teams={["Sand blue"]=1,["Bright green"]=1,["Dusty Rose"]=0}
	checkValid=function(hum) 
		if hum and hum.Parent then
		local tplr=game.Players:GetPlayerFromCharacter(hum.Parent)
			if tplr then
				if (Teams[tplr.TeamColor.Name]~=Teams[plr.TeamColor.Name] or (tplr.TeamColor==BrickColor.new("White") and 	
				plr.TeamColor==BrickColor.new("White"))) and tplr~=plr then
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

-- firing functions --
	Raycast=(function(x,b)
	local ray=Ray.new(x,((b-x).Unit)*999)
	local hit,pos=game.Workspace:FindPartOnRayWithIgnoreList(ray,{chr,game.Workspace.RayIgnore, camera},true)
	return hit,pos
	end)
Fire_Foxtrot=function(tgt) --special flamethrower
	-- wallshot check --
	local i=1
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
				if not checkValid(hum) then
						--hit sound--
					hum.Health=hum.Health+5
					if heal>=5 and hum.Health<hum.MaxHealth then 
						local H = Instance.new("IntValue") H.Name=("Heal") 
						H.Value=5 H.Parent=plr.KillFeed heal = 0 
					end
					heal = heal + 1
				end
			end		
		end
	end

Fire_Alpha=function(tgt,dm) --regular shot
	-- wallshot check --
		if workspace:FindPartOnRayWithIgnoreList(Ray.new(chr["Head"].Position,((_G.Handle.CFrame*_G.Stats.firepos)-chr["Head"].Position).Unit*(chr["Head"].Position-(_G.Handle.CFrame*_G.Stats.firepos)).magnitude),{chr,workspace.RayIgnore})~=nil then return end
	-- setup --
		local predist=(tgt-(_G.Handle.CFrame*_G.Stats.firepos)).magnitude
		local spread=(_G.check)*(_G.Values.recoil.Value/100)+(_G.check2) 
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
						if hum.Health>0 then script.Parent["Hit"]:Play() end
						--damage tag--
						local d=(_G.DMG(finaldist)/game.Players:GetPlayerFromCharacter(hum.Parent).PlayerStats.Armor.Value)
						local DAMAGE=math.random(d-(d*0.05), d+(d*0.05))+dm
						local dmgtag=dmgtag:clone()
						dmgtag.Value=hum 
						dmgtag["Damage"].Value=DAMAGE
						dmgtag.Parent=script.Parent.GlobalControl	
					end
				end
			end
	end


Fire_Epsilon=function(tgt,dm) --special explosive
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
			_G.lighbullet:clone().Parent=b2
			explSound:Play()
			debris:AddItem(b2,_G.rayDisp2)

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
						local d=(_G.DMG(finaldist))
						local DAMAGE=math.random(d-(d*0.05), d+(d*0.05))+dm
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
if not _G.GunStatsLoaded or not _G.IsEquipped or M1Down or not _G.Values.canfire or _G.Values.ammo.Value<=0 or _G.Stats.reloading then return end
	M1Down=true
	if plr.PlayerStats.Class.Value==('RECON') and _G.Active==true then _G.Energy=0 end
		if _G.Stats.firemode=="Auto" then
			while M1Down and chr["Humanoid"].Health>0 and _G.Values.canfire and _G.Values.ammo.Value>0 and _G.IsEquipped do
				_G.Light.Light.Enabled=true				
				_G.Values.ammo.Value=_G.Values.ammo.Value-1
				_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
				_G.updateGui()
				_G.Handle['Fire'].Pitch=_G.Stats['Audio']+math.random(0.1,0.7)
				_G.Handle["Fire"]:Play()
				Fire_Alpha(mouse.hit.p,0)
				_G.Values.canfire=false
				wait(_G.Stats.firerate)
				_G.Values.canfire=true
			end
			_G.Light.Light.Enabled=false
		elseif _G.Stats.firemode=="Semi" then
			_G.Light.Light.Enabled=true
			_G.Values.canfire=false
			_G.Values.ammo.Value=_G.Values.ammo.Value-1
			_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
			_G.updateGui()
			_G.Handle["Fire"]:Play()
			Fire_Alpha(mouse.hit.p,0)
			wait(0.005)
			_G.Light.Light.Enabled=false
			wait(_G.Stats.firerate)
			_G.Values.canfire=true
		elseif _G.Stats.firemode=="Burst" then
			_G.Light.Light.Enabled=true	
				_G.Values.canfire=false
				if _G.Values.ammo.Value>0 then
				_G.Handle["Fire"]:Play()
				Fire_Alpha(mouse.hit.p,0)
				_G.Values.ammo.Value=_G.Values.ammo.Value-1
				_G.updateGui()
				end
					wait(.05)
				if _G.Values.ammo.Value>0 then
				_G.Handle["Fire"]:Play()
				Fire_Alpha(mouse.hit.p,0)
				_G.Values.ammo.Value=_G.Values.ammo.Value-1
				_G.updateGui()
				end
					wait(.05)
				if _G.Values.ammo.Value>0 then
				_G.Handle["Fire"]:Play()
				Fire_Alpha(mouse.hit.p,0)
				_G.Values.ammo.Value=_G.Values.ammo.Value-1
				_G.updateGui()
				end
				wait(_G.Stats.firerate)
				_G.Values.canfire=true
				_G.Light.Light.Enabled=false
		elseif _G.Stats.firemode=="Shot" then
			_G.Light.Light.Enabled=true
				_G.Values.canfire=false
				Fire_Alpha(mouse.hit.p,0)
				Fire_Alpha(mouse.hit.p,0)
				Fire_Alpha(mouse.hit.p,0)
				Fire_Alpha(mouse.hit.p,0)
				_G.Handle["Fire"]:Play()
				_G.Values.ammo.Value=_G.Values.ammo.Value-1
				_G.updateGui()
				wait(0.005)
				_G.Light.Light.Enabled=false
				wait(_G.Stats.firerate-0.385)
				_G.Values.canfire=true
		elseif _G.Stats.firemode=="Heal" and _G.Energy>20 then
			_G.healing=true
			while M1Down and chr["Humanoid"].Health>0 and _G.Values.canfire and _G.IsEquipped and _G.Energy>0 do
				_G.Tool["FirePart"].Light.Enabled=true
				_G.Tool["FirePart"].Fire.Enabled=true			
				Fire_Foxtrot(_G.Handle.Position+_G.Handle.CFrame.lookVector*5)
				_G.updateEnergyBar() 
				_G.Values.canfire=false
				wait(0.25)
				_G.Values.canfire=true
				_G.Energy = _G.Energy- 1
			end
			_G.healing=false
			_G.Tool["FirePart"].Light.Enabled=false
			_G.Tool["FirePart"].Fire.Enabled=false	
	elseif _G.Stats.firemode=="Energy" and _G.Energy>20 then
		_G.Tool["Light"].Light.Brightness = 0
		_G.Tool["Light"].Light.Enabled=true
		_G.Tool["Light"].Fire.Enabled=true		
		local dmg = 0
		 _G.Charging=true
		local char = 0
		while M1Down and chr["Humanoid"].Health>0 and _G.Values.canfire and _G.Values.ammo.Value>0 and _G.IsEquipped and _G.Energy>0 do	
		wait(0.05)		
		_G.Tool["Light"].Light.Brightness = _G.Tool["Light"].Light.Brightness + 0.1
		_G.Energy = _G.Energy - 1
		dmg = dmg + 0.5
		_G.updateEnergyBar() 
		char = char + 1
		end
		if char>=25 then
		 _G.Charging=false
		_G.Tool["Light"].Light.Enabled=false
		_G.Tool["Light"].Fire.Enabled=false
		_G.Values.canfire=false
		_G.Handle["Charge"]:stop()
		_G.Handle["Fire"]:Play()
		Fire_Alpha(mouse.hit.p,dmg)
		wait(.05)
		Fire_Alpha(mouse.hit.p,dmg)
		wait(.05)
		Fire_Alpha(mouse.hit.p,dmg)
		_G.Values.ammo.Value=_G.Values.ammo.Value-1
		_G.updateGui()
		wait(_G.Stats.firerate)
		_G.Values.canfire=true
		else
		 _G.Charging=false
		_G.Tool["Light"].Light.Enabled=false
		_G.Tool["Light"].Fire.Enabled=false
		_G.Values.canfire=false
		_G.Handle["Charge"]:stop()
		_G.Handle["Fire"]:Play()
		Fire_Alpha(mouse.hit.p,dmg)
		_G.Values.ammo.Value=_G.Values.ammo.Value-1
		_G.updateGui()
		wait(_G.Stats.firerate)
		_G.Values.canfire=true
		end
	elseif _G.Stats.firemode=="Energy2" and _G.Energy>20 then
		_G.Light.Light.Enabled=true
		_G.Values.canfire=false
		_G.Energy = _G.Energy - 25
		_G.Values.ammo.Value=_G.Values.ammo.Value-1
		_G.Values.recoil.Value=_G.Values.recoil.Value+_G.Stats.aimflaw
		_G.updateGui()
		_G.Handle["Fire"]:Play()
		Fire_Alpha(mouse.hit.p,0)
		wait(0.005)
		_G.Light.Light.Enabled=false
		wait(_G.Stats.firerate)
		_G.Values.canfire=true	
	end
end

	_G.Mouse1Up=function(mouse)
	M1Down=false
	_G.Values.recoil.Value=0
	heal=0
end




	