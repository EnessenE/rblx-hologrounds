local TextChatService = game:GetService("TextChatService")
local generalChannel: TextChannel = TextChatService:WaitForChild("TextChannels").RBXGeneral

local function OnServerMessage(text)
	print("New server message: "..text)
	generalChannel:DisplaySystemMessage(text)
end

game.ReplicatedStorage:WaitForChild("ServerMessageEvent").OnClientEvent:Connect(OnServerMessage)
print("Chat system ready")