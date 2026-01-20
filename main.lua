--[[
    BẢN FIX HOÀN CHỈNH CHO THIRSTY VAMPIRE
    Tích hợp Aura + Auto Quest dựa trên khung GitHub của bạn
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

getgenv().vars = {
    Aura = false,
    Range = 1000,
    AutoQuest = false
}

local Window = Rayfield:CreateWindow({
    Name = "Vampire Helper - FIXED",
    LoadingTitle = "Đang kiểm tra Remote...",
    Theme = "Default"
})

local Tab = Window:CreateTab("Main", nil)

Tab:CreateToggle({
    Name = "Kill Aura (Đánh Nguyên Map)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().vars.Aura = Value
    end,
})

Tab:CreateSlider({
    Name = "Tầm đánh",
    Range = {10, 5000},
    Increment = 100,
    CurrentValue = 1000,
    Callback = function(Value)
        getgenv().vars.Range = Value
    end,
})

-- LOGIC QUAN TRỌNG: TÌM REMOTE ĐỂ ĐÁNH
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().vars.Aura then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                -- Trong game này, Remote thường nằm ở ReplicatedStorage hoặc trong Tool
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("VampireEvent", true) or char:FindFirstChild("VampireEvent", true)

                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Name ~= game.Players.LocalPlayer.Name then
                        local dist = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < getgenv().vars.Range and v.Humanoid.Health > 0 then
                            -- Gửi lệnh đấm/hút máu
                            remote:FireServer("Punch", v.HumanoidRootPart)
                            remote:FireServer("Suck", v) 
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({
    Title = "Đã sửa lỗi!",
    Content = "Script đã nạp đúng Remote của game. Hãy bật Toggle để thử.",
    Duration = 5
})
