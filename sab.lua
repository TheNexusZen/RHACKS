local sab = 109983668079237
local AkaliNotif = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))()
local Notify = AkaliNotif.Notify
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

if game.PlaceId == sab then
    print("in sab executing script now")
    local Window = Rayfield:CreateWindow({
        Name = "Brainrot Hub",
        LoadingTitle = "Brainrot Hub",
        LoadingSubtitle = "Made for u",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "BrainrotHub",
            FileName = "HubConfig"
        }
    })

    local PlayerTab = Window:CreateTab("Main", 4483362458)

    ----------------------------------------------------
    -- AUTO KICK
    ----------------------------------------------------
    PlayerTab:CreateToggle({
        Name = "Auto Kick (Steals)",
        CurrentValue = false,
        Flag = "AutoKickToggle",
        Callback = function(Value)
            if Value then
                -- Already connected once—no need to reconnect each toggle
            end
        end
    })

    -- Single connection to avoid bounce
    LocalPlayer:GetAttributeChangedSignal("Steals"):Connect(function()
        local s = LocalPlayer:GetAttribute("Steals")
        if s and s > 0 then
            LocalPlayer:Kick("You Have Stolen Something!")
        end
    end)

    ----------------------------------------------------
    -- AUTO SHOOT (Lazer Cape)
    ----------------------------------------------------
    local AutoShootEnabled = false
    local AutoShootButton, ShootConn
    local AutoShootButtonPos = UDim2.new(0.5, -50, 0.8, 0)
    local ShootingLoop = false

    PlayerTab:CreateToggle({
        Name = "Auto Shoot",
        CurrentValue = false,
        Flag = "AutoShootToggle",
        Callback = function(Value)
            AutoShootEnabled = Value
            if Value then
                -- create button
                AutoShootButton = Instance.new("TextButton")
                AutoShootButton.Size = UDim2.new(0, 140, 0, 50)
                AutoShootButton.Position = AutoShootButtonPos
                AutoShootButton.Text = "Auto Shoot: OFF"
                AutoShootButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                AutoShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                AutoShootButton.Active = true
                AutoShootButton.Draggable = true
                AutoShootButton.Parent = game.CoreGui

                AutoShootButton:GetPropertyChangedSignal("Position"):Connect(function()
                    AutoShootButtonPos = AutoShootButton.Position
                end)

                AutoShootButton.MouseButton1Click:Connect(function()
                    ShootingLoop = not ShootingLoop
                    if ShootingLoop then
                        AutoShootButton.Text = "Auto Shoot: ON"
                        AutoShootButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

                        ShootConn = RunService.RenderStepped:Connect(function()
                            if not ShootingLoop or not AutoShootEnabled then return end
                            local nearest, dist = nil, 35
                            for _, plr in ipairs(Players:GetPlayers()) do
                                if plr ~= LocalPlayer
                                   and plr.Character
                                   and plr.Character:FindFirstChild("HumanoidRootPart")
                                   and not LocalPlayer:IsFriendsWith(plr.UserId)
                                then
                                    local mag = (plr.Character.HumanoidRootPart.Position -
                                                LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                    if mag <= dist then
                                        dist = mag
                                        nearest = plr
                                    end
                                end
                            end

                            if nearest and nearest.Character and
                               nearest.Character:FindFirstChild("HumanoidRootPart")
                            then
                                local tool = LocalPlayer.Backpack:FindFirstChild("Lazer Cape") or
                                             LocalPlayer.Character:FindFirstChild("Lazer Cape")
                                if tool then
                                    if tool.Parent == LocalPlayer.Backpack then
                                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                                    end
                                    if tool:FindFirstChild("Activate") then
                                        tool:Activate()
                                    elseif tool:FindFirstChild("RemoteEvent") then
                                        tool.RemoteEvent:FireServer(
                                            nearest.Character.HumanoidRootPart.Position,
                                            nearest.Character.HumanoidRootPart)
                                    end
                                end
                            end
                        end)
                    else
                        AutoShootButton.Text = "Auto Shoot: OFF"
                        AutoShootButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                        if ShootConn then ShootConn:Disconnect() ShootConn = nil end
                    end
                end)
            else
                if AutoShootButton then
                    AutoShootButtonPos = AutoShootButton.Position
                    AutoShootButton:Destroy()
                    AutoShootButton = nil
                end
                ShootingLoop = false
                if ShootConn then ShootConn:Disconnect() ShootConn = nil end
            end
        end
    })

    ----------------------------------------------------
    -- AIMBOT (Web Sling)
    ----------------------------------------------------
    local AimbotReady = true
    PlayerTab:CreateToggle({
        Name = "Aimbot (Web Sling)",
        CurrentValue = false,
        Flag = "AimbotToggle",
        Callback = function(Value)
            if Value then
                UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe then return end
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and AimbotReady then
                        AimbotReady = false
                        local nearest, dist = nil, 60
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character and
                               plr.Character:FindFirstChild("HumanoidRootPart")
                            then
                                local mag = (plr.Character.HumanoidRootPart.Position -
                                            LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                if mag <= dist then
                                    dist = mag
                                    nearest = plr
                                end
                            end
                        end
                        if nearest then
                            local tool = LocalPlayer.Backpack:FindFirstChild("Web Sling") or
                                         LocalPlayer.Character:FindFirstChild("Web Sling")
                            if tool then
                                LocalPlayer.Character.Humanoid:EquipTool(tool)
                                tool:Activate()
                            end
                        end
                        task.delay(11, function() AimbotReady = true end)
                    end
                end)
            end
        end
    })

    ----------------------------------------------------
    -- ESP (Highlights + NameTags)
    ----------------------------------------------------
    PlayerTab:CreateToggle({
        Name = "ESP",
        CurrentValue = false,
        Flag = "ESPToggle",
        Callback = function(Value)
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local highlight = plr.Character:FindFirstChild("BrainrotESP")
                    if highlight then highlight:Destroy() end
                    if Value then
                        local h = Instance.new("Highlight")
                        h.Name = "BrainrotESP"
                        if LocalPlayer:IsFriendsWith(plr.UserId) then
                            h.FillColor = Color3.fromRGB(0, 0, 255)
                            h.OutlineColor = Color3.fromRGB(0, 255, 0)
                        else
                            h.FillColor = Color3.fromRGB(0, 255, 0)
                            h.OutlineColor = Color3.fromRGB(255, 0, 0)
                        end
                        h.Parent = plr.Character

                        local billboard = Instance.new("BillboardGui")
                        billboard.Size = UDim2.new(0, 100, 0, 20)
                        billboard.Adornee = plr.Character:FindFirstChild("Head")
                        billboard.AlwaysOnTop = true
                        billboard.Parent = plr.Character

                        local nameLabel = Instance.new("TextLabel", billboard)
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = plr.Name
                        nameLabel.TextColor3 = LocalPlayer:IsFriendsWith(plr.UserId) and
                                               Color3.fromRGB(0, 255, 0) or
                                               Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        end
    })

    ----------------------------------------------------
    -- JumpPower + Infinity Jump
    ----------------------------------------------------
    PlayerTab:CreateSlider({
        Name = "Jump Power",
        Range = {0, 80},
        Increment = 1,
        CurrentValue = 50,
        Flag = "JumpPowerSlider",
        Callback = function(Value)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                hum.UseJumpPower = true
                hum.JumpPower = Value
            end
        end
    })

    PlayerTab:CreateToggle({
        Name = "Infinity Jump",
        CurrentValue = false,
        Flag = "InfJumpToggle",
        Callback = function(Value)
            if Value then
                UserInputService.JumpRequest:Connect(function()
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.JumpPower = 80
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        end
    })

    ----------------------------------------------------
    -- Anti AFK Grapple Speed (placeholder)
    ----------------------------------------------------
    PlayerTab:CreateButton({
        Name = "Load Anti AFK Grapple Speed",
        Callback = function()
            loadstring(game:HttpGet("PUT_YOUR_LOADSTRING_URL_HERE"))()
        end
    })

    ----------------------------------------------------
    -- Fly Part System
    ----------------------------------------------------
    local FlyPart = nil
    PlayerTab:CreateToggle({
        Name = "Fly Part",
        CurrentValue = false,
        Flag = "FlyPartToggle",
        Callback = function(Value)
            if Value then
                local FlyButton = Instance.new("TextButton")
                FlyButton.Size = UDim2.new(0, 140, 0, 50)
                FlyButton.Position = UDim2.new(0.5, -50, 0.7, 0)
                FlyButton.Text = "Fly OFF"
                FlyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                FlyButton.Draggable = true
                FlyButton.Parent = game.CoreGui

                FlyButton.MouseButton1Click:Connect(function()
                    if FlyPart then
                        FlyPart:Destroy()
                        FlyPart = nil
                        FlyButton.Text = "Fly OFF"
                        FlyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                    else
                        FlyPart = Instance.new("Part")
                        FlyPart.Size = Vector3.new(5, 1, 5)
                        FlyPart.Anchored = true
                        FlyPart.CanCollide = true
                        FlyPart.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
                        FlyPart.Parent = workspace
                        FlyButton.Text = "Fly ON"
                        FlyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

                        RunService.RenderStepped:Connect(function()
                            if FlyPart then
                                FlyPart.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
                            end
                        end)
                    end
                end)
            else
                if FlyPart then
                    FlyPart:Destroy()
                    FlyPart = nil
                end
            end
        end
    })

    ----------------------------------------------------
    -- Tic Tac Toe Game
    ----------------------------------------------------
    PlayerTab:CreateButton({
        Name = "Open Tic Tac Toe",
        Callback = function()
            local gui = Instance.new("ScreenGui", game.CoreGui)
            gui.Name = "TicTacToe"
            local frame = Instance.new("Frame", gui)
            frame.Size = UDim2.new(0, 300, 0, 300)
            frame.Position = UDim2.new(0.5, -150, 0.5, -150)
            frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

            local turn, board = "X", {}
            local function checkWin()
                local wins = {
                    {1,2,3},{4,5,6},{7,8,9},
                    {1,4,7},{2,5,8},{3,6,9},
                    {1,5,9},{3,5,7}
                }
                for _, combo in ipairs(wins) do
                    if board[combo[1]] and board[combo[1]] == board[combo[2]] and
                       board[combo[2]] == board[combo[3]] then
                        return true
                    end
                end
                return false
            end

            for i = 1, 9 do
                local b = Instance.new("TextButton", frame)
                b.Size = UDim2.new(0, 100, 0, 100)
                b.Position = UDim2.new(0, ((i-1)%3)*100, 0, math.floor((i-1)/3)*100)
                b.Text = ""
                b.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

                b.MouseButton1Click:Connect(function()
                    if b.Text == "" then
                        b.Text = turn
                        board[i] = turn
                        if checkWin() then
                            frame.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                        else
                            turn = (turn == "X") and "O" or "X"
                        end
                    end
                end)
            end
        end
    })

    Notify({
        Description = "Successfully Loaded! Place Id:" .. sab,
        Title = "Loadstring Loaded",
        Duration = 5
    })
else
    print("not in sab")
    Notify({
        Description = "You Aren't In Steal A Brainrot Or In The New Player Servers",
        Title = "Failed To Load | ErrorCode: 400",
        Duration = 5
    })
end
