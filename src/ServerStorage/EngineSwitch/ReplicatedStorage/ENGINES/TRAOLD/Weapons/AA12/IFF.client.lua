--hey. it's me alextomcool. just change the normel, friendly and enemy crosshair's or just use the starter crosshair's.
--this was modifed from a KeyDoor script. credit's to whomever made the KeyDoors

bin = script.Parent
normel = "http://www.roblox.com/asset/?id=7419350"
friendly = "http://www.roblox.com/asset/?id=7419364"
enemy = "http://www.roblox.com/asset/?id=7419379"
function Run(mouse)
	mouse.Icon = normel
	local hit = mouse.Target
	if (hit == nil) then return end
        h = hit.Parent:FindFirstChild("Humanoid")
        if h ~= nil then
        torso = hit.Parent.Torso
        if torso ~= nil then
        if h.Health > 0 then
	if (torso.BrickColor == bin.Parent.Torso.BrickColor) then
        mouse.Icon = friendly
        elseif torso.BrickColor ~= bin.Parent.Torso.BrickColor then
        mouse.Icon = enemy
        end
        end
        end
        
	end
end







function on(mouse)
        while true do
        wait()
	Run(mouse)
        end
end



script.Parent.Equipped:Connect(on)

