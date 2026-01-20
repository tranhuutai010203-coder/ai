--// Blind Bomber ESP FINAL (ANTI LAG + FIX BOMB)

if not Drawing then return end

--========== LIB =========--
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Blind Bomber ESP",
    LoadingTitle = "Blind Bomber",
    LoadingSubtitle = "Stable Version",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("ESP", 4483362458)

--========== SERVICES =========--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--========== TOGGLES =========--
local ESP_PLAYER = false
local ESP_NAME = false
local ESP_BOMB = false
local ESP_HOLDER = false

Tab:CreateToggle({ Name="ESP Player", Callback=function(v) ESP_PLAYER=v end })
Tab:CreateToggle({ Name="ESP Name", Callback=function(v) ESP_NAME=v end })
Tab:CreateToggle({ Name="ESP Bomb (Placed)", Callback=function(v) ESP_BOMB=v end })
Tab:CreateToggle({ Name="ESP Bomb Holder", Callback=function(v) ESP_HOLDER=v end })

--========== PLAYER ESP =========--
local playerESP = {}

local function clearPlayer(plr)
    if playerESP[plr] then
        for _,d in pairs(playerESP[plr]) do d:Remove() end
        playerESP[plr] = nil
    end
end

Players.PlayerRemoving:Connect(clearPlayer)

--========== BOMB CACHE =========--
local bombCache = {}

local function isBombPart(part)
    return part:IsA("BasePart")
       and part:FindFirstChildWhichIsA("TouchInterest")
       and not part:IsDescendantOf(LocalPlayer.Character)
end

-- detect bomb spawn
workspace.DescendantAdded:Connect(function(obj)
    if isBombPart(obj) then
        local text = Drawing.new("Text")
        text.Text = "💣 BOMB"
        text.Size = 14
        text.Center = true
        text.Outline = true
        text.Color = Color3.fromRGB(255,70,70)

        bombCache[obj] = text

        obj.AncestryChanged:Connect(function(_, parent)
            if not parent then
                text:Remove()
                bombCache[obj] = nil
            end
        end)
    end
end)

--========== HOLDER CHECK =========--
local function IsHoldingBomb(plr)
    if not plr.Character then return false end

    for _,v in ipairs(plr.Character:GetChildren()) do
        if v:IsA("Tool") then return true end
    end

    return false
end

--========== MAIN LOOP =========--
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

            local isHolder = ESP_HOLDER and IsHoldingBomb(plr)
            local color = isHolder and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)

            if ESP_PLAYER and vis then
                local s = 2000 / pos.Z
                box.Size = Vector2.new(s, s*1.5)
                box.Position = Vector2.new(pos.X - s/2, pos.Y - s)
                box.Color = color
                box.Thickness = 2
                box.Visible = true
            else
                box.Visible = false
            end

            if ESP_NAME and vis then
                name.Text = plr.Name
                name.Position = Vector2.new(pos.X, pos.Y - 60)
                name.Size = 16
                name.Center = true
                name.Outline = true
                name.Color = color
                name.Visible = true
            else
                name.Visible = false
            end
        else
            clearPlayer(plr)
        end
    end

    -- BOMB ESP UPDATE (NHẸ)
    for part,txt in pairs(bombCache) do
        if ESP_BOMB and part and part.Parent then
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
