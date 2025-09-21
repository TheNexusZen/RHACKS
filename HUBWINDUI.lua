local Version = "1.6.41"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local isPremium = false
local url = "https://raw.githubusercontent.com/TheNexusZen/RHACKS/refs/heads/main/premiumplayers"

WindUI:SetNotificationLower(true)
WindUI:SetTheme("Dark")

local Window = WindUI:CreateWindow({
    Title = "NexusHub",
    Icon = "door-open",
    Author = "Made By NexusZen",
    Folder = "NexusHubConfig",
    
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = false,
    Theme = "Dark",
    Resizable = false,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("???")
        end,
    },

    
    KeySystem = {                                                   
        Note = "Compelete Key System To Continue Join Our Discord To Win Free Keys",        
        API = {                                                     
            { -- pandadevelopment
                Type = "pandadevelopment",
                ServiceId = "sidezen_clicker_1337",
                    Callback = function(keyData)
                    if keyData.Type == "Premium" then
                        isPremium = true
                        end
                    end
            },                                                      
        },                                                          
    },                                                              
})

local success, response = pcall(function()
    return game:HttpGet(url, true)
end)

if success and response then
    local list = {}
    for line in response:gmatch("[^\r\n]+") do
        list[line] = true
    end

    if list[tostring(plr.UserId)] or list[plr.Name] then
        isPremium = true
    end
end

WindUI:Notify({
    Title = "Success!",
    Content = "Script Loaded Successfully",
    Duration = 3,
    Icon = "bell",
})

Window:EditOpenButton({
    Title = "Open NexusHub",
    Icon = "script",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = false,
})

Window:Tag({
    Title = "v0",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 0, -- from 0 to 13
})

Window:Tag({
    Title = "BETA",
    Color = Color3.fromHex("#CF3636"),
    Radius = 0, -- from 0 to 13
})

local player = Window:Tab({
    Title = "Player",
    Icon = "user",
    Locked = false,
})

local VisualsTab = Window:Tab({
    Title = "Visuals",
    Icon = "eye-closed",
    Locked = false,
})

local tptab = Window:Tab({
    Title = "Teleport",
    Icon = "map-pinned",
    Locked = false,
})

local SerTab = Window:Tab({
    Title = "Server",
    Icon = "server",
    Locked = false,
})

local Premium = Window:Tab({
    Title = "Premium Features",
    Icon = "star",
    Locked = not isPremium,
})

local jobIdInputValue = ""
local autoLoadScript = false
local serverFilter = "High Players"
local scriptUrl = "https://raw.githubusercontent.com/TheNexusZen/RHACKS/main/HUBWINDUI.lua"

-- JobId Input
local Input = SerTab:Input({
    Title = "Server JobId",
    Desc = "Paste JobId to join a server",
    Value = "",
    InputIcon = "text-cursor",
    Type = "Input",
    Placeholder = "Enter JobId...",
    Callback = function(input)
        jobIdInputValue = input
    end
})

-- Join JobId Button
SerTab:Button({
    Title = "Join Server JobId",
    Desc = "Teleports to the JobId entered",
    Callback = function()
        if jobIdInputValue ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobIdInputValue, Players.LocalPlayer)
        end
    end
})

-- Copy JobId Button
SerTab:Button({
    Title = "Copy Current JobId",
    Desc = "Copies current server JobId to clipboard",
    Callback = function()
        setclipboard(game.JobId)
    end
})

-- Auto Load Script Toggle
SerTab:Toggle({
    Title = "Auto Load Script On Server Hop",
    Desc = "Automatically executes script when joining a new server SOON wont work but keep it on just incase",
    Default = false,
    Callback = function(state)
        autoLoadScript = state
    end
})

-- Server Filter Dropdown
local ServerDropdown = SerTab:Dropdown({
    Title = "Server Filter",
    Values = {"High Players", "Low Players"},
    Value = "High Players",
    Callback = function(option)
        serverFilter = option
    end
})

-- Helper function to fetch servers
local function getServers(cursor)
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    if cursor then
        url = url.."&cursor="..cursor
    end
    local success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if success and data and data.data then
        return data
    else
        return nil
    end
