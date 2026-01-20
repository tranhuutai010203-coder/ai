--// Blind Bomber - REAL Bomb (FULL FINAL)
--// Hook Remote -> Record -> Use Real Bomb
--// Không fake, không đoán, không lag

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- STORAGE
-- =========================
local BombRemote = nil
local BombArgs = nil

-- =========================
-- HOOK REMOTE (RECORD MODE)
-- =========================
local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" then
        local name = tostring(self):lower()
        if name:find("bomb") or name:find("plant") or name:find("explode") then
            warn("===== REAL BOMB REMOTE RECORDED =====")
            warn("Remote:", self:GetFullName())
            warn("Args:")
            for i,v in ipairs(args) do
                warn(i, v)
            end

            BombRemote = self
            BombArgs = args
        end
    end

    return oldNamecall(self, ...)
end)

-- =========================
-- UI (RAYFIELD)
-- =========================
local Rayfield = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"
))()

local Window = Rayfield:CreateWindow({
    Name = "Blind Bomber | REAL Bomb",
    LoadingTitle = "Recording Bomb Remote",
    LoadingSubtitle = "Wait for someone to plant bomb",
    ConfigurationSaving = {Enabled = false}
})

local Tab = Window:CreateTab("REAL Bomb", 4483362458)

-- =========================
-- BUTTON: PLANT REAL BOMB
-- =========================
Tab:CreateButton({
    Name = "Plant Bomb (REAL)",
    Callback = function()
        if BombRemote and BombArgs then
            BombRemote:FireServer(unpack(BombArgs))
            Rayfield:Notify({
                Title = "Bomb",
                Content = "Bomb planted (SERVER ACCEPTED)",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Bomb",
                Content = "Chưa record được remote",
                Duration = 4
            })
        end
    end
})

-- =========================
-- BUTTON: DETONATE (NẾU GAME CÓ)
-- =========================
Tab:CreateButton({
    Name = "Detonate Bomb",
    Callback = function()
        if BombRemote then
            BombRemote:FireServer(true)
        end
    end
})

Rayfield:Notify({
    Title = "Blind Bomber",
    Content = "Đợi người khác đặt bomb để record remote",
    Duration = 6
})
