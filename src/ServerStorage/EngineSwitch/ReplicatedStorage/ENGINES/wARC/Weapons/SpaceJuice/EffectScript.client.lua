wait()
sp=script.Parent
plr=game.Players:GetPlayerFromCharacter(sp)
chr=sp
hum=chr:findFirstChild("Humanoid")
camera=workspace.CurrentCamera
while playergui==nil do playergui=plr:findFirstChild("PlayerGui") wait(.01) end

local gui=script.DrinkGui:clone()
gui.Parent=playergui
label=gui.TextLabel

originalwalkspeed=hum.WalkSpeed
count=math.random(190, 210)
fov=70
camera.CameraType=Enum.CameraType.Scriptable
tr=.8
roll=-.5
direction=true
for i = 1, count do
if direction==true then roll=roll+0.1 else roll=roll-0.1 end
if roll<-0.4 then roll=-0.5 direction=true elseif roll>0.5 then direction=false roll=0.4 end
fov=70-(20*(i/count))
hum.WalkSpeed=math.random(-20, 20)
camera.FieldOfView=fov
camera:SetRoll(roll)
tr=tr-0.0015
label.BackgroundTransparency=tr
wait(.1)
end

tr=label.BackgroundTransparency
for i = 1, 100 do
tr=tr+0.01
label.BackgroundTransparency=tr
wait()
end

gui:remove()

camera:SetRoll(0)
camera.CameraType=Enum.CameraType.Custom
camera.FieldOfView=70
hum.WalkSpeed=originalwalkspeed