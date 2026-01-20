--// Blind Bomber ESP - Full Fixed Version
--// UI: Rayfield | Event-based | No Lag

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// UI LIB
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Blind Bomber ESP",
    LoadingTitle = "Blind Bomber ESP",
    LoadingSubtitle = "by ChatGPT",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("ESP", 4483362458)

--// SETTINGS
local Settings = {
    PlayerESP = false,
    NameESP = false,
    BombPlacedESP = false,
    BombHolderESP = false
}

--// STORAGE
local PlayerESP = {}
local BombESP = {}

--// UTILS
local function CreateHighlight(color)
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = Color3.new(1,1,1)
    h.FillTransparency = 0.4
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    return h
end

--// CHECK BOMB TOOL (FIX AI CŨNG CẦM BOM)
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

--// PLAYER ESP
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

--// BOMB HOLDER CHECK (EVENT BASED)
RunService.Heartbeat:Connect(function()
    if not Settings.BombHolderESP then return end

    for plr,hl in pairs(PlayerESP) do
        if hl and hl.Parent and IsHoldingBomb(plr) then
            hl.FillColor = Color3.fromRGB(255,0,0)
            hl.Enabled = true
        elseif hl then
            hl.FillColor = Color3.fromRGB(0,255,0)
            hl.Enabled = Settings.PlayerESP
        end
    end
end)

--// BOMB PLACED ESP
Workspace.ChildAdded:Connect(function(obj)
    if not Settings.BombPlacedESP then return end

    if obj:IsA("Model") or obj:IsA("Part") then
        local hasTimer = false

        for _,v in ipairs(obj:GetDescendants()) do
            if v:IsA("SurfaceGui") or v:IsA("BillboardGui") then
                hasTimer = true
            end
        end

        if hasTimer then
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

--// UI TOGGLES
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
    Name = "ESP Name",
    CurrentValue = false,
    Callback = function(v)
        Settings.NameESP = v
        -- Name ESP có thể mở rộng thêm BillboardGui nếu bạn muốn
    end
})

Tab:CreateToggle({
    Name = "ESP Bomb (Placed)",
    CurrentValue = false,
    Callback = function(v)
        Settings.BombPlacedESP = v
    end
})

Tab:CreateToggle({
    Name = "ESP Bomb Holder",
    CurrentValue = false,
    Callback = function(v)
        Settings.BombHolderESP = v
    end
})

Rayfield:Notify({
    Title = "Blind Bomber ESP",
    Content = "Loaded successfully!",
    Duration = 5
})
