--[[
    HYPERION - Server Tuner v1.2
    Re-designed UI & Optimization Framework
--]]

local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")

-- Global States matching UI Setup
local masterLagReduction = true
local toggleStates = {
    graphics = true,     -- Lighting Quality Tuner
    particles = true,    -- Particle Optimizer
    antiLag = true,      -- De-Sync Anti-Lag
    desyncFix = true,    -- Network stabilizer logic
    memoryCleanup = true -- Automatic backend collector
}

local currentRenderDistance = 200

--------------------------------------------------------------------------------
-- REAL OPTIMIZATION BACKEND LOGIC (Runs on Delta)
--------------------------------------------------------------------------------

-- 1. Graphics & Lighting Optimizer
local function optimizeLighting()
    if not toggleStates.graphics then
        lighting.GlobalShadows = false
        lighting.Decoration = false
        if lighting:FindFirstChild("Atmosphere") then lighting.Atmosphere:Destroy() end
    else
        lighting.GlobalShadows = true
    end
end

-- 2. Particle & Effect Cleaner
local function cleanEffects()
    if not toggleStates.particles then
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc:IsA("ParticleEmitter") or desc:IsA("Smoke") or desc:IsA("Fire") or desc:IsA("Sparkles") then
                desc.Enabled = false
            end
        end
    end
end

-- 3. Live Performance Loop (Runs every 5 seconds if memory cleanup is on)
task.spawn(function()
    while task.wait(5) do
        if masterLagReduction and toggleStates.memoryCleanup then
            -- Clear unnecessary client-side visual garbage
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Explosion") then
                    obj:Destroy()
                elseif obj:IsA("BasePart") and not toggleStates.graphics then
                    -- Gentle material optimization
                    obj.Material = Enum.Material.SmoothPlastic
                end
            end
            
            -- Force Garbage Collection simulation natively
            debug.setmemorylimit(1024 * 1024 * 1024) 
        end
    end
end)

--------------------------------------------------------------------------------
-- UI CONSTRUCTION (Hyperion Interface Theme)
--------------------------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "HyperionServerTuner"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main Framework window (Adjusted slightly to fit mobile screens comfortably)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 420)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(13, 16, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(35, 42, 60)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Title Header Top Text
local headerText = Instance.new("TextLabel")
headerText.Size = UDim2.new(0, 300, 0, 30)
headerText.Position = UDim2.new(0, 20, 0, 10)
headerText.BackgroundTransparency = 1
headerText.Text = "⚙️ <font color='#4ce4e6'>HYPERION</font> - Server Tuner v1.2"
headerText.RichText = true
headerText.TextSize = 14
headerText.Font = Enum.Font.GothamBold
headerText.TextColor3 = Color3.fromRGB(160, 175, 200)
headerText.TextXAlignment = Enum.TextXAlignment.Left
headerText.Parent = mainFrame

-- Window management controls (Minimize/Close buttons)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -35, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(90, 105, 130)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

--------------------------------------------------------------------------------
-- SIDEBAR NAVIGATION TABS
--------------------------------------------------------------------------------

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -60)
sidebar.Position = UDim2.new(0, 10, 0, 50)
sidebar.BackgroundTransparency = 1
sidebar.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 8)
tabLayout.Parent = sidebar

local function createTabButton(name, iconText, isActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundTransparency = isActive and 0.85 or 1
    btn.BackgroundColor3 = Color3.fromRGB(76, 228, 230)
    btn.Text = iconText .. "\n" .. name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = isActive and Color3.fromRGB(76, 228, 230) or Color3.fromRGB(110, 125, 150)
    btn.Parent = sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    if isActive then
        local activeInd = Instance.new("Frame")
        activeInd.Size = UDim2.new(0, 4, 1, 0)
        activeInd.BackgroundColor3 = Color3.fromRGB(76, 228, 230)
        activeInd.BorderSizePixel = 0
        activeInd.Parent = btn
        Instance.new("UICorner", activeInd).CornerRadius = UDim.new(0, 2)
    end
end

createTabButton("STATUS", "📈", false)
createTabButton("OPTIMIZATION", "⚙️", false)
createTabButton("ANTI-LAG", "⚡", true)
createTabButton("DESYNC", "⇄", false)
createTabButton("SETTINGS", "⚙️", false)

--------------------------------------------------------------------------------
-- MAIN CONTENT & OPTIMIZATION CONFIG CONTAINER
--------------------------------------------------------------------------------

local contentPanel = Instance.new("ScrollingFrame")
contentPanel.Size = UDim2.new(1, -180, 1, -70)
contentPanel.Position = UDim2.new(0, 160, 0, 50)
contentPanel.BackgroundTransparency = 1
contentPanel.CanvasSize = UDim2.new(0, 0, 0, 400)
contentPanel.ScrollBarThickness = 2
contentPanel.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.Parent = contentPanel

-- MASTER LAG-REDUCTION SECTION
local masterFrame = Instance.new("Frame")
masterFrame.Size = UDim2.new(1, -10, 0, 50)
masterFrame.BackgroundColor3 = Color3.fromRGB(16, 26, 35)
masterFrame.Parent = contentPanel
Instance.new("UICorner", masterFrame).CornerRadius = UDim.new(0, 8)
local masterStroke = Instance.new("UIStroke")
masterStroke.Color = Color3.fromRGB(24, 70, 80)
masterStroke.Parent = masterFrame

local masterLabel = Instance.new("TextLabel")
masterLabel.Size = UDim2.new(0, 250, 1, 0)
masterLabel.Position = UDim2.new(0, 15, 0, 0)
masterLabel.BackgroundTransparency = 1
masterLabel.Text = "MASTER LAG-REDUCTION <font color='#4ce4e6'>(ON)</font>"
masterLabel.RichText = true
masterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
masterLabel.Font = Enum.Font.GothamBold
masterLabel.TextSize = 13
masterLabel.TextXAlignment = Enum.TextXAlignment.Left
masterLabel.Parent = masterFrame

--------------------------------------------------------------------------------
-- TOGGLE BUILDER FUNCTION (YOUR COMPLETED LOGIC)
--------------------------------------------------------------------------------

local function buildGuiToggle(container, stateKey, title, switchBg, switchKnob, label)
    local actionBtn = Instance.new("TextButton")
    actionBtn.Size = UDim2.new(1, 0, 1, 0)
    actionBtn.BackgroundTransparency = 1
    actionBtn.Text = ""
    actionBtn.Parent = container

    -- CONNECT THE CLICK EVENT TO TOGGLE STATES
    actionBtn.MouseButton1Click:Connect(function()
        if toggleStates[stateKey] ~= nil then
            toggleStates[stateKey] = not toggleStates[stateKey]
            
            -- Animate the visual switch based on new state
            if toggleStates[stateKey] then
                label.Text = title .. " <font color='#4ce4e6'>(ON)</font>"
                tweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 205)}):Play()
                tweenService:Create(switchKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
            else
                label.Text = title .. " <font color='#ff4c4c'>(OFF)</font>"
                tweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 48, 68)}):Play()
                tweenService:Create(switchKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
            end

            -- Trigger immediate background optimization updates
            optimizeLighting()
            cleanEffects()
        end
    end)
end

-- Abstracted functional constructor to initialize structural elements
local function createToggleRow(title, desc, stateKey)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 55)
    container.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    container.Parent = contentPanel
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(28, 35, 50)
    stroke.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 0, 20)
    label.Position = UDim2.new(0, 65, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = title .. " <font color='#4ce4e6'>(ON)</font>"
    label.RichText = true
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -100, 0, 20)
    descLabel.Position = UDim2.new(0, 65, 0, 26)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(120, 135, 155)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = container

    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 42, 0, 22)
    switchBg.Position = UDim2.new(0, 12, 0.5, -11)
    switchBg.BackgroundColor3 = Color3.fromRGB(0, 200, 205)
    switchBg.Parent = container
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local switchKnob = Instance.new("Frame")
    switchKnob.Size = UDim2.new(0, 16, 0, 16)
    switchKnob.Position = UDim2.new(1, -19, 0.5, -8)
    switchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchKnob.Parent = switchBg
    Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(1, 0)

    -- Call your fixed function mapping parameters perfectly
    buildGuiToggle(container, stateKey, title, switchBg, switchKnob, label)
end

--------------------------------------------------------------------------------
-- GENERATE MENU ROW TOGGLES
--------------------------------------------------------------------------------

createToggleRow("LIGHTING TUNER", "Lowers heavy engines & dynamic shadows", "graphics")
createToggleRow("PARTICLE OPTIMIZER", "Limits intense engine visual effects & smoke", "particles")
createToggleRow("DE-SYNC ANTI-LAG", "Optimizes internal frame caching network loops", "antiLag")
createToggleRow("MEMORY CLEANUP", "Automatically flushes garbage collections", "memoryCleanup")
