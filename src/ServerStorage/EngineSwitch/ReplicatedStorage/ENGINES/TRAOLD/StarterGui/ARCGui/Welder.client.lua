--This script peforms very ugly haxwelds on the players arms.
wait(.1)
-- define --
	local w=Instance.new("Weld")

-- primary functions --
	_G.weldHandle=function(tool, torso, bool)
	print("CALLED")
		--if tool:findFirstChild("ARC")==nil then _G.IsWelded=true return end
		--handle
		local c=tool:GetChildren()
		for i = 1, #c do
			if c[i]:IsA("Part") then
				local w=w:clone()
				local part=c[i]
				local handle=tool["Handle"]
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
		--arm
		if tool:findFirstChild("ARCnoweld")~=nil then _G.IsWelded=true return end
		local ls,rs=torso["Left Shoulder"],torso["Right Shoulder"]
		local la,ra=torso.Parent["Left Arm"],torso.Parent["Right Arm"]
			if bool then
				ls.Part1=nil rs.Part1=nil
					w1=w:clone()
				w1.Name="Weld1"
				w1.Part0=torso
				w1.Part1=la
				w1.C1=_G.WeldLeftArm
				w1.Parent=torso
					w2=w:clone()
				w2.Name="Weld2"
				w2.Part0=torso
				w2.Part1=ra
				w2.C1=_G.WeldRightArm
				w2.Parent=torso
			elseif not bool and w1 and w2 then
					w1:Destroy() w2:Destroy()
				ls.Part1=la
				rs.Part1=ra
			end
		--done
		_G.IsWelded=true
	end
