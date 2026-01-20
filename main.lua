--[[
    SCRIPT: DON'T PRESS THE BUTTON 4 - ULTIMATE HUB
    VERSION: 3.6 (FIXED LOADING)
    AUTHOR: TRAN HUU TAI & GEMINI AI
]]

-- == [1. KHỞI TẠO HỆ THỐNG & FIX LOAD] ==
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
end)

if not success or not OrionLib then
    -- Nếu link chính lỗi, thử link dự phòng hoặc thông báo
    warn("Lỗi tải Orion Library! Đang thử lại...")
    OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer

-- Đợi nhân vật load hoàn toàn
local function getCharacter()
    return LP.Character or LP.CharacterAdded:Wait()
end

-- == [2. QUẢN LÝ BIẾN TOÀN CỤC] ==
_G.Settings = {
    AutoWin = false,
    AutoPress = false,
    AutoFarmCoins = false,
    SafeHeight = 1500,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    ButtonHighlight = false
}

-- == [3. HÀM HỖ TRỢ] ==
local function Notify(title, text)
    OrionLib:MakeNotification({
        Name = title,
        Content = text,
        Image = "rbxassetid://4483345998",
        Time = 4
    })
end

local function CreateSafePlatform()
    local platName = "SafeZone_Platform"
    if Workspace:FindFirstChild(platName) then Workspace[platName]:Destroy() end
    
    local platform = Instance.new("Part")
    platform.Name = platName
    platform.Size = Vector3.new(100, 2, 100)
    platform.Position = Vector3.new(0, _G.Settings.SafeHeight, 0)
    platform.Anchored = true
    platform.Transparency = 0.5
    platform.BrickColor = BrickColor.new("Bright bluish green")
    platform.Material = Enum.Material.ForceField
    platform.Parent = Workspace
    return platform
end

-- == [4. LOGIC CHỨC NĂNG] ==

-- Smart Auto Win
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.AutoWin then
            pcall(function()
                local char = getCharacter()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if hrp.Position.Y < (_G.Settings.SafeHeight - 10) then
                        hrp.CFrame = CFrame.new(hrp.Position.X, _G.Settings.SafeHeight + 5, hrp.Position.Z)
                    end
                    if not Workspace:FindFirstChild("SafeZone_Platform") then
                        CreateSafePlatform()
                    end
                end
            end)
        end
    end
end)

-- Auto Press
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.AutoPress then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("ClickDetector") or v:IsA("ProximityPrompt") then
                    if v.Parent.Name:lower():find("button") then
                        if v:IsA("ClickDetector") then fireclickdetector(v)
                        else fireproximityprompt(v) end
                    end
                end
            end
        end
    end
end)

-- Auto Farm
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.AutoFarmCoins and not _G.Settings.AutoWin then
            pcall(function()
                for _, coin in pairs(Workspace:GetDescendants()) do
                    if (coin.Name == "Coin" or coin.Name == "Point") and coin:IsA("BasePart") then
                        getCharacter().HumanoidRootPart.CFrame = coin.CFrame
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
end)

-- Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.Settings.InfJump then
        local char = getCharacter()
        if char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

-- == [5. GIAO DIỆN UI] ==
local Window = OrionLib:MakeWindow({
    Name = "AI Hub | DPTB 4",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AI_Hub_Data"
})

local FarmTab = Window:MakeTab({ Name = "Farm & Win", Icon = "rbxassetid://4483345998" })

FarmTab:AddToggle({
    Name = "Smart Auto Win (Né thảm họa)",
    Default = false,
    Callback = function(v)
        _G.Settings.AutoWin = v
        if v then CreateSafePlatform() else
            if Workspace:FindFirstChild("SafeZone_Platform") then Workspace.SafeZone_Platform:Destroy() end
        end
    end
})

FarmTab:AddSlider({
    Name = "Độ cao an toàn",
    Min = 500, Max = 5000, Default = 1500, Increment = 100,
    Callback = function(v) _G.Settings.SafeHeight = v end
})

FarmTab:AddToggle({
    Name = "Auto Press Button",
    Default = false,
    Callback = function(v) _G.Settings.AutoPress = v end
})

FarmTab:AddToggle({
    Name = "Auto Farm Coins",
    Default = false,
    Callback = function(v) _G.Settings.AutoFarmCoins = v end
})

local PlayerTab = Window:MakeTab({ Name = "Nhân vật", Icon = "rbxassetid://4483345998" })

PlayerTab:AddSlider({
    Name = "Tốc độ chạy",
    Min = 16, Max = 300, Default = 16, Increment = 1,
    Callback = function(v) getCharacter().Humanoid.WalkSpeed = v end
})

PlayerTab:AddToggle({
    Name = "Nhảy vô hạn",
    Default = false,
    Callback = function(v) _G.Settings.InfJump = v end
})

local SettingTab = Window:MakeTab({ Name = "Hệ thống", Icon = "rbxassetid://4483345998" })

SettingTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in pairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            end
        end
    end
})

OrionLib:Init()
Notify("AI Hub", "Script đã sẵn sàng!")
