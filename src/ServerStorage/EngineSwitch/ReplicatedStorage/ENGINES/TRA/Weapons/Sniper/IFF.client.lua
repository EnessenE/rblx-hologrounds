bin = script.Parent
normel = "http://www.roblox.com/asset/?id=7419350"
friendly = "http://www.roblox.com/asset/?id=7419364"
enemy = "http://www.roblox.com/asset/?id=7419379"

function Run(mouse)
	mouse.Icon = normel
	local hit = mouse.Target
	if (hit == nil) then return end
	h = hit.Parent:FindFirstChild("Humanoid")
	if h ~= nil then
		player = game.Players:GetPlayerFromCharacter(hit.Parent)
		if player ~= nil then
			localplayer = game.Players:GetPlayerFromCharacter(bin.Parent)
			if localplayer ~= nil then
				if h.Health > 0 then
					if player.TeamColor == localplayer.TeamColor then
						mouse.Icon = friendly
					else
						mouse.Icon = enemy
					end
				end
			end
		end
	end
end

function on(mouse)
	while true do
		wait()
		Run(mouse)
	end
end

script.Parent.Equipped:Connect(on)