local Version = "1.6.41"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
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

