wait()

--define--
	sp=script.Parent
	plr=game.Players.LocalPlayer
	chr=plr.Character
	camera=workspace.CurrentCamera
	cams=workspace["Cameras"]
	forward=sp["ButtonForward"]
	backward=sp["ButtonBackward"]
	exit=sp["ButtonExit"]
	guiname=sp["GuiName"]

	current=1
--functions--
	exit.MouseButton1Click:Connect(function()
	chr["Humanoid"].Jump=true
	end)

	chr["Humanoid"].Changed:Connect(function(prop)
		if prop=="Jump" then
			if chr.Humanoid.Jump==true then
			camera.CameraType="Custom"
			camera.CameraSubject=chr["Humanoid"]
			end
		end
	end)

	setCamera=function(cam)
		camera.CameraType="Scriptable"
		camera.CoordinateFrame=CFrame.new(cam.Part1.Position, (cam.Part1.Position-cam.Part1.CFrame.lookVector*50))
		guiname.Text=cam.Name
	end

	forward.MouseButton1Click:Connect(function()
		current=current+1
		if current>#(cams:GetChildren()) then
		current=1
		end
		local table=cams:GetChildren()
		setCamera(table[current])
	end)

	backward.MouseButton1Click:Connect(function()
		current=current-1
		if current<=0 then
		current=#(cams:GetChildren())
		end
		local table=cams:GetChildren()
		setCamera(table[current])
	end)


--run--
	setCamera((cams:GetChildren())[1])

--