local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local HttpService       = game:GetService("HttpService")
local TeleportService   = game:GetService("TeleportService")
local localPlayer = Players.LocalPlayer
while not localPlayer do task.wait() localPlayer = Players.LocalPlayer end
local LOBBY_PLACE_ID = 2414851778
local remotes = ReplicatedStorage:WaitForChild("remotes", 10)
local function findRemote(names)
    if not remotes then remotes = ReplicatedStorage:FindFirstChild("remotes") end
    if not remotes then return nil end
    if type(names) == "string" then names = { names } end
    for _, n in ipairs(names) do
        local lower = n:lower()
        for _, v in ipairs(remotes:GetChildren()) do
            if v.Name:lower() == lower or v.Name:lower():find(lower, 1, true) then
                return v
            end
        end
    end
    return nil
end
local function fireRemoteSafe(remote, ...)
    if not remote then return false end
    local args = { ... }
    if remote:IsA("RemoteFunction") then
        local ok, res = pcall(function() return remote:InvokeServer(unpack(args)) end)
        return ok, res
    elseif remote:IsA("RemoteEvent") then
        return pcall(function() remote:FireServer(unpack(args)) end)
    end
    return false
end
-- Remotes cần thiết cho Send, Accept và Leave
local respondJoinRemote = findRemote("respondJoinRequest")
local showJoinRemote    = findRemote("showJoinRequest")
local sendJoinRemote    = findRemote("sendJoinRequest")
local leaveRemote       = findRemote({ "returnToLobby", "ReturnToLobbyEvent", "teleToLobby", "teleportToLobby", "leaveDungeon", "goLobby", "toLobby" })
-- Xử lý linh hoạt config bảng
local carryCfg = getgenv().carry or {}
local cfgReq   = carryCfg["AutoRequest"] or {}
local cfgAcc   = carryCfg["AutoAccept"] or {}
local cfgWeb   = carryCfg["Webhook"] or {}
-- Lấy danh sách Hosts cho AutoRequest (hỗ trợ cả {"Name"} hoặc Hosts = {"Name"})
local targetHosts = {}
if #cfgReq > 0 then
    targetHosts = cfgReq
elseif cfgReq.Hosts then
    targetHosts = type(cfgReq.Hosts) == "table" and cfgReq.Hosts or { tostring(cfgReq.Hosts) }
elseif cfgReq.TargetUsername then
    targetHosts = { tostring(cfgReq.TargetUsername) }
end
-- Lấy danh sách Members cho AutoAccept (hỗ trợ cả {"Alt1"} hoặc Members = {"Alt1"})
local acceptedMembers = {}
if #cfgAcc > 0 then
    acceptedMembers = cfgAcc
elseif cfgAcc.Members then
    acceptedMembers = type(cfgAcc.Members) == "table" and cfgAcc.Members or { tostring(cfgAcc.Members) }
end
local function inDungeon()
    local games = Workspace:FindFirstChild("games")
    if games and games:FindFirstChild("inGame") and games.inGame:FindFirstChild(localPlayer.Name) then
        return true
    end
    return Workspace:FindFirstChild("dungeon") ~= nil
end
local function leaveLobbyFire()
    if leaveRemote then fireRemoteSafe(leaveRemote) end
    if remotes then
        for _, child in ipairs(remotes:GetChildren()) do
            local l = child.Name:lower()
            if l:find("returntolobby") or l:find("leavedungeon") or l == "tolobby" then
                fireRemoteSafe(child)
            end
        end
    end
    if game.PlaceId ~= LOBBY_PLACE_ID then
        pcall(function() TeleportService:Teleport(LOBBY_PLACE_ID, localPlayer) end)
    end
end
--// ========================================================================
--// 1. WEBHOOK (GIỮ LẠI ĐẦY ĐỦ THÔNG BÁO VÀ STATS)
--// ========================================================================
local Session = {
    Runs      = 0,
    Wins      = 0,
    Losses    = 0,
    StartTime = os.time(),
    RunStart  = 0,
    TotalUlt  = 0,
    TotalLeg  = 0,
    TotalEpic = 0,
}
local function getRequestFunc()
    return (syn and syn.request) or (http and http.request) or http_request or request
end
local function sendDiscordWebhook(payload)
    local req = getRequestFunc()
    if not req then return end
    local urls = {}
    if cfgWeb.Enabled1 and cfgWeb.Url1 and #cfgWeb.Url1 > 10 then table.insert(urls, cfgWeb.Url1) end
    if cfgWeb.Enabled2 and cfgWeb.Url2 and #cfgWeb.Url2 > 10 then table.insert(urls, cfgWeb.Url2) end
    if #urls == 0 then return end
    local body = HttpService:JSONEncode(payload)
    for _, url in ipairs(urls) do
        task.spawn(function()
            pcall(function()
                req({
                    Url = url,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = body,
                })
            end)
        end)
    end
