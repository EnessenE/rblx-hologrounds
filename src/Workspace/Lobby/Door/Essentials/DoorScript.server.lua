sp=script.Parent
spp=sp.Parent
timer=spp.Timer
locked=spp.Locked
name=spp.Name
touch1=sp.Touch1
touch2=sp.Touch2
dp=spp.DoorParts
db=1
mode=1 --1==closed, 2==opened, 3==busy

function move(open)
if open==true and locked.Value==false and mode==1 then
mode=3
for i = 1, 45 do
wait(.01)
dp.Left1.CFrame = dp.Left1.CFrame * CFrame.new(0, 0, -0.1)
dp.Left2.CFrame = dp.Left2.CFrame * CFrame.new(0.1, 0, 0)
dp.Left3.CFrame = dp.Left3.CFrame * CFrame.new(0, 0, 0.1)
dp.Left4.CFrame = dp.Left4.CFrame * CFrame.new(0.1, 0, 0)
dp.Middle.CFrame = dp.Middle.CFrame * CFrame.new(0.1, 0, 0)
dp.Right1.CFrame = dp.Right1.CFrame * CFrame.new(0, 0, 0.1)
dp.Right2.CFrame = dp.Right2.CFrame * CFrame.new(-0.1, 0, 0)
dp.Right3.CFrame = dp.Right3.CFrame * CFrame.new(0, 0, -0.1)
dp.Right4.CFrame = dp.Right4.CFrame * CFrame.new(0.1, 0, 0)
end
mode=2
elseif open==false and mode==2 then
mode=3
for i = 1, 45 do
wait(.01)
dp.Left1.CFrame = dp.Left1.CFrame * CFrame.new(0, 0, 0.1)
dp.Left2.CFrame = dp.Left2.CFrame * CFrame.new(-0.1, 0, 0)
dp.Left3.CFrame = dp.Left3.CFrame * CFrame.new(0, 0, -0.1)
dp.Left4.CFrame = dp.Left4.CFrame * CFrame.new(-0.1, 0, 0)
dp.Middle.CFrame = dp.Middle.CFrame * CFrame.new(-0.1, 0, 0)
dp.Right1.CFrame = dp.Right1.CFrame * CFrame.new(0, 0, -0.1)
dp.Right2.CFrame = dp.Right2.CFrame * CFrame.new(0.1, 0, 0)
dp.Right3.CFrame = dp.Right3.CFrame * CFrame.new(0, 0, 0.1)
dp.Right4.CFrame = dp.Right4.CFrame * CFrame.new(-0.1, 0, 0)
end
mode=1
end
end

function engage()
if locked.Value==true then return end
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

touch1.Touched:Connect(engage)
touch2.Touched:Connect(engage)
touch1.Touched:Connect(renew)
touch2.Touched:Connect(renew)
locked.Changed:Connect(lock)