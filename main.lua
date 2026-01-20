--[[
    Thirsty Vampire - Full Aura & Auto Combat Script
    Dựa trên cấu trúc Remote: VampireEvent
]]

getgenv().vars = {
    AuraEnabled = false,
    AuraRange = 500, -- Khoảng cách đánh (Chỉnh cao để đánh nguyên map)
    AttackSpeed = 0.1,
    ESPEnabled = true
}

local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace")
}

local lp = Services.Players.LocalPlayer

-- Hàm lấy Remote Event từ Character
local function getVampireRemote()
    local char = lp.Character
    if not char then return nil end
    local vFolder = char:FindFirstChild("Vampire")
    return vFolder and vFolder:FindFirstChild("VampireEvent")
end

-- Hàm thực thi đòn đánh (Dựa trên logic của bạn)
local function performAttack(targetPart)
    local remote = getVampireRemote()
    if remote then
        -- Chu kỳ nạp và đánh để tránh bị hệ thống chặn
        remote:FireServer("Charging")
        remote:FireServer("CancelCharging")
        remote:FireServer("Punch")
        remote:FireServer("PunchHit", { hit = targetPart })
    end
end

-- Rayfield UI Setup
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Vampire Ultra Hub 2026",
    LoadingTitle = "Thirsty Vampire Script",
    LoadingSubtitle = "by Gemini AI",
    Theme = "DarkBlue"
})

local MainTab = Window:CreateTab("Combat", nil)

MainTab:CreateSection("Aura Settings")

MainTab:CreateToggle({
    Name = "Kill Aura (Multi-Target)",
    CurrentValue = getgenv().vars.AuraEnabled,
    Callback = function(Value)
        getgenv().vars.AuraEnabled = Value
    end,
})

MainTab:CreateSlider({
    Name = "Aura Range (Map Scale)",
    Range = {10, 5000},
    Increment = 50,
    Suffix = " studs",
    CurrentValue = getgenv().vars.AuraRange,
    Callback = function(Value)
        getgenv().vars.AuraRange = Value
    end,
})

MainTab:CreateSlider({
    Name = "Attack Speed",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = " sec",
    CurrentValue = getgenv().vars.AttackSpeed,
    Callback = function(Value)
        getgenv().vars.AttackSpeed = Value
    end,
})

-- Logic Aura Chạy Ngầm (Heartbeat tối ưu hơn Loop thường)
task.spawn(function()
    while true do
        if getgenv().vars.AuraEnabled then
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- Quét tất cả người chơi
                for _, player in ipairs(Services.Players:GetPlayers()) do
                    if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHrp = player.Character.HumanoidRootPart
                        local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                        
                        -- Kiểm tra khoảng cách và trạng thái sống
                        local distance = (hrp.Position - targetHrp.Position).Magnitude
                        if distance <= getgenv().vars.AuraRange and targetHum and targetHum.Health > 0 then
                            performAttack(targetHrp)
                        end
                    end
                end
            end
        end
        task.wait(getgenv().vars.AttackSpeed)
    end
end)

-- Thông báo khi Script load xong
Rayfield:Notify({
    Title = "Script Activated",
    Content = "Kill Aura đã sẵn sàng. Hãy cẩn thận với Anti-cheat!",
    Duration = 5,
    Image = 4483362458,
})
