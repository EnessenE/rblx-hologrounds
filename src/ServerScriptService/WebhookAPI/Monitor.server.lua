local Http = game:GetService("HttpService")
local webHook = require(script.Parent)
local myWebHook = webHook.new("333704450533359647","SLeVGUFsxt6od0X5RGrPW7pibr0lUTN_5Sd2OXG56ivCkmPgzvinqNBCY_kuWiFYxXyj") --Creates a new Webhook

--FOR ABOVE, put your ID and key. https://canary.discordapp.com/api/webhooks/223844685624508426/KEY
local stop=false

game.Players.PlayerAdded:Connect(function(player)
	if stop==false then
	if player.Name=="Player1" then
		warn("TEST SERVER DETECTED")
		stop=true
	end
	if stop==false then
	myWebHook:post{
		username = "ERIN",content = player.Name.." - "..player:GetRoleInGroup(3747606).." has joined a server."
	}
			player.Chatted:Connect(function(msg)
				if (msg ~= "") then
					local nametext="["..player.Team.Name.."]"..player.Name
					myWebHook:post{
						username = nametext,		
						content = msg
					}
				end
			end)
	end
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	if stop==false then
   		myWebHook:post{
			username = "ERIN",
			content = player.Name.." has left a server."
}
	end
end)

wait(5)
if stop==false then
	repeat wait(.5) until _G.VSA2~=nil
	myWebHook:post{username = "ERIN",content = "Started a server! ".._G.VSA2}
end