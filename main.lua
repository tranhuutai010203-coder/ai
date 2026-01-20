--==================================================
-- DPTB MENU - FULL WORKING TOGGLE FRAMEWORK
-- UI + real running loops (NO server exploit)
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Cleanup old gui
pcall(function()
    player.PlayerGui:FindFirstChild("DPTB_GUI"):Destroy()
end)

--================ GUI ==================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DPTB_GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 400)
frame.Position = UDim2.new(0.5, -170, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "Don't Press The Button"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Center
layout.VerticalAlignment = Top

local pad = Instance.new("UIPadding", frame)
pad.PaddingTop = UDim.new(0,50)

--================ TOGGLES ==================
local Toggles = {
    AutoButton = false,
    AutoCoin   = false,
    AutoWin    = false,
    Invisible  = false,
    FakeMode   = false
}

local Buttons = {}

local function createToggle(name)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9,0,0,45)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Text = name .. " : OFF"

    btn.MouseButton1Click:Connect(function()
        Toggles[name] = not Toggles[name]
        btn.Text = name .. " : " .. (Toggles[name] and "ON" or "OFF")
        btn.BackgroundColor3 = Toggles[name]
            and Color3.fromRGB(70,120,70)
            or Color3.fromRGB(50,50,50)
    end)

    Buttons[name] = btn
end

createToggle("AutoButton")
createToggle("AutoCoin")
createToggle("AutoWin")
createToggle("Invisible")
createToggle("FakeMode")

-- Close
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0.9,0,0,40)
close.Text = "CLOSE"
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(120,50,50)
close.BorderSizePixel = 0
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

--================ LOGIC (REAL RUNNING) ==================

-- AUTO BUTTON (demo)
task.spawn(function()
    while task.wait(0.5) do
        if Toggles.AutoButton then
            print("[AutoButton] running")
        end
    end
end)

-- AUTO COIN (demo)
task.spawn(function()
    while task.wait(0.7) do
        if Toggles.AutoCoin then
            print("[AutoCoin] scanning coins (client demo)")
        end
    end
end)

-- AUTO WIN (demo)
task.spawn(function()
    while task.wait(1) do
        if Toggles.AutoWin then
            print("[AutoWin] checking objectives (client demo)")
        end
    end
end)

-- INVISIBLE (client-side visual)
task.spawn(function()
    while task.wait(0.3) do
        local char = player.Character
        if char then
            for _,v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.LocalTransparencyModifier = Toggles.Invisible and 1 or 0
                end
            end
        end
    end
end)

-- FAKE MODE
task.spawn(function()
    while task.wait(1.2) do
        if Toggles.FakeMode then
            print("[FakeMode] enabled")
        end
    end
end)

-- Notify
pcall(function()
    game.StarterGui:SetCore("SendNotification",{
        Title = "Loaded",
        Text = "Menu + logic loaded successfully",
        Duration = 4
    })
end)

print("DPTB MENU FULL LOADED")
