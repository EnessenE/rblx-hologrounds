local Tool = script.Parent;

enabled = true
function onButton1Down(mouse)
	if not enabled then
		return
	end

	enabled = false
	mouse.Icon = "http://www.roblox.com/asset/?id=91822850"

	wait(.5)
	mouse.Icon = "http://www.roblox.com/asset/?id=91822850"
	enabled = true

end

function onEquippedLocal(mouse)
	Tool.SwordScript.Disabled=false
	if mouse == nil then
		print("Mouse not found")
		return 
	end

	mouse.Icon = "http://www.roblox.com/asset/?id=91822850"
	mouse.Button1Down:Connect(function() onButton1Down(mouse) end)
end


Tool.Equipped:Connect(onEquippedLocal)
