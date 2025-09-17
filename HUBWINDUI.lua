local Version = "1.6.41"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()
local Players = game:GetService("Players")
local Plr = Players.LocalPlayer

local allowed = {"Seventeenlovesyouw","NexusMejorPlays21","Cusaak2"}
if table.find(allowed, plr.Name) then
    WindUI:Notify({
    Title = "Passed!",
    Content = "Hey Your The Owner You Have Acess To Everything",
    Duration = 3, -- 3 seconds
    Icon = "door-open",
})
else
    plr:kick("Player Is Not The Owner Script Is Still In Beta Please Wait For Full Release")
end


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
            print("clicked")
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
    Duration = 3, -- 3 seconds
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

local Tab = Window:Tab({
    Title = "Player",
    Icon = "user",
    Locked = false,
})
