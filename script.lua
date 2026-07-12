--[[
    AKAI-X-DKAY - Server Tuner v1.6 (Monochrome Theme)
    Unified Mobile Optimization Panel - Part 1
--]]

local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")
local stats = game:GetService("Stats")
local terrain = workspace:FindFirstChildOfClass("Terrain")

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
    desyncFix = false,    
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

-- Safe environment FFlag function handler
local function safeboxSetFFlag(flagName, value)
    local setfflagFunc = setfflag or set_fflag or (syn and syn.set_fflag)
    if setfflagFunc then
        pcall(function()
            setfflagFunc(flagName, tostring(value))
        end)
    end
end

--------------------------------------------------------------------------------
-- ADVANCED ENGINE INTERPOLATION & GRAPHICS OPTIMIZER
--------------------------------------------------------------------------------

local function optimizeVisuals(obj)
    if not toggleStates.graphics then
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
            obj.Reflectance = 0
        elseif obj:IsA("MeshPart") then
            obj.CastShadow = false
            obj.CollisionFidelity = Enum.CollisionFidelity.Box
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1 
        end
    end
end

local function optimizeLighting()
    if not toggleStates.graphics then
        safeboxSetFFlag("FFlagDisableShadows", true)
        safeboxSetFFlag("FFlagDisableMaterials", true)
        safeboxSetFFlag("DFIntGraphicsQualityLevel", 1)
        safeboxSetFFlag("FFlagGraphicsSkipLODCheck", true)

        lighting.GlobalShadows = false
        lighting.ShadowSoftness = 0
        lighting.EnvironmentBlendParameter = 0
        lighting.Decoration = false

        if lighting:FindFirstChild("Atmosphere") then lighting.Atmosphere:Destroy() end

        for _, fx in ipairs(lighting:GetChildren()) do
            if fx:IsA("BlurEffect") or fx:IsA("SunRaysEffect") or fx:IsA("BloomEffect") or fx:IsA("DepthOfFieldEffect") then
                fx.Enabled = false
            end
        end

        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 0
        end

        task.spawn(function()
            local count = 0
            for _, child in ipairs(workspace:GetDescendants()) do
                optimizeVisuals(child)
                count = count + 1
                if count % 100 == 0 then
                    task.wait()
                end
            end
            print("[Akai-X-Dkay] Graphics & Rendering optimized smoothly.")
        end)
    else
        lighting.GlobalShadows = true
    end
end

workspace.DescendantAdded:Connect(optimizeVisuals)

local function cleanEffects()
    if not toggleStates.particles then
        safeboxSetFFlag("FFlagDisableParticles", true)
        safeboxSetFFlag("FFlagDisableEffects", true)

        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc:IsA("ParticleEmitter") or desc:IsA("Smoke") or desc:IsA("Fire") or desc:IsA("Sparkles") or desc:IsA("Beam") or desc:IsA("Trail") then
                desc.Enabled = false
            end
        end
    end
end

