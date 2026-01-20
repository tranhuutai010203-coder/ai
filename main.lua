--// Blind Bomber ESP FINAL
--// Fixed Bomb Detection + Anti Lag
--// Rayfield UI

if not Drawing then return end

--================ LIB =================--
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Blind Bomber ESP",
    LoadingTitle = "Blind Bomber",
    LoadingSubtitle = "Final Stable",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("ESP", 4483362458)

--================ SERVICES =================--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--================ TOGGLES =================--
local ESP_PLAYER = false
local ESP_NAME = false
local ESP_BOMB = false
local ESP_HOLDER = false

Tab:CreateToggle({
    Name = "ESP Player (Box)",
    Callback = function(v) ESP_PLAYER = v end
})

Tab:CreateToggle({
    Name = "ESP Name",
    Callback = function(v) ESP_NAME = v end
})

Tab:CreateToggle({
    Name = "ESP Bomb (Placed)",
    Callback = function(v) ESP_BOMB = v end
})

Tab:CreateToggle({
    Name = "ESP Bomb Holder",
    Callback = function(v) ESP_HOLDER = v end
})

--================ PLAYER ESP =================--
local playerESP = {}

local function clearPlayer(plr)
    if playerESP[plr] then
        for _,d in pairs(playerESP[plr]) do d:Remove() end
        playerESP[plr] = nil
    end
end

Players.PlayerRemoving:Connect(clearPlayer)

--================ BOMB DETECTION =================--
-- Bomb trong Blind Bomber:
-- BasePart + có Mesh / Particle / vòng tròn đỏ
-- KHÔNG dựa vào tên

local bombCache = {}

local function isPlacedBomb(obj)
    if not obj:IsA("BasePart") then return false end
    if LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character) then return false end

    for _,v in ipairs(obj:GetChildren()) do
        if v:IsA("SpecialMesh")
        or v:IsA("CylinderMesh")
        or v:IsA("ParticleEmitter")
        or v:IsA("SelectionSphere")
        or v:IsA("SelectionRing") then
            return true
        end
    end

    return false
end

-- cache bomb khi spawn
workspace.DescendantAdded:Connect(function(obj)
    if isPlacedBomb(obj) then
        local txt = Drawing.new("Text")
        txt.Text = "💣"
        txt.Size = 16
        txt.Center = true
        txt.Outline = true
        txt.Color = Color3.fromRGB(255,60,60)
        txt.Visible = false

        bombCache[obj] = txt

        obj.AncestryChanged:Connect(function(_, parent)
            if not parent then
                txt:Remove()
                bombCache[obj] = nil
            end
        end)
    end
end)

--================ HOLDER CHECK =================--
local function IsHoldingBomb(plr)
    if not plr.Character then return false end

    for _,v in ipairs(plr.Character:GetChildren()) do
        if v:IsA("Tool") then
            return true -- Blind Bomber chỉ cho cầm bomb
        end
    end

    return false
end

--================ MAIN LOOP =================--
RunService.RenderStepped:Connect(function()
    -- PLAYER ESP
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)

            if not playerESP[plr] then
                playerESP[plr] = {
                    box = Drawing.new("Square"),
                    name = Drawing.new("Text")
                }
            end

            local box = playerESP[plr].box
            local name = playerESP[plr].name

            local holder = ESP_HOLDER and IsHoldingBomb(plr)
            local color = holder and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)

            if ESP_PLAYER and vis then
                local s = 2000 / pos.Z
                box.Size = Vector2.new(s, s * 1.5)
                box.Position = Vector2.new(pos.X - s/2, pos.Y - s)
                box.Color = color
                box.Thickness = 2
                box.Visible = true
            else
                box.Visible = false
            end

            if ESP_NAME and vis then
                name.Text = plr.Name
                name.Size = 16
                name.Center = true
                name.Outline = true
                name.Color = color
                name.Position = Vector2.new(pos.X, pos.Y - 60)
                name.Visible = true
            else
                name.Visible = false
            end
        else
            clearPlayer(plr)
        end
    end

    -- BOMB ESP (NHẸ – KHÔNG SCAN)
    for part,txt in pairs(bombCache) do
        if ESP_BOMB and part.Parent then
            local p, v = Camera:WorldToViewportPoint(part.Position)
            txt.Visible = v
            if v then
                txt.Position = Vector2.new(p.X, p.Y)
            end
        else
            txt.Visible = false
        end
    end
end)
