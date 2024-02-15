wait(1)
local patch=script.Parent.VersionUpdate
local s=patch.List.Template:Clone()

if script.Parent.Parent.Parent.Name=="HoloScript" then
	for i=1,#_G.VSA1 do
		local x=s:Clone()
		x.Parent=patch.List
		x.Position=UDim2.new(0,0,0,(20+(45*(i-1))))
		x.Visible=true
		x.Text=_G.VSA1[i]
		print(_G.VSA1[i])
	end
	patch.List.CanvasSize = UDim2.new(0,0,0, (20+(45*(#_G.VSA1+2))))
end