task.spawn(function()
    while task.wait(3) do
        if masterLagReduction then
            local setfpscapFunc = setfpscap or set_fps_cap
            if setfpscapFunc then
                setfpscapFunc(999)
            else
                safeboxSetFFlag("DFIntTaskSchedulerTargetFps", 999)
            end

            safeboxSetFFlag("FFlagSmoothScheduler", true)
            safeboxSetFFlag("DFFlagThreadedSteppedFix", true)
            safeboxSetFFlag("FFlagDebugReportPhysicsErrors", false)

            -- Custom Desync Engine Configuration
            if toggleStates.desyncFix then
                safeboxSetFFlag("FFlagPhysicsSenderSendsVelocity", false) 
                safeboxSetFFlag("DFIntNetworkPredictionMaxUpdateTime", 0)
                safeboxSetFFlag("DFIntNetworkPredictionMaxRollbackTime", 0)
                safeboxSetFFlag("FFlagThrottleUnreliablePackets", true)
                safeboxSetFFlag("DFIntNetworkMinSendInterval", 50) 
                print("[Akai-X-Dkay] Physics desync matrix active. Velocity data spoofed.")
            else
                safeboxSetFFlag("FFlagPhysicsSenderSendsVelocity", true)
                safeboxSetFFlag("DFIntNetworkPredictionMaxUpdateTime", 120)
                safeboxSetFFlag("FFlagThrottleUnreliablePackets", false)
                safeboxSetFFlag("DFIntNetworkMinSendInterval", 15)
            end

            if toggleStates.memoryCleanup then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Explosion") or obj:IsA("ShirtGraphic") then
                        obj:Destroy()
                    end
                end

                pcall(function()
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                    settings().Rendering.MeshCacheSize = 256
                end)
                
                print("[Akai-X-Dkay] Cleaned local memory registers & geometric caches.")
            end

            if toggleStates.pingStabilizer or toggleStates.packetThrottling then
                safeboxSetFFlag("DFFlagFixPingSpikes", true)
                safeboxSetFFlag("FFlagNetworkUseNewTransport", true)

                pcall(function()
                    local networkSettings = settings().Network
                    local baseSettings = settings()

                    networkSettings.IncomingReplicationLag = 0
                    networkSettings.PhysicsSendRate = 20

                    if baseSettings.Diagnostics then
                        baseSettings.Diagnostics.LuaRamLimit = 0
                    end
                end)

                if terrain then
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                end
                print("[Akai-X-Dkay] Network, pipelines, and replication profiles maximized.")
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- PERSISTENT HUD OVERLAY
--------------------------------------------------------------------------------
local hudGui = Instance.new("ScreenGui")
hudGui.Name = "AkaiXPersistentHUD"
hudGui.ResetOnSpawn = false
hudGui.Parent = playerGui

local hudLabel = Instance.new("TextLabel")
hudLabel.Size = UDim2.new(0, 120, 0, 30)
hudLabel.Position = UDim2.new(0, 15, 0.4, 0)
hudLabel.BackgroundTransparency = 1
hudLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hudLabel.Font = Enum.Font.GothamBold
hudLabel.TextSize = 16
hudLabel.TextXAlignment = Enum.TextXAlignment.Left
hudLabel.Visible = false
hudLabel.Parent = hudGui

--------------------------------------------------------------------------------
-- UI CONSTRUCTION & RESTORE BADGE MATRIX
--------------------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "AkaiXDkayServerTuner"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local iconWebURL = "https://files.catbox.moe/7fg949.png"
local localAssetPath = "AkaiCustomBadgeIcon.png"

pcall(function()
    if writefile and getcustomasset then
        local success, imageData = pcall(function() return game:HttpGet(iconWebURL) end)
        if success and imageData then
            writefile(localAssetPath, imageData)
        end
    end
end)

local restoreCircle = Instance.new("ImageButton")
restoreCircle.Name = "RestoreBadge"
restoreCircle.Size = UDim2.new(0, 55, 0, 55)
restoreCircle.Position = UDim2.new(0.05, 0, 0.2, 0)
restoreCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
restoreCircle.Visible = false
restoreCircle.Active = true
restoreCircle.Draggable = true
restoreCircle.Parent = gui

if getcustomasset and pcall(function() getcustomasset(localAssetPath) end) then
    restoreCircle.Image = getcustomasset(localAssetPath)
else
    restoreCircle.Image = "rbxassetid://10848301131"
    restoreCircle.ImageColor3 = Color3.fromRGB(255, 255, 255)
end

restoreCircle.ScaleType = Enum.ScaleType.Fit

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(1, 0)
badgeCorner.Parent = restoreCircle

local badgeStroke = Instance.new("UIStroke")
badgeStroke.Color = Color3.fromRGB(255, 255, 255) 
badgeStroke.Thickness = 2
badgeStroke.Parent = restoreCircle

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 420)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255) 
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

local headerText = Instance.new("TextLabel")
headerText.Size = UDim2.new(0, 350, 0, 30)
headerText.Position = UDim2.new(0, 20, 0, 10)
headerText.BackgroundTransparency = 1
headerText.Text = "🐻‍❄️ <font color='#ffffff'>AKAI-X-DKAY</font> - Server Tuner v1.6"
headerText.RichText = true
headerText.TextSize = 14
headerText.Font = Enum.Font.GothamBold
headerText.TextColor3 = Color3.fromRGB(255, 255, 255) 
headerText.TextXAlignment = Enum.TextXAlignment.Left
headerText.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -35, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -65, 0, 10)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "⎯"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function() 
    gui:Destroy() 
end)

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    restoreCircle.Visible = true
end)

restoreCircle.MouseButton1Click:Connect(function()
    restoreCircle.Visible = false
    mainFrame.Visible = true
end)

