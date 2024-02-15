--[[
	Rewritten by ArceusInator
	
	This script will run the sword code on the client if filtering is disabled
--]]
local Tool = script.Parent
local Sword = require(Tool:WaitForChild'Sword')
local GLib = require(Tool:WaitForChild'GLib')

if not workspace.FilteringEnabled then
	-- Run the sword code on the client
	
	Sword:Initialize()
end

Tool.Equipped:Connect(function(mouse)
	Tool.Handle.UnsheathSound:Play()
	
	mouse.Button1Down:Connect(function()
		GLib.FastSpawn(function() Sword:LocalAttack() end)
		
		if workspace.FilteringEnabled then
			-- Send input info to the server
			Tool.RemoteClick:FireServer()
		else
			-- Interpret it on the client
			Sword:Attack()
		end
	end)
end)
Tool.Unequipped:Connect(function()
	Sword:Unequip()
end)