local jumpsleft=1

plr=game.Players.LocalPlayer
mouse=plr:GetMouse()
repeat wait(.05) until plr.Character~=nil
hum=plr.Character.Humanoid
hum.FreeFalling:Connect(function()
local function onKeyDown( key )
if key==' ' and jumpsleft>=1 then
jumpsleft=0
hum.PlatformStand=true
wait()
hum.Jump=true
hum.PlatformStand=false
end
end
mouse.KeyDown:Connect(onKeyDown)
end)

hum.Running:Connect(function()
	jumpsleft=1
end)