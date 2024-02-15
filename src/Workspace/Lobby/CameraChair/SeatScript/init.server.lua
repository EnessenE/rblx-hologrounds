print("Camera seat engaged")

--define--
	sp=script.Parent
	seat=sp["Seat"]
	gui=script["CameraGui"]

	current=nil
--functions--
	seat.ChildAdded:Connect(function(child)
	wait()
		if child:IsA("Weld") and child.Part1 then
			local torso=child.Part1
			local chr=torso.Parent
			local plr=game.Players:GetPlayerFromCharacter(chr)
			if plr and chr then
				local pgui=plr:findFirstChild("PlayerGui")
				if pgui then
				current=gui:clone()
				current.Parent=pgui
				end
			end
		end
	end)

	seat.ChildRemoved:Connect(function()
	wait(.5)
		if current then current:Destroy() end
	end)