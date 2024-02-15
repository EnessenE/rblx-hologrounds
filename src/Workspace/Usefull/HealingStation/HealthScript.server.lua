	-- pre-define --
sp=script.Parent
trigger=sp["Trigger"]
status=sp["Indicator"]
sound=trigger["Recharge"]
debtime=3

	-- touch event --
deb=false
trigger.Touched:Connect(function(hit)
	if not deb and hit and hit.Parent then
		local hum=hit.Parent:findFirstChild("Humanoid")
		if hum then 
			if hum.Health<hum.MaxHealth then
				hum.Health=hum.MaxHealth
				sound:Play()
				status.PointLight.Color=Color3.new(255,0,0)
				status.BrickColor=BrickColor.new("Bright red")
				deb=true
				wait(debtime)
				deb=false --170, 255, 127
				status.PointLight.Color=Color3.new(170, 255, 127)
				status.BrickColor=BrickColor.new("Bright green")
			end
		end
	end
end)

 -- --

