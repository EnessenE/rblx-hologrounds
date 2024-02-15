--define--
	sp=script.Parent
	trigger=sp["TriggerPart"]
	screen=sp["Screen"]
	dispenser=sp["Dispenser"]
	debris=game:GetService("Debris")

	deb=false
--functions--
	dispense=function(plr)
	local backp=plr["Backpack"]
	game.ServerStorage.Weapons.SpaceJuice:clone().Parent=backp
	end

	trigger.Touched:Connect(function(hit)
		if hit and not deb then
		if hit.Parent and hit.Parent:findFirstChild("Humanoid") then
		local plr=game.Players:GetPlayerFromCharacter(hit.Parent)
			if plr then
			deb=true
			dispense(plr)
			screen.BrickColor=BrickColor.new("Bright orange")
			wait(5)
			screen.BrickColor=BrickColor.new("Bright blue")
			deb=false
			end
		end
		end
	end)