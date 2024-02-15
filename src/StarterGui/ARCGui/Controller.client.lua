--Controller, this script is the local controller it is responsable for Connecting the functions of each tool. These are peformed using local shared tables (_G), the method used to Connect the tools is very inefficient however is functional. If you are considering on using snippets I would reccomend editing the tool Connection system to be less haxy.
wait(.45)
-- pre-define --
	sp=script.Parent
	local plr=game.Players.LocalPlayer
	local camera=game.Workspace.CurrentCamera
	local chr=plr.Character
	local pgui=plr:findFirstChild("PlayerGui")
	local backpack=plr:findFirstChild("Backpack")
	local debris=game:GetService("Debris")
	local lighting=game:GetService("Lighting")
	local heatgui=sp:WaitForChild("HeatFrame")
	local topgui=sp:WaitForChild("TopFrame")
	local flashpart=topgui:WaitForChild("FlashPart")
	
repeat wait(.05) until pgui and backpack

	local Connections={}
	_G.IsEquipped=false
	_G.CanFire=false
	_G.IsWelded=false
	_G.GunStatsLoaded=false
	local lasthealth=100
	_setmaxhealth=100
	local pointschain=0
	local descpos=-170

	Icons={"http://www.roblox.com/asset/?id=91822850", "http://www.roblox.com/asset/?id=91822843"}
	--hires(test)Icons={"http://www.roblox.com/asset/?id=105080423", "http://www.roblox.com/asset/?id=105080548"} It is recommended you don't use Hires icons.

Connected={}
-- misc. functions --
	equipTool=function(mouse,tool)
		--equip
		_G.IsWelded=false
		_G.GunStatsLoaded=false
		_G.IsEquipped=true
		tool["Stats"].Disabled=true
		tool["Stats"].Disabled=false
		_G.weldHandle(tool, chr["Torso"], true)
			if tool:findFirstChild("ARC") then --if gun do, if sword dont
				tool["Stats"]["Battery"].Changed:Connect(_G.SetBattery)
				heatgui.Visible=true
				mouse.Icon=Icons[1]
				heatgui.Battery.Text="Battery "..tostring(tool["Stats"]["Battery"].Value)
					if tool["Stats"]["Overheat"].Value then
						heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(170/255, 0, 0)
					else
					heatgui.Bar1.Bar2.BackgroundColor3=Color3.new(0, 44/255, 112/255)
					end
				--Connect
				mouse.Button1Down:Connect(function() _G.Mouse1Down(mouse) end)
				mouse.Button1Up:Connect(function() _G.Mouse1Up(mouse) end)
				heatgui.Visible=true
			end
	end
	
-- unofficial warc patch by enes130 --
	unequipTool=function(mouse,tool)
		_G.weldHandle(tool, chr["Torso"], false)
		_G.isEquipped=false
		_G.Mouse1Up()
		_G.Values.canfire=false
		heatgui.Visible=false
	end

	_G.ConnectTool=function(tool)
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

