--[[
    AKAI-X-DKAY - Server Tuner v1.5
    Fixed Image Formatting & Scope Handling
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

                debug.setmemorylimit(1024 * 1024 * 1024) 
                print("[Akai-X-Dkay] Cleaned local memory registers & geometric caches.")
            end

            if toggleStates.pingStabilizer or toggleStates.packetThrottling then
                safeboxSetFFlag("FFlagThrottleUnreliablePackets", true)
                safeboxSetFFlag("DFFlagFixPingSpikes", true)
                safeboxSetFFlag("DFIntNetworkMinSendInterval", 15)
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
hudLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
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

-- Direct Web Integration Pipeline using your working Catbox Link
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

-- Floating Restore Circle Badge (Upgraded to ImageButton)
local restoreCircle = Instance.new("ImageButton")
restoreCircle.Name = "RestoreBadge"
restoreCircle.Size = UDim2.new(0, 55, 0, 55)
restoreCircle.Position = UDim2.new(0.05, 0, 0.2, 0)
restoreCircle.BackgroundColor3 = Color3.fromRGB(20, 25, 35) 
restoreCircle.Visible = false
restoreCircle.Active = true
restoreCircle.Draggable = true
restoreCircle.Parent = gui

-- Dynamic executor asset checker mapping
if getcustomasset and pcall(function() getcustomasset(localAssetPath) end) then
    restoreCircle.Image = getcustomasset(localAssetPath)
else
    -- Server configuration backup icon if executor folder path is write-locked
    restoreCircle.Image = "rbxassetid://10848301131"
    restoreCircle.ImageColor3 = Color3.fromRGB(255, 76, 76)
end

restoreCircle.ScaleType = Enum.ScaleType.Fit

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(1, 0)
badgeCorner.Parent = restoreCircle

local badgeStroke = Instance.new("UIStroke")
badgeStroke.Color = Color3.fromRGB(255, 76, 76) 
badgeStroke.Thickness = 2
badgeStroke.Parent = restoreCircle

-- Main Core Window
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
headerText.Text = "⚡ <font color='#ff4c4c'>AKAI-X-DKAY</font> - Server Tuner v1.5"
headerText.RichText = true
headerText.TextSize = 14
headerText.Font = Enum.Font.GothamBold
headerText.TextColor3 = Color3.fromRGB(160, 175, 200)
headerText.TextXAlignment = Enum.TextXAlignment.Left
headerText.Parent = mainFrame

-- Window Operation Actions (Close, Minimize, Restore)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -35, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(90, 105, 130)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -65, 0, 10)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "⎯"
minimizeBtn.TextColor3 = Color3.fromRGB(90, 105, 130)
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
    panel.CanvasSize = UDim2.new(0, 0, 0, 440) -- Adjusted for mobile scroll padding
    panel.ScrollBarThickness = 2
    panel.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = panel
    return panel
end

local statusPanel = generatePanel("Status", false)
local optimizationPanel = generatePanel("Optimization", false)
local antiLagPanel = generatePanel("AntiLag", true) 
local desyncPanel = generatePanel("Desync", false)
local settingsPanel = generatePanel("Settings", false)

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
