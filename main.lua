--[[ 
    DON'T PRESS THE BUTTON 4 - ULTIMATE MOBILE HUB
    - Library: Rayfield (Siêu mượt, không đơ cảm ứng)
    - Fix lỗi: got nil & liệt UI
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "AI HUB | Don't Press The Button 4",
   LoadingTitle = "Đang khởi chạy hệ thống...",
   LoadingSubtitle = "by Tran Huu Tai",
   ConfigurationSaving = {
      Enabled = false -- Tắt để tránh lỗi đơ khi tải file cấu hình
   },
   Discord = {
      Enabled = false
   }
})

-- == BIẾN CẤU HÌNH ==
local LP = game:GetService("Players").LocalPlayer
local _G = {
    AutoWin = false,
    AutoPress = false,
    AutoFarm = false,
    SafeHeight = 1500
}

-- == HÀM HỖ TRỢ ==
local function CreatePlatform()
    local name = "SafeZone_AI_Part"
    if workspace:FindFirstChild(name) then workspace[name]:Destroy() end
    local p = Instance.new("Part", workspace)
    p.Name = name
    p.Size = Vector3.new(100, 2, 100)
    p.Anchored = true
    p.Position = Vector3.new(0, _G.SafeHeight, 0)
    p.Material = Enum.Material.ForceField
    p.BrickColor = BrickColor.new("Electric blue")
    p.Transparency = 0.5
    return p
end

-- == CÁC TAB CHỨC NĂNG ==

-- TAB 1: CHÍNH
local MainTab = Window:CreateTab("Chức Năng", 4483345998)

MainTab:CreateToggle({
   Name = "Smart Auto Win (Né thảm họa)",
   CurrentValue = false,
   Flag = "AutoWinToggle",
   Callback = function(Value)
      _G.AutoWin = Value
      if Value then
         CreatePlatform()
         task.spawn(function()
            while _G.AutoWin do
               task.wait(0.5)
               pcall(function()
                  local hrp = LP.Character.HumanoidRootPart
                  -- Nếu nhân vật rơi khỏi bục hoặc ở thấp hơn bục an toàn
                  if hrp.Position.Y < (_G.SafeHeight - 10) then
                     hrp.CFrame = CFrame.new(hrp.Position.X, _G.SafeHeight + 5, hrp.Position.Z)
                  end
               end)
            end
         end)
      else
         if workspace:FindFirstChild("SafeZone_AI_Part") then 
            workspace.SafeZone_AI_Part:Destroy() 
         end
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Press (Tự nhấn nút)",
   CurrentValue = false,
   Flag = "AutoPressToggle",
   Callback = function(Value)
      _G.AutoPress = Value
      task.spawn(function()
         while _G.AutoPress do
            task.wait(0.5)
            for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("ClickDetector") or v:IsA("ProximityPrompt") then
                  if v.Parent.Name:lower():find("button") or v.Parent:IsA("Model") then
                     if v:IsA("ClickDetector") then 
                        fireclickdetector(v)
                     else 
                        fireproximityprompt(v) 
                     end
                  end
               end
            end
         end
      end)
   end,
})

MainTab:CreateSection("Cài đặt Safe Zone")

MainTab:CreateSlider({
   Name = "Độ cao an toàn",
   Range = {500, 5000},
   Increment = 100,
   Suffix = "Studs",
   CurrentValue = 1500,
   Flag = "HeightSlider",
   Callback = function(Value)
      _G.SafeHeight = Value
      if workspace:FindFirstChild("SafeZone_AI_Part") then
         workspace.SafeZone_AI_Part.Position = Vector3.new(0, Value, 0)
      end
   end,
})

-- TAB 2: NGƯỜI CHƠI
local PlayerTab = Window:CreateTab("Người Chơi", 4483345998)

PlayerTab:CreateSlider({
   Name = "Tốc độ chạy",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      pcall(function() LP.Character.Humanoid.WalkSpeed = Value end)
   end,
})

PlayerTab:CreateButton({
   Name = "Reset Nhân Vật",
   Callback = function()
      if LP.Character then LP.Character:BreakJoints() end
   end,
})

Rayfield:Notify({
   Title = "Tải Thành Công",
   Content = "Chúc bạn chơi game vui vẻ!",
   Duration = 5,
   Image = 4483345998,
})