end
local function getLootFromUI()
    local lootList = {}
    local pGui = localPlayer:FindFirstChild("PlayerGui")
    local clearGui = pGui and pGui:FindFirstChild("dungeonClear")
    if not (clearGui and clearGui.Enabled) then return lootList end
    for _, v in ipairs(clearGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Name == "itemName" and v.Visible and v.Text ~= "" then
            local rarity = "Common"
            local t = v.Text
            if t:find("Ultimate") then rarity = "Ultimate"
            elseif t:find("Legendary") then rarity = "Legendary"
            elseif t:find("Epic") then rarity = "Epic"
            elseif t:find("Rare") then rarity = "Rare" end
            table.insert(lootList, { Name = t, Rarity = rarity })
        end
    end
    return lootList
end
local function sendWebhookReport(isWin)
    local drops = getLootFromUI()
    local shouldPing = false
    local dropLines = {}
    for _, item in ipairs(drops) do
        local r = (item.Rarity or ""):lower()
        local icon = "⚪"
        if r:find("ultimate") then
            icon = "🔴"
            Session.TotalUlt = Session.TotalUlt + 1
            if cfgWeb.PingUltimate then shouldPing = true end
        elseif r:find("legendary") then
            icon = "🟡"
            Session.TotalLeg = Session.TotalLeg + 1
            if cfgWeb.PingLegendary then shouldPing = true end
        elseif r:find("epic") then
            icon = "🟣"
            Session.TotalEpic = Session.TotalEpic + 1
            if cfgWeb.PingEpic then shouldPing = true end
        end
        table.insert(dropLines, icon .. " " .. item.Name .. " (" .. item.Rarity .. ")")
    end
    local pingContent = ""
    if shouldPing and cfgWeb.DiscordID and #cfgWeb.DiscordID > 0 then
        pingContent = "<@" .. cfgWeb.DiscordID .. ">"
    end
    local duration = Session.RunStart > 0 and (os.time() - Session.RunStart) or 0
    local runTimeStr = string.format("%02d:%02d", math.floor(duration / 60), duration % 60)
    local fields = {
        { name = "Account", value = localPlayer.Name, inline = true },
        { name = "Kết Quả", value = isWin and "Thắng (Victory)" or "Thất Bại (Defeat)", inline = true },
        { name = "Thời Gian Trận", value = runTimeStr, inline = true },
        { name = "Thống Kê", value = string.format("Thắng: %d | Thua: %d (Tổng: %d)", Session.Wins, Session.Losses, Session.Runs), inline = false },
        { name = "Vật Phẩm Nhận", value = #dropLines > 0 and table.concat(dropLines, "\n") or "Không có vật phẩm mới", inline = false }
    }
    local embed = {
        title = "Dungeon Quest Report: " .. (isWin and "CHIẾN THẮNG" or "THẤT BẠI"),
        color = isWin and 65280 or 16711680,
        fields = fields,
        footer = { text = "carry manager • " .. os.date("%X") },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
    sendDiscordWebhook({ content = pingContent, embeds = { embed } })
end
--// ========================================================================
--// 2. SEND (AUTO REQUEST - GỬI YÊU CẦU CHO ACC PHỤ)
--// ========================================================================
task.spawn(function()
    local reqEnabled = (cfgReq.Enabled ~= false)
    while true do
        task.wait(2)
        if reqEnabled and not inDungeon() and sendJoinRemote then
            for _, hostName in ipairs(targetHosts) do
                if hostName and hostName ~= "" then
                    pcall(function()
                        sendJoinRemote:InvokeServer(hostName)
                    end)
                end
            end
        end
    end
end)
-- Theo dõi kết thúc trận & Host rời game để Alt tự về sảnh
task.spawn(function()
    local isFinished = false
    while true do
        task.wait(1)
        if inDungeon() then
            if Session.RunStart == 0 then
                Session.RunStart = os.time()
                isFinished = false
            end
            local d = Workspace:FindFirstChild("dungeon")
            local bossRoom = d and d:FindFirstChild("bossRoom")
            local fin = bossRoom and bossRoom:FindFirstChild("dungeonFinished")
            local progress = Workspace:FindFirstChild("dungeonProgress")
            local pGui = localPlayer:FindFirstChild("PlayerGui")
            local win = (fin and fin.Value == true) or (progress and progress.Value == "bossKilled") or (pGui and pGui:FindFirstChild("dungeonClear") and pGui.dungeonClear.Enabled)
            local defeat = (pGui and pGui:FindFirstChild("gameDefeat") and pGui.gameDefeat.Enabled) or (d and d:FindFirstChild("lives") and d.lives.Value <= 0)
            -- Kiểm tra xem Host còn trong server không
            local hostPresent = (#targetHosts == 0)
            for _, h in ipairs(targetHosts) do
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Name:lower() == h:lower() then hostPresent = true break end
                end
            end
            local hostLeft = (#targetHosts > 0 and not hostPresent)
            if (win or defeat or hostLeft) and not isFinished then
                isFinished = true
                Session.Runs = Session.Runs + 1
                if win then Session.Wins = Session.Wins + 1 else Session.Losses = Session.Losses + 1 end
                -- Gửi Webhook
                task.delay(1.5, function()
                    if cfgWeb.SendStats and (Session.Wins % (cfgWeb.StatsEveryWins or 1) == 0) then
                        sendWebhookReport(win)
                    end
                end)
                -- Tự rời về Lobby
                if cfgReq.AutoReturnLobby ~= false then
                    local delayTime = hostLeft and 1 or (cfgReq.ReturnLobbyDelay or 4)
                    task.wait(delayTime)
                    leaveLobbyFire()
                end
            end
        else
            Session.RunStart = 0
            isFinished = false
        end
    end
end)
--// ========================================================================
--// 3. ACCEPT (AUTO ACCEPT - DUYỆT YÊU CẦU CHO ACC CHÍNH)
--// ========================================================================
if showJoinRemote and respondJoinRemote then
    showJoinRemote.OnClientEvent:Connect(function(requestId, displayName, eventType)
        if cfgAcc.Enabled == false then return end
        if eventType == "close" or requestId == nil then return end
        local requester = tostring(displayName):lower()
        local isAllowed = (#acceptedMembers == 0)
        for _, member in ipairs(acceptedMembers) do
            if member:lower() == requester then
                isAllowed = true
                break
            end
        end
        if isAllowed then
            fireRemoteSafe(respondJoinRemote, requestId, true)
            print("[AutoAccept] Đã chấp nhận: " .. tostring(displayName))
        end
    end)
end
