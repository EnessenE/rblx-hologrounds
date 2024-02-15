-------------------------------------Gun info
ToolName="Machine Gun"
ClipSize=50
ReloadTime=5
Firerate=0.1
SpreadRate = 0.1
MinSpread = 0.1
MaxSpread = 4
BaseDamage=10
Damage=10
automatic=true
burst=false
shot=false			--Shotgun
BarrlePos=Vector3.new(0,0,0)
Cursors={"rbxasset://textures\\GunCursor.png"}
ReloadCursor="http://www.roblox.com/asset/?id=7419350"
-------------------------------------
equiped=false
sp=script.Parent
RayLength=999
Spread=.3
enabled=true
reloading=false
down=false
r=game:service("RunService")
last=0
last2=0
last3=0
last4=0
last5=0
last6=0

function check()

end

function tagHumanoid(humanoid, player)
	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = player
	creator_tag.Name = "creator"
	creator_tag.Parent = humanoid
	wait(0.01)
end

function untagHumanoid(humanoid)
	if humanoid ~= nil then
		local tag = humanoid:findFirstChild("creator")
		if tag ~= nil then
			tag.Parent = nil
		end
	end
end


function reload(mouse)
	reloading=true
	mouse.Icon=ReloadCursor
	while sp.Ammo.Value<ClipSize and reloading and enabled do
		wait(ReloadTime/ClipSize)
		if reloading then
			sp.Ammo.Value=sp.Ammo.Value+1
			check()
		else
			break
		end
	end
	check()
	mouse.Icon=Cursors[1]
	reloading=false
end

function onKeyDown(key,mouse)
	key=key:lower()
	if key=="r" and not reloading then
		reload(mouse)
	end
end

function movecframe(p,pos)
	p.Parent=game.Lighting
	p.Position=pos
	p.Parent=game.Workspace
end


function fire(aim)
	sp.Handle.Fire:Play()

	t=r.Stepped:wait()
	last6=last5
	last5=last4
	last4=last3
	last3=last2
	last2=last
	last=t
local Hit, Pos = game.Workspace:FindPartOnRay(Ray.new(script.Parent.Barrel.Position, CFrame.new(script.Parent.Barrel.Position,aim).lookVector * 999), script.Parent.Parent )
if Hit then
print( Hit,Pos)
if Hit.Parent.Parent:FindFirstChild("Humanoid") then
pl = game.Players:findFirstChild(Hit.Parent.Parent.Name)
if pl then
if pl.TeamColor ~= game.Players.LocalPlayer.TeamColor or pl.Neutral == true then
local damage = Damage+math.random(1,10)
Hit.Parent.Parent.Humanoid:TakeDamage(damage)
tagHumanoid(Hit.Parent.Parent.Humanoid, game.Players.LocalPlayer)
untagHumanoid(Hit.Parent.Parent.Humanoid)
end
else
local damage = Damage+math.random(1,10)
Hit.Parent.Parent.Humanoid:TakeDamage(damage)
tagHumanoid(Hit.Parent.Parent.Humanoid, game.Players.LocalPlayer)
untagHumanoid(Hit.Parent.Parent.Humanoid)
end
elseif Hit.Parent:FindFirstChild("Humanoid") then
pl = game.Players:findFirstChild(Hit.Parent.Name)
if pl then
if pl.TeamColor ~= game.Players.LocalPlayer.TeamColor or pl.Neutral == true then
local damage = Damage+math.random(1,10)
if Hit.Name == "Head" then
damage= damage*1.25
end
Hit.Parent.Humanoid:TakeDamage(damage)
tagHumanoid(Hit.Parent.Humanoid, game.Players.LocalPlayer)
untagHumanoid(Hit.Parent.Humanoid)
end
else
local damage = Damage+math.random(1,10)
if Hit.Name == "Head" then
damage= damage*1.25
end
Hit.Parent.Humanoid:TakeDamage(damage)
tagHumanoid(Hit.Parent.Humanoid, game.Players.LocalPlayer)
untagHumanoid(Hit.Parent.Humanoid)
end
end
elseif Hit == nil then
	Pos = aim
end
local a = Instance.new("Part",script.Parent.Parent)
a.formFactor = "Custom"
a.Size = Vector3.new(0.2,0.2,0.2)
a.CFrame = CFrame.new(script.Parent.Barrel.Position,Pos)*CFrame.Angles(math.rad(-90),0,0)
a.Anchored = true
a.CanCollide = false
a.Transparency = 0.5
a.TopSurface = 0
a.BottomSurface = 0
a.BrickColor = BrickColor.new("Bright green")
local b = Instance.new("BlockMesh",a)
b.Scale = Vector3.new(1,(script.Parent.Barrel.Position-Pos).magnitude*5,1)
b.Offset = Vector3.new(0,(script.Parent.Barrel.Position-Pos).magnitude/2,0)
b.Parent = a
local bu = Instance.new("Part",script.Parent.Parent)
bu.formFactor = "Custom"
bu.Size = Vector3.new(0.5,0.5,0.5)
bu.Anchored = true
bu.CanCollide = false
bu.Transparency = 0.3
bu.TopSurface = 0
bu.BottomSurface = 0
bu.BrickColor = BrickColor.new("Bright green")
bu.CFrame = CFrame.new(Pos)
bu.Parent = script.Parent.Parent
a.Parent = script.Parent.Parent
game.Debris:AddItem(a,0.05)
game.Debris:AddItem(bu,0.05)
end

function onButton1Up(mouse)
	down=false
end

