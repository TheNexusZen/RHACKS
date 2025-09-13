local NexusAIService = {}

NexusAIService.OWNERS = {"Sidezen","Friend1","Friend2"}
NexusAIService.PROXIMITY_RADIUS = 35
NexusAIService.CHECK_INTERVAL = 1
NexusAIService.CREDIT_COST = 50
NexusAIService.LOCAL_AI_PROXY = "http://127.0.0.1:3000/chat"
NexusAIService.WEBSITE_VALIDATE_KEY = "https://yourwebsite.com/validateKey"
NexusAIService.AI_PERSONALITIES = {
    default = {name = "HelperAI", promptPrefix = "Answer clearly: "},
    roast = {name = "RoastAI", promptPrefix = "Roast the player humorously: "},
    uwu = {name = "UwU Girl", promptPrefix = "Respond in cute uwu style: "}
}

function NexusAIService:IsOwner(player)
    for _, name in pairs(self.OWNERS) do
        if player.Name == name then return true end
    end
    return false
end

function NexusAIService:ValidateKey(player, key, HttpService)
    local success, response = pcall(function()
        return HttpService:PostAsync(
            self.WEBSITE_VALIDATE_KEY,
            HttpService:JSONEncode({key = key}),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    if not success then return false, "Failed to contact website" end
    local data = HttpService:JSONDecode(response)
    if not data.active then return false, "Key disabled" end
    if data.username ~= player.Name and not self:IsOwner(player) then return false, "Username mismatch" end
    return true, data
end

function NexusAIService:CanUseAI(player, keyData)
    if self:IsOwner(player) then return true end
    return keyData and keyData.credits >= self.CREDIT_COST
end

function NexusAIService:ConsumeCredits(key, HttpService, player)
    if self:IsOwner(player) then return end
    pcall(function()
        HttpService:PostAsync("https://yourwebsite.com/consumeCredits", HttpService:JSONEncode({key=key, amount=self.CREDIT_COST}), Enum.HttpContentType.ApplicationJson)
    end)
end

function NexusAIService:AskAI(player, keyData, key, prompt, personality, HttpService)
    if not self:CanUseAI(player, keyData) then return "AI disabled: insufficient credits" end
    personality = personality or "default"
    local prefix = self.AI_PERSONALITIES[personality] and self.AI_PERSONALITIES[personality].promptPrefix or ""
    local fullPrompt = prefix .. prompt
    local success, response = pcall(function()
        return HttpService:PostAsync(
            self.LOCAL_AI_PROXY,
            HttpService:JSONEncode({key=key, prompt=fullPrompt}),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    if success then
        self:ConsumeCredits(key, HttpService, player)
        return HttpService:JSONDecode(response).reply or "No reply"
    else
        return "AI request failed"
    end
end

function NexusAIService:RunPremiumEffect(character, keyData, player, personality)
    if not keyData.premium and not self:IsOwner(player) then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if personality == "roast" and hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(0,0,3)
    elseif personality == "uwu" and humanoid then
        humanoid.Jump = true
    end
end

return NexusAIService
