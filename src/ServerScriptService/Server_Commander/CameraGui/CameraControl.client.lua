wait()

--define--
	sp=script.Parent
	plr=game.Players.LocalPlayer
	chr=plr.Character
	camera=workspace.CurrentCamera
	cams=game.Players
	forward=sp["ButtonForward"]
	backward=sp["ButtonBackward"]
	exit=sp["ButtonExit"]
	guiname=sp["GuiName"]

	current=1
--functions--
	exit.MouseButton1Click:Connect(function()
	camera.CameraType="Custom"
	camera.CameraSubject=chr["Humanoid"]
	script.Parent:Destroy()
	end)

	--[[chr["Humanoid"].Changed:Connect(function(prop)
		if prop=="Jump" then
			if chr.Humanoid.Jump==true then
			camera.CameraType="Custom"
			camera.CameraSubject=chr["Humanoid"]
			end
		end
	end)]]

	setCamera=function(cam)
		--camera.CameraType="Follow"
		--camera.CoordinateFrame=CFrame.new(cam.Position, (cam.Position-cam.CFrame.lookVector*50))
		camera.CameraType="Custom"
		camera.CameraSubject=cam.Parent.Humanoid
		guiname.Text=cam.Parent.Name
	end

	forward.MouseButton1Click:Connect(function()
		current=current+1
		if current>#(cams:GetChildren()) then
		current=1
		end
		local table=cams:GetChildren()
		setCamera(table[current].Character.Torso)
	end)

	backward.MouseButton1Click:Connect(function()
		current=current-1
		if current<=0 then
		current=#(cams:GetChildren())
		end
		local table=cams:GetChildren()
		setCamera(table[current].Character.Torso)
	end)


--run--
	setCamera((cams:GetChildren())[1].Character.Torso)

--