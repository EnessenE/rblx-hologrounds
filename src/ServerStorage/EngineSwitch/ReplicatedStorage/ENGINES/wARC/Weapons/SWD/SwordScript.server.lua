r = game:service("RunService")
debris = game:GetService("Debris")

local damage = 5


local slash_damage = 10
local lunge_damage = 30

Tool = script.Parent
sword = Tool.Handle



local SlashSound = Instance.new("Sound")
SlashSound.SoundId = "rbxasset://sounds\\swordslash.wav"
SlashSound.Parent = sword
SlashSound.Volume = .7

local LungeSound = Instance.new("Sound")
LungeSound.SoundId = "rbxasset://sounds\\swordlunge.wav"
LungeSound.Parent = sword
LungeSound.Volume = .6

local UnsheathSound = Instance.new("Sound")
UnsheathSound.SoundId = "rbxasset://sounds\\unsheath.wav"
UnsheathSound.Parent = sword
UnsheathSound.Volume = 1

local tag=Instance.new("ObjectValue")
tag.Name="creator"
tag.Value=plr



colors={["Bright blue"]=1, ["Bright green"]=1, ["Bright red"]=3, ["White"]=4}
function blow(hit)
	if (hit.Parent == nil) then return end -- happens when bullet hits sword

	local humanoid = hit.Parent:findFirstChild("Humanoid")
	local vCharacter = Tool.Parent
	local vPlayer = game.Players:playerFromCharacter(vCharacter)
	local hum = vCharacter:findFirstChild("Humanoid") -- non-nil if tool held by a character
	if humanoid~=nil and humanoid ~= hum and hum ~= nil then
		-- final check, make sure sword is in-hand
		local tPlayer=game.Players:GetPlayerFromCharacter(humanoid.Parent)
		local right_arm = vCharacter:FindFirstChild("Right Arm")
		if (right_arm ~= nil) and tPlayer then
			local joint = right_arm:FindFirstChild("RightGrip")
			if (joint ~= nil and (joint.Part0 == sword or joint.Part1 == sword)) and (colors[tostring(vPlayer.TeamColor)]~=colors[tostring(tPlayer.TeamColor)] or colors[tostring(vPlayer.TeamColor)]==colors[tostring("White")]) then
				tagHumanoid(humanoid, vPlayer)
				humanoid:TakeDamage(damage)
			end
		end


	end
end


function tagHumanoid(humanoid, player)
	if humanoid:findFirstChild(player.Name)~=nil then humanoid[player.Name]:Destroy() end
	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = player
	creator_tag.Name = player.Name
	creator_tag.Parent = humanoid
	local weptag=Instance.new("StringValue", creator_tag)
	weptag.Name="Wep"
	weptag.Value="SWD"
	debris:AddItem(creator_tag, 3)
end

function untagHumanoid(humanoid)
	if humanoid ~= nil then
		local tag = humanoid:findFirstChild("creator")
		if tag ~= nil then
			tag.Parent = nil
		end
	end
end


function attack()
	damage = slash_damage
	SlashSound:play()
	local anim = Instance.new("StringValue")
	anim.Name = "toolanim"
	anim.Value = "Slash"
	anim.Parent = Tool
end

function lunge()
	damage = lunge_damage

	LungeSound:play()

	local anim = Instance.new("StringValue")
	anim.Name = "toolanim"
	anim.Value = "Lunge"
	anim.Parent = Tool
	
	
	force = Instance.new("BodyVelocity")
	force.velocity = Vector3.new(0,1,0) --Tool.Parent.Torso.CFrame.lookVector * 80
	force.Parent = Tool.Parent.Torso
	wait(.25)
	swordOut()
	wait(.25)
	force.Parent = nil
	wait(.5)
	swordUp()

	damage = slash_damage
end

function swordUp()
	Tool.GripForward = Vector3.new(1.000e-004, -1.000e-009, -1)
	Tool.GripRight = Vector3.new(1, -1.000e-005, 1.000e-004)
	Tool.GripUp = Vector3.new(1.000e-005, 1, 0)
	Tool.GripPos = Vector3.new(0.1, -1.65, 0)
end

function swordOut()
	Tool.GripUp = Vector3.new(1.000e-007, 0.01, 1) 
	Tool.GripPos = Vector3.new(0.1, -1.3, 0)
end

function swordAcross()
	-- parry
end


Tool.Enabled = true
local last_attack = 0
function onActivated()

	if not Tool.Enabled then
		return
	end

	Tool.Enabled = false

	local character = Tool.Parent;
	local humanoid = character.Humanoid
	if humanoid == nil then
		print("Humanoid not found")
		return 
	end

	t = r.Stepped:wait()

	if (t - last_attack < .2) then
		lunge()
	else
		attack()
	end

	last_attack = t

	--wait(.5)

	Tool.Enabled = true
end


function onEquipped()
	UnsheathSound:play()
end


script.Parent.Activated:Connect(onActivated)
script.Parent.Equipped:Connect(onEquipped)


Connection = sword.Touched:Connect(blow)


