--[[
	Rewritten by ArceusInator
	
	This script is the Sword module.  This runs on either the server (when FilteringEnabled is on) or the client (when FilteringEnabled is off)
--]]
local Tool = script.Parent
local Handle = Tool.Handle
local Config = Tool:WaitForChild'Configurations'
local Sword = {
	-- Advanced settings
	DoubleClickMaxTime = 0.2,
	LocalDoubleClickMaxTime = 0.2,
	
	-- Variables
	State = 'Idle', -- Idle, Slashing, Lunging
	LocalState = 'Idle',
	SlashingStartedAt = 0,
	LocalSlashingStartedAt = 0,
	AttackTicket = 0,
	LocalAttackTicket = 0,
	DestroyOnUnequip = {}
}

local GLib = require(Tool:WaitForChild'GLib') -- Library of useful functions

--
--
function Sword:Connect()
	Handle.Touched:Connect(function(hit)
		local myPlayer = GLib.GetPlayerFromPart(Tool)
		local character, player, humanoid = GLib.GetCharacterFromPart(hit)
		
		if myPlayer~=nil and character~=nil and humanoid~=nil and myPlayer~=player then
			local isTeammate = GLib.IsTeammate(myPlayer, player)
			local myCharacter = myPlayer.Character
			local myHumanoid = myCharacter and myCharacter:FindFirstChild'Humanoid'
			
			if (Config.CanTeamkill.Value==true or isTeammate~=true) and (myHumanoid and myHumanoid:IsA'Humanoid' and myHumanoid.Health > 0) and (Config.CanKillWithForceField.Value or myCharacter:FindFirstChild'ForceField'==nil) then
				local doDamage = Config.IdleDamage.Value
				if Sword.State == 'Slashing' then
					doDamage = Config.SlashDamage.Value
				elseif Sword.State == 'Lunging' then
					doDamage = Config.LungeDamage.Value
				end
				
				GLib.TagHumanoid(humanoid, myPlayer, 1)
				humanoid:TakeDamage(doDamage)
			end
		end
	end)
end

function Sword:Attack()
	local myCharacter, myPlayer, myHumanoid = GLib.GetCharacterFromPart(Tool)
	
	if myHumanoid~=nil and myHumanoid.Health > 0 then
		if Config.CanKillWithForceField.Value or myCharacter:FindFirstChild'ForceField'==nil then
			local now = tick()
			
			if Sword.State == 'Slashing' and now-Sword.SlashingStartedAt < Sword.DoubleClickMaxTime then
				Sword.AttackTicket = Sword.AttackTicket+1
				
				Sword:Lunge(Sword.AttackTicket)
			elseif Sword.State == 'Idle' then
				Sword.AttackTicket = Sword.AttackTicket+1
				Sword.SlashingStartedAt = now
				
				Sword:Slash(Sword.AttackTicket)
			end
		end
	end
end

function Sword:LocalAttack()
	local myCharacter, myPlayer, myHumanoid = GLib.GetCharacterFromPart(Tool)
	
	if myHumanoid~=nil and myHumanoid.Health > 0 then
		if Config.CanKillWithForceField.Value or myCharacter:FindFirstChild'ForceField'==nil then
			local now = tick()
			
			if Sword.LocalState == 'Slashing' and now-Sword.LocalSlashingStartedAt < Sword.LocalDoubleClickMaxTime then
				Sword.LocalAttackTicket = Sword.LocalAttackTicket+1
				
				Sword:LocalLunge(Sword.LocalAttackTicket)
			elseif Sword.LocalState == 'Idle' then
				Sword.LocalAttackTicket = Sword.LocalAttackTicket+1
				Sword.LocalSlashingStartedAt = now
				
				Sword:LocalSlash(Sword.LocalAttackTicket)
			end
		end
	end
end

function Sword:Slash(ticket)
	Sword.State = 'Slashing'
	
	Handle.SlashSound:Play()
	Sword:Animate'Slash'
	
	wait(0.5)
	
	if Sword.AttackTicket == ticket then
		Sword.State = 'Idle'
	end
end

function Sword:LocalSlash(ticket)
	Sword.LocalState = 'Slashing'
	
	wait(0.5)
	
	if Sword.LocalAttackTicket == ticket then
		Sword.LocalState = 'Idle'
	end
end

function Sword:Lunge(ticket)
	Sword.State = 'Lunging'
	
	Handle.LungeSound:Play()
	Sword:Animate'Lunge'
	
	local force = Instance.new'BodyVelocity'
	force.velocity = Vector3.new(0, 10, 0)
	force.maxForce = Vector3.new(0, 4000, 0)
	force.Parent = Tool.Parent.Torso
	Sword.DestroyOnUnequip[force] = true
	
	wait(0.25)
	Tool.Grip = CFrame.new(0, 0, -1.5, 0, -1, -0, -1, 0, -0, 0, 0, -1)
	wait(0.25)
	force:Destroy()
	Sword.DestroyOnUnequip[force] = nil
	wait(0.5)
	Tool.Grip = CFrame.new(0, 0, -1.5, 0, 0, 1, 1, 0, 0, 0, 1, 0)
	
	Sword.State = 'Idle'
end

function Sword:LocalLunge(ticket)
	Sword.LocalState = 'Lunging'
	
	wait(0.25)
	wait(0.25)
	wait(0.5)
	
	Sword.LocalState = 'Idle'
end

function Sword:Animate(name)
	local tag = Instance.new'StringValue'
	tag.Name = 'toolanim'
	tag.Value = name
	tag.Parent = Tool -- Tag gets removed by the animation script
end

function Sword:Unequip()
	for obj in next, Sword.DestroyOnUnequip do
		obj:Destroy()
	end
	
	Sword.DestroyOnUnequip = {}
	
	Tool.Grip = CFrame.new(0, 0, -1.5, 0, 0, 1, 1, 0, 0, 0, 1, 0)
	Sword.State = 'Idle'
	Sword.LocalState = 'Idle'
end

--
function Sword:Initialize()
	Sword:Connect()
end

--
--
return Sword