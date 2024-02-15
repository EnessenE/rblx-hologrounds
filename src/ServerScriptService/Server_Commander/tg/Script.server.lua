sp=script.Parent
img=script.Parent.img
cancel=script.Parent.img.cancel
go=script.Parent.img.go
local place = sp.TeleportScript:FindFirstChild("PlaceId").Value
img.Image="http://www.roblox.com/Thumbs/Asset.ashx?format=png&width=420&height=230&assetId="..place

go.MouseButton1Click:Connect(function()
	sp.TeleportScript.Disabled=false
end)

cancel.MouseButton1Click:Connect(function()
	sp:Destroy()
end)

if _G.timer>0 then
function countdown()
timer = _G.timer
while timer > 0 do timer=timer-0.1 cancel.Text=("[X] Cancel Teleport "..timer) wait(0.1) end
sp.TeleportScript.Disabled=false
end
cd=coroutine.create(countdown)
coroutine.resume(cd)
end