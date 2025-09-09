local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JoinServerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 10)

local copyBtn = Instance.new("TextButton")
copyBtn.Parent = frame
copyBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
copyBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
copyBtn.Text = "Copy JobId"
copyBtn.TextScaled = true
copyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 250)
copyBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)

local textBox = Instance.new("TextBox")
textBox.Parent = frame
textBox.Size = UDim2.new(0.9, 0, 0.25, 0)
textBox.Position = UDim2.new(0.05, 0, 0.3, 0)
textBox.PlaceholderText = "Paste JobId here..."
textBox.TextScaled = true
textBox.ClearTextOnFocus = false
textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
textBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 8)

local joinBtn = Instance.new("TextButton")
joinBtn.Parent = frame
joinBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
joinBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
joinBtn.Text = "Join Server"
joinBtn.TextScaled = true
joinBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 120)
joinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 8)

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = frame
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -28, 0, 4)
minimizeBtn.Text = "-"
minimizeBtn.TextScaled = true
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local minimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        frame.Size = UDim2.new(0, 250, 0, 150)
        minimized = false
        minimizeBtn.Text = "-"
    else
        frame.Size = UDim2.new(0, 100, 0, 40)
        minimized = true
        minimizeBtn.Text = "+"
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    local jobId = game.JobId
    if setclipboard then
        setclipboard(jobId)
    elseif writeclipboard then
        writeclipboard(jobId)
    end
    game.StarterGui:SetCore("SendNotification", {
        Title = "JobId Copied",
        Text = "Send this script to your friend and let him give you the JobId. Paste it in the box.",
        Duration = 8
    })
end)

joinBtn.MouseButton1Click:Connect(function()
    local jobId = textBox.Text
    if jobId and jobId ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
    end
end)
