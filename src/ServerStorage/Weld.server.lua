function weld()
	local parts,last = {}
	local function scan(parent)
		for _,v in pairs(parent:GetChildren()) do
			if (v:IsA("BasePart")) then
				if (last) then
					local w = Instance.new("Weld")
					w.Name = ("%s_Weld"):format(v.Name)
					w.Part0,w.Part1 = last,v
					w.C0 = last.CFrame:inverse()
					w.C1 = v.CFrame:inverse()
					w.Parent = last
				end
				last = v
				table.insert(parts,v)
			end
			scan(v)
		end
	end
	scan(script.Parent)
	for _,v in pairs(parts) do
		v.Anchored = false
	end
end

weld()
script:Remove()