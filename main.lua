--[[
    THIRSTY VAMPIRE - AUTO FARM COIN & CHEST
    Tích hợp vào khung logic của bạn
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local lp = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

getgenv().vars = {
    AutoFarmCoin = false,
    FarmSpeed = 100 -- Tốc độ di chuyển khi farm
}

-- Hàm di chuyển mượt (Tween) để không bị Kick vì Teleport
local function tweenTo(targetCFrame)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = lp.Character.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local info = TweenInfo.new(distance / getgenv().vars.FarmSpeed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

local Window = Rayfield:CreateWindow({
    Name = "Vampire Coin Hub",
    LoadingTitle = "Preparing Coin Collector...",
    Theme = "Default"
})

local Tab = Window:CreateTab("Farming", nil)

Tab:CreateToggle({
    Name = "Auto Collect Coins/Chests",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().vars.AutoFarmCoin = Value
    end,
})

Tab:CreateSlider({
    Name = "Tween Speed",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 100,
    Callback = function(Value)
        getgenv().vars.FarmSpeed = Value
    end,
})

-- LOGIC FARM COIN
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().vars.AutoFarmCoin then
            pcall(function()
                -- Tìm các vật phẩm Coin hoặc Chest trong Workspace
                -- Lưu ý: Tên "Coin" hoặc "Chest" có thể thay đổi tùy bản update, script sẽ quét từ khóa
                for _, obj in pairs(game.Workspace:GetChildren()) do
                    if getgenv().vars.AutoFarmCoin == false then break end
                    
                    if obj.Name:lower():find("coin") or obj.Name:lower():find("chest") or obj:FindFirstChild("TouchInterest") then
                        if obj:IsA("BasePart") or obj:FindFirstChildOfClass("BasePart") then
                            local targetPart = obj:IsA("BasePart") and obj or obj:FindFirstChildOfClass("BasePart")
                            
                            -- Bay đến chỗ Coin/Chest
                            local tw = tweenTo(targetPart.CFrame)
                            if tw then tw.Completed:Wait() end
                            
                            -- Đợi một chút để game nhận vật phẩm
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({
    Title = "Auto Farm Ready",
    Content = "Script sẽ tự động tìm rương và coin trên map để gom!",
    Duration = 5
})
