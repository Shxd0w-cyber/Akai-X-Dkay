-- Akai X Dkay - FPS Boost, Anti-Lag, Anti-Freeze, Desync Fix
local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")

-- Individual toggle states
local toggleStates = {
    graphics = true,
    particles = true,
    antiLag = true,
    desyncFix = true,
    memoryCleanup = true,
}

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "OptimizationGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 550, 0, 550)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -275)
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

-- ScrollingFrame for options
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -20, 1, -20)
scrollFrame.Position = UDim2.new(0, 10, 0, 10)
scrollFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
scrollFrame.BorderColor3 = Color3.fromRGB(0, 200, 80)
scrollFrame.BorderSizePixel = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = contentFrame

-- Create toggle items
local function createToggleItem(parent, name, key, yPosition)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -10, 0, 45)
    container.Position = UDim2.new(0, 5, 0, yPosition)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = name .. "Label"
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Toggle Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = name .. "Toggle"
    toggleBtn.Size = UDim2.new(0, 80, 0, 35)
    toggleBtn.Position = UDim2.new(0.6, 5, 0, 5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 13
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Text = "✓ ON"
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = container
    
    -- Toggle function
    toggleBtn.MouseButton1Click:Connect(function()
        toggleStates[key] = not toggleStates[key]
        
        if toggleStates[key] then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            toggleBtn.Text = "✓ ON"
            print("✓ " .. name .. " ENABLED")
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            toggleBtn.Text = "✗ OFF"
            print("✗ " .. name .. " DISABLED")
        end
    end)
    
    return toggleBtn
end

-- Create toggle items
local graphicsToggle = createToggleItem(scrollFrame, "Graphics Optimization", "graphics", 5)
local particlesToggle = createToggleItem(scrollFrame, "Disable Particles", "particles", 55)
local antiLagToggle = createToggleItem(scrollFrame, "Anti-Lag", "antiLag", 105)
local desyncToggle = createToggleItem(scrollFrame, "Desync Fix", "desyncFix", 155)
local memoryToggle = createToggleItem(scrollFrame, "Memory Cleanup", "memoryCleanup", 205)

-- Update scroll size
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 255)

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

-- GRAPHICS OPTIMIZATION FUNCTION
local function applyGraphics()
    if toggleStates.graphics then
        game.Lighting.GlobalShadows = false
        game.Lighting.Brightness = 2
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
            game.Lighting.Fog.FogEnd = 500
        end)
    else
        game.Lighting.GlobalShadows = true
        game.Lighting.Brightness = 1
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)
        pcall(function()
            game.Lighting.Fog.FogEnd = 100000
        end)
    end
end

-- PARTICLES FUNCTION
local function applyParticles()
    local function setParticles(enabled)
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                pcall(function() v.Enabled = enabled end)
            end
        end
    end
    
    if toggleStates.particles then
        setParticles(false)
    else
        setParticles(true)
    end
end

print("Starting FPS Optimizer...")
applyGraphics()
applyParticles()

-- ANTI-LAG
runService.Heartbeat:Connect(function()
    if toggleStates.antiLag then
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
        if humanoidRootPart and toggleStates.desyncFix then
            pcall(function()
                humanoidRootPart.CanCollide = true
            end)
        end
    end)
end)

-- MEMORY CLEANUP
local lastMemoryClear = tick()
runService.Heartbeat:Connect(function()
    if tick() - lastMemoryClear > 30 and toggleStates.memoryCleanup then
        pcall(function()
            collectgarbage("collect")
        end)
        lastMemoryClear = tick()
    end
end)

-- Reapply graphics when toggled
local lastGraphicsState = toggleStates.graphics
runService.Heartbeat:Connect(function()
    if lastGraphicsState ~= toggleStates.graphics then
        applyGraphics()
        lastGraphicsState = toggleStates.graphics
    end
    
    if toggleStates.particles then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                if v.Enabled == true then
                    pcall(function() v.Enabled = false end)
                end
            end
        end
    end
end)

print("✓ FPS Optimizer Loaded!")
print("✓ Individual toggles available")
print("✓ FPS Counter at top left")