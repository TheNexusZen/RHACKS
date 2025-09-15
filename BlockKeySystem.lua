-- KEY SYSTEM SCRIPT
local plr = game.Players.LocalPlayer
local LOCAL_KEY_VAR = "BlockerSavedKey"
local GITHUB_KEYS_URL = "https://raw.githubusercontent.com/TheNexusZen/RHACKS/refs/heads/main/keysblock.txt" -- your keys
local USE_BASE64 = true
local DISCORD_LINK = "https://discord.gg/4HXx3EDggJ"
local BLOCKER_UI_URL = "https://raw.githubusercontent.com/TheNexusZen/RHACKS/refs/heads/main/BlockUI.lua" -- main UI script

-- BASE64 helper
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64Encode(data)
	return ((data:gsub('.', function(x)
		local r,bits = '',x:byte()
		for i=8,1,-1 do r=r..(bits%2^i-bits%2^(i-1)>0 and '1' or '0') end
		return r
	end)..'0000'):gsub('%d%d%d%d%d%d', function(x)
		if #x < 6 then return '' end
		local c=0
		for i=1,6 do c=c + (x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#data%3+1])
end

-- Fetch keys from GitHub
local function getKeys()
	local success, data = pcall(function()
		return game:HttpGet(GITHUB_KEYS_URL)
	end)
	if not success then return {} end
	local keys = {}
	for line in data:gmatch("[^\r\n]+") do
		table.insert(keys, line)
	end
	return keys
end

local function isKeyValid(key)
	for _, k in ipairs(getKeys()) do
		local cmp = USE_BASE64 and base64Encode(k) or k
		if key == cmp then return true end
	end
	return false
end

-- GUI
local screenGui = Instance.new("ScreenGui", plr.PlayerGui)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,300,0,180)
frame.Position = UDim2.new(0.5,-150,0.5,-90)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(20,20,20)
header.Text = "NEXUS ZEN KEY SYSTEM"
header.TextColor3 = Color3.fromRGB(255,255,255)
header.Font = Enum.Font.SourceSansBold
header.TextSize = 18
header.Parent = frame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0,220,0,40)
keyBox.Position = UDim2.new(0.5,-110,0,50)
keyBox.PlaceholderText = "Enter Key"
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
keyBox.ClearTextOnFocus = false
keyBox.Parent = frame

local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0,120,0,40)
getBtn.Position = UDim2.new(0,20,0,110)
getBtn.Text = "Get Key"
getBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
getBtn.TextColor3 = Color3.fromRGB(255,255,255)
getBtn.Parent = frame

local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0,120,0,40)
checkBtn.Position = UDim2.new(1,-140,0,110)
checkBtn.Text = "Check Key"
checkBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
checkBtn.TextColor3 = Color3.fromRGB(255,255,255)
checkBtn.Parent = frame

-- Get Key
getBtn.MouseButton1Click:Connect(function()
	game.StarterGui:SetCore("SendNotification", {
		Title = "NEXUS ZEN",
		Text = "Copied Discord link to clipboard!",
		Duration = 3
	})
	setclipboard(DISCORD_LINK)
end)

-- Check Key
local keyValid = false
checkBtn.MouseButton1Click:Connect(function()
	local userKey = keyBox.Text
	if isKeyValid(userKey) then
		plr:SetAttribute(LOCAL_KEY_VAR,userKey)
		keyValid = true
		frame:Destroy()
		-- ✅ RUN MAIN BLOCKER UI SCRIPT AFTER VALID KEY
		pcall(function()
			loadstring(game:HttpGet(BLOCKER_UI_URL))()
		end)
	else
		game.StarterGui:SetCore("SendNotification", {
			Title = "NEXUS ZEN",
			Text = "Invalid key!",
			Duration = 3
		})
	end
end)

repeat task.wait() until keyValid