--health indicator
	chr["Humanoid"].HealthChanged:Connect(function()
		local hum=chr["Humanoid"]
		local health=hum.Health
		local shield=0
		local maxshield=100
		local maxhealth=hum.MaxHealth
		flashpart.BackgroundColor3=Color3.new(210/255, 0, 0)
			--set shield--
				--_G.h.Text=shield.." "..maxshield.." "..hum.Health.." "..maxhealth.." ".._setmaxhealth
				if maxhealth>_setmaxhealth and health>_setmaxhealth then
				shield=health-_setmaxhealth
				maxshield=maxhealth-_setmaxhealth
				health=health-shield
				flashpart.BackgroundColor3=Color3.new(244/255, 177/255, 0)
				end	
			--bar fx--
				if health>40 and health<=100 then
					topgui.HealthBar1.HealthBar2.BackgroundColor3=Color3.new(109/255, 160/255, 1)
					topgui.HealthNumber.TextColor3=Color3.new(109/255, 160/255, 1)
					topgui.WarningPart.Visible=false
				elseif health>20 and health<=40 then
					topgui.HealthBar1.HealthBar2.BackgroundColor3=Color3.new(188/255, 185/255, 0)
					topgui.HealthNumber.TextColor3=Color3.new(188/255, 185/255, 0)
					topgui.WarningPart.Visible=true
				elseif health>0 and health<=20 then
					topgui.HealthBar1.HealthBar2.BackgroundColor3=Color3.new(1, 34/255, 34/255)
					topgui.HealthNumber.TextColor3=Color3.new(1, 34/255, 34/255)
					topgui.WarningPart.Visible=true
				elseif health<=0 then
					topgui.HealthBar1.HealthBar2.BackgroundColor3=Color3.new(95/255, 95/255, 95/255)
					topgui.HealthNumber.TextColor3=Color3.new(95/255, 95/255, 95/255)
					topgui.WarningPart.Visible=true
					topgui.WarningPart.Text=string.upper(plr.Name).."//STATUS[KIA]/"
				end
			--gui fx--
				topgui.HealthNumber.Text=tostring(math.ceil(health-1))
				topgui.HealthBar1.HealthBar2.Size=UDim2.new((health/_setmaxhealth), 0, 1, 0)
				topgui.ShieldNumber.Text=tostring(math.ceil(shield))
				topgui.ShieldBar1.ShieldBar2.Size=UDim2.new((shield/maxshield), 0, 1, 0)
			--flash screen fx--
				if hum.Health<lasthealth then
					flashpart.Visible=true
					--if shield>0 then setShield(0.8, 0.25) delay(1.5, function() setShield(1,1) end) elseif shield<=0 then setShield(1,1) end
					wait(0.01*(lasthealth-hum.Health))
					flashpart.Visible=false
				elseif hum.Health>lasthealth and (hum.Health-lasthealth)>2 then
					flashpart.BackgroundColor3=Color3.new(51/255, 204/255, 51/255)
					flashpart.Visible=true
					wait(0.012*(hum.Health-lasthealth))
					flashpart.Visible=false
				end
			lasthealth=hum.Health
			flashpart.Visible=false --so it doesnt forget
	end)

	local died=false