function onButton1Down(mouse)
	h=sp.Parent:FindFirstChild("Humanoid")
	if not enabled or reloading or down or h==nil then
		return
	end
	if sp.Ammo.Value>0 and h.Health>0 then
		if sp.Ammo.Value<=0 then
			if not reloading then
				reload(mouse)
			end
			return
		end
		down=true
		enabled=false
		while down do
			if sp.Ammo.Value<=0 then
				break
			end
			if burst then
				local startpoint=sp.Handle.CFrame*BarrlePos
				local mag=(mouse.Hit.p-startpoint).magnitude
				local rndm=Vector3.new(math.random(-(Spread/10)*mag,(Spread/10)*mag),math.random(-(Spread/10)*mag,(Spread/10)*mag),math.random(-(Spread/10)*mag,(Spread/10)*mag))
				fire(mouse.Hit.p+rndm)
				sp.Ammo.Value=sp.Ammo.Value-1
				if sp.Ammo.Value<=0 then
					break
				end
				wait(.05)
				local startpoint=sp.Handle.CFrame*BarrlePos
				local mag2=((mouse.Hit.p+rndm)-startpoint).magnitude
				local rndm2=Vector3.new(math.random(-(.1/10)*mag2,(.1/10)*mag2),math.random(-(.1/10)*mag2,(.1/10)*mag2),math.random(-(.1/10)*mag2,(.1/10)*mag2))
				fire(mouse.Hit.p+rndm+rndm2)
				sp.Ammo.Value=sp.Ammo.Value-1
				if sp.Ammo.Value<=0 then
					break
				end
				wait(.05)
				fire(mouse.Hit.p+rndm+rndm2+rndm2)
				sp.Ammo.Value=sp.Ammo.Value-1
			elseif shot then
				sp.Ammo.Value=sp.Ammo.Value-1
				local startpoint=sp.Handle.CFrame*BarrlePos
				local mag=(mouse.Hit.p-startpoint).magnitude
				local rndm=Vector3.new(math.random(-(Spread/10)*mag,(Spread/10)*mag),math.random(-(Spread/10)*mag,(Spread/10)*mag),math.random(-(Spread/10)*mag,(Spread/10)*mag))
				fire(mouse.Hit.p+rndm)
				local mag2=((mouse.Hit.p+rndm)-startpoint).magnitude
				local rndm2=Vector3.new(math.random(-(.2/10)*mag2,(.2/10)*mag2),math.random(-(.2/10)*mag2,(.2/10)*mag2),math.random(-(.2/10)*mag2,(.2/10)*mag2))
				fire(mouse.Hit.p+rndm+rndm2)
				local rndm3=Vector3.new(math.random(-(.2/10)*mag2,(.2/10)*mag2),math.random(-(.2/10)*mag2,(.2/10)*mag2),math.random(-(.2/10)*mag2,(.2/10)*mag2))
				fire(mouse.Hit.p+rndm+rndm3)
				local rndm4=Vector3.new(math.random(-(.2/10)*mag2,(.2/10)*mag2),math.random(-(.2/10)*mag2,(.2/10)*mag2),math.random(-(.2/10)*mag2,(.2/10)*mag2))
				fire(mouse.Hit.p+rndm+rndm4)
			else
				sp.Ammo.Value=sp.Ammo.Value-1
				local startpoint=sp.Barrel.Position
				local mag=(mouse.Hit.p-startpoint).magnitude
				local rndm=Vector3.new(math.random(-(Spread/10)*mag,(Spread/10)*mag),math.random(-(Spread/10)*mag,(Spread/10)*mag),math.random(-(Spread/10)*mag,(Spread/10)*mag))
				fire(mouse.Hit.p+rndm)
			end
			wait(Firerate)
			if not automatic then
				break
			end
		end	
		enabled=true
	else
		sp.Handle.Trigger:Play()
	end
end

function onEquippedLocal(mouse)
	if mouse==nil then
		print("Mouse not found")
		return 
	end
	mouse.Icon=Cursors[1]
	mouse.KeyDown:Connect(function(key) onKeyDown(key,mouse) end)
	mouse.Button1Down:Connect(function() onButton1Down(mouse) end)
	mouse.Button1Up:Connect(function() onButton1Up(mouse) end)
	check()
	equiped=true
	if #Cursors>1 then
		while equiped do
			t=r.Stepped:wait()
			local action=sp.Parent:FindFirstChild("Pose")
			if action~=nil then
				if sp.Parent.Pose.Value=="Standing" then
					Spread=MinSpread
				else
					Spread=MinSpread+((4/10)*(MaxSpread-MinSpread))
				end
			else
				Spread=MinSpread
			end
			if t-last<SpreadRate then
				Spread=Spread+.1*(MaxSpread-MinSpread)
			end
			if t-last2<SpreadRate then
				Spread=Spread+.1*(MaxSpread-MinSpread)
			end
			if t-last3<SpreadRate then
				Spread=Spread+.1*(MaxSpread-MinSpread)
			end
			if t-last4<SpreadRate then
				Spread=Spread+.1*(MaxSpread-MinSpread)
			end
			if t-last5<SpreadRate then
				Spread=Spread+.1*(MaxSpread-MinSpread)
			end
			if t-last6<SpreadRate then
				Spread=Spread+.1*(MaxSpread-MinSpread)
			end
			if not reloading then
				local percent=(Spread-MinSpread)/(MaxSpread-MinSpread)
				for i=0,#Cursors-1 do
					if percent>(i/(#Cursors-1))-((1/(#Cursors-1))/2) and percent<(i/(#Cursors-1))+((1/(#Cursors-1))/2) then
						mouse.Icon=Cursors[i+1]
					end
				end
			end
			wait(Firerate*.9)
		end
	end
end
function onUnequippedLocal(mouse)
	equiped=false
	reloading=false
end
sp.Equipped:Connect(onEquippedLocal)
sp.Unequipped:Connect(onUnequippedLocal)
check()