end

-- Auto-Hop Button
SerTab:Button({
    Title = "Auto Hop To Filtered Server",
    Desc = "Finds server based on filter and hops",
    Callback = function()
        spawn(function()
            local servers = {}
            local cursor
            repeat
                local data = getServers(cursor)
                if not data then break end
                for _, s in pairs(data.data) do
                    if s.playing < s.maxPlayers then
                        table.insert(servers, s)
                    end
                end
                cursor = data.nextPageCursor
            until not cursor

            if #servers == 0 then
                warn("No suitable servers found.")
                return
            end

            if serverFilter == "High Players" then
                table.sort(servers, function(a,b) return a.playing > b.playing end)
            elseif serverFilter == "Low Players" then
                table.sort(servers, function(a,b) return a.playing < b.playing end)
            end

            local target = servers[1]
            if target then
                print("Teleporting to server:", target.id)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, Players.LocalPlayer)
                if autoLoadScript then
                    task.wait(3)
                    loadstring(game:HttpGet(scriptUrl, true))()
                end
            end
        end)
    end
})

local fullbrightActive = false

local originalLighting = {
    Brightness = game.Lighting.Brightness,
    ClockTime = game.Lighting.ClockTime,
    FogEnd = game.Lighting.FogEnd,
    GlobalShadows = game.Lighting.GlobalShadows,
    Ambient = game.Lighting.Ambient
}

VisualsTab:Button({
    Title = "Player ESP",
    Desc = "⚠️THIS EXECUTES ANOTHER SCRIPT!⚠️ BROKEN CURRENTLY.",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wa0101/Roblox-ESP/refs/heads/main/esp.lua", true))()
    end
})

VisualsTab:Slider({
    Title = "FOV",
    Value = {Min = 70, Max = 200, Default = 70, Step = 1},
    Callback = function(val)
        workspace.CurrentCamera.FieldOfView = val
    end
})

VisualsTab:Toggle({
    Title = "Fullbright",
    Desc = "Bright game",
    Default = false,
    Callback = function(state)
        fullbrightActive = state
        if state then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 1e9
            game.Lighting.GlobalShadows = false
            game.Lighting.Ambient = Color3.new(1,1,1)
        else
            for k,v in pairs(originalLighting) do
                game.Lighting[k] = v
            end
        end
    end
})

local selectedTarget

local function getPlayerList()
    local names = {}
    for _,v in ipairs(Players:GetPlayers()) do
        if v ~= plr then
            table.insert(names, v.Name)
        end
    end
    return names
end

local TeleportDown = tptab:Dropdown({
    Title = "Players",
    Values = getPlayerList(),
    Value = "",
    Callback = function(option)
        selectedTarget = option
    end
})

local RefreshBtn = tptab:Button({
    Title = "Refresh List",
    Desc = "Update player dropdown",
    Locked = false,
    Callback = function()
        TeleportDown:Refresh(getPlayerList())
    end
})

local TpBtn = tptab:Button({
    Title = "Teleport",
    Desc = "TP to selected player",
    Locked = false,
    Callback = function()
        if selectedTarget then
            local target = Players:FindFirstChild(selectedTarget)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
                end
            end
        end
    end
})

local savedSlots = {}
local currentSlot = nil

local TpDropdown = tptab:Dropdown({
    Title = "Saved Slots",
    Values = {},
    Value = nil,
    Callback = function(option)
        currentSlot = option
    end
})

