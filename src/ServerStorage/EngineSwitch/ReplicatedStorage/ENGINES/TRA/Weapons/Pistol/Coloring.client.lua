repeat
wait()
until script.Parent.Parent.Parent.ClassName == "Player"
g = script.Parent:GetChildren()
for i = 1,#g do
	if g[i].Name == "Color" then
		g[i].BrickColor = script.Parent.Parent.Parent.TeamColor
	end
end
