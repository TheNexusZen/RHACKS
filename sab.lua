local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "SideHub",
    LoadingTitle = "SideHub Loader",
    LoadingSubtitle = "by sidezen",
    ConfigurationSaving = {Enabled = false}
})

Rayfield:Notify({Title = "SideHub", Content = "Loaded Successfully", Duration = 5})

-- Key system
Rayfield:CreatePrompt({
    Title = "Key System",
    Content = "Enter Key",
    Placeholder = "Key",
    Callback = function(input)
        if input ~= "Kf94h2$!f1!@93HJSJ**921" then
            LocalPlayer:Kick("Invalid Key")
        end
    end
})

local PlayerTab = Window:CreateTab("Player")
local CombatTab = Window:CreateTab("Combat")
local UtilityTab = Window:CreateTab("Utility")

-- Auto Kick
local lastSteals = 0
local function watchSteals()
    local stats = LocalPlayer:WaitForChild("leaderstats", 5)
    if stats and stats:FindFirstChild("Steals") then
        local steals = stats.Steals
        lastSteals = steals.Value
        steals:GetPropertyChangedSignal("Value"):Connect(function()
            if steals.Value > lastSteals then
                LocalPlayer:Kick("You Have Stolen Something!")
            end
            lastSteals = steals.Value
        end)
    end
end
if LocalPlayer:FindFirstChild("leaderstats") then
    watchSteals()
end
LocalPlayer.CharacterAdded:Connect(watchSteals)

-- Jump Power slider
PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {0,80},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JP",
    Callback = function(val)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = val
        end
    end
})

-- Infinity Jump
local infJump = false
PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Callback = function(v) infJump = v end
})
UserInputService.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ESP (Workspace rigs)
local rigs = {}
local function createRigForPlayer(player)
    if rigs[player] then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local rig = Instance.new("Part")
    rig.Size = Vector3.new(2,5,1)
    rig.Anchored = true
    rig.CanCollide = false
    rig.Transparency = 1
    rig.Name = player.Name.."_ESP"
    rig.Parent = workspace
    local hl = Instance.new("Highlight", rig)
    if LocalPlayer:IsFriendsWith(player.UserId) then
        hl.FillColor = Color3.fromRGB(0,0,255)
        hl.OutlineColor = Color3.fromRGB(0,255,0)
    else
        hl.FillColor = Color3.fromRGB(0,255,0)
        hl.OutlineColor = Color3.fromRGB(255,0,0)
    end
    local bb = Instance.new("BillboardGui", rig)
    bb.Size = UDim2.new(0,200,0,50)
    bb.StudsOffset = Vector3.new(0,3,0)
    bb.AlwaysOnTop = true
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = player.Name
    lbl.TextScaled = true
    lbl.TextColor3 = hl.OutlineColor
    rigs[player] = {Rig=rig,HRP=hrp}
end
local function removeRig(player)
    if rigs[player] then
        rigs[player].Rig:Destroy()
        rigs[player]=nil
    end
end
Players.PlayerAdded:Connect(function(p)
    if p~=LocalPlayer then
        p.CharacterAdded:Connect(function() createRigForPlayer(p) end)
    end
end)
Players.PlayerRemoving:Connect(removeRig)
RunService.RenderStepped:Connect(function()
    for pl,data in pairs(rigs) do
        if data.HRP and data.Rig then data.Rig.CFrame=data.HRP.CFrame end
    end
end)
UtilityTab:CreateToggle({Name="ESP",CurrentValue=false,Callback=function(v)
    if v then for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then createRigForPlayer(p) end end
    else for _,data in pairs(rigs) do data.Rig:Destroy() end rigs={} end
end})

-- Fly Part
local flyPart,flyButton,flyConn
UtilityTab:CreateToggle({Name="Fly Part",CurrentValue=false,Callback=function(v)
    if v then
        flyButton=Instance.new("TextButton")
        flyButton.Size=UDim2.new(0,100,0,40)
        flyButton.Position=UDim2.new(0.5,-50,0.7,0)
        flyButton.BackgroundColor3=Color3.fromRGB(0,100,200)
        flyButton.Text="Fly"
        flyButton.TextColor3=Color3.new(1,1,1)
        flyButton.Parent=LocalPlayer:WaitForChild("PlayerGui")
        flyButton.Draggable=true
        local active=false
        flyButton.MouseButton1Click:Connect(function()
            active=not active
            if active then
                flyPart=Instance.new("Part")
                flyPart.Size=Vector3.new(5,1,5)
                flyPart.Anchored=true
                flyPart.Transparency=0.5
                flyPart.Parent=workspace
                flyConn=RunService.RenderStepped:Connect(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        flyPart.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,-3,0)
                    end
                end)
            else
                if flyConn then flyConn:Disconnect() flyConn=nil end
                if flyPart then flyPart:Destroy() flyPart=nil end
            end
        end)
    else
        if flyConn then flyConn:Disconnect() flyConn=nil end
        if flyPart then flyPart:Destroy() flyPart=nil end
        if flyButton then flyButton:Destroy() flyButton=nil end
    end
end})

-- Aimbot (Web Sling)
local aimbot=false
local cd=false
CombatTab:CreateToggle({Name="Aimbot",CurrentValue=false,Callback=function(v) aimbot=v end})
RunService.RenderStepped:Connect(function()
    if aimbot and not cd then
        cd=true
        local nearest,dist=nil,math.huge
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d=(LocalPlayer.Character.HumanoidRootPart.Position-p.Character.HumanoidRootPart.Position).Magnitude
                if d<dist then dist=d nearest=p end
            end
        end
        if nearest then
            local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:EquipTool(LocalPlayer.Backpack:FindFirstChild("Web Sling")) end
            game:GetService("VirtualUser"):ClickButton1(Vector2.new())
        end
        task.delay(11,function() cd=false end)
    end
end)

-- Auto Shoot (Lazer Cape)
local autoShoot=false
CombatTab:CreateToggle({Name="Auto Shoot",CurrentValue=false,Callback=function(v) autoShoot=v end})
RunService.RenderStepped:Connect(function()
    if autoShoot then
        local nearest,dist=nil,35
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d=(LocalPlayer.Character.HumanoidRootPart.Position-p.Character.HumanoidRootPart.Position).Magnitude
                if d<dist then dist=d nearest=p end
            end
        end
        if nearest then
            local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:EquipTool(LocalPlayer.Backpack:FindFirstChild("Lazer Cape")) end
            game:GetService("VirtualUser"):ClickButton1(Vector2.new())
        end
    end
end)

-- Anti Die Button
local btn=Instance.new("TextButton")
btn.Size=UDim2.new(0,100,0,40)
btn.Position=UDim2.new(0.5,-50,0.85,0)
btn.BackgroundColor3=Color3.fromRGB(150,0,0)
btn.Text="Anti Die: OFF"
btn.TextColor3=Color3.new(1,1,1)
btn.Parent=LocalPlayer:WaitForChild("PlayerGui")
btn.Draggable=true
local ad=false conn=nil
btn.MouseButton1Click:Connect(function()
    ad=not ad
    if ad then
        btn.BackgroundColor3=Color3.fromRGB(0,150,0)
        btn.Text="Anti Die: ON"
        conn=RunService.RenderStepped:Connect(function()
            local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health=hum.MaxHealth
                hum.BreakJointsOnDeath=false
                if hum:GetState()==Enum.HumanoidStateType.Dead then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end)
    else
        btn.BackgroundColor3=Color3.fromRGB(150,0,0)
        btn.Text="Anti Die: OFF"
        if conn then conn:Disconnect() conn=nil end
    end
end)
