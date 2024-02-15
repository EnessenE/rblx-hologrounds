print("WIJ Global Started")

-- Notes --
--[[
This is a global script that should be put in the Workspace of your game. In Indigo II, this script did everything related to the leaderboard, points, leveling and spawning.
However, since this is the light version, none of that is needed here. So all you'll find is a preweld function that welds weapon handles before they're used.
This way you will have way less weld failure on equip when you spawn. Simply put this in Workspace and it will work!

(This was called WIJGlobal before its name was changed to Preweld)	

PS: There's also a handy hat removal function added for if you dislike hats cluttering in your game!
	
--]]

-- main functions --
	
	preweld=function(dest)
	local w=Instance.new("Weld")
	local c=dest:GetChildren()	
		for i = 1, #c do
		if c[i]:IsA("Tool") and (c[i]:findFirstChild("ARC") or c[i]:findFirstChild("ARCnoweld")) then
			local d=c[i]:GetChildren()
			for e = 1, #d do
				if d[e]:IsA("Part") then
				local w=w:clone()
				local part=d[e]
				local handle=c[i]["Handle"]
				w.Part0=handle
				w.Part1=part
				local CC=CFrame.new(handle.Position)
				local C0=handle.CFrame:inverse()*CC
				local C1=part.CFrame:inverse()*CC
				w.C0=C0
				w.C1=C1
				w.Parent=handle
				end
			end
		end
		wait()
		end
	end

-- hat spawn removal (remove this bit if you allow hat dropping)--
	workspace.ChildAdded:Connect(function(child)
	wait() if child:IsA("Hat") or child:IsA("Accessory") or child:IsA("Script") or child:IsA("LocalScript") then child:Destroy() end
	end)
	
	--preweld engage
	preweld(game.ServerStorage.Weapons)
	preweld(game.ReplicatedStorage)
	preweld(game.StarterPack)
	
--