--------------------------------------------------------------------------------
-- PANELS AND INTERFACE TABS
--------------------------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -60)
sidebar.Position = UDim2.new(0, 10, 0, 50)
sidebar.BackgroundTransparency = 1
sidebar.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 8)
tabLayout.Parent = sidebar

local function generatePanel(name, isDefault)
    local panel = Instance.new("ScrollingFrame")
    panel.Name = name .. "Panel"
    panel.Size = UDim2.new(1, -180, 1, -70)
    panel.Position = UDim2.new(0, 160, 0, 50)
    panel.BackgroundTransparency = 1
    panel.Visible = isDefault
    panel.CanvasSize = UDim2.new(0, 0, 0, 440)
    panel.ScrollBarThickness = 2
    panel.Parent = mainFrame
    return panel
end

local statusPanel = generatePanel("Status", false)
local optimizationPanel = generatePanel("Optimization", false)
local antiLagPanel = generatePanel("AntiLag", true) 
local desyncPanel = generatePanel("Desync", false)
local settingsPanel = generatePanel("Settings", false)

local layoutS = Instance.new("UIListLayout") layoutS.Padding = UDim.new(0, 10) layoutS.Parent = statusPanel
local layoutO = Instance.new("UIListLayout") layoutO.Padding = UDim.new(0, 10) layoutO.Parent = optimizationPanel
local layoutA = Instance.new("UIListLayout") layoutA.Padding = UDim.new(0, 10) layoutA.Parent = antiLagPanel
local layoutD = Instance.new("UIListLayout") layoutD.Padding = UDim.new(0, 10) layoutD.Parent = desyncPanel
local layoutSe = Instance.new("UIListLayout") layoutSe.Padding = UDim.new(0, 10) layoutSe.Parent = settingsPanel

local function createTabButton(name, iconText, targetPanel, startActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundTransparency = startActive and 0.85 or 1
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
    btn.Text = iconText .. "\n" .. name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = startActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    btn.Parent = sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local activeInd = Instance.new("Frame")
    activeInd.Size = UDim2.new(0, 4, 1, 0)
    activeInd.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
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
                child.TextColor3 = Color3.fromRGB(150, 150, 150)
                if child:FindFirstChild("Frame") then child.Frame.Visible = false end
            end
        end
        btn.BackgroundTransparency = 0.2
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        activeInd.Visible = true
    end)
end

createTabButton("STATUS", "📈", statusPanel, false)
createTabButton("OPTIMIZATION", "⚙️", optimizationPanel, false)
createTabButton("ANTI-LAG", "⚡", antiLagPanel, true)
createTabButton("DESYNC", "⇄", desyncPanel, false)
createTabButton("SETTINGS", "⚙️", settingsPanel, false)

--------------------------------------------------------------------------------
-- STATUS METRIC RENDERING ENGINE
--------------------------------------------------------------------------------
local function createStatDisplay(title, initialValue, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) 
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(50, 50, 50) 

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

local fpsCount = 0
runService.RenderStepped:Connect(function()
    fpsCount = fpsCount + 1
end)

task.spawn(function()
    while task.wait(1) do
        local connectionPing = 0
        pcall(function()
            connectionPing = math.round(stats.PerformanceStats.Ping:GetValue())
        end)

        fpsLabel.Text = "FPS: <font color='#ffffff'>" .. fpsCount .. "</font>"
        fpsLabel.RichText = true
        pingLabel.Text = "PING: <font color='#ffffff'>" .. connectionPing .. " ms</font>"
        pingLabel.RichText = true

        if toggleStates.fpsOverlay then
            hudLabel.Visible = true
            hudLabel.Text = fpsCount .. " FPS"
        end
        fpsCount = 0
    end
end)

