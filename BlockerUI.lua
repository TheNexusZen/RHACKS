-- MAIN BLOCKER UI SCRIPT
local plr = game.Players.LocalPlayer
local LOCAL_KEY_VAR = "BlockerSavedKey"
local KEY_SYSTEM_URL = "https://raw.githubusercontent.com/TheNexusZen/RHACKS/refs/heads/main/BlockKeySystem.lua"
local GITHUB_KEYS_URL = "https://raw.githubusercontent.com/TheNexusZen/RHACKS/refs/heads/main/keysblock.txt"
local USE_BASE64 = true
local Players = game:GetService("Players")

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

-- CHECK KEY
local savedKey = plr:GetAttribute(LOCAL_KEY_VAR)
if not savedKey or not isKeyValid(savedKey) then
	-- key invalid → run key system
	pcall(function()
		loadstring(game:HttpGet(KEY_SYSTEM_URL))()
	end)
	return
end

-- DRAGGABLE BLOCKER UI
local screenGui = Instance.new("ScreenGui", plr.PlayerGui)
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,300,0,400)
frame.Position = UDim2.new(0.5,-150,0.5,-200)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.Text = "BLOCKER UI"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- SCROLLABLE PLAYER LIST, SEARCH, AVATARS, BLOCK BUTTONS
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0,220,0,30)
searchBox.Position = UDim2.new(0.5,-110,0,40)
searchBox.PlaceholderText = "Search Players"
searchBox.TextColor3 = Color3.fromRGB(255,255,255)
searchBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchBox.ClearTextOnFocus = false
searchBox.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-80)
scroll.Position = UDim2.new(0,10,0,80)
scroll.BackgroundColor3 = Color3.fromRGB(50,50,50)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 8
scroll.Parent = frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)
UIListLayout.Parent = scroll

local blockedPlayers = {}

local function refreshPlayerList()
	scroll:ClearAllChildren()
	local searchText = searchBox.Text:lower()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= plr and not table.find(blockedPlayers,p.UserId) then
			if searchText == "" or p.Name:lower():find(searchText) then
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1,0,0,40)
				btn.Text = p.Name
				btn.TextColor3 = Color3.fromRGB(255,255,255)
				btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
				btn.Parent = scroll

				local thumb = Players:GetUserThumbnailAsync(p.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
				local img = Instance.new("ImageLabel")
				img.Size = UDim2.new(0,36,0,36)
				img.Position = UDim2.new(0,4,0,2)
				img.Image = thumb
				img.BackgroundTransparency = 1
				img.Parent = btn

				btn.MouseButton1Click:Connect(function()
					blockedPlayers[#blockedPlayers+1] = p.UserId
					refreshPlayerList()
				end)
			end
		end
	end
	scroll.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()
