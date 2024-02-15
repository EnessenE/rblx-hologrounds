sp=script.Parent
spp=sp.Parent
timer=spp.Timer
locked=spp.Locked
name=spp.Name
touch1=sp.Touch1
touch2=sp.Touch2
db=1
mode=1 --1==closed, 2==opened, 3==busy

function move(open)
if open==true and locked.Value==false and mode==1 then
mode=3
for i = 1, 70 do
wait(.01)
	for index, child in pairs(script.Parent.Parent:GetChildren()) do
		if child.Name=="Left" then
			child.CFrame = child.CFrame * CFrame.new(0, 0, 0.1)
		elseif child.Name=="Right" then
			child.CFrame = child.CFrame * CFrame.new(0, 0, -0.1)
		end
	end
end
mode=2
elseif open==false and mode==2 then
mode=3
for i = 1, 70 do
wait(.01)
	for index, child in pairs(script.Parent.Parent:GetChildren()) do
		if child.Name=="Left" then
			child.CFrame = child.CFrame * CFrame.new(0, 0, -0.1)
			--print(child.Name.."left")
		elseif child.Name=="Right" then
			child.CFrame = child.CFrame * CFrame.new(0, 0, 0.1)
			--print(child.Name.."right")
		end
	end
end
mode=1
end
end

function engage(trainers)
if locked.Value==true then return end
if trainers.Parent.Parent:FindFirstChild("Humanoid") or trainers.Parent:FindFirstChild("Humanoid") then
	char=game.Players:GetPlayerFromCharacter(trainers.Parent.Parent) or game.Players:GetPlayerFromCharacter(trainers.Parent)
	if char then
		if char.TeamColor==game.Teams.Trainers.TeamColor then 
			--print("Trainer")
		else return 
		end
	else
	return 
	end
end
if db==1 then
db=2
if mode==3 then 
timer.Value=5
elseif mode==1 then
move(true)
timer.Value=5
while true do
wait(1)
timer.Value=timer.Value-1
if timer.Value<=0 then
move(false)
break
end
end
elseif mode==2 then
timer.Value=5
end
wait(0.1)
db=1
end
end

function renew()
if mode==3 or mode==2 then
timer.Value=5
end
end

function lock()
if locked.Value==true then
repeat wait(.1) until mode==2 or mode==1 
	if mode==2 then
	move(false)
	end
end
end

touch1.Touched:Connect(function(otherPart)
  engage(otherPart)
end)
touch2.Touched:Connect(function(otherPart)
  engage(otherPart)
end)

touch1.Touched:Connect(renew)
touch2.Touched:Connect(renew)
locked.Changed:Connect(lock)