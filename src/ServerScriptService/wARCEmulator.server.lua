print("Hello world!")

Hit = function(player, damage, target)
	
	warn(player.Name, " is oofing ", target.Name, " with ", damage, "." )
	target:TakeDamage(damage)
end

local event = game:GetService("ReplicatedStorage").Events:WaitForChild("RemoteEvent")

local function RemoteEventReciever(player, name, ...)
	if name == "SetTrigger" then
		Trigger()
	else 
		for i, targ in pairs(game:GetService("Players"):GetPlayers()) do
		    if player ~= targ then
				event:FireClient(targ, name, ...)
			end
		end
	end
end	


Trigger = function()
	workspace.Data.Trig.Value=true
end
event.OnServerEvent:Connect(RemoteEventReciever)
