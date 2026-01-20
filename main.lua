--[[ 
    DON'T PRESS THE BUTTON 4 - FIX CLICK UI
    Đã xóa bỏ SaveConfig để tránh kẹt Menu
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Khởi tạo Window với cấu hình tối giản để tránh đơ
local Window = OrionLib:MakeWindow({
    Name = "AI HUB | DPTB 4 (FIXED)", 
    HidePremium = true, 
    SaveConfig = false, -- Tắt cái này để tránh lỗi không ấn được
    IntroText = "Đang khởi tạo AI Hub..."
})

local LP = game:GetService("Players").LocalPlayer
local _G = {
    AutoWin = false,
    AutoPress = false,
    AutoFarm = false,
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

-- Tab chính
local Tab = Window:MakeTab({
    Name = "Chức Năng",
    Icon = "rbxassetid://4483345998"
})

Tab:AddToggle({
    Name = "Auto Win (Né thảm họa)",
    Default = false,
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
    end    
})

Tab:AddToggle({
    Name = "Auto Press (Tự nhấn nút)",
    Default = false,
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
    end    
})

Tab:AddSlider({
    Name = "Tốc độ chạy",
    Min = 16, Max = 300, Default = 16, Increment = 1,
    Callback = function(v) 
        pcall(function() LP.Character.Humanoid.WalkSpeed = v end) 
    end
})

OrionLib:Init()
