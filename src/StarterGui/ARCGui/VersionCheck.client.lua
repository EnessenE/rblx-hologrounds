repeat wait() until workspace.Data:FindFirstChild("Version") and workspace.Data:FindFirstChild("Gamemode")
local data=workspace.Data
script.Parent.State.Text="Click here for patch notes."
print("Got state")

script.Parent.State.MouseButton1Click:Connect(function()
	print("Clicked")
  	game.Players.LocalPlayer.PlayerGui.HoloGUI.VersionUpdate.Visible=true
end)

wait()

function request(q,e)
	if q/e>=1 then 
		return 1 
	else 
		return q/e
	end
end


function requestteam(team)
local num=0
for _, player in pairs(game.Players:GetPlayers()) do
	if player.Character then
		if player.Team==team then
			num=num+1
		end
	end
end
return num
end
local firsteli=true
local firstffa=true
local redrem=0
local bluerem=0


data.Gamemode.Changed:Connect(function(NewValue)
	print(NewValue)
	script.Parent.BottomFrame.ObjectiveFrame.Main.GameMode.Text=string.upper(data.Gamemode.Value)
	checkall()
end)

data.Red.Changed:Connect(function(NewValue)
	checkall()
end)

data.Blue.Changed:Connect(function(NewValue)
	checkall()
end)

data.RedTarget.Changed:Connect(function(NewValue)
	checkall()
end)

data.BlueTarget.Changed:Connect(function(NewValue)
	checkall()
end)

function checkall()
if data.Gamemode.Value=="GAME_MODE[TDM]" then
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Text=string.upper("  RED_TEAM["..data.Red.Value.."/"..data.RedTarget.Value.."]")
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Text=string.upper("  BLUE_TEAM["..data.Blue.Value.."/"..data.BlueTarget.Value.."]")
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Bar1:TweenSize(UDim2.new(request(data.Red.Value,data.RedTarget.Value),0,1,4))
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Bar1:TweenSize(UDim2.new(request(data.Blue.Value,data.BlueTarget.Value),0,1,4))
elseif data.Gamemode.Value=="GAME_MODE[CTP]" then
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Text=string.upper("  RED_TEAM["..data.Red.Value.."/"..data.RedTarget.Value.."]")
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Text=string.upper("  BLUE_TEAM["..data.Blue.Value.."/"..data.BlueTarget.Value.."]")
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Bar1:TweenSize(UDim2.new(request(data.Red.Value,data.RedTarget.Value),0,1,4))
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Bar1:TweenSize(UDim2.new(request(data.Blue.Value,data.BlueTarget.Value),0,1,4))
elseif data.Gamemode.Value=="GAME_MODE[CTF]" then
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Text=string.upper("  RED_TEAM["..data.Red.Value.."/"..data.RedTarget.Value.."]")
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Text=string.upper("  BLUE_TEAM["..data.Blue.Value.."/"..data.BlueTarget.Value.."]")
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Bar1:TweenSize(UDim2.new(request(data.Red.Value,data.RedTarget.Value),0,1,4))
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Bar1:TweenSize(UDim2.new(request(data.Blue.Value,data.BlueTarget.Value),0,1,4))
elseif data.Gamemode.Value=="GAME_MODE[ELIMINATION]" then
	if firsteli==true then
		firsteli=false
		redrem=requestteam(game.Teams["Red team"])
		bluerem=requestteam(game.Teams["Blue team"])
	end
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Bar1:TweenSize(UDim2.new(request(requestteam(game.Teams["Red team"]),redrem),0,1,4))
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Bar1:TweenSize(UDim2.new(request(requestteam(game.Teams["Blue team"]),bluerem),0,1,4))
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Text=string.upper("  RED_TEAM["..requestteam(game.Teams["Red team"]).."_REMAINING]")
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Text=string.upper("  BLUE_TEAM["..requestteam(game.Teams["Blue team"]).."_REMAINING]]")
elseif data.Gamemode.Value=="GAME_MODE[FFA]" then
	if firstffa==true then
		firstffa=false
		bluerem=requestteam(game.Teams["Team"])
	end
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Visible=false
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Text=string.upper("  PLAYERS["..requestteam(game.Teams["Team"]).."_REMAINING]]")
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Bar1:TweenSize(UDim2.new(request(requestteam(game.Teams["Team"]),bluerem),0,1,4))
else
	firsteli=true
	firstffa=true
	bluerem=0
	redrem=0
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Bar1:TweenSize(UDim2.new(1,0,1,4))
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Bar1:TweenSize(UDim2.new(1,0,1,4))
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Visible=true
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Visible=true
	script.Parent.BottomFrame.ObjectiveFrame.Main.Red.Text=string.upper("  RED_TEAM[/]")
	script.Parent.BottomFrame.ObjectiveFrame.Main.Blue.Text=string.upper("  BLUE_TEAM[/]")
	end
end


script.Parent.BottomFrame.ObjectiveFrame.Main.GameMode.Text=string.upper(data.Gamemode.Value)
checkall()