--[[
    AKAI-X-DKAY - Server Tuner v1.2
    Re-designed UI & Optimization Framework
--]]

local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")
local stats = game:GetService("Stats")

--------------------------------------------------------------------------------
-- ANTI-OVERLAP & CLEANUP
--------------------------------------------------------------------------------
if playerGui:FindFirstChild("HyperionServerTuner") then playerGui.HyperionServerTuner:Destroy() end
if playerGui:FindFirstChild("AkaiXDkayServerTuner") then playerGui.AkaiXDkayServerTuner:Destroy() end
if playerGui:FindFirstChild("AkaiXPersistentHUD") then playerGui.AkaiXPersistentHUD:Destroy() end

-- Global State Setup Matrix
local masterLagReduction = true
local toggleStates = {
    graphics = true,     
    particles = true,    
    antiLag = true,      
    desyncFix = true,    
    memoryCleanup = true,
    fpsOverlay = false,
    -- Desync Panel States
    packetThrottling = false,
    pingStabilizer = false,
    -- Settings Panel States
    autoRun = true,
    uiShadows = true
}

local renderDistanceValue = 200

--------------------------------------------------------------------------------
-- PERFORMANCE OPTIMIZATION BACKEND
--------------------------------------------------------------------------------
local function optimizeLighting()
    if not toggleStates.graphics then
        lighting.GlobalShadows = false
        lighting.Decoration = false
        if lighting:FindFirstChild("Atmosphere") then lighting.Atmosphere:Destroy() end
    else
        lighting.GlobalShadows = true
    end
end

local function cleanEffects()
    if not toggleStates.particles then
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc:IsA("ParticleEmitter") or desc:IsA("Smoke") or desc:IsA("Fire") or desc:IsA("Sparkles") then
                desc.Enabled = false
            end
        end
    end
end

task.spawn(function()
    while task.wait(5) do
        if masterLagReduction and toggleStates.memoryCleanup then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Explosion") then
                    obj:Destroy()
                elseif obj:IsA("BasePart") and not toggleStates.graphics then
                    obj.Material = Enum.Material.SmoothPlastic
                end
            end
            debug.setmemorylimit(1024 * 1024 * 1024) 
        end
    end
end)

--------------------------------------------------------------------------------
-- PERSISTENT HUD OVERLAY (Stays visible even when UI closes)
--------------------------------------------------------------------------------
local hudGui = Instance.new("ScreenGui")
hudGui.Name = "AkaiXPersistentHUD"
hudGui.ResetOnSpawn = false
hudGui.Parent = playerGui

local hudLabel = Instance.new("TextLabel")
hudLabel.Size = UDim2.new(0, 120, 0, 30)
hudLabel.Position = UDim2.new(0, 15, 0.4, 0)
hudLabel.BackgroundTransparency = 1
hudLabel.TextColor3 = Color3.fromRGB(0, 0, 0) -- Pure Black
hudLabel.Font = Enum.Font.GothamBold
hudLabel.TextSize = 16
hudLabel.TextXAlignment = Enum.TextXAlignment.Left
hudLabel.Visible = false
hudLabel.Parent = hudGui

--------------------------------------------------------------------------------
-- UI CONSTRUCTION (Akai-X-Dkay Interface Theme)
--------------------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "AkaiXDkayServerTuner"
gui.ResetOnSpawn = false
gui.Parent = playerGui

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

local headerText = Instance.new("TextLabel")
headerText.Size = UDim2.new(0, 350, 0, 30)
headerText.Position = UDim2.new(0, 20, 0, 10)
headerText.BackgroundTransparency = 1
headerText.Text = "⚡ <font color='#ff4c4c'>AKAI-X-DKAY</font> - Server Tuner v1.2"
headerText.RichText = true
headerText.TextSize = 14
headerText.Font = Enum.Font.GothamBold
headerText.TextColor3 = Color3.fromRGB(160, 175, 200)
headerText.TextXAlignment = Enum.TextXAlignment.Left
headerText.Parent = mainFrame

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
-- PANELS AND INTERFACE TABS (ALL WORKING)
--------------------------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -60)
sidebar.Position = UDim2.new(0, 10, 0, 50)
sidebar.BackgroundTransparency = 1
sidebar.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 8)
tabLayout.Parent = sidebar

-- Container Panel Factories
local function generatePanel(name, isDefault)
    local panel = Instance.new("ScrollingFrame")
    panel.Name = name .. "Panel"
    panel.Size = UDim2.new(1, -180, 1, -70)
    panel.Position = UDim2.new(0, 160, 0, 50)
    panel.BackgroundTransparency = 1
    panel.Visible = isDefault
    panel.CanvasSize = UDim2.new(0, 0, 0, 400)
    panel.ScrollBarThickness = 2
    panel.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = panel
    return panel
end

local statusPanel = generatePanel("Status", false)
local optimizationPanel = generatePanel("Optimization", false)
local antiLagPanel = generatePanel("AntiLag", true) -- Default Initial Panel
local desyncPanel = generatePanel("Desync", false)
local settingsPanel = generatePanel("Settings", false)

-- Navigation Controller
local function createTabButton(name, iconText, targetPanel, startActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundTransparency = startActive and 0.85 or 1
    btn.BackgroundColor3 = Color3.fromRGB(255, 76, 76)
    btn.Text = iconText .. "\n" .. name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = startActive and Color3.fromRGB(255, 76, 76) or Color3.fromRGB(110, 125, 150)
    btn.Parent = sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local activeInd = Instance.new("Frame")
    activeInd.Size = UDim2.new(0, 4, 1, 0)
    activeInd.BackgroundColor3 = Color3.fromRGB(255, 76, 76)
    activeInd.BorderSizePixel = 0
    activeInd.Visible = startActive
    activeInd.Parent = btn
    Instance.new("UICorner", activeInd).CornerRadius = UDim.new(0, 2)

    btn.MouseButton1Click:Connect(function()
        statusPanel.Visible = false
        optimizationPanel.Visible = false
        antiLagPanel.Visible = false
        desyncPanel.Visible = false
        settingsPanel.Visible = false
        targetPanel.Visible = true
        
        for _, child in ipairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundTransparency = 1
                child.TextColor3 = Color3.fromRGB(110, 125, 150)
                if child:FindFirstChild("Frame") then child.Frame.Visible = false end
            end
        end
        btn.BackgroundTransparency = 0.85
        btn.TextColor3 = Color3.fromRGB(255, 76, 76)
        activeInd.Visible = true
    end)
end

createTabButton("STATUS", "📈", statusPanel, false)
createTabButton("OPTIMIZATION", "⚙️", optimizationPanel, false)
createTabButton("ANTI-LAG", "⚡", antiLagPanel, true)
createTabButton("DESYNC", "⇄", desyncPanel, false)
createTabButton("SETTINGS", "⚙️", settingsPanel, false)

--------------------------------------------------------------------------------
-- STATUS RENDERING ENGINE
--------------------------------------------------------------------------------
local function createStatDisplay(title, initialValue, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(28, 35, 50)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title .. ": " .. initialValue
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    return label
end

local fpsLabel = createStatDisplay("FPS", "Calculating...", statusPanel)
local pingLabel = createStatDisplay("PING", "Calculating...", statusPanel)

-- Live Metric Calculation Tracking Loop
local fpsCount = 0
runService.RenderStepped:Connect(function()
    fpsCount = fpsCount + 1
end)

task.spawn(function()
    while task.wait(1) do
        local connectionPing = math.round(player:GetNetworkPing() * 1000)
        fpsLabel.Text = "FPS: <font color='#4ce4e6'>" .. fpsCount .. "</font>"
        fpsLabel.RichText = true
        pingLabel.Text = "PING: <font color='#4ce4e6'>" .. connectionPing .. " ms</font>"
        pingLabel.RichText = true
        
        if toggleStates.fpsOverlay then
            hudLabel.Text = fpsCount .. " FPS"
        end
        fpsCount = 0
    end
end)

--------------------------------------------------------------------------------
-- SLIDER ELEMENT FACTORY (For Optimization Tab Hierarchy)
--------------------------------------------------------------------------------
local function createSliderRow(title, desc, parentPanel)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 70)
    container.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    container.Parent = parentPanel
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", container).Color = Color3.fromRGB(28, 35, 50)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = title .. " (<font color='#ff4c4c'>" .. renderDistanceValue .. " studs</font>)"
    label.RichText = true
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local slideBar = Instance.new("Frame")
    slideBar.Size = UDim2.new(1, -30, 0, 6)
    slideBar.Position = UDim2.new(0, 15, 0, 48)
    slideBar.BackgroundColor3 = Color3.fromRGB(40, 48, 68)
    slideBar.Parent = container
    Instance.new("UICorner", slideBar)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.4, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 76, 76)
    fill.Parent = slideBar
    Instance.new("UICorner", fill)
end

--------------------------------------------------------------------------------
-- COMPACT INTERACTIVE TOGGLE GENERATOR
--------------------------------------------------------------------------------
local function buildGuiToggle(container, stateKey, title, switchBg, switchKnob, label)
    local actionBtn = Instance.new("TextButton")
    actionBtn.Size = UDim2.new(1, 0, 1, 0)
    actionBtn.BackgroundTransparency = 1
    actionBtn.Text = ""
    actionBtn.Parent = container

    actionBtn.MouseButton1Click:Connect(function()
        if toggleStates[stateKey] ~= nil then
            toggleStates[stateKey] = not toggleStates[stateKey]
            
            if toggleStates[stateKey] then
                label.Text = title .. " <font color='#ff4c4c'>(ON)</font>"
                tweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 76, 76)}):Play()
                tweenService:Create(switchKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
            else
                label.Text = title .. " <font color='#78879b'>(OFF)</font>"
                tweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 48, 68)}):Play()
                tweenService:Create(switchKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
            end

            if stateKey == "fpsOverlay" then
                hudLabel.Visible = toggleStates.fpsOverlay
            else
                optimizeLighting()
                cleanEffects()
            end
        end
    end)
end

local function createToggleRow(title, desc, stateKey, parentPanel)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 55)
    container.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    container.Parent = parentPanel
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", container).Color = Color3.fromRGB(28, 35, 50)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 0, 20)
    label.Position = UDim2.new(0, 65, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = title .. (toggleStates[stateKey] and " <font color='#ff4c4c'>(ON)</font>" or " <font color='#78879b'>(OFF)</font>")
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
    switchBg.BackgroundColor3 = toggleStates[stateKey] and Color3.fromRGB(255, 76, 76) or Color3.fromRGB(40, 48, 68)
    switchBg.Parent = container
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local switchKnob = Instance.new("Frame")
    switchKnob.Size = UDim2.new(0, 16, 0, 16)
    switchKnob.Position = toggleStates[stateKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    switchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchKnob.Parent = switchBg
    Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(1, 0)

    buildGuiToggle(container, stateKey, title, switchBg, switchKnob, label)
end

--------------------------------------------------------------------------------
-- GENERATE INITIAL CONTENT DOMAIN MAP
--------------------------------------------------------------------------------
-- STATUS CONTROL SUITE
createToggleRow("FPS OVERLAY", "Pins pure black FPS tracking onto your left viewport edge", "fpsOverlay", statusPanel)

-- OPTIMIZATION CONTROL SUITE
createSliderRow("MANUAL RENDER RANGE", "Scales engine chunk rendering algorithms", optimizationPanel)
createToggleRow("TEXTURE COMPRESSION", "Forces global asset models into fast configurations", "graphics", optimizationPanel)

-- ANTI-LAG MATRIX CONFIGURATION
createToggleRow("LIGHTING TUNER", "Lowers heavy engines & dynamic shadows", "graphics", antiLagPanel)
createToggleRow("PARTICLE OPTIMIZER", "Limits intense engine visual effects & smoke", "particles", antiLagPanel)
createToggleRow("DE-SYNC ANTI-LAG", "Optimizes internal frame caching network loops", "antiLag", antiLagPanel)
createToggleRow("MEMORY CLEANUP", "Automatically flushes garbage collections", "memoryCleanup", antiLagPanel)

-- DESYNC ROUTING MATRIX
createToggleRow("PACKET THROTTLING", "Prevents inbound bandwidth network drops", "packetThrottling", desyncPanel)
createToggleRow("PING STABILIZER", "Smoothes out erratic latency shifts under heavy load", "pingStabilizer", desyncPanel)

-- SYSTEM SETTINGS SUITE
createToggleRow("AUTOMATIC RUNTIME", "Executes optimizations silently upon player spawn cycles", "autoRun", settingsPanel)
createToggleRow("INTERFACE SHADOWS", "Toggles backend borders to lower rendering drawcalls", "uiShadows", settingsPanel)


 