--------------------------------------------------------------------------------
-- SLIDER ROUTING FRAMEWORK (MONOCHROME VARIANT)
--------------------------------------------------------------------------------
local function createSliderRow(title, minVal, maxVal, startVal, isDecimal, desc, parentPanel, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 75)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    container.Parent = parentPanel
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", container).Color = Color3.fromRGB(50, 50, 50)

    local currentVal = startVal
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = title .. " (<font color='#ffffff'>" .. string.format(isDecimal and "%.1f" or "%d", currentVal) .. "</font>)"
    label.RichText = true
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local slideBar = Instance.new("TextButton")
    slideBar.Size = UDim2.new(1, -30, 0, 12)
    slideBar.Position = UDim2.new(0, 15, 0, 46)
    slideBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    slideBar.Text = ""
    slideBar.AutoButtonColor = false
    slideBar.Parent = container
    Instance.new("UICorner", slideBar)

    local fill = Instance.new("Frame")
    local startScale = (startVal - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(startScale, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
    fill.Parent = slideBar
    Instance.new("UICorner", fill)

    local function updateSliderInput(input)
        local rawScale = math.clamp((input.Position.X - slideBar.AbsolutePosition.X) / slideBar.AbsoluteSize.X, 0, 1)
        local value = minVal + (rawScale * (maxVal - minVal))
        
        if isDecimal then
            value = math.round(value * 10) / 10
        else
            value = math.round(value)
        end
        
        local finalScale = (value - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(finalScale, 0, 1, 0)
        label.Text = title .. " (<font color='#ffffff'>" .. string.format(isDecimal and "%.1f" or "%d", value) .. "</font>)"
        
        if callback then callback(value) end
    end

    local dragging = false
    slideBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSliderInput(input)
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSliderInput(input)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

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
                label.Text = title .. " <font color='#ffffff'>(ON)</font>"
                tweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                tweenService:Create(switchKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
                tweenService:Create(switchKnob, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            else
                label.Text = title .. " <font color='#808080'>(OFF)</font>"
                tweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                tweenService:Create(switchKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
                tweenService:Create(switchKnob, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
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
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    container.Parent = parentPanel
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", container).Color = Color3.fromRGB(50, 50, 50)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 0, 20)
    label.Position = UDim2.new(0, 65, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = title .. (toggleStates[stateKey] and " <font color='#ffffff'>(ON)</font>" or " <font color='#808080'>(OFF)</font>")
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
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = container

    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 42, 0, 22)
    switchBg.Position = UDim2.new(0, 12, 0.5, -11)
    switchBg.BackgroundColor3 = toggleStates[stateKey] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
    switchBg.Parent = container
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local switchKnob = Instance.new("Frame")
    switchKnob.Size = UDim2.new(0, 16, 0, 16)
    switchKnob.Position = toggleStates[stateKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    switchKnob.BackgroundColor3 = toggleStates[stateKey] and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    switchKnob.Parent = switchBg
    Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(1, 0)

    buildGuiToggle(container, stateKey, title, switchBg, switchKnob, label)
end

--------------------------------------------------------------------------------
-- GENERATE INITIAL CONTENT DOMAIN MAP
--------------------------------------------------------------------------------
-- Status Panel Setup
createToggleRow("FPS OVERLAY", "Pins pure black FPS tracking onto your left viewport edge", "fpsOverlay", statusPanel)
createSliderRow("CAMERA SENSITIVITY", 1.0, 7.0, 1.2, true, "Adjusts dynamic pointer tracking metrics", statusPanel, function(value)
    pcall(function()
        local camera = workspace.CurrentCamera
        if camera then
            camera.MouseSensitivity = (value / 3)
        end
    end)
end)

-- Optimization Panel Setup
createSliderRow("MANUAL RENDER RANGE", 50, 1000, 200, false, "Scales engine chunk rendering algorithms", optimizationPanel, function(value)
    renderDistanceValue = value
end)
createToggleRow("TEXTURE COMPRESSION", "Forces global asset models into fast configurations", "graphics", optimizationPanel)

-- Anti-Lag Panel Setup
createToggleRow("LIGHTING TUNER", "Lowers heavy engines & dynamic shadows", "graphics", antiLagPanel)
createToggleRow("PARTICLE OPTIMIZER", "Limits intense engine visual effects & smoke", "particles", antiLagPanel)
createToggleRow("DE-SYNC ANTI-LAG", "Optimizes internal frame caching network loops", "antiLag", antiLagPanel)
createToggleRow("MEMORY CLEANUP", "Automatically flushes garbage collections & uncaps scheduling limits", "memoryCleanup", antiLagPanel)

-- Desync Panel Setup
createToggleRow("PHYSICS DESYNC", "Spoofs velocity updates and network packet replication ranges", "desyncFix", desyncPanel)
createToggleRow("PING STABILIZER", "Optimizes physical replication send rate and packet processing lag", "pingStabilizer", desyncPanel)

-- Settings Panel Setup
createToggleRow("AUTOMATIC RUNTIME", "Executes optimizations silently upon player spawn cycles", "autoRun", settingsPanel)
createToggleRow("INTERFACE SHADOWS", "Toggles backend borders to lower rendering drawcalls", "uiShadows", settingsPanel)
