function Touched(part)
	script.Parent.GlassBreak:Play()
	con:Disconnect()
end

con = script.Parent.Touched:Connect(Touched)

wait(30)
script.Parent:Remove()