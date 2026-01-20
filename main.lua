--[[ 
    DON'T PRESS THE BUTTON 4 - SMART HUB PRO
    - Logic: Auto Teleport to Win & Smart Safe Zone
    - Library: Rayfield
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "AI HUB | DPTB 4 PRO",
   LoadingTitle = "Đang cấu hình Smart Logic...",
   LoadingSubtitle = "by Tran Huu Tai",
   ConfigurationSaving = { Enabled = false }
})

-- == HỆ THỐNG BIẾN ==
local LP = game:GetService("Players").LocalPlayer
local _G = {
    AutoWin = false,
    AutoPress = false,
    SafeHeight = 1500
}

-- == HÀM HỖ TRỢ ==
local function CreatePlatform()
    local name = "SmartSafeZone_Part"
    if workspace:FindFirstChild(name) then workspace[name]:Destroy() end
    local p = Instance.new("Part", workspace)
    p.Name = name
    p.Size = Vector3.new(50, 2, 50)
    p.Anchored = true
    p.Position = Vector3.new(0, _G.SafeHeight, 0)
    p.Transparency = 0.5
    p.BrickColor = BrickColor.new("Electric blue")
    return p
end

-- == LOGIC THÔNG MINH ==

-- 1. SMART AUTO WIN (Tele Đích hoặc Tele Trời)
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.AutoWin then
            pcall(function()
                local hrp = LP.Character.HumanoidRootPart
                -- Tìm khu vực Đích (Thường là WinZone hoặc EndPart trong DPTB4)
                local WinPart = workspace:FindFirstChild("WinPart") or workspace:FindFirstChild("EndPart") or workspace:FindFirstChild("WinnerPart")
                
                -- Kiểm tra nếu có thảm họa (Disaster) đang diễn ra
                -- Trong DPTB4, khi có thảm họa, map thường xuất hiện các vật thể lạ hoặc folder Disaster
                local DisasterActive = workspace:FindFirstChild("Disasters") or workspace:FindFirstChild("Events")
                
                if DisasterActive and #DisasterActive:GetChildren() > 0 then
                    -- NẾU CÓ THẢM HỌA: Tele lên trời né
                    if hrp.Position.Y < (_G.SafeHeight - 10) then
                        hrp.CFrame = CFrame.new(0, _G.SafeHeight + 5, 0)
                    end
                    if not workspace:FindFirstChild("SmartSafeZone_Part") then CreatePlatform() end
                elseif WinPart then
                    -- NẾU KHÔNG CÓ THẢM HỌA: Tele thẳng đến chỗ thắng
                    hrp.CFrame = WinPart.CFrame + Vector3.new(0, 3, 0)
                end
            end)
        end
    end
end)

-- 2. AUTO PRESS BUTTON (Fix lỗi không ấn được)
task.spawn(function()
    while task.wait(0.3) do -- Tăng tốc độ quét
        if _G.Settings.AutoPress then
            pcall(function()
                -- Tìm tất cả các nút trong game
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ClickDetector") or v:IsA("ProximityPrompt") then
                        -- Kiểm tra nếu tên cha là Button hoặc có hình dáng nút
                        if v.Parent.Name:lower():find("button") or v.Parent:IsA("Model") then
                            -- Kiểm tra khoảng cách để đảm bảo Executor có thể tương tác
                            if v:IsA("ClickDetector") then 
                                fireclickdetector(v)
                            elseif v:IsA("ProximityPrompt") then
                                fireproximityprompt(v)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- == GIAO DIỆN ==
local MainTab = Window:CreateTab("Chức Năng Chính", 4483345998)

MainTab:CreateToggle({
   Name = "Smart Auto Win (Đích/Trời)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Settings.AutoWin = Value
      if not Value and workspace:FindFirstChild("SmartSafeZone_Part") then
         workspace.SmartSafeZone_Part:Destroy()
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Press Button (Đã Fix)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Settings.AutoPress = Value
   end,
})

MainTab:CreateSlider({
   Name = "Độ cao né thảm họa",
   Range = {500, 5000},
   Increment = 100,
   CurrentValue = 1500,
   Callback = function(Value) _G.SafeHeight = Value end,
})

local PlayerTab = Window:CreateTab("Người Chơi", 4483345998)
PlayerTab:CreateSlider({
   Name = "Tốc độ chạy",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) pcall(function() LP.Character.Humanoid.WalkSpeed = v end) end,
})

Rayfield:LoadConfiguration()
