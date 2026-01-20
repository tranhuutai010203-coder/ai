--[[
    THIRSTY VAMPIRE - AUTO FARM COIN (PRO VERSION)
    Tự động bay đến và thực hiện lệnh nhặt (Click/E/Touch)
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local lp = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

getgenv().vars = {
    AutoCoin = false,
    Speed = 150
}

local function tweenTo(targetCFrame)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = lp.Character.HumanoidRootPart
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    local info = TweenInfo.new(dist / getgenv().vars.Speed, Enum.EasingStyle.Linear)
    local tw = TweenService:Create(hrp, info, {CFrame = targetCFrame})
    tw:Play()
    return tw
end

local Window = Rayfield:CreateWindow({
    Name = "Vampire Collector",
    LoadingTitle = "Checking Coin Logic...",
    Theme = "Default"
})

local Tab = Window:CreateTab("Farm Money", nil)

Tab:CreateToggle({
    Name = "Auto Farm Coin/Chest",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().vars.AutoCoin = Value
    end,
})

-- LOGIC NHẶT TIỀN TỔNG HỢP
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().vars.AutoCoin then
            pcall(function()
                for _, obj in pairs(game.Workspace:GetDescendants()) do
                    if not getgenv().vars.AutoCoin then break end

                    -- Kiểm tra xem vật phẩm có phải là Coin/Money/Chest không
                    if obj.Name:lower():find("coin") or obj.Name:lower():find("money") or obj.Name:lower():find("chest") then
                        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                        
                        if part then
                            -- 1. Bay đến mục tiêu
                            local tw = tweenTo(part.CFrame * CFrame.new(0, 2, 0)) -- Bay cao hơn một chút tránh kẹt map
                            if tw then tw.Completed:Wait() end
                            
                            -- 2. Thực hiện mọi cách nhặt:
                            -- Cách A: Nhấn chuột (ClickDetector)
                            local cd = obj:FindFirstChildOfClass("ClickDetector") or part:FindFirstChildOfClass("ClickDetector")
                            if cd then fireclickdetector(cd) end
                            
                            -- Cách B: Nhấn phím E (ProximityPrompt)
                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or part:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then fireproximityprompt(prompt) end
                            
                            -- Cách C: Chạm trực tiếp (Touch)
                            firetouchinterest(lp.Character.HumanoidRootPart, part, 0)
                            firetouchinterest(lp.Character.HumanoidRootPart, part, 1)
                            
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end
end)
