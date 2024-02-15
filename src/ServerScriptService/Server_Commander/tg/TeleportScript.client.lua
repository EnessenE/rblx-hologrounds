wait()
local place = script:FindFirstChild("PlaceId")
local spawn = script:FindFirstChild("DestinationSpawnName")

local placeId
local spawnName
if place then
	placeId = place.Value
	if spawn and spawn.Value then
		spawnName = spawn.Value
		game:GetService("TeleportService"):TeleportToSpawnByName(placeId, spawnName)
	else
		game:GetService("TeleportService"):Teleport(placeId)
	end
end
