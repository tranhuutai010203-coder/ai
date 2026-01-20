--// Blind Bomber ESP + Give Bomb Tool (FULL)
--// UI: Rayfield | Event-based | Optimized | No Lag

--// SERVICES
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

--// UI LIB
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Blind Bomber | ESP + Bomb",
    LoadingTitle = "Blind Bomber",
    LoadingSubtitle = "ESP + Give Bomb",
    ConfigurationSaving = {Enabled = false}
})

local Tab = Window:CreateTab("ESP / Bomb", 4483362458)

--// SETTINGS
local Settings = {
    PlayerESP = false,
    BombPlacedESP = false,
    BombHolderESP = false
}

--// STORAGE
local PlayerESP = {}
local BombESP = {}

--// UTIL
local function CreateHighlight(color)
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = Color3.new(1,1,1)
    h.FillTransparency = 0.4
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    return h
end

--// CHECK HOLDING BOMB (FIX AI CŨNG CẦM BOM)
local function IsHoldingBomb(plr)
    if not plr.Character then return false end

    for _,tool in ipairs(plr.Character:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            for _,v in ipairs(tool.Handle:GetChildren()) do
                if v:IsA("SpecialMesh")
                or v:IsA("ParticleEmitter")
                or v:IsA("SelectionSphere")
                or v:IsA("SelectionRing") then
                    return true
                end
            end
        end
    end
    return false
end

--// PLAYER ESP SETUP
local function SetupPlayer(plr)
    if plr == LocalPlayer then return end

    local function OnCharacter(char)
        if PlayerESP[plr] then
            PlayerESP[plr]:Destroy()
        end

        local hl = CreateHighlight(Color3.fromRGB(0,255,0))
        hl.Adornee = char
        hl.Enabled = false
        hl.Parent = char
        PlayerESP[plr] = hl
    end

    if plr.Character then
        OnCharacter(plr.Character)
    end
    plr.CharacterAdded:Connect(OnCharacter)
end

for _,p in ipairs(Players:GetPlayers()) do
    SetupPlayer(p)
end
Players.PlayerAdded:Connect(SetupPlayer)

--// UPDATE BOMB HOLDER (NHẸ – KHÔNG LAG)
RunService.Heartbeat:Connect(function()
    if not Settings.BombHolderESP then return end

    for plr,hl in pairs(PlayerESP) do
        if hl and hl.Parent then
            if IsHoldingBomb(plr) then
                hl.FillColor = Color3.fromRGB(255,0,0)
                hl.Enabled = true
            else
                hl.FillColor = Color3.fromRGB(0,255,0)
                hl.Enabled = Settings.PlayerESP
            end
        end
    end
end)

--// BOMB PLACED ESP
Workspace.ChildAdded:Connect(function(obj)
    if not Settings.BombPlacedESP then return end

    if obj:IsA("Model") or obj:IsA("Part") then
        local isBomb = false

        for _,v in ipairs(obj:GetDescendants()) do
            if v:IsA("SurfaceGui") or v:IsA("BillboardGui") then
                isBomb = true
            end
        end

        if isBomb then
            local hl = CreateHighlight(Color3.fromRGB(255,170,0))
            hl.Adornee = obj
            hl.Parent = obj
            hl.Enabled = true
            BombESP[obj] = hl

            obj.AncestryChanged:Connect(function(_,parent)
                if not parent and BombESP[obj] then
                    BombESP[obj]:Destroy()
                    BombESP[obj] = nil
                end
            end)
        end
    end
end)

--// GIVE BOMB TOOL
local function GiveBomb()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end

    local function Scan(container)
        for _,v in ipairs(container:GetDescendants()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
                for _,m in ipairs(v.Handle:GetChildren()) do
                    if m:IsA("SpecialMesh")
                    or m:IsA("ParticleEmitter")
                    or m:IsA("SelectionSphere")
                    or m:IsA("SelectionRing") then
                        v:Clone().Parent = backpack
                        return true
                    end
                end
            end
        end
        return false
    end

    if Scan(ReplicatedStorage) or Scan(Workspace) then
        Rayfield:Notify({
            Title = "Give Bomb",
            Content = "Bomb tool added to Backpack",
            Duration = 4
        })
    else
        Rayfield:Notify({
            Title = "Give Bomb",
            Content = "Bomb là server-side (không give được)",
            Duration = 4
        })
    end
end

--// UI
Tab:CreateToggle({
    Name = "ESP Player",
    CurrentValue = false,
    Callback = function(v)
        Settings.PlayerESP = v
        for _,hl in pairs(PlayerESP) do
            if hl then hl.Enabled = v end
        end
    end
})

Tab:CreateToggle({
    Name = "ESP Bomb Holder",
    CurrentValue = false,
    Callback = function(v)
        Settings.BombHolderESP = v
    end
})

Tab:CreateToggle({
    Name = "ESP Bomb (Placed)",
    CurrentValue = false,
    Callback = function(v)
        Settings.BombPlacedESP = v
    end
})

Tab:CreateButton({
    Name = "Give Bomb Tool",
    Callback = function()
        GiveBomb()
    end
})

Rayfield:Notify({
    Title = "Blind Bomber",
    Content = "Loaded successfully!",
    Duration = 5
})
