game.Players.LocalPlayer:WaitForChild("CameraFix").OnClientEvent:Connect(function()
	game.Players.LocalPlayer.PlayerGui.ARCGui.MiddleFrame.BossFrame.Visible=false
	game.Players.LocalPlayer.PlayerGui.ARCGui.MiddleFrame.BossFrame.LevelPart.Text=""
	game.Workspace.CurrentCamera.CameraType = "Scriptable"
	game.Workspace.CurrentCamera:Interpolate (game.Players.LocalPlayer.Character.Head.CFrame+Vector3.new(0,5,-10),game.Players.LocalPlayer.Character.Head.CFrame,1.5)
	wait(1.5)
	game:GetService('Players').LocalPlayer.CameraMode = Enum.CameraMode.Classic
	game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
	game.Workspace.CurrentCamera.CameraType = "Custom"
	print("Camera fixed")
end)

game.Players.LocalPlayer:WaitForChild("BossCam").OnClientEvent:Connect(function(name,part)
	print("Boss cam: "..name,part)
	local p=part.CFrame
	game.Players.LocalPlayer.PlayerGui.ARCGui.MiddleFrame.BossFrame.Visible=true
	game.Players.LocalPlayer.PlayerGui.ARCGui.MiddleFrame.BossFrame.LevelPart.Text=name
	game.Workspace.CurrentCamera.CameraType = "Scriptable"
	if name=="MASTERHAND" then
		p=CFrame.new(p.p)*CFrame.Angles(0,180,0)
	end
	game.Workspace.CurrentCamera:Interpolate (p+Vector3.new(0,10,-50),part.CFrame,1.5)
end)

--cam:Interpolate (cambrick.CFrame,game.Players.LocalPlayer.Character.Torso.CFrame,.1)