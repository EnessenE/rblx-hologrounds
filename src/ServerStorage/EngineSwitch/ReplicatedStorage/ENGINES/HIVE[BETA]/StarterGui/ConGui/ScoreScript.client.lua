wait()
repeat wait() until game.Players.LocalPlayer:FindFirstChild("KillFeed") and _G.FinishLoading~=nil
-- pre-define --
local player = game.Players.LocalPlayer
local sp = script.Parent
local KillFeed = player.KillFeed
Level = player.PlayerStats.Level
Exp = player.PlayerStats.Exp
Exp.MaxValue = math.ldexp(Level.Value,7)
sp.expFrame.expText.Text=("EXP "..Exp.Value.."/"..Exp.MaxValue)
sp.expFrame.bar:TweenSize(UDim2.new(Exp.Value/Exp.MaxValue,0,1,0),"Out", "Quad", 0.2, true)	
sp.serverFrame.playerRank.Text=("SR + "..Level.Value)
bonusexp=1
if player.PlayerStats.expVIP.Value==true then bonusexp = 1.5 end
pointschain=0
killd={}
credd={}
messageon=0
i=0
kd=sp.KillFeedGui.KillText
cd=sp.KillFeedGui.PointText
KillFeed:ClearAllChildren()


viewMsg=function()
pointschain=pointschain+credd[1]
kd.Text=killd[1]
if pointschain>1 then
cd.Text="+"..pointschain
else
cd.Text=pointschain
end
table.remove(killd, 1)
table.remove(credd, 1)
kd.Visible=true
cd.Visible=true
wait(2.5)
messageon=messageon-1
kd.Visible=false
cd.Visible=false
if #killd<=0 then
pointschain=0
messageon=0
kill = false
end
end


player.KillFeed.ChildAdded:Connect(function(child)
if Level.Value<50 then Exp.Value=Exp.Value+math.ceil(child.Value*bonusexp) end
table.insert(credd, math.ceil(child.Value*bonusexp))
table.insert(killd, child.Name)
wait(0.05)
child:remove()
delay((messageon*2.61), viewMsg)
messageon=messageon+1
end)

Exp.Changed:Connect(function()
if Exp.Value >= Exp.MaxValue then 
	Level.Value=Level.Value+1
	Exp.Value=0 
	Exp.MaxValue = math.ldexp(Level.Value,7)
	sp.UnlockGui.RankText.Visible=true
	for i,v in pairs(_G.Variables['Weapons']) do
		for i,l in pairs(v) do
			print(l['NAME'])
			if Level.Value==l['LEVEL'] then
			print('UNLOCKED: '..l['NAME'])
			sp.UnlockGui.UnlockText.Text=('UNLOCKED: '..l['NAME'])
			sp.UnlockGui.UnlockText.Visible=true
			end
		end
	end
	sp.LevelUp:Play()
	wait(5)
	sp.UnlockGui.UnlockText.Visible=false
	sp.UnlockGui.RankText.Visible=false 
	end
sp.expFrame.expText.Text=("EXP "..Exp.Value.."/"..Exp.MaxValue)
sp.expFrame.bar:TweenSize(UDim2.new(Exp.Value/Exp.MaxValue,0,1,0),"Out", "Quad", 0.2, true)	
sp.serverFrame.playerRank.Text=("SR + "..Level.Value)
end)



