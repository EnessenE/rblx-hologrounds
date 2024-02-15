--Put all the health orbs in this model or they will not work!
--You may clone any of the orbs as many times as you want!

sp=script.Parent
orbregen=2

for key,value in pairs(sp:GetChildren()) do
	if value:IsA("Model") and string.sub(value.Name,1,6)=="Health" then
		local enabled=true
		value.Main.Touched:Connect(function(hit)
			hum=hit.Parent:FindFirstChild("Humanoid")
			if enabled and hum and hum.Health<hum.MaxHealth and hum.Health>0 then
				enabled=false
				if value.Name=="HealthLarge" then
					hum.Health=hum.Health+130
				elseif value.Name=="HealthMed" then
					hum.Health=hum.Health+20
				elseif value.Name=="HealthSmall" then
					hum.Health=hum.Health+10
				end
				if hum.Health>hum.MaxHealth then
					hum.Health=hum.MaxHealth
				end
				value.Parent=nil
				wait(orbregen)
				value.Parent=sp
				enabled=true
			end
		end)
	end
end