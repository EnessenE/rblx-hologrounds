-- damage center --
	--This global script deals with dealing damage in a global environment to ensure damage is administered on server time. Some features are disabled from the full version of wARC that the wARC leaderboard requires but is not necessary for standalone use.
	print("globalcontrol start")
	wait(1)
	debris=game:GetService("Debris")
	
	script.RemoteEvent.OnServerEvent:Connect(function(plr, humanoid, weapon, damage)
		wait()
		local tag=Instance.new("ObjectValue")
		tag.Name="creator"
		tag.Value=plr
		local weptag=Instance.new("StringValue")
		weptag.Name="Wep"
		weptag.Parent=tag
	
		--damage
		humanoid:TakeDamage(damage)
		--tag remove
		if humanoid:findFirstChild(plr.Name)~=nil then humanoid[plr.Name]:Destroy() end
		--tag add
		local cl=tag:clone()
		cl["Wep"].Value=weapon
		cl.Parent=humanoid
		debris:AddItem(cl, 10)
		--remove dmgtag
	end)
	print("child Connected")