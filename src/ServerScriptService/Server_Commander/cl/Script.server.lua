sp=script.Parent
--plr=script.Parent.Parent.Parent
local cmdnumber=0
local ynumber=0

sp.main.close.MouseButton1Down:Connect(function()
	sp:Destroy()
end)

for i, v in ipairs (_G.commands) do
	cmdnumber=cmdnumber+1
	local c=sp.main.cmd:Clone()
	c.Name="newcmd"
	c.Text=v
	if (string.sub(v,1,2)=="By" or v=="Target Groups") then cmdnumber=0 c.Font=Enum.Font.SourceSansBold c.TextColor3=Color3.new(0/255,40/255,255/255) end
	if cmdnumber<=1 then ynumber=ynumber+1 end
	if cmdnumber>=1 then 
		c.Position=UDim2.new(0,40+(400*(cmdnumber-1)),0,20+((ynumber-1)*20)) 
	else
		c.Position=UDim2.new(0,0,0,20+((ynumber-1)*20))
	end
	c.Visible=true
	c.Parent=sp.main
	if cmdnumber==3 then cmdnumber=0 end
end