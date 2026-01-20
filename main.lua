--[[
    THIRSTY VAMPIRE - FINAL FIX (NGUYÊN MAP)
    Dán nội dung này vào Executor của bạn
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local lp = game.Players.LocalPlayer

getgenv().vars = {
    Aura = false,
    Distance = 2000 -- Tầm đánh nguyên map
}

local Window = Rayfield:CreateWindow({
    Name = "Vampire Ultra Hub",
    LoadingTitle = "Fixing Attack Logic...",
    Theme = "Default"
})

local Tab = Window:CreateTab("Main", nil)

Tab:CreateToggle({
    Name = "Kill Aura (Đánh Toàn Map)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().vars.Aura = Value
    end,
})

-- LOGIC TẤN CÔNG CHÍNH XÁC
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().vars.Aura then
            pcall(function()
                local char = lp.Character
                -- Tìm RemoteEvent nằm trong folder Vampire của nhân vật
                local vFolder = char:FindFirstChild("Vampire")
                local remote = vFolder and vFolder:FindFirstChild("VampireEvent")

                if remote then
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        -- Tìm mục tiêu là NPC hoặc Player khác
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= char then
                            local targetHrp = v.HumanoidRootPart
                            local dist = (char.HumanoidRootPart.Position - targetHrp.Position).Magnitude
                            
                            if dist <= getgenv().vars.Distance and v.Humanoid.Health > 0 then
                                -- BƯỚC 1: KÍCH HOẠT TRẠNG THÁI ĐÁNH (BẮT BUỘC)
                                remote:FireServer("Charging")
                                remote:FireServer("Punch")
                                
                                -- BƯỚC 2: GỬI DỮ LIỆU SÁT THƯƠNG (DÙNG TABLE NHƯ CODE BẠN GỬI)
                                remote:FireServer("PunchHit", {
                                    ["hit"] = targetHrp
                                })
                                
                                -- BƯỚC 3: HÚT MÁU (NẾU LÀ VAMPIRE)
                                remote:FireServer("Suck", v)
                                
                                -- BƯỚC 4: KẾT THÚC TRẠNG THÁI
                                remote:FireServer("CancelCharging")
                            end
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({
    Title = "Đã Fix Lỗi Tấn Công",
    Content = "Hãy bật Aura và đứng gần quái/người chơi để thử nghiệm.",
    Duration = 5
})
