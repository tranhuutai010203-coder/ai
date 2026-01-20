--[[ 
    Simple Menu Framework
    UI + Toggle ON/OFF (Client-side)
    No exploit logic inside
--]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Remove old GUI if reload
pcall(function()
    player.PlayerGui:FindFirstChild("DPTB_Menu"):Destroy()
end)

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "DPTB_Menu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 320, 0, 360)
frame.Position = UDim2.new(0.5, -160, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Don't Press The Button"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- Container
local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10)
list.Parent = frame
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.VerticalAlignment = Enum.VerticalAlignment.Top

local pad = Instance.new("UIPadding")
pad.Parent = frame
pad.PaddingTop = UDim.new(0, 50)

-- Toggle storage
local Toggles = {}

-- Toggle creator
local function createToggle(name)
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham

    Toggles[name] = false
    btn.Text = name .. " : OFF"

    btn.MouseButton1Click:Connect(function()
        Toggles[name] = not Toggles[name]
        btn.Text = name .. " : " .. (Toggles[name] and "ON" or "OFF")
        btn.BackgroundColor3 = Toggles[name]
            and Color3.fromRGB(70,120,70)
            or Color3.fromRGB(50,50,50)

        print("[TOGGLE]", name, Toggles[name])
    end)
end

-- Create toggles
createToggle("Auto Button")
createToggle("Auto Coin")
createToggle("Auto Win")
createToggle("Invisible")
createToggle("Fake Mode")

-- Close button
local close = Instance.new("TextButton")
close.Parent = frame
close.Size = UDim2.new(0.9, 0, 0, 40)
close.BackgroundColor3 = Color3.fromRGB(120,50,50)
close.BorderSizePixel = 0
close.Text = "CLOSE MENU"
close.TextColor3 = Color3.new(1,1,1)
close.TextScaled = true
close.Font = Enum.Font.GothamBold

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Notify load
pcall(function()
    game.StarterGui:SetCore("SendNotification",{
        Title = "Loaded",
        Text = "Menu loaded successfully",
        Duration = 4
    })
end)

print("MENU LOADED SUCCESSFULLY")
