local Tool = script.Parent


local GlassBreak = Instance.new("Sound")
GlassBreak.Name = "GlassBreak"
GlassBreak.SoundId = "http://www.roblox.com/asset/?id=11415738"
GlassBreak.Volume = 1
GlassBreak.Parent = Tool.Handle

local DrinkSound = Instance.new("Sound")
DrinkSound.Name = "Drink"
DrinkSound.SoundId = "http://www.roblox.com/asset/?id=10722059"
DrinkSound.Volume = .5
DrinkSound.Parent = Tool.Handle


function onActivated()
	if not Tool.Enabled  then
		return
	end

	Tool.Enabled = false
	Tool.GripForward = Vector3.new(0,-.759,-.651)
	Tool.GripPos = Vector3.new(1.5,-.35,.1)
	Tool.GripRight = Vector3.new(1,0,0)
	Tool.GripUp = Vector3.new(0,.651,-.759)


	DrinkSound:Play()
	DrinkSound:Remove()
	wait(3)

	Tool.GripForward = Vector3.new(-.976,0,-0.217)
	Tool.GripPos = Vector3.new(0.1,0,.1)
	Tool.GripRight = Vector3.new(.217,0,-.976)
	Tool.GripUp = Vector3.new(0,1,0)

	wait(1)

	local sc = Tool.EffectScript:clone()
	sc.Disabled = false
	sc.Parent = Tool.Parent

	local p = Tool.Handle:Clone()
	GlassBreak.Parent = p
	p.Transparency = 0
	
	Tool.Parent.Torso["Right Shoulder"].MaxVelocity = 0.7
	Tool.Parent.Torso["Right Shoulder"].DesiredAngle = 3.6
	wait(.1)
	Tool.Parent.Torso["Right Shoulder"].MaxVelocity = 1

	local dir = Tool.Parent.Head.CFrame.lookVector
	p.Velocity = (dir * 45) + Vector3.new(0,45,0)
	p.CanCollide = true
	Tool.Glass.Parent = p
	p.Glass.Disabled = false
	p.Parent = game.Workspace


	Tool:Remove()
end

script.Parent.Handle.Touched:Connect(function(hit) 
script.Parent.Handle.Anchored=false
script.Parent.Handle.CanCollide=false
end)

script.Parent.Activated:Connect(onActivated)