--[[	chr["Humanoid"].Died:Connect(function()
		if died then return end
		died=true
		if _G.Tool~=nil then _G.Tool:Destroy() end
		heatgui.Visible=false
		topgui.HealthNumber.Text="0"
		for i = 1, #Connections do
		Connections[i]:Disconnect()
		end
		flashpart.Visible=true
	script.Disabled=true
end)]]
	chr["Humanoid"].Died:Connect(function()
		if died then return end
		died=true
		if _G.Tool~=nil then _G.Tool:Destroy() end
		heatgui.Visible=false
		topgui.HealthNumber.Text="0"
		for i = 1, #Connections do
		Connections[i]:Disconnect()
		end
		print("You died!")
		flashpart.Visible=true
		local c=chr["Humanoid"]:GetChildren()
		local tag=c[#c]
			if tag and tag:IsA("ObjectValue") and tag.Name~="BOSS" and string.upper(tag.Name)~=string.upper("masterhand") then 
			local torso=tag.Value:FindFirstChild("Torso") or tag.Value.Character:FindFirstChild("Torso") 
			wait(2)
			flashpart.Visible=true
			local name=torso.Parent.Name
			if name=="IRISEBOSS" then
				name="ERIN" 
			end
			topgui.KillNamePart.Text="[ killed by "..name.." with a "..tag.Wep.Value.." ]"
			camera.CameraType="Custom"
			camera.CameraSubject=torso
			camera.CoordinateFrame=CFrame.new(torso.Position+(torso.CFrame.lookVector*-5))
			elseif tag.Name=="BOSS" then
				local torso=tag.Value["Torso"]
				wait(2)
				flashpart.Visible=true
				topgui.KillNamePart.Text="[ killed by "..torso.Parent.Name.." with a "..tag.Wep.Value.." ]"
				camera.CameraType="Custom"
				camera.CameraSubject=torso
				camera.CoordinateFrame=CFrame.new(torso.Position+(torso.CFrame.lookVector*-5))
			elseif string.upper(tag.Name)==string.upper("masterhand") then
				local torso=tag
				wait(2)
				flashpart.Visible=true
				topgui.KillNamePart.Text="[ killed by MASTERHAND with a "..tag.Wep.Value.." ]"
				camera.CameraType="Custom"
				camera.CameraSubject=tag.Value
				--camera.CoordinateFrame=CFrame.new(torso.Position+(torso.CFrame.lookVector*-5))
			else
				warn("No tag on your death!")
			end
	script.Disabled=true
	end)


-- start --
	--rayignore-- (Creates a RayIgnore model in the Workspace, probably not the best idea to execute this in a local environment, but hey.. Blame SS) or blame owen he's responsible for all that's ever gone wrong!
	if workspace:findFirstChild("RayIgnore")==nil then 
		local m=Instance.new("Model", workspace) m.Name="RayIgnore"
	end
	
	
			local hum=chr["Humanoid"]
		local health=hum.Health
		local shield=0
		local maxshield=100
		local maxhealth=hum.MaxHealth
		flashpart.BackgroundColor3=Color3.new(210/255, 0, 0)
			--set shield--
				--_G.h.Text=shield.." "..maxshield.." "..hum.Health.." "..maxhealth.." ".._setmaxhealth
				if maxhealth>_setmaxhealth and health>_setmaxhealth then
				shield=health-_setmaxhealth
				maxshield=maxhealth-_setmaxhealth
				health=health-shield
				flashpart.BackgroundColor3=Color3.new(244/255, 177/255, 0)
				end	
			--bar fx--
				if health>40 and health<=100 then
					topgui.HealthBar1.HealthBar2.BackgroundColor3=Color3.new(109/255, 160/255, 1)
					topgui.HealthNumber.TextColor3=Color3.new(109/255, 160/255, 1)
					topgui.WarningPart.Visible=false
				elseif health>20 and health<=40 then
					topgui.HealthBar1.HealthBar2.BackgroundColor3=Color3.new(188/255, 185/255, 0)
					topgui.HealthNumber.TextColor3=Color3.new(188/255, 185/255, 0)
					topgui.WarningPart.Visible=true
				elseif health>0 and health<=20 then
					topgui.HealthBar1.HealthBar2.BackgroundColor3=Color3.new(1, 34/255, 34/255)
					topgui.HealthNumber.TextColor3=Color3.new(1, 34/255, 34/255)
					topgui.WarningPart.Visible=true
				elseif health<=0 then
					topgui.HealthBar1.HealthBar2.BackgroundColor3=Color3.new(95/255, 95/255, 95/255)
					topgui.HealthNumber.TextColor3=Color3.new(95/255, 95/255, 95/255)
					topgui.WarningPart.Visible=true
					topgui.WarningPart.Text=string.upper(plr.Name).."//STATUS[KIA]/"
				end
			--gui fx--
				topgui.HealthNumber.Text=tostring(math.ceil(health-1))
				topgui.HealthBar1.HealthBar2.Size=UDim2.new((health/_setmaxhealth), 0, 1, 0)
				topgui.ShieldNumber.Text=tostring(math.ceil(shield))
				topgui.ShieldBar1.ShieldBar2.Size=UDim2.new((shield/maxshield), 0, 1, 0)
			--flash screen fx--
				if hum.Health<lasthealth then
					flashpart.Visible=true
					--if shield>0 then setShield(0.8, 0.25) delay(1.5, function() setShield(1,1) end) elseif shield<=0 then setShield(1,1) end
					wait(0.01*(lasthealth-hum.Health))
					flashpart.Visible=false
				elseif hum.Health>lasthealth and (hum.Health-lasthealth)>2 then
					flashpart.BackgroundColor3=Color3.new(51/255, 204/255, 51/255)
					flashpart.Visible=true
					wait(0.012*(hum.Health-lasthealth))
					flashpart.Visible=false
				end
			lasthealth=hum.Health
			flashpart.Visible=false --so it doesnt forget