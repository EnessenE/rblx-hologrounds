local Tool = script.Parent;
local zoom = false
local cam = ""
local dot = Instance.new("Part")
dot.Locked = true
dot.Anchored = true
dot.CanCollide = false
dot.Transparency = 1
dot.TopSurface = 0
dot.BottomSurface = 0
dot.Name = "Dot"
dot.Shape = 0
dot.Size = Vector3.new(1,1,1)
local user = ""



function onEquippedLocal(mouse2)


	local human = script.Parent.Parent
	local player = game.Players:GetPlayerFromCharacter(human)
	if player ~= nil then
		user = player
	end
	if mouse2 == nil then

		print("Mouse not found")

		return 

	end
	mouse2.KeyDown:Connect(onKeyDown)
end
function onKeyDown(key)
	key:lower()
	if key == "q" then
		if not zoom then
			zoom = true
			cam = workspace.CurrentCamera:Clone()
			cam.Parent = workspace
			dot.Parent = workspace
			local targ = user.Character.Humanoid.TargetPoint - user.Character.Head.Position
			local dir = targ / targ.magnitude
			local mag = targ.magnitude
			if mag > 150 then
				mag = 140
			elseif mag < 25 then
				mag = mag
			else
				mag = mag - 10
			end
			local startpos = user.Character.Head.Position
			local dotpos = startpos + (dir * mag)
			dot.CFrame = CFrame.new(dotpos)
			workspace.CurrentCamera.CameraSubject = dot
			workspace.CurrentCamera.CameraType = 4
		else
			zoom = false
			workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
			workspace.CurrentCamera:Remove()
			workspace.CurrentCamera = cam
			dot.Parent = nil
		end
	end
end


Tool.Equipped:Connect(onEquippedLocal)

