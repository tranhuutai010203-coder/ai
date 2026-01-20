--[[
    Script cho game: First Is Owner
    Chức năng: Tạo Menu & Tìm Server Rỗng
]]

local Lyr = instance.new("ScreenGui")
local MainFrame = instance.new("Frame")
local Title = instance.new("TextLabel")
local HopBtn = instance.new("TextButton")
local CloseBtn = instance.new("TextButton")
local UICorner = instance.new("UICorner")

-- Thiết lập Giao diện (GUI)
Lyr.Name = "FirstIsOwnerMenu"
Lyr.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = Lyr
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Cho phép kéo menu đi chỗ khác

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "MENU CHỦ LẦM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

HopBtn.Name = "HopBtn"
HopBtn.Parent = MainFrame
HopBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
HopBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
HopBtn.Size = UDim2.new(0.8, 0, 0, 40)
HopBtn.Font = Enum.Font.SourceSans
HopBtn.Text = "Tìm Server Rỗng"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 18

local btnCorner = instance.new("UICorner")
btnCorner.Parent = HopBtn

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0.15, 0, 0.2, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextSize = 15

-- Chức năng Tìm Server Rỗng (Server Hop)
local function ServerHop()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local function GetServers(cursor)
        local url = Api .. (cursor and "&cursor=" .. cursor or "")
        -- Sử dụng proxy vì Roblox chặn gọi trực tiếp API từ client
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            return Http:JSONDecode(result)
        end
        return nil
    end

    local serverList = GetServers()
    if serverList and serverList.data then
        for _, server in pairs(serverList.data) do
            -- Kiểm tra server còn chỗ và không phải server hiện tại
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, server.id, game.Players.LocalPlayer)
                return
            end
        end
    end
    print("Không tìm thấy server phù hợp.")
end

-- Kết nối sự kiện
HopBtn.MouseButton1Click:Connect(function()
    HopBtn.Text = "Đang tìm..."
    ServerHop()
end)

CloseBtn.MouseButton1Click:Connect(function()
    Lyr:Destroy()
end)
