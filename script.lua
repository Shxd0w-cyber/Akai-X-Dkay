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
mainFrame.Size = UDim2.new(0, 600, 0, 500)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
mainFrame.Parent = gui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(0, 255, 100)
titleText.TextSize = 20
titleText.Font = Enum.Font.GothamBold
titleText.Text = "⚡ FPS Optimizer"
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 50, 0, 50)
closeBtn.Position = UDim2.new(1, -50, 0, 0)
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
contentFrame.Size = UDim2.new(1, 0, 1, -50)
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Create toggle switch function
local function createToggleSwitch(parent, name, key, yPosition)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -40, 0, 50)
    container.Position = UDim2.new(0, 20, 0, yPosition)
    container.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    container.BorderColor3 = Color3.fromRGB(60, 60, 70)
    container.BorderSizePixel = 1
    container.Parent = parent
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = name .. "Label"
    label.Size = UDim2.new(0, 300, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Toggle Background
    local toggleBg = Instance.new("Frame")
    toggleBg.Name = name .. "BG"
    toggleBg.Size = UDim2.new(0, 60, 0, 30)
    toggleBg.Position = UDim2.new(1, -90, 0.5, -15)
    toggleBg.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = container
    
    -- Toggle Circle (Knob)
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = name .. "Circle"
    toggleCircle.Size = UDim2.new(0, 26, 0, 26)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -13)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleBg
    
    -- Toggle Button (invisible clickable area)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = name .. "Toggle"
    toggleBtn.Size = UDim2.new(0, 60, 0, 30)
    toggleBtn.Position = UDim2.new(1, -90, 0.5, -15)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.TextTransparency = 1
    toggleBtn.Parent = container
    
    -- Toggle function
    local function updateToggle()
        if toggleStates[key] then
            toggleBg.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            toggleCircle:TweenPosition(UDim2.new(0, 32, 0.5, -13), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        else
            toggleBg.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            toggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, -13), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        toggleStates[key] = not toggleStates[key]
        updateToggle()
        
        if toggleStates[key] then
            print("✓ " .. name .. " ENABLED")
        else
            print("✗ " .. name .. " DISABLED")
        end
    end)
    
    return toggleBg, toggleCircle
end

-- Create toggle items
local graphicsToggle = createToggleSwitch(contentFrame, "Graphics Optimization", "graphics", 10)
local particlesToggle = createToggleSwitch(contentFrame, "Disable Particles", "particles", 70)
local antiLagToggle = createToggleSwitch(contentFrame, "Anti-Lag", "antiLag", 130)
local desyncToggle = createToggleSwitch(contentFrame, "Desync Fix", "desyncFix", 190)
local memoryToggle = createToggleSwitch(contentFrame, "Memory Cleanup", "memoryCleanup", 250)

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
print("✓ Toggle switches available")
print("✓ FPS Counter at top left")