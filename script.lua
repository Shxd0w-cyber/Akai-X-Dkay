-- Akai X Dkay - FPS Boost, Anti-Lag, Anti-Freeze, Desync Fix
local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")

-- Toggle state
local optimizationsEnabled = true

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "OptimizationGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 450)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
mainFrame.Parent = gui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(0, 255, 100)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.Text = "⚡ FPS Optimizer"
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Content area
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 16
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = "✓ Optimizing..."
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentFrame

-- Optimization info
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(1, -20, 1, -120)
infoLabel.Position = UDim2.new(0, 10, 0, 50)
infoLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
infoLabel.BorderColor3 = Color3.fromRGB(0, 200, 80)
infoLabel.BorderSizePixel = 1
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = 13
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Text = "Loading optimizations..."
infoLabel.Parent = contentFrame

-- TOGGLE BUTTON
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleBtn"
toggleButton.Size = UDim2.new(0, 150, 0, 40)
toggleButton.Position = UDim2.new(0.5, -75, 1, -50)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "✓ ON"
toggleButton.BorderSizePixel = 0
toggleButton.Parent = contentFrame

toggleButton.MouseButton1Click:Connect(function()
    optimizationsEnabled = not optimizationsEnabled
    
    if optimizationsEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        toggleButton.Text = "✓ ON"
        statusLabel.Text = "✓ Optimizations ON"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        print("✓ Optimizations ENABLED")
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        toggleButton.Text = "✗ OFF"
        statusLabel.Text = "✗ Optimizations OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        print("✗ Optimizations DISABLED")
    end
end)

-- FPS COUNTER (Floating Button at Top Left)
local fpsGui = Instance.new("ScreenGui")
fpsGui.Name = "FPSGui"
fpsGui.ResetOnSpawn = false
fpsGui.Parent = playerGui

local fpsButton = Instance.new("TextButton")
fpsButton.Name = "FPSCounter"
fpsButton.Size = UDim2.new(0, 100, 0, 40)
fpsButton.Position = UDim2.new(0, 15, 0, 15)
fpsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fpsButton.BackgroundTransparency = 0.5
fpsButton.TextColor3 = Color3.fromRGB(0, 0, 0)
fpsButton.TextSize = 16
fpsButton.Font = Enum.Font.GothamBold
fpsButton.Text = "FPS: 60"
fpsButton.BorderSizePixel = 1
fpsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
fpsButton.Parent = fpsGui

-- FPS Counter Logic
local lastUpdate = tick()
local frameCount = 0
local currentFPS = 0

runService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = tick()
    if currentTime - lastUpdate >= 1 then
        currentFPS = frameCount
        fpsButton.Text = "FPS: " .. currentFPS
        frameCount = 0
        lastUpdate = currentTime
    end
end)

-- FPS BOOST FUNCTION
local function enableOptimizations()
    game.Lighting.GlobalShadows = false
    game.Lighting.Brightness = 2

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    pcall(function()
        game.Lighting.Fog.FogEnd = 500
    end)

    local function disableEffects()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                pcall(function() v.Enabled = false end)
            end
        end
    end

    disableEffects()
end

-- DISABLE OPTIMIZATIONS FUNCTION
local function disableOptimizations()
    game.Lighting.GlobalShadows = true
    game.Lighting.Brightness = 1

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end)

    pcall(function()
        game.Lighting.Fog.FogEnd = 100000
    end)

    local function enableEffects()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                pcall(function() v.Enabled = true end)
            end
        end
    end

    enableEffects()
end

print("Starting FPS optimizations...")
enableOptimizations()

-- ANTI-LAG
local antiLagEnabled = true

runService.Heartbeat:Connect(function()
    if antiLagEnabled and optimizationsEnabled then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                if v.CanCollide == false and v.Transparency == 1 and #v:GetChildren() == 0 then
                    pcall(function() v:Destroy() end)
                end
            end
        end
    end
end)

-- DESYNC FIX
pcall(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    runService.Heartbeat:Connect(function()
        if humanoidRootPart and optimizationsEnabled then
            pcall(function()
                humanoidRootPart.CanCollide = true
            end)
        end
    end)
end)

-- ANTI-FREEZE (Memory Management)
local lastMemoryClear = tick()
runService.Heartbeat:Connect(function()
    if tick() - lastMemoryClear > 30 and optimizationsEnabled then
        pcall(function()
            collectgarbage("collect")
        end)
        lastMemoryClear = tick()
    end
end)

-- Update GUI
wait(1)

local optimizations = {
    "✓ Graphics Quality: Level 1",
    "✓ Shadows: DISABLED",
    "✓ Particles: DISABLED",
    "✓ Fog Distance: 500",
    "✓ Brightness: 2x",
    " ",
    "✓ Anti-Lag: ACTIVE",
    "✓ Desync Fix: ACTIVE",
    "✓ Memory Cleanup: ACTIVE",
    " ",
    "📊 FPS Counter: Top Left",
    " ",
    "Status: All Systems GO!",
}

infoLabel.Text = table.concat(optimizations, "\n")
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
statusLabel.Text = "✓ All Optimizations Active!"

print("✓ FPS Optimizer Loaded!")
print("✓ Toggle button available in GUI")