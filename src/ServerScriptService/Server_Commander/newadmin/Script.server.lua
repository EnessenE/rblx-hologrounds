duration=10

plr=script.Parent.Parent.Parent
sp=script.Parent
main=sp.main
line=sp.main.line
repeat wait(.05) until _G.adminupdates["title"]~=nil

line.Text=_G.adminupdates["title"]
wait(duration/5)
main:TweenSize(UDim2.new(1, 0, 0, 60), "Out", "Linear", 2, true, nil)
wait(duration)
main:TweenSize(UDim2.new(0, 0, 0, 60), "Out", "Linear", 2, true, nil)
wait(duration/2)
sp:Destroy()