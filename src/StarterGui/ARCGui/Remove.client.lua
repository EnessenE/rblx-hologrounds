wait(.2)

-- pre-define --
	plr=game.Players.LocalPlayer
	chr=plr.Character
	
-- remove stuff --
	repeat wait(.1) chr=plr.Character 
	until chr
	repeat wait(.1) 
	playergui=plr:findFirstChild("PlayerGui")
	robloxhealth=chr:findFirstChild("Health")
	until robloxhealth and playergui
	--robloxhealth:Destroy()
	game:GetService("StarterGui"):SetCoreGuiEnabled("Health", false)