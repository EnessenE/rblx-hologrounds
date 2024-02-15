tool=script.Parent
Cooldown=.5
dmg=tool._MeleeVal
p1=1.1
p2=1.2
p3=1.3
p4=1.4
p5=1.5
ps={p1,p2,p3,p4,p5}
function MeleeK(key)

if key then
key = string.lower(key)
if (key=="q") then
if not tool.Enabled then return end
tool.Enabled = false
on=true
local s=Instance.new("Sound")
s.Parent=tool.Handle
s.SoundId="rbxasset://sounds\\swordslash.wav"
s.Volume=1
s:play()
function Melee(hit)
if not on then return end
on=false
if hit.Parent:findFirstChild("Humanoid")then
hit.Parent.Humanoid:TakeDamage(dmg.Value)
local s=Instance.new("Sound")
s.Parent=tool.Glass
s.SoundId="rbxasset://sounds\\swordlunge.wav"
s.Volume=1
s.Pitch=ps[math.random(1,#ps)]
s:play()
wait(3)
s:remove()
end
end
tool.Glass.Touched:Connect(Melee)
tool.GripPos=Vector3.new(0,0.5,-0.6)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.50)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.40)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.30)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.20)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.10)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,0.10)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,0.20)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,0.30)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,0.20)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,0.10)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,0.0)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.10)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.20)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.30)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.40)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.50)
wait(.01)
tool.GripPos=Vector3.new(0,0.5,-0.6)
s:remove()
wait(Cooldown)
tool.Enabled=true
end
end
end
function Equip(mouse)
mouse.KeyDown:Connect(MeleeK)
end
script.Parent.Equipped:Connect(Equip)