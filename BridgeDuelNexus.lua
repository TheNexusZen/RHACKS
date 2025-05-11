-- Nexus Exclusive GUI (Bridge Duel Edition) 💀🔥
local NexusGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local toggles = {}
local features = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- GUI Setup
NexusGui.Name = "NexusBridgeGUI"
NexusGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

Main.Name = "Main"
Main.Parent = NexusGui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Position = UDim2.new(0, 20, 0.5, -200)
Main.Size = UDim2.new(0, 220, 0, 400)
Main.Active = true
Main.Draggable = true

UIListLayout.Parent = Main
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createToggle(name, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Text = "[ OFF ] " .. name
    toggle.Parent = Main

    local on = false
    toggle.MouseButton1Click:Connect(function()
        on = not on
        toggle.Text = (on and "[ ON  ] " or "[ OFF ] ") .. name
        callback(on)
    end)
end

-- 1. God Mode (Set health to 100)
createToggle("God Mode", function(state)
    toggles.god = state
end)
RunService.Heartbeat:Connect(function()
    if toggles.god and Humanoid.Health < 100 then
        Humanoid.Health = 100
    end
end)

-- 2. Kill Aura
createToggle("Kill Aura", function(state)
    toggles.killaura = state
end)
RunService.Heartbeat:Connect(function()
    if toggles.killaura then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                local target = plr.Character:FindFirstChild("HumanoidRootPart")
                if target and (target.Position - HRP.Position).Magnitude < 15 then
                    firetouchinterest(HRP, target, 0)
                    firetouchinterest(HRP, target, 1)
                end
            end
        end
    end
end)

-- 3. Auto Jump Reset (clutch save)
createToggle("Auto Jump Reset", function(state)
    toggles.autojump = state
end)
RunService.Heartbeat:Connect(function()
    if toggles.autojump and HRP.Position.Y < -5 then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 4. Void Save (TP to safe spot if falling)
createToggle("Void Save", function(state)
    toggles.voidsave = state
end)
RunService.Heartbeat:Connect(function()
    if toggles.voidsave and HRP.Position.Y < -25 then
        HRP.CFrame = CFrame.new(0, 50, 0)
    end
end)

-- 5. Auto Bridge (hold B to place blocks)
createToggle("Auto Bridge", function(state)
    toggles.bridge = state
end)
RunService.Heartbeat:Connect(function()
    if toggles.bridge and UserInputService:IsKeyDown(Enum.KeyCode.B) then
        -- fake: simulate block placement (depends on the game)
        -- in real game you'd fire a remote or trigger tool event
        print("Bridging...")
    end
end)

-- 6. Speed Boost
createToggle("Speed Boost", function(state)
    Humanoid.WalkSpeed = state and 100 or 16
end)

-- 7. Noclip Walls
createToggle("No Clip", function(state)
    toggles.noclip = state
end)
RunService.Stepped:Connect(function()
    if toggles.noclip then
        Humanoid:ChangeState(11)
    end
end)

-- 8. Anti Knockback
createToggle("Anti Knockback", function(state)
    toggles.antikb = state
end)
RunService.Heartbeat:Connect(function()
    if toggles.antikb then
        HRP.Velocity = Vector3.new(0, 0, 0)
    end
end)

-- 9. Enemy ESP
createToggle("Enemy ESP", function(state)
    if state then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and not hrp:FindFirstChild("NexusESP") then
                    local box = Instance.new("BoxHandleAdornment", hrp)
                    box.Name = "NexusESP"
                    box.Size = Vector3.new(4, 6, 2)
                    box.Color3 = Color3.fromRGB(255, 0, 0)
                    box.Transparency = 0.5
                    box.AlwaysOnTop = true
                    box.Adornee = hrp
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local adorn = p.Character.HumanoidRootPart:FindFirstChild("NexusESP")
                if adorn then adorn:Destroy() end
            end
        end
    end
end)

-- 10. Delete GUI
createToggle("Delete GUI", function(state)
    if state then
        NexusGui:Destroy()
    end
end)
