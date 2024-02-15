local Tool = script.Parent;

enabled = true
function onButton1Down(mouse)
	if not enabled then
		return
	end
	if game.Players.LocalPlayer.PlayerStats.Class.Value=='RECON' and _G.Active==true then
	_G.Energy = 0
	end
	enabled = false
	mouse.Icon = "http://www.roblox.com/asset/?id=102439605"

	wait(.5)
	mouse.Icon = "http://www.roblox.com/asset/?id=102439605"
	enabled = true
end

function onEquippedLocal(mouse)
	Tool.SwordScript.Disabled=false
	if mouse == nil then
		print("Mouse not found")
		return 
	end

	mouse.Icon = "http://www.roblox.com/asset/?id=102439605"
	mouse.Button1Down:Connect(function() onButton1Down(mouse) end)
end


Tool.Equipped:Connect(onEquippedLocal)
