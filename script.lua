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
-- PERFORMANCE OPTIMIZATION BACKEND
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
-- UI CONSTRUCTION (Akai-X-Dkay Interface Theme)
--------------------------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "AkaiXDkayServerTuner"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main Framework window
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