local function refreshDropdown()
    local names = {}
    for i = 1, #savedSlots do
        names[i] = "Slot "..i
    end
    TpDropdown:Refresh(names)
    if #names > 0 then
        currentSlot = names[#names]
    else
        currentSlot = nil
    end
end

tptab:Button({
    Title = "Save New Slot",
    Desc = "Save your current location",
    Callback = function()
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            table.insert(savedSlots, char.HumanoidRootPart.CFrame)
            refreshDropdown()
        end
    end
})

tptab:Button({
    Title = "Teleport to Slot",
    Desc = "Teleport to selected saved slot",
    Callback = function()
        if currentSlot then
            local index = tonumber(string.match(currentSlot,"%d+"))
            local pos = savedSlots[index]
            if pos then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = pos
                end
            end
        end
    end
})

tptab:Button({
    Title = "Delete Slot",
    Desc = "Delete the selected saved slot",
    Callback = function()
        if currentSlot then
            local index = tonumber(string.match(currentSlot,"%d+"))
            if savedSlots[index] then
                table.remove(savedSlots, index)
                refreshDropdown()
            end
        end
    end
})

-- 📜 Paragraph explaining the system
tptab:Paragraph({
    Title = "Teleport Slot System",
    Desc = 
        "📌 Saving System:\n" ..
        "- Every time you press 'Save New Slot', your current position is saved as the next slot in order (Slot 1, Slot 2, Slot 3...)\n\n" ..
        "🚀 Teleporting:\n" ..
        "- Select a slot from the dropdown and press 'Teleport to Slot' to snap back to that exact saved location.\n\n" ..
        "🗑️ Deleting System:\n" ..
        "- When you delete a slot, only the one you selected will be removed.\n" ..
        "- After deletion, all remaining slots are automatically renumbered (Slot 1, Slot 2, Slot 3...) so there are no gaps.",
    Color = "Blue",
    Image = "",
    ImageSize = 0,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false
})



-- Fly Button in Player Tab
local MobileFlyBtn = player:Button({
    Title = "Mobile Fly GUI",
    Desc = "Open Mobile Fly Controls",
    Locked = false,
    Callback = function()
        -- Prevent multiple GUI instances
        if game.CoreGui:FindFirstChild("TimelessFlyGui") then return end

        local Player = plr
        local RunService = game:GetService("RunService")

        local Character = Player.Character or Player.CharacterAdded:Wait()
        local HRP = Character:WaitForChild("HumanoidRootPart")
        local Humanoid = Character:WaitForChild("Humanoid")

        local flying = false
        local flySpeed = 50
        local flyDirectionY = 0
        local conn

        -- GUI
        local gui = Instance.new("ScreenGui", game.CoreGui)
        gui.Name = "TimelessFlyGui"
        gui.ResetOnSpawn = false

        -- Toggle Button
        local toggleBtn = Instance.new("TextButton", gui)
        toggleBtn.Size = UDim2.new(0, 40, 0, 40)
        toggleBtn.Position = UDim2.new(0, 10, 1, -50)
        toggleBtn.Text = "🔘"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextScaled = true

        -- Main GUI
        local main = Instance.new("Frame", gui)
        main.Size = UDim2.new(0, 300, 0, 210)
        main.Position = UDim2.new(0.35, 0, 0.3, 0)
        main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        main.Active = true
        main.Draggable = true

        -- Watermark
        local wm = Instance.new("TextLabel", main)
        wm.Size = UDim2.new(1, 0, 0, 20)
        wm.Text = "made by timeless"
        wm.Font = Enum.Font.Gotham
        wm.TextColor3 = Color3.new(1, 1, 1)
        wm.TextScaled = true
        wm.BackgroundTransparency = 1

        -- Speed Box
        local speedBox = Instance.new("TextBox", main)
        speedBox.Position = UDim2.new(0.1, 0, 0.2, 0)
        speedBox.Size = UDim2.new(0.8, 0, 0.15, 0)
        speedBox.PlaceholderText = "Enter Fly Speed"
        speedBox.Text = tostring(flySpeed)
        speedBox.TextScaled = true
        speedBox.Font = Enum.Font.Gotham
        speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        speedBox.TextColor3 = Color3.new(1, 1, 1)
        speedBox.ClearTextOnFocus = false

        speedBox.FocusLost:Connect(function()
            local newSpeed = tonumber(speedBox.Text)
            if newSpeed then flySpeed = newSpeed end
        end)

        -- Up Button
        local upBtn = Instance.new("TextButton", main)
        upBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
        upBtn.Size = UDim2.new(0.35, 0, 0.15, 0)
        upBtn.Text = "⬆️ Up"
        upBtn.Font = Enum.Font.GothamBold
        upBtn.TextScaled = true
        upBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        upBtn.TextColor3 = Color3.new(1, 1, 1)

        -- Down Button
        local downBtn = Instance.new("TextButton", main)
        downBtn.Position = UDim2.new(0.55, 0, 0.4, 0)
        downBtn.Size = UDim2.new(0.35, 0, 0.15, 0)
        downBtn.Text = "⬇️ Down"
        downBtn.Font = Enum.Font.GothamBold
        downBtn.TextScaled = true
        downBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        downBtn.TextColor3 = Color3.new(1, 1, 1)

        -- Fly Toggle Button
        local flyBtn = Instance.new("TextButton", main)
        flyBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
        flyBtn.Size = UDim2.new(0.8, 0, 0.2, 0)
        flyBtn.Text = "🚀 Fly"
        flyBtn.Font = Enum.Font.GothamBold
        flyBtn.TextScaled = true
        flyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        flyBtn.TextColor3 = Color3.new(1, 1, 1)

        -- Fly logic
        local function startFly()
            flying = true
            conn = RunService.RenderStepped:Connect(function()
                if HRP and Humanoid then
                    local move = Humanoid.MoveDirection
                    local total = Vector3.new(move.X, flyDirectionY, move.Z)
                    if total.Magnitude > 0 then
                        HRP.Velocity = total.Unit * flySpeed
                    else
                        HRP.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        end

        local function stopFly()
            flying = false
            if conn then conn:Disconnect() end
            if HRP then HRP.Velocity = Vector3.zero end
        end

        -- Toggle Fly
        flyBtn.MouseButton1Click:Connect(function()
            if flying then
                stopFly()
                flyBtn.Text = "🚀 Fly"
            else
                startFly()
                flyBtn.Text = "🛑 Stop Fly"
            end
        end)

        -- Up/Down Buttons
        upBtn.MouseButton1Click:Connect(function()
            flyDirectionY = 1
            wait(0.3)
            flyDirectionY = 0
        end)

        downBtn.MouseButton1Click:Connect(function()
            flyDirectionY = -1
            wait(0.3)
            flyDirectionY = 0
        end)

local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
local spinning = false
local gyro

RunService.RenderStepped:Connect(function(delta)
    if flying and hrp then
        if not spinning then
            spinning = true
            gyro = Instance.new("BodyGyro", hrp)
            gyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        end
        local angle = tick() * math.rad(180)
        gyro.CFrame = CFrame.Angles(angle, angle, angle)
    elseif spinning then
        spinning = false
        if gyro then
            gyro:Destroy()
        end
    end
end)
            
        -- Show/Hide GUI
        toggleBtn.MouseButton1Click:Connect(function()
            main.Visible = not main.Visible
        end)
    end
})

-- Infinite Jump Toggle
local infJumpActive = false
player:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump infinitely while on",
    Default = false,
    Callback = function(state)
        infJumpActive = state
    end
})

