	-- pre-define --
sp=script.Parent
trigger=sp["Trigger"]
status=sp["Status"]
sound=trigger["Recharge"]
debtime=1.5

	-- touch event --
deb=false
trigger.Touched:Connect(function(hit)
	if not deb and hit and hit.Parent then
		local hum=hit.Parent.Parent:findFirstChild("Humanoid")
		if hum then 
			local c=hum.Parent:GetChildren()
			for i = 1, #c do
			if c[i]:IsA("Tool") and c[i]:findFirstChild("ARC") then
				local stats=c[i]:findFirstChild("Stats")
				if stats then
					local battery=stats["Battery"]
					if battery.Value<100 then
						battery.Value=100
						stats["ShotsDeplete"].Value=0
						sound:Play()
						status.BrickColor=BrickColor.new("Bright red")
						deb=true
						wait(debtime)
						deb=false
						status.BrickColor=BrickColor.new("Bright blue")
					end
				end
			end	
			end
		end
	end
end)

 -- --

