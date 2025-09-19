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
    Author = "by NexueZen A Solo Dev Guy",
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

local Player = Window:Tab({
    Title = "Player",
    Icon = "user",
    Locked = false,
})

local Teleport = Window:Tab({
    Title = "Teleport",
    Icon = "map-pinned",
    Locked = false,
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

local TeleportDown = Teleport:Dropdown({
    Title = "Players",
    Values = getPlayerList(),
    Value = "",
    Callback = function(option)
        selectedTarget = option
    end
})

local RefreshBtn = Teleport:Button({
    Title = "Refresh List",
    Desc = "Update player dropdown",
    Locked = false,
    Callback = function()
        TeleportDown:Refresh(getPlayerList())
    end
})

local TpBtn = Teleport:Button({
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

local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro

local FlyButton = Player:Toggle({
    Title = "Fly",
    Desc = "Toggle Fly",
    Default = false,
    Callback = function(state)
        flying = state
        local char = plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        if flying then
            hum.PlatformStand = true
            bodyVelocity = Instance.new("BodyVelocity", hrp)
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)

            bodyGyro = Instance.new("BodyGyro", hrp)
            bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bodyGyro.CFrame = hrp.CFrame

            WindUI:Notify({
                Title = "Fly",
                Content = "Fly Enabled ✅",
                Duration = 3,
                Icon = "bird",
            })
        else
            hum.PlatformStand = false
            if bodyVelocity then bodyVelocity:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end

            WindUI:Notify({
                Title = "Fly",
                Content = "Fly Disabled ❌",
                Duration = 3,
                Icon = "bird",
            })
        end
    end
})

local function getMoveVector()
    local moveVec = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + workspace.CurrentCamera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - workspace.CurrentCamera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - workspace.CurrentCamera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + workspace.CurrentCamera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec - Vector3.new(0, 1, 0) end
    return moveVec.Unit * flySpeed
end

RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity then
        bodyVelocity.Velocity = getMoveVector()
        if bodyGyro then
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end
    end
end)


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


local InfJump = Player:Button({
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

local SpeedSlider = Player:Slider({
    Title = "Speed",
    Step = 1,
    Value = {Min = 20, Max = 120, Default = speedValue},
    Callback = function(val)
        speedValue = val
    end
})

local JumpSlider = Player:Slider({
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