-- Listen for jump
UserInputService.JumpRequest:Connect(function()
    if infJumpActive then
        local char = plr.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip Toggle
local noclipActive = false
player:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls while on",
    Default = false,
    Callback = function(state)
        noclipActive = state
    end
})

-- RunService loop for noclip
RunService.Stepped:Connect(function()
    if noclipActive then
        local char = plr.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)


local hum

local function hookHumanoid(char)
    hum = char:WaitForChild("Humanoid")
end

plr.CharacterAdded:Connect(hookHumanoid)
if plr.Character then hookHumanoid(plr.Character) end

local speedValue = 70
local jumpValue = 50

local SpeedSlider = player:Slider({
    Title = "Speed",
    Step = 1,
    Value = {Min = 20, Max = 120, Default = speedValue},
    Callback = function(val)
        speedValue = val
    end
})

local JumpSlider = player:Slider({
    Title = "JumpPower",
    Step = 1,
    Value = {Min = 20, Max = 200, Default = jumpValue},
    Callback = function(val)
        jumpValue = val
    end
})

RunService.RenderStepped:Connect(function()
    if hum then
        hum.WalkSpeed = speedValue
        if hum then
    if hum.UseJumpPower ~= nil and hum.UseJumpPower == true then
        hum.JumpPower = jumpValue
    else
        hum.JumpHeight = jumpValue / 3.57
    end
end

    end
    
end)
