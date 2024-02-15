local plr=game.Players.LocalPlayer
print("Starting tag system")

while true do
	wait(.5)
	if plr.PlayerGui and plr.PlayerGui:FindFirstChild("PlayersBill")~=nil and workspace.Data.ShowTag.Value==true then
		plr.PlayerGui.PlayersBill:ClearAllChildren()
		for _, player in pairs(game.Players:GetPlayers()) do
			if player~=plr and player.TeamColor==plr.TeamColor and player.Character and player.Character:FindFirstChild("Torso") then
				if plr.PlayerGui.PlayersBill:FindFirstChild(player.Name)==nil then
					local g=script.PlayerName:Clone()
					g.Frame.BackgroundColor3=plr.TeamColor.Color
					g.Parent=plr.PlayerGui.PlayersBill
					g.Name=player.Name
					g.Adornee=player.Character.Torso
				elseif plr.PlayerGui.PlayersBill:FindFirstChild(player.Name)~=nil then
					plr.PlayerGui.PlayersBill[player.Name].Adornee=player.Character.Torso
				end
			end
		end
	elseif plr.PlayerGui and plr.PlayerGui:FindFirstChild("PlayersBill")~=nil and workspace.Data.ShowTag.Value==false then
		plr.PlayerGui.PlayersBill:ClearAllChildren()
	end
end