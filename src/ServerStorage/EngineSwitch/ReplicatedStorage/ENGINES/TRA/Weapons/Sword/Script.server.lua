--[[
	Rewritten by ArceusInator
	- Completely rewrote the sword
	- Added a Configurations folder so damage settings can be easily modified
	- The sword runs on the client in non-FE to reduce the impression of input delay
	- Fixed the floaty lunge issue
	
	This script will run the sword code on the server if filtering is enabled
--]]
local Tool = script.Parent
local GLib = require(206209239)
local GLibScript = GLib.Script
GLibScript.Name = 'GLib'
GLibScript.Parent = Tool
local Sword = require(Tool:WaitForChild'Sword')

if workspace.FilteringEnabled then
	-- Run the sword code on the server and accept input from the client
	
	Sword:Initialize()
	
	Tool:WaitForChild'RemoteClick'.OnServerEvent:Connect(function(client, action)
		if client.Character == Tool.Parent then
			Sword:Attack()
		end
	end)
end
Tool.Unequipped:Connect(function()
	Sword:Unequip()
end)