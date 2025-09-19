local Version = "1.6.41"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
            },                                                      
        },                                                          
    },                                                              
})

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

local playerConnections = {}
local friendsCheck = {}
local highlightToggleActive = false

VisualsTab:Toggle({
    Title = "Player Highlights",
    Desc = "Highlights all players with name tags",
    Default = false,
    Callback = function(state)
        highlightToggleActive = state

        local function applyHighlight(pl)
            if pl == plr then return end
            local char = pl.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            if char:FindFirstChild("PlayerHL") then return end

            -- Highlight
            local hl = Instance.new("Highlight")
            hl.Name = "PlayerHL"
            hl.Parent = char
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 1
            hl.FillColor = plr:IsFriendsWith(pl.UserId) and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)

            -- BillboardGui
            local bill = Instance.new("BillboardGui")
            bill.Name = "PlayerTag"
            bill.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            bill.Size = UDim2.new(0,120,0,40)
            bill.StudsOffset = Vector3.new(0,3,0)
            bill.AlwaysOnTop = true
            bill.Parent = char

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1,0,1,0)
            frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
            frame.BackgroundTransparency = 0.5
            frame.Parent = bill

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,6)
            corner.Parent = frame

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1,0,1,0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.new(1,1,1)
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.Text = "👤 "..pl.Name
            nameLabel.Parent = frame

            -- Friend color check
            friendsCheck[pl] = RunService.RenderStepped:Connect(function()
                if hl and highlightToggleActive then
                    hl.FillColor = plr:IsFriendsWith(pl.UserId) and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
                end
            end)
        end

        local function removeHighlight(pl)
            if pl.Character then
                local hl = pl.Character:FindFirstChild("PlayerHL")
                if hl then hl:Destroy() end
                local bill = pl.Character:FindFirstChild("PlayerTag")
                if bill then bill:Destroy() end
            end
            if friendsCheck[pl] then
                friendsCheck[pl]:Disconnect()
                friendsCheck[pl] = nil
            end
        end

        if state then
            for _, pl in pairs(Players:GetPlayers()) do
                applyHighlight(pl)
            end

            playerConnections.joinConn = Players.PlayerAdded:Connect(applyHighlight)
            playerConnections.leaveConn = Players.PlayerRemoving:Connect(removeHighlight)
        else
            for _, pl in pairs(Players:GetPlayers()) do
                removeHighlight(pl)
            end

            if playerConnections.joinConn then playerConnections.joinConn:Disconnect() end
            if playerConnections.leaveConn then playerConnections.leaveConn:Disconnect() end
            playerConnections = {}
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

        -- Show/Hide GUI
        toggleBtn.MouseButton1Click:Connect(function()
            main.Visible = not main.Visible
        end)
    end
})



local noclip = false

local Noclip = Player:Button({
    Title = "Noclip",
    Desc = "Walk thru walls ez",
    Locked = false,
    Callback = function()
        noclip = not noclip
            print("Noclip:", noclip)
    end
})

RunService.Stepped:Connect(function()
    if noclip then
        local plr = game.Players.LocalPlayer
        local char = plr.Character
        if char then
            for _,part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)


local InfJump = player:Button({
    Title = "Infinite Jump",
    Desc = "When Pressed You Can Jump Infinitly!",
    Locked = false,
    Callback = function()
        UserInputService.JumpRequest:Connect(function()
            local plr = game.Players.LocalPlayer
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
})

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

