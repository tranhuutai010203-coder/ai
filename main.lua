--[[ 
    DON'T PRESS THE BUTTON 4 - MOBILE FIX (RAYFIELD)
    - Fix đơ cảm ứng 100%
    - Tối ưu hóa cho Executor Mobile
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "AI HUB | DPTB 4",
   LoadingTitle = "Đang khởi chạy...",
   LoadingSubtitle = "by Tran Huu Tai",
   ConfigurationSaving = {
      Enabled = false -- Tắt để tránh đơ do lưu file
   }
})

local LP = game:GetService("Players").LocalPlayer
local _G = {
    AutoWin = false,
    AutoPress = false,
    SafeHeight = 1500
}

-- Hàm tạo sàn an toàn
local function CreatePlatform()
    local name = "SafeZone_AI"
    if workspace:FindFirstChild(name) then workspace[name]:Destroy() end
    local p = Instance.new("Part", workspace)
    p.Name = name
    p.Size = Vector3.new(100, 2, 100)
    p.Anchored = true
    p.Position = Vector3.new(0, _G.SafeHeight, 0)
    p.Material = Enum.Material.ForceField
    p.BrickColor = BrickColor.new("Electric blue")
    return p
end

-- Tab Chức Năng
local MainTab = Window:CreateTab("Chức Năng", 4483345998)

MainTab:CreateToggle({
   Name = "Auto Win (Né thảm họa)",
   CurrentValue = false,
   Flag = "ToggleWin",
   Callback = function(Value)
      _G.AutoWin = Value
      if Value then
         CreatePlatform()
         task.spawn(function()
            while _G.AutoWin do
               task.wait(0.5)
               pcall(function()
                  local hrp = LP.Character.HumanoidRootPart
                  if hrp.Position.Y < (_G.SafeHeight - 10) then
                     hrp.CFrame = CFrame.new(hrp.Position.X, _G.SafeHeight + 5, hrp.Position.Z)
                  end
               end)
            end
         end)
      else
         if workspace:FindFirstChild("SafeZone_AI") then workspace.SafeZone_AI:Destroy() end
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Press (Tự nhấn nút)",
   CurrentValue = false,
   Flag = "TogglePress",
   Callback = function(Value)
      _G.AutoPress = Value
      task.spawn(function()
         while _G.AutoPress do
            task.wait(0.5)
            for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("ClickDetector") or v:IsA("ProximityPrompt") then
                  if v.Parent.Name:lower():find("button") then
                     if v:IsA("ClickDetector") then fireclickdetector(v)
                     else fireproximityprompt(v) end
                  end
               end
            end
         end
      end)
   end,
})

-- Tab Người Chơi
local PlayerTab = Window:CreateTab("Người Chơi", 4483345998)

PlayerTab:CreateSlider({
   Name = "Tốc độ chạy",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      pcall(function() LP.Character.Humanoid.WalkSpeed = Value end)
   end,
})

PlayerTab:CreateButton({
   Name = "Reset Nhân Vật",
   Callback = function()
      LP.Character:BreakJoints()
   end,
})
