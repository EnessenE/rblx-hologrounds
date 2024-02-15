-- damage center --
	--This global script deals with dealing damage in a global environment to ensure damage is administered on server time. Some features are disabled from the full version of wARC that the wARC leaderboard requires but is not necessary for standalone use.
	
	local plr=script.Parent.Parent.Parent
	debris=game:GetService("Debris")
	
	local tag=Instance.new("ObjectValue")
	tag.Name="creator"
	tag.Value=plr
	--[[weptag=Instance.new("StringValue",tag)
	weptag.Name="Wep"]]
	
	script.ChildAdded:Connect(function(child)
		wait()
		local hum=child.Value
		--damage
		hum:TakeDamage(child.Damage.Value)
		--tag remove
		--[[if hum:findFirstChild(plr.Name)~=nil then hum[plr.Name]:Destroy() end]]
		--tag add
		local cl=tag:clone()
		--[[cl["Wep"].Value=child["Wep"].Value]]
		cl.Parent=hum
		debris:AddItem(cl, 10)
		--remove dmgtag
		child:Destroy()
	end)