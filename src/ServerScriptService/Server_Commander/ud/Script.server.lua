sp=script.Parent
t1=sp.main.title
t2=sp.main.title2
pt=sp.main.placetab
at=sp.main.admintab
u=sp.main.update

sp.main.close.MouseButton1Down:Connect(function()
	sp:Destroy()
end)

--Place Updates
function pu()
	at.BackgroundTransparency=0.8
	pt.BackgroundTransparency=0.4
	t1.Text=_G.placeupdates["title"]
	t2.Text=_G.placeupdates["title2"]
	for key, value in pairs (sp.main:GetChildren()) do
		if value.Name=="upd" then
			value:Destroy()
		end
	end
	local updnum=0
	for i=1,#_G.placeupdates do
		updnum=updnum+1
		local upd=u:Clone()
		upd.Name="upd"
		upd.Text=_G.placeupdates[i]
		if string.sub(_G.placeupdates[i],1,2)=="- " then
			upd.Position=UDim2.new(0,40,0,80+(20*(updnum-1)))
		elseif string.sub(_G.placeupdates[i],1,2)=="--" then
			upd.Position=UDim2.new(0,60,0,80+(20*(updnum-1)))
			upd.Text=string.sub(_G.placeupdates[i],2,#_G.placeupdates[i])
		else
			upd.Position=UDim2.new(0,20,0,80+(20*(updnum-1)))
		end
		upd.Visible=true
		upd.Parent=sp.main
	end
end

pu()

function au()
	pt.BackgroundTransparency=0.8
	at.BackgroundTransparency=0.4
	t1.Text=_G.adminupdates["title"]
	t2.Text=_G.adminupdates["title2"]
	for key, value in pairs (sp.main:GetChildren()) do
		if value.Name=="upd" then
			value:Destroy()
		end
	end
	local updnum=0
	for i=1,#_G.adminupdates do
		updnum=updnum+1
		local upd=u:Clone()
		upd.Name="upd"
		upd.Text=_G.adminupdates[i]
		if string.sub(_G.adminupdates[i],1,2)=="- " then
			upd.Position=UDim2.new(0,40,0,80+(20*(updnum-1)))
		elseif string.sub(_G.adminupdates[i],1,2)=="--" then
			upd.Position=UDim2.new(0,60,0,80+(20*(updnum-1)))
			upd.Text=string.sub(_G.adminupdates[i],2,#_G.adminupdates[i])
		else
			upd.Position=UDim2.new(0,20,0,80+(20*(updnum-1)))
		end
		upd.Visible=true
		upd.Parent=sp.main
	end
end

pt.MouseButton1Down:Connect(pu)
at.MouseButton1Down:Connect(au)