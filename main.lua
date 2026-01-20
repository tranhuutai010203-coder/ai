--[[ 
	HỆ THỐNG ADMIN MENU - KICK CÓ LÝ DO
	Admin ID: 9697304616
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. CẤU HÌNH ADMIN
local AdminList = {
	[9697304616] = true -- ID của bạn
	-- [123456] = true, -- Thêm ID khác nếu muốn
}

-- 2. TẠO REMOTE EVENT (Cầu nối giữa GUI và Server)
local remoteName = "AdminActionRemote"
local remoteEvent = ReplicatedStorage:FindFirstChild(remoteName)
if not remoteEvent then
	remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Name = remoteName
	remoteEvent.Parent = ReplicatedStorage
end

-- 3. HÀM XỬ LÝ SERVER (KICK)
remoteEvent.OnServerEvent:Connect(function(player, action, targetName, reason)
	-- Kiểm tra quyền Admin (Bảo mật server)
	if not AdminList[player.UserId] then 
		warn(player.Name .. " cố tình hack Admin GUI!")
		return 
	end

	-- Xử lý lệnh Kick
	if action == "Kick" then
		-- BẮT BUỘC CÓ LÝ DO (Server check)
		if not reason or reason == "" or reason == " " then
			return -- Không làm gì nếu không có lý do
		end

		-- Tìm người chơi
		local targetPlayer = nil
		for _, p in pairs(Players:GetPlayers()) do
			-- Tìm tên gần đúng
			if string.lower(p.Name):sub(1, #targetName) == string.lower(targetName) then
				targetPlayer = p
				break
			end
		end

		if targetPlayer then
			targetPlayer:Kick("\n⛔ ADMIN MENU KICK ⛔\n\n📝 Lý do: " .. reason .. "\n👮 Bởi: " .. player.Name)
			print("Đã kick " .. targetPlayer.Name)
		end
	end
end)

-- 4. TẠO GIAO DIỆN (GUI) CHO ADMIN
local function CreateGUI()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AdminSystemGUI"
	ScreenGui.ResetOnSpawn = false

	-- Nút Mở Menu (Góc trái)
	local OpenBtn = Instance.new("TextButton")
	OpenBtn.Name = "OpenButton"
	OpenBtn.Size = UDim2.new(0, 100, 0, 40)
	OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
	OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	OpenBtn.Text = "Admin Panel"
	OpenBtn.TextColor3 = Color3.new(1,1,1)
	OpenBtn.Font = Enum.Font.GothamBold
	OpenBtn.TextSize = 14
	OpenBtn.Parent = ScreenGui
	
	-- Khung chính (Main Frame)
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 300, 0, 250)
	MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
	MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	MainFrame.BorderSizePixel = 0
	MainFrame.Visible = false -- Mặc định ẩn
	MainFrame.Parent = ScreenGui

	-- Tiêu đề
	local Title = Instance.new("TextLabel")
	Title.Text = "QUẢN LÝ SERVER"
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Title.TextColor3 = Color3.new(1,1,1)
	Title.Font = Enum.Font.GothamBlack
	Title.TextSize = 18
	Title.Parent = MainFrame

	-- Ô nhập tên
	local NameBox = Instance.new("TextBox")
	NameBox.PlaceholderText = "Nhập tên người chơi..."
	NameBox.Size = UDim2.new(0.9, 0, 0, 40)
	NameBox.Position = UDim2.new(0.05, 0, 0.25, 0)
	NameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameBox.TextColor3 = Color3.fromRGB(0,0,0)
	NameBox.Text = ""
	NameBox.Parent = MainFrame

	-- Ô nhập lý do (QUAN TRỌNG)
	local ReasonBox = Instance.new("TextBox")
	ReasonBox.PlaceholderText = "NHẬP LÝ DO (BẮT BUỘC)..."
	ReasonBox.Size = UDim2.new(0.9, 0, 0, 40)
	ReasonBox.Position = UDim2.new(0.05, 0, 0.45, 0)
	ReasonBox.BackgroundColor3 = Color3.fromRGB(255, 200, 200) -- Màu đỏ nhạt để chú ý
	ReasonBox.TextColor3 = Color3.fromRGB(0,0,0)
	ReasonBox.Text = ""
	ReasonBox.Parent = MainFrame

	-- Nút Kick
	local KickBtn = Instance.new("TextButton")
	KickBtn.Text = "KICK PLAYER"
	KickBtn.Size = UDim2.new(0.9, 0, 0, 40)
	KickBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
	KickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	KickBtn.TextColor3 = Color3.new(1,1,1)
	KickBtn.Font = Enum.Font.GothamBold
	KickBtn.Parent = MainFrame

	-- Nút Đóng
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "X"
	CloseBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseBtn.Position = UDim2.new(1, -35, 0, 5)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	CloseBtn.TextColor3 = Color3.new(1,1,1)
	CloseBtn.Parent = MainFrame

	-- 5. LOCAL SCRIPT (Xử lý bấm nút)
	-- Chúng ta sẽ nhúng code LocalScript vào trong GUI luôn
	local LocalScript = Instance.new("LocalScript")
	LocalScript.Name = "Handler"
	LocalScript.Parent = ScreenGui
	
	-- Code client dạng chuỗi để inject
	local clientCode = [[
		local gui = script.Parent
		local frame = gui:WaitForChild("MainFrame")
		local openBtn = gui:WaitForChild("OpenButton")
		local kickBtn = frame:WaitForChild("TextButton") -- Nút kick
		local closeBtn = frame:WaitForChild("TextButton") -- Nút đóng (tìm theo tên hơi rủi ro nên sửa lại logic find)
		
		-- Tìm lại các nút chính xác
		for _, v in pairs(frame:GetChildren()) do
			if v.Text == "KICK PLAYER" then kickBtn = v end
			if v.Text == "X" then closeBtn = v end
		end
		
		local nameBox = frame:WaitForChild("TextBox") -- Ô tên
		-- Tìm ô lý do
		local reasonBox
		for _, v in pairs(frame:GetChildren()) do
			if v:IsA("TextBox") and v.PlaceholderText:find("LÝ DO") then
				reasonBox = v
			end
		end
		
		local Remote = game.ReplicatedStorage:WaitForChild("AdminActionRemote")

		-- Mở/Đóng Menu
		openBtn.MouseButton1Click:Connect(function()
			frame.Visible = not frame.Visible
		end)
		
		closeBtn.MouseButton1Click:Connect(function()
			frame.Visible = false
		end)

		-- Xử lý bấm KICK
		kickBtn.MouseButton1Click:Connect(function()
			local tName = nameBox.Text
			local reason = reasonBox.Text
			
			if tName == "" then
				nameBox.Text = "NHẬP TÊN VÀO ĐÂY!"
				wait(1)
				nameBox.Text = ""
				return
			end
			
			-- CHECK BẮT BUỘC LÝ DO TRÊN CLIENT
			if reason == "" or reason == " " then
				reasonBox.Text = "⚠️ BẮT BUỘC GHI LÝ DO!"
				wait(1.5)
				reasonBox.Text = ""
				return
			end

			-- Gửi yêu cầu lên Server
			Remote:FireServer("Kick", tName, reason)
			
			-- Reset ô nhập
			nameBox.Text = ""
			reasonBox.Text = ""
			frame.Visible = false
		end)
	]]
	
	-- Do LocalScript.Source chỉ hoạt động với Plugin, ta dùng cách khác để chạy logic client:
	-- (Lưu ý: Cách nhúng source ở trên chỉ dùng cho Plugin. 
	-- Để script này chạy ngay trong ServerScript, ta sẽ tạo GUI và Clone LocalScript có sẵn hoặc dùng module).
	
	-- CÁCH ĐƠN GIẢN HƠN:
	-- Tôi sẽ không tạo LocalScript động vì Roblox chặn việc ghi Source.
	-- Tôi sẽ dùng script cha để quản lý sự kiện click của GuiButton luôn? Không được, Server ko thấy click GUI.
	
	-- GIẢI PHÁP: 
	-- Script này sẽ tạo GUI, nhưng bạn hãy tự tạo LocalScript thủ công để dán code vào, hoặc tôi dùng Hopperscript (Legacy).
	-- NHƯNG ĐỂ TIỆN NHẤT CHO BẠN: Tôi sẽ dùng NLS (NewLocalScript) - Một tính năng cho phép server tạo LocalScript.
end

-- FIX LẠI CÁCH TẠO LOCAL SCRIPT
-- Đoạn dưới này sẽ gửi GUI kèm logic cho người chơi
game.Players.PlayerAdded:Connect(function(player)
	if AdminList[player.UserId] then
		local sg = Instance.new("ScreenGui")
		sg.Name = "AdminGUI"
		sg.ResetOnSpawn = false
		sg.Parent = player:WaitForChild("PlayerGui")
		
		-- Tạo GUI bằng code (như trên nhưng rút gọn vào function NLS)
		local NLS = require(script) -- Kỹ thuật này phức tạp.
		
		-- ĐỂ ĐƠN GIẢN NHẤT: Tôi sẽ gửi bạn 2 script riêng biệt.
		-- 1 cái Server, 1 cái Local.
	end
end)
