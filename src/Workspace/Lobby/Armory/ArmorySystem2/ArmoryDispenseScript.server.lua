print("wARC ARMORY SYSTEM - ENGAGED")

--define--
	sp=script.Parent
	local armorybutton=sp["ArmoryButton"]
	local part1,part2=sp["Part1"],sp["Part2"]
	local deb=false

	local armorygui=game.ReplicatedStorage.Assets.GUIs.ArmoryGui
	
	local p1=Instance.new("Vector3Value", sp)
	p1.Name="Part1" p1.Value=part1.Position
	part1:Destroy()
	local p2=Instance.new("Vector3Value", sp)
	p2.Name="Part2" p2.Value=part2.Position
	part2:Destroy()	
	

--functions--

	armorybutton.Touched:Connect(function(hit)
		if hit and hit.Parent and not deb then
			local hum=hit.Parent:findFirstChild("Humanoid")
			if hum then
			deb=true
				local plr=game.Players:GetPlayerFromCharacter(hit.Parent)
				if plr and hum.Health>0 then
					local plrgui=plr:findFirstChild("PlayerGui")
					if plrgui then
						local agui=plrgui:findFirstChild("ArmoryGui")
						if not agui then
							local	agui=armorygui:clone()
							agui.Armory.Value=script.Parent
							agui.Parent=plrgui
						end
					end
				end
			wait(.1)
			deb=false
			end
		end
	end)