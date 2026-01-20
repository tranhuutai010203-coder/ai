-- CẤU HÌNH ADMIN
local AdminList = {
	9697304616  -- Đã thêm ID của bạn từ link profile
	-- Nếu muốn thêm người khác, thêm dấu phẩy và ID của họ vào đây. VD: 9697304616, 12345678
}

local Prefix = "/" -- Ký tự bắt đầu lệnh

-- Hàm kiểm tra quyền Admin
local function isAdmin(player)
	for _, id in ipairs(AdminList) do
		if player.UserId == id then
			return true
		end
	end
	return false
end

-- Hàm tìm người chơi theo tên (viết tắt cũng được)
local function findPlayer(nameString)
	for _, player in ipairs(game.Players:GetPlayers()) do
		if string.lower(player.Name):sub(1, #nameString) == string.lower(nameString) then
			return player
		end
	end
	return nil
end

game.Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		-- 1. Kiểm tra quyền Admin
		if not isAdmin(player) then return end

		-- 2. Tách lệnh
		local args = string.split(message, " ")
		local command = args[1]

		-- 3. Xử lý lệnh KICK
		if string.lower(command) == Prefix .. "kick" then
			local targetName = args[2]
			
			-- Nối lý do từ từ thứ 3 trở đi
			local reason = table.concat(args, " ", 3)

			-- Kiểm tra tên
			if not targetName then
				warn("Thiếu tên người chơi!")
				return
			end

			-- --- QUAN TRỌNG: KIỂM TRA BẮT BUỘC LÝ DO ---
			if not reason or reason == "" or reason == " " then
				-- Chat phản hồi lại cho Admin biết là lệnh thất bại
				local hint = Instance.new("Hint", workspace)
				hint.Text = "LỖI: Bạn phải nhập lý do! Cú pháp: /kick [tên] [lý do]"
				game:GetService("Debris"):AddItem(hint, 3) -- Xóa thông báo sau 3 giây
				return -- Dừng script, không kick
			end
			-- -------------------------------------------

			local targetPlayer = findPlayer(targetName)

			if targetPlayer then
				-- Kick người chơi
				targetPlayer:Kick("\n🛑 BẠN ĐÃ BỊ KICK!\n\n📝 Lý do: " .. reason .. "\n👮 Xử lý bởi: " .. player.Name)
				print("Admin " .. player.Name .. " đã kick " .. targetPlayer.Name .. " | Lý do: " .. reason)
			end
		end
	end)
end)
