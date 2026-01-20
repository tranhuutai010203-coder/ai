local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cấu hình
local autoOpen = true -- Chuyển thành false nếu muốn dừng

RunService.RenderStepped:Connect(function()
    if autoOpen then
        -- Tìm tất cả các ProximityPrompt trong game
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                -- Kiểm tra khoảng cách giữa nhân vật và rương
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - prompt.Parent:GetModelCFrame().p).Magnitude
                    
                    -- Nếu đứng gần rương (dưới 15 feet), tự động kích hoạt
                    if distance < 15 then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end
end)
