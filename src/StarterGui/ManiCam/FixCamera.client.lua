repeat wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
game.Workspace.CurrentCamera.CameraType = "Custom"
game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid