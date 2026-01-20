--// Blind Bomber ESP Script
--// by ChatGPT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--================ GUI =================--
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local UIList = Instance.new("UIListLayout", Frame)

Frame.Size = UDim2.new(0, 200, 0, 180)
Frame.Position = UDim2.new(0, 20, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.Active = true
Frame.Draggable = true

local function Button(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 30)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = Frame
    return b
end

local ESP_Player = false
local ESP_Name = false
local ESP_Bomb = false
local ESP_BombHolder = false

Button("ESP PLAYER").MouseButton1Click:Connect(function()
    ESP_Player = not ESP_Player
end)

Button("ESP NAME").MouseButton1Click:Connect(function()
    ESP_Name = not ESP_Name
end)

Button("ESP BOMB").MouseButton1Click:Connect(function()
    ESP_Bomb = not ESP_Bomb
end)

Button("ESP BOMB HOLDER").MouseButton1Click:Connect(function()
    ESP_BombHolder = not ESP_BombHolder
end)

--================ DRAWING =================--
local Drawings = {}

local function Clear(plr)
    if Drawings[plr] then
        for _,v in pairs(Drawings[plr]) do
            v:Remove()
        end
        Drawings[plr] = nil
    end
end

RunService.RenderStepped:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if not Drawings[plr] then
                Drawings[plr] = {
                    Box = Drawing.new("Square"),
                    Name = Drawing.new("Text")
                }
            end

            local box = Drawings[plr].Box
            local name = Drawings[plr].Name

            if onScreen and ESP_Player then
                local size = 2000 / pos.Z
                box.Size = Vector2.new(size, size*1.5)
                box.Position = Vector2.new(pos.X - size/2, pos.Y - size)
                box.Color = Color3.new(0,1,0)
                box.Thickness = 2
                box.Visible = true
            else
                box.Visible = false
            end

            -- ESP NAME
            if onScreen and ESP_Name then
                name.Text = plr.Name
                name.Size = 16
                name.Position = Vector2.new(pos.X, pos.Y - 60)
                name.Center = true
                name.Color = Color3.new(1,1,1)
                name.Visible = true
            else
                name.Visible = false
            end
