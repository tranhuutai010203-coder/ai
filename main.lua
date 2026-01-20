--// Blind Bomber ESP - Rayfield Version

if not Drawing then
    warn("Executor không hỗ trợ Drawing API")
    return
end

--================ LIB =================--
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Blind Bomber ESP",
    LoadingTitle = "Blind Bomber",
    LoadingSubtitle = "ESP Loaded",
    ConfigurationSaving = {
        Enabled = false
    }
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
    CurrentValue = false,
    Callback = function(v)
        ESP_PLAYER = v
    end
})

Tab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = false,
    Callback = function(v)
        ESP_NAME = v
    end
})

Tab:CreateToggle({
    Name = "ESP Bomb",
    CurrentValue = false,
    Callback = function(v)
        ESP_BOMB = v
    end
})

Tab:CreateToggle({
    Name = "ESP Bomb Holder",
    CurrentValue = false,
    Callback = function(v)
        ESP_HOLDER = v
    end
})

--================ ESP CORE =================--
local cache = {}

local function clear(plr)
    if cache[plr] then
        for _,d in pairs(cache[plr]) do
            d:Remove()
        end
        cache[plr] = nil
    end
end

Players.PlayerRemoving:Connect(clear)

RunService.RenderStepped:Connect(function()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if not cache[plr] then
                cache[plr] = {
                    box = Drawing.new("Square"),
                    name = Drawing.new("Text")
                }
            end

            local box = cache[plr].box
            local name = cache[plr].name

            -- check bomb holder
            local isHolder = false
            for _,tool in ipairs(plr.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():find("bomb") then
                    isHolder = true
                end
            end

            local color = isHolder and Color3.new(1,0,0) or Color3.new(0,1,0)

            -- BOX
            if ESP_PLAYER and onScreen then
                local size = 2000 / pos.Z
                box.Size = Vector2.new(size, size * 1.5)
                box.Position = Vector2.new(pos.X - size/2, pos.Y - size)
                box.Color = color
                box.Thickness = 2
                box.Visible = true
            else
                box.Visible = false
            end

            -- NAME
            if ESP_NAME and onScreen then
                name.Text = plr.Name
                name.Size = 16
                name.Center = true
                name.Outline = true
                name.Position = Vector2.new(pos.X, pos.Y - 60)
                name.Color = color
                name.Visible = true
            else
                name.Visible = false
            end
        else
            clear(plr)
        end
    end

    -- ESP BOMB MAP
    if ESP_BOMB then
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Tool") and v.Name:lower():find("bomb") and v:FindFirstChild("Handle") then
                local p, vis = Camera:WorldToViewportPoint(v.Handle.Position)
                if vis then
                    local t = Drawing.new("Text")
                    t.Text = "💣 BOMB"
                    t.Size = 14
                    t.Center = true
                    t.Outline = true
                    t.Color = Color3.new(1,0,0)
                    t.Position = Vector2.new(p.X, p.Y)
                    task.delay(0.05, function()
                        t:Remove()
                    end)
                end
            end
        end
    end
end)
