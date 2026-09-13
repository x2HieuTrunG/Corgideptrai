

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local HttpService       = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
while not localPlayer do
    task.wait()
    localPlayer = Players.LocalPlayer
end


local SOURCES = {
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/",
    "https://cdn.jsdelivr.net/gh/deividcomsono/Obsidian@main/",
}

local function fetchLib(path, name)
    for _, base in ipairs(SOURCES) do
        local okHttp, code = pcall(function() return game:HttpGet(base .. path) end)
        if okHttp and type(code) == "string" and #code > 100 then
            local okLoad, chunk = pcall(loadstring, code)
            if okLoad and chunk then
                local okRun, lib = pcall(chunk)
                if okRun and type(lib) == "table" then
                    print("Loaded " .. name .. " from " .. base)
                    return lib
                end
            end
        end
        warn("Could not load " .. name .. " from " .. base)
        task.wait(0.5)
    end
    return nil
end

local Library = fetchLib("Library.lua", "Library.lua")
if not Library then
    warn("FATAL: no UI library available — script aborted")
    return
end
local ThemeManager = fetchLib("addons/ThemeManager.lua", "ThemeManager")
local SaveManager  = fetchLib("addons/SaveManager.lua", "SaveManager")

local Options = Library.Options
local Toggles = Library.Toggles


local remotes = ReplicatedStorage:WaitForChild("remotes", 10)

local function findRemote(names)
    if not remotes then remotes = ReplicatedStorage:FindFirstChild("remotes") end
    if not remotes then return nil end
    if type(names) == "string" then names = { names } end
    for _, n in ipairs(names) do
        local lower = n:lower()
        for _, v in ipairs(remotes:GetChildren()) do
            if v.Name:lower() == lower then return v end
        end
    end
    for _, n in ipairs(names) do
        local lower = n:lower()
        for _, v in ipairs(remotes:GetChildren()) do
            if v.Name:lower():find(lower, 1, true) then return v end
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
        local ok = pcall(function() remote:FireServer(unpack(args)) end)
        return ok
    else
        local ok, res = pcall(function() return remote:FireServer(unpack(args)) end)
        if not ok then
            return pcall(function() return remote:InvokeServer(unpack(args)) end)
        end
        return ok, res
    end
end

local createLobbyRemote  = findRemote({ "createLobby", "createDungeon" })
local startRemote        = findRemote("startDungeon")
local changeStartRemote  = findRemote("changeStartValue")
local replayRemote       = findRemote("replayDungeon")
local dungeonStatsRemote = findRemote("getDungeonStats")
local respondJoinRemote  = findRemote("respondJoinRequest")
local showJoinRemote     = findRemote("showJoinRequest")
local sendJoinRemote     = findRemote("sendJoinRequest")
local reloadInvyRemote   = findRemote("reloadInvy")
local leaveRemote        = findRemote({ "returnToLobby", "ReturnToLobbyEvent", "teleToLobby", "teleportToLobby", "leaveDungeon", "goLobby", "leaveGame", "toLobby", "exitDungeon" })

local function refreshInventoryRemote()
    if not remotes then remotes = ReplicatedStorage:FindFirstChild("remotes") end
    reloadInvyRemote = remotes and (remotes:FindFirstChild("reloadInvy") or findRemote("reloadInvy"))
    return reloadInvyRemote
end


local function leaveLobbyFire()
    local done = false
    -- 1. Gọi leaveRemote đã cache
    if leaveRemote then
        local ok = fireRemoteSafe(leaveRemote)
        if ok then done = true end
    end

    -- 2. Quét lại remotes tìm tất cả remote liên quan đến lobby/leave
    if remotes then
        for _, child in ipairs(remotes:GetChildren()) do
            local l = child.Name:lower()
            if l:find("returntolobby") or l:find("teletolobby") or l:find("leavedungeon") or l == "tolobby" or l == "lobby" then
                local ok = fireRemoteSafe(child)
                if ok then done = true end
            end
        end
    end

    -- 3. Click nút UI trong PlayerGui nếu có
    local pg = localPlayer:FindFirstChild("PlayerGui")
    if pg then
        for _, guiName in ipairs({ "dungeonClear", "gameDefeat", "pauseMenu", "topBarGui" }) do
            local g = pg:FindFirstChild(guiName)
            if g then
                for _, descendant in ipairs(g:GetDescendants()) do
                    if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
                        local n = descendant.Name:lower()
                        local t = (descendant:IsA("TextButton") and descendant.Text:lower()) or ""
                        if n:find("lobby") or n:find("leave") or n:find("return")
                            or t:find("lobby") or t:find("leave") or t:find("return") then
                            pcall(function()
                                if firesignal then firesignal(descendant.MouseButton1Click) end
                                if getconnections then
                                    for _, c in pairs(getconnections(descendant.MouseButton1Click)) do c:Fire() end
                                    for _, c in pairs(getconnections(descendant.Activated)) do c:Fire() end
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
    return done
end


local WEBHOOK_URL       = ""
local DISCORD_ID        = ""
local SEND_WEBHOOK      = false
local PING_ON_EPIC      = true
local PING_ON_LEGENDARY = true
local PING_ON_ULTIMATE  = true
local INV_CAPACITY      = 300
local SEND_STATS        = true
local STATS_EVERY_WINS  = 1
local STATS_ON_LOSSES   = true

local DATA_FOLDER = "hieutrungcaylapbu"
local STATS_FILE  = DATA_FOLDER .. "/stats.json"
local RUNS_FILE   = DATA_FOLDER .. "/runs.json"
local MAX_RUN_LOG = 200
local CAN_WRITE   = type(writefile) == "function" and type(readfile) == "function"

local RARITY_DOTS = {
    ["⚪"] = "common",
    ["🟢"] = "uncommon",
    ["🔵"] = "rare",
    ["🟣"] = "epic",
    ["🟠"] = "legendary",
    ["⭐"] = "ultimate",
    ["🟡"] = "legendary",
    ["🌟"] = "ultimate",
}
local DOT_FOR = {
    common    = "⚪",
    uncommon  = "🟢",
    rare      = "🔵",
    epic      = "🟣",
    legendary = "🟠",
    ultimate  = "⭐",
}

local function rarityFromName(name)
    local lower = string.lower(name or "")
    if string.find(lower, "ultimate") then return "ultimate"
    elseif string.find(lower, "legendary") then return "legendary"
    elseif string.find(lower, "epic") then return "epic"
    elseif string.find(lower, "rare") then return "rare"
    elseif string.find(lower, "uncommon") then return "uncommon"
    elseif string.find(lower, "common") then return "common" end
    return nil
end

local function getStat(name)
    local ls = localPlayer:FindFirstChild("leaderstats")
    if not ls then return nil end
    local v = ls:FindFirstChild(name)
    if v then return tonumber(v.Value) end
    return nil
end

local function getMapName()
    local v = Workspace:FindFirstChild("dungeonName")
    local n = v and v.Value or ""
    if n ~= "" then return n end
    return "unknown"
end

local function getLootFromUI()
    local lootList = {}
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return lootList end
    local dungeonClear = playerGui:FindFirstChild("dungeonClear")
    if not (dungeonClear and dungeonClear.Enabled) then return lootList end
    for _, v in ipairs(dungeonClear:GetDescendants()) do
        if v:IsA("TextLabel") and v.Name == "itemName" and v.Visible then
            local text = v.Text
            if text and text ~= "" then
                local rarity
                for dot, r in pairs(RARITY_DOTS) do
                    if string.find(text, dot, 1, true) then rarity = r break end
                end
                if not rarity then rarity = rarityFromName(text) end
                local name = text:gsub("%p", " "):gsub("^%s+", ""):gsub("%s+$", "")
                if name ~= "" then
                    table.insert(lootList, { Name = name, Rarity = rarity or "unknown" })
                end
            end
        end
    end
    return lootList
end

local function screenVisible()
    local pg = localPlayer:FindFirstChild("PlayerGui")
    local dc = pg and pg:FindFirstChild("dungeonClear")
    return dc ~= nil and dc.Enabled
end

local function abbrevNum(n)
    n = tonumber(n) or 0
    local abs = math.abs(n)
    if abs >= 1e12 then return string.format("%.2ft", n / 1e12)
    elseif abs >= 1e9 then return string.format("%.2fb", n / 1e9)
    elseif abs >= 1e6 then return string.format("%.2fm", n / 1e6)
    elseif abs >= 1e3 then return string.format("%.2fk", n / 1e3)
    else return tostring(math.floor(n + 0.5)) end
end

local function deltaStr(n)
    if (tonumber(n) or 0) >= 0 then return "+" .. abbrevNum(n) end
    return "-" .. abbrevNum(math.abs(n))
end

local function fmtTime(sec)
    sec = math.max(0, math.floor(tonumber(sec) or 0))
    return math.floor(sec / 60) .. "m " .. (sec % 60) .. "s"
end

local runCollector = { drops = {}, index = {}, src = {} }

local function collectorAdd(col, name, rarity, cat, source, n)
    if type(name) ~= "string" or name == "" or not col then return end
    local key = name .. "|" .. tostring(rarity)
    local idx = col.index[key]
    if not idx then
        table.insert(col.drops, { Name = name, Rarity = rarity or "unknown", Cat = cat, Count = 0 })
        idx = #col.drops
        col.index[key] = idx
        col.src[key] = {}
    end
    if cat and (col.drops[idx].Cat == nil or col.drops[idx].Cat == "unknown") then
        col.drops[idx].Cat = cat
    end
    local src = col.src[key]
    src[source or "inv"] = (src[source or "inv"] or 0) + math.max(1, n or 1)
    col.drops[idx].Count = math.max(src.screen or 0, src.inv or 0)
end

local function readInventory()
    local remote = reloadInvyRemote or refreshInventoryRemote()
    if not remote then return nil, "reloadInvy remote not found" end
    local ok, inv = pcall(function() return remote:InvokeServer() end)
    if not ok then return nil, tostring(inv) end
    if type(inv) ~= "table" then return nil, "reloadInvy returned " .. typeof(inv) end
    local list = {}
    for cat, items in pairs(inv) do
        if type(items) == "table" then
            for _, item in pairs(items) do
                if type(item) == "table" and type(item.name) == "string" and item.name ~= "" then
                    local rarity = string.lower(tostring(item.rarity or ""))
                    if rarity == "" then rarity = rarityFromName(item.name) or "unknown" end
                    table.insert(list, { Name = item.name, Rarity = rarity, Cat = tostring(cat) })
                end
            end
        end
    end
    return list
end

local function listToCounts(list)
    local counts = {}
    for _, it in ipairs(list or {}) do
        local key = it.Name .. "|" .. it.Rarity
        counts[key] = (counts[key] or 0) + 1
    end
    return counts
end

local function abbrevRank(rarity)
    return rarity == "epic" and 1 or rarity == "legendary" and 2 or rarity == "ultimate" and 3 or 0
end

local function getRequestFunc()
    return (syn and syn.request)
        or (http and http.request)
        or http_request
        or request
end

local function postWebhook(payload)
    local requestFunc = getRequestFunc()
    if not requestFunc then
        warn("webhook: executor has no HTTP request function")
        return false
    end
    if WEBHOOK_URL == "" or not WEBHOOK_URL:find("http") then
        return false
    end
    local ok, res = pcall(function()
        return requestFunc({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
    if not ok then return false end
    local code = nil
    if type(res) == "table" then
        code = tonumber(res.StatusCode) or tonumber(res.code) or tonumber(res.ResponseCode)
    end
    return (code and code >= 200 and code < 300) or true
end

local function sendDiscordEmbed(isWin, drops, statsData, titleSuffix)
    if not SEND_WEBHOOK or WEBHOOK_URL == "" then return end
    statsData = statsData or {}

    local shouldPing = false
    local highestRarity = 0
    local lines = {}
    for _, item in ipairs(drops) do
        local dot = DOT_FOR[item.Rarity] or "⚪"
        local line = dot .. " " .. item.Name .. " (" .. item.Rarity .. ")"
        if (item.Count or 1) > 1 then line = line .. " x" .. item.Count end
        table.insert(lines, line)
        local rank = abbrevRank(item.Rarity)
        if rank > 0 then
            highestRarity = math.max(highestRarity, rank)
            if (rank == 1 and PING_ON_EPIC)
                or (rank == 2 and PING_ON_LEGENDARY)
                or (rank == 3 and PING_ON_ULTIMATE) then
                shouldPing = true
            end
        end
    end
    local lootText = #lines > 0 and table.concat(lines, "\n") or "No items found."

    local embedColor = isWin and 65280 or 16711680
    if isWin then
        if highestRarity == 3 then embedColor = 16711935
        elseif highestRarity == 2 then embedColor = 16766720
        elseif highestRarity == 1 then embedColor = 10038527 end
    end

    local pingContent = ""
    if shouldPing and DISCORD_ID ~= "" then
        pingContent = "<@" .. DISCORD_ID .. ">"
    end

    local fields = {}
    if statsData.Level and statsData.GoldEarned then
        table.insert(fields, { ["name"] = "Level",       ["value"] = statsData.Level,            ["inline"] = true })
        table.insert(fields, { ["name"] = "Run Time",    ["value"] = statsData.RunTime or "—",   ["inline"] = true })
        table.insert(fields, { ["name"] = "Inventory",   ["value"] = statsData.Inventory or "—", ["inline"] = true })
        table.insert(fields, { ["name"] = "Gold Earned", ["value"] = statsData.GoldEarned or "—",["inline"] = true })
        table.insert(fields, { ["name"] = "Total Gold",  ["value"] = statsData.TotalGold or "—", ["inline"] = true })
        table.insert(fields, { ["name"] = "Gems Earned", ["value"] = statsData.GemsEarned or "—",["inline"] = true })
        table.insert(fields, { ["name"] = "Total Gems",  ["value"] = statsData.TotalGems or "—", ["inline"] = true })
    elseif statsData.Level then
        table.insert(fields, { ["name"] = "Level",    ["value"] = statsData.Level,          ["inline"] = true })
        table.insert(fields, { ["name"] = "Run Time", ["value"] = statsData.RunTime or "—", ["inline"] = true })
    end
    table.insert(fields, { ["name"] = "Loot Obtained", ["value"] = lootText, ["inline"] = false })

    local payload = {
        ["content"] = pingContent,
        ["embeds"] = {{
            ["title"] = "Dungeon Complete: " .. (isWin and "WIN" or "LOSE") .. (titleSuffix and (" — " .. titleSuffix) or ""),
            ["color"] = embedColor,
            ["fields"] = fields,
            ["footer"] = { ["text"] = "cay lap 67 cm" },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    postWebhook(payload)
end

local stats = {
    runs       = 0,
    wins       = 0,
    losses     = 0,
    clearTime  = 0,
    itemRolls  = 0,
    gearDrops  = 0,
    spellDrops = 0,
    eif        = 0,
    eir        = 0,
    items      = {},
    tiers      = {},
}

local TIER_ORDER = { "common", "uncommon", "rare", "epic", "legendary", "ultimate", "unknown" }
local SPELL_LIST_RAW = "Agony Orbs|Amethyst Beams|Amethyst Blast|Aquatic Smite|Arc Blast|Arc Wave|Arcane Amplifier|Arcane Barrage|Arcane Spray|Arrow Barrage|Arrow Rain|Aura of Life|Battle Shout|Berserk|Blade Barrage|Blade Fall|Blade Revolver|Blade Storm|Blade Throw|Blood Pact|Blue Fireball|Carrot Barrage|Chain Heal|Chain Lightning|Chain Phase Shock|Chain Storm|Chained Energy Blasts|Chromatic Rain|Cleansing Beam|Crystalline Cannon|Demonic Curse|Demonic Spikes|Demonic Strike|Earth Clap|Earth Kick|Earth Spikes|Egg Bomb|Electric Boom|Electric Field|Electric Grinder|Electric Slash|Enchanted Shuriken|Enchanted Spinning Blades|Energy Orb|Enhanced Inner Focus|Enhanced Inner Rage|Explosive Mine|Explosive Punch|Fire Bomb|Fireball|Flame Cyclone|Flame Shuriken|Flame Step|Flame Strike|Focus Beam|Forgotten Army|Frost Cone|Fungal Poison|Gale Barrage|Gale Slice|Geyser|Ghostly Cannon Barrage|Ghostly Rampage|Glacial Blows|God Spear|Gravity Leap|Ground Slam|Ground Stomp|Guardian Call|Guardian Roar|Guardian's Blessing|Hand Cannon|Hands Of Death|Holy Barrier|Holy Circle|Ice Barrage|Ice Crash|Ice Needles|Ice Nova|Ice Spikes|Ice Totem|Icicle Barrage|Illusion Blast|Infernal Blast|Infernal Orbs|Infernal Strike|Inner Focus|Inner Rage|Innervate|Jade Rain|Jade Roller|Kunai Knives|Lava Barrage|Lava Beam Orb|Lava Cage|Lava Lash|Leaping Strike|Life Dash|Life Pulse|Lightning Beam|Lightning Burst|Lightning Strikes|Mighty Cleave|Mighty Leap|Molten Ball|Molten Shards|Mystery Matter|Orb Of Destruction|Overcharge|Phantom Blades|Phantom Flames|Phantom Striker|Phase Barrage|Piercing Rain|Piercing Roots|Poison Cloud|Pulse Beam|Pulse Waves|Pulsefire|Redemption|Rejuvenating Spray|Rending Slice|Revitalize|Rift Beam|Runic Strike|Sacrificial Orbs|Searing Beam|Shatterstrike|Shock Blast|Shock Wave|Skull Flames|Slam|Smite|Solar Beam|Soul Drain|Spear Strike|Spinning Blade Smash|Spirit Bomb|Spirit Link|Star Barrage|Starfall|Storm Blast|Storm Wave|Taunt|Taunting Aura|Thunderous Blast|Triple Blade Throw|Triple Quake|Tsunami|Twin Slash|Universal Heal|Unstable Warp|Vengeful Taunt|Void Beam|Void Dragon|Void Spheres|Voidflames|Vortex|Vortex Grenade|Water Orb|Whirlwind|Wind Blast|Yokai Transformation"

local SPELL_NAMES = {}
for spellName in SPELL_LIST_RAW:gmatch("[^|]+") do
    SPELL_NAMES[spellName:lower():gsub("%W", "")] = true
end

local function nameKey(name)
    return string.lower(name or ""):gsub("%W", "")
end

local function isSpellItem(name, cat)
    if cat == "abilities" then return true end
    return SPELL_NAMES[nameKey(name)] == true
end

local function ensureFolder()
    if not CAN_WRITE then return end
    if type(isfolder) == "function" then
        if not isfolder(DATA_FOLDER) then pcall(makefolder, DATA_FOLDER) end
    else
        pcall(makefolder, DATA_FOLDER)
    end
end

local function saveStats()
    if not CAN_WRITE then return end
    ensureFolder()
    pcall(function() writefile(STATS_FILE, HttpService:JSONEncode(stats)) end)
end

local function readDataFile(name)
    if not CAN_WRITE then return nil end
    local ok, raw = pcall(readfile, DATA_FOLDER .. "/" .. name)
    if ok and type(raw) == "string" and #raw > 0 then return raw end
    ok, raw = pcall(readfile, "bucu/" .. name)
    if ok and type(raw) == "string" and #raw > 0 then return raw end
    return nil
end

local function loadPersistedStats()
    local raw = readDataFile("stats.json")
    if not raw then return end
    local decoded, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not decoded or type(data) ~= "table" then return end
    local numerics = { "runs", "wins", "losses", "clearTime", "itemRolls", "gearDrops", "spellDrops", "eif", "eir" }
    for _, k in ipairs(numerics) do
        local v = tonumber(data[k])
        if v then stats[k] = v end
    end
    if type(data.items) == "table" then
        for key, count in pairs(data.items) do
            local c = tonumber(count)
            if type(key) == "string" and c then stats.items[key] = c end
        end
    end
    if type(data.tiers) == "table" then
        for tier, count in pairs(data.tiers) do
            local c = tonumber(count)
            if type(tier) == "string" and c then stats.tiers[tier] = c end
        end
    end
end

local function recomputeSpellCounters()
    stats.eif, stats.eir = 0, 0
    for key, count in pairs(stats.items) do
        local name = key:match("^(.*)|(.*)$")
        local c = tonumber(count) or 0
        local lower = string.lower(name or ""):gsub("%s+", " ")
        if string.find(lower, "enhanced inner focus", 1, true) then
            stats.eif = stats.eif + c
        elseif string.find(lower, "enhanced inner rage", 1, true) then
            stats.eir = stats.eir + c
        end
    end
end

local runHistory = {}
local function loadRunHistory()
    runHistory = {}
    local raw = readDataFile("runs.json")
    if raw then
        local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if ok and type(data) == "table" then
            for _, r in ipairs(data) do table.insert(runHistory, r) end
        end
    end
end

local function writeRunHistory()
    if not CAN_WRITE then return end
    ensureFolder()
    while #runHistory > MAX_RUN_LOG do table.remove(runHistory, 1) end
    pcall(function() writefile(RUNS_FILE, HttpService:JSONEncode(runHistory)) end)
end

local function appendRunRecord(record)
    record.uid = tostring(math.floor(tick() * 1000)) .. "-" .. tostring(math.random(100000, 999999))
    table.insert(runHistory, record)
    writeRunHistory()
end

local function foldItemsIntoStats(drops)
    for _, item in ipairs(drops) do
        local n = math.max(1, item.Count or 1)
        stats.itemRolls = stats.itemRolls + n
        local key = item.Name .. "|" .. tostring(item.Rarity)
        stats.items[key] = (stats.items[key] or 0) + n
        stats.tiers[item.Rarity] = (stats.tiers[item.Rarity] or 0) + n
        if isSpellItem(item.Name, item.Cat) then
            stats.spellDrops = stats.spellDrops + n
            local lower = string.lower(item.Name):gsub("%s+", " ")
            if string.find(lower, "enhanced inner focus", 1, true) then
                stats.eif = stats.eif + n
            elseif string.find(lower, "enhanced inner rage", 1, true) then
                stats.eir = stats.eir + n
            end
        else
            stats.gearDrops = stats.gearDrops + n
        end
    end
end

local function foldRunIntoStats(col, isWin, clearTimeSec)
    if not STATS_ON_LOSSES and not isWin then return end
    stats.runs = stats.runs + 1
    if isWin then
        stats.wins = stats.wins + 1
        stats.clearTime = stats.clearTime + (tonumber(clearTimeSec) or 0)
    else
        stats.losses = stats.losses + 1
    end
    foldItemsIntoStats(col.drops)
end

local function pct(part, total)
    if not total or total <= 0 then return "0%" end
    return string.format("%.1f%%", (part / total) * 100)
end

local function buildStatsEmbed()
    local lines = {}
    table.insert(lines, "Total runs: " .. stats.runs)
    if stats.wins > 0 then
        table.insert(lines, "Average clear: " .. fmtTime(stats.clearTime / stats.wins))
    else
        table.insert(lines, "Average clear: —")
    end
    table.insert(lines, "Total item rolls: " .. stats.itemRolls)
    table.insert(lines, "Non-spell Gear Drops: " .. stats.gearDrops)

    local itemList = {}
    for key, count in pairs(stats.items) do
        local name, rarity = key:match("^(.*)|(.*)$")
        table.insert(itemList, { Name = name, Rarity = rarity, Count = count })
    end
    table.sort(itemList, function(a, b)
        if a.Count ~= b.Count then return a.Count > b.Count end
        return a.Name < b.Name
    end)
    if #itemList > 0 then
        table.insert(lines, "")
        table.insert(lines, "Item Breakdown")
        for _, it in ipairs(itemList) do
            table.insert(lines, it.Name .. " x" .. it.Count .. " (" .. pct(it.Count, stats.itemRolls) .. ")")
        end
    end

    local tierLines = {}
    for _, tier in ipairs(TIER_ORDER) do
        local c = stats.tiers[tier]
        if c and c > 0 then
            table.insert(tierLines, tier .. " " .. c .. " (" .. pct(c, stats.itemRolls) .. ")")
        end
    end
    if #tierLines > 0 then
        table.insert(lines, "")
        table.insert(lines, "Tier Breakdown")
        for _, l in ipairs(tierLines) do table.insert(lines, l) end
    end

    table.insert(lines, "")
    table.insert(lines, "Spells")
    table.insert(lines, stats.spellDrops .. " Spells (" .. pct(stats.spellDrops, stats.itemRolls) .. " of items)")
    table.insert(lines, "EIF: " .. stats.eif .. "  EIR: " .. stats.eir)

    local fields = {}
    local chunk = table.concat(lines, "\n")
    if #chunk > 1024 then chunk = chunk:sub(1, 1020) .. "..." end
    table.insert(fields, { ["name"] = "Session Stats", ["value"] = chunk, ["inline"] = false })

    return {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Session Stats — " .. stats.wins .. " wins" .. (stats.losses > 0 and (" / " .. stats.losses .. " losses") or ""),
            ["color"] = 3447003,
            ["fields"] = fields,
            ["footer"] = { ["text"] = "testgai" },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
end

local statsWinsSinceLast = 0
local function maybeSendStats(isWin)
    if not (SEND_STATS and SEND_WEBHOOK) then return end
    if isWin then
        statsWinsSinceLast = statsWinsSinceLast + 1
        if statsWinsSinceLast < STATS_EVERY_WINS then return end
    else
        return
    end
    statsWinsSinceLast = 0
    task.spawn(function()
        task.wait(1)
        postWebhook(buildStatsEmbed())
    end)
end

_G.resetSessionStats = function()
    stats.runs, stats.wins, stats.losses, stats.clearTime = 0, 0, 0, 0
    stats.itemRolls, stats.gearDrops, stats.spellDrops = 0, 0, 0
    stats.eif, stats.eir = 0, 0
    stats.items, stats.tiers = {}, {}
    statsWinsSinceLast = 0
    runHistory = {}
    saveStats()
    if CAN_WRITE then
        ensureFolder()
        pcall(function() writefile(RUNS_FILE, HttpService:JSONEncode({})) end)
    end
    print("Session stats reset.")
end

loadPersistedStats()
recomputeSpellCounters()
saveStats()
loadRunHistory()
ensureFolder()


local okWin, Window = pcall(function()
    return Library:CreateWindow({
        Title    = "hieutrung doggy",
        Footer   = "created by the one and only. x2hieutrung",
        Center   = true,
        AutoShow = true,
        Size     = UDim2.new(0, 540, 0, 360),
    })
end)
if not okWin or not Window then
    warn("CreateWindow failed — script aborted")
    return
end

local Tabs = {
    Main       = Window:AddTab("Main"),
    Webhook    = Window:AddTab("Webhook & Stats"),
    UISettings = Window:AddTab("UI Settings"),
}

local LeftCol  = Tabs.Main:AddLeftGroupbox("Manager")
local RightCol = Tabs.Main:AddRightGroupbox("Status")
local WebhookLeft  = Tabs.Webhook:AddLeftGroupbox("Discord Webhook")
local WebhookRight = Tabs.Webhook:AddRightGroupbox("Session Statistics")


local DungeonOrder = {
    "Desert Temple", "Winter Outpost", "Pirate Island", "King's Castle",
    "The Underworld", "Samurai Palace", "The Canals", "Ghastly Harbor",
    "Steampunk Sewers", "Orbital Outpost", "Volcanic Chambers",
    "Aquatic Temple", "Enchanted Forest", "Northern Lands", "Egg Island"
}

local DungeonDifficultyLevels = {
    ["Desert Temple"]     = { Easy = 1, Medium = 6, Hard = 12, Insane = 20, Nightmare = 27 },
    ["Winter Outpost"]    = { Easy = 33, Medium = 40, Hard = 45, Insane = 50, Nightmare = 55 },
    ["Pirate Island"]     = { Insane = 60, Nightmare = 65 },
    ["King's Castle"]     = { Insane = 70, Nightmare = 75 },
    ["The Underworld"]    = { Insane = 80, Nightmare = 85 },
    ["Samurai Palace"]    = { Insane = 90, Nightmare = 95 },
    ["The Canals"]        = { Insane = 100, Nightmare = 105 },
    ["Ghastly Harbor"]    = { Insane = 110, Nightmare = 115 },
    ["Steampunk Sewers"]  = { Insane = 120, Nightmare = 125 },
    ["Orbital Outpost"]   = { Insane = 135, Nightmare = 140 },
    ["Volcanic Chambers"] = { Insane = 150, Nightmare = 155 },
    ["Aquatic Temple"]    = { Insane = 160, Nightmare = 165 },
    ["Enchanted Forest"]  = { Insane = 170, Nightmare = 175 },
    ["Northern Lands"]    = { Insane = 180, Nightmare = 185 },
    ["Egg Island"]        = { Easy = 0, Nightmare = 0 },
}

local Difficulties = { "Easy", "Medium", "Hard", "Insane", "Nightmare" }
local EventDungeons = { ["Egg Island"] = true }
local DungeonReqs = {}

local orderIndex = {}
for i, name in ipairs(DungeonOrder) do orderIndex[name] = i end

local diffIndex = {}
for i, d in ipairs(Difficulties) do diffIndex[d] = i end

local function dungeonReqs(name)
    return DungeonReqs[name] or DungeonDifficultyLevels[name] or {}
end

local function clampMode(name, mode)
    local reqs = dungeonReqs(name)
    if reqs[mode] then return mode end
    for _, d in ipairs(Difficulties) do
        if reqs[d] then return d end
    end
    return mode
end

local function bestPickForLevel(level)
    local bestName, bestMode = nil, nil
    for _, name in ipairs(DungeonOrder) do
        if not EventDungeons[name] then
            local reqs = dungeonReqs(name)
            local mode = nil
            for _, d in ipairs(Difficulties) do
                if reqs[d] and level >= reqs[d] then mode = d end
            end
            if mode then bestName, bestMode = name, mode end
        end
    end
    return bestName, bestMode
end

local function fetchDungeonReqs(name)
    if not dungeonStatsRemote then return end
    local ok, statsData = pcall(function() return dungeonStatsRemote:InvokeServer(name) end)
    if not ok or type(statsData) ~= "table" then return end
    local reqs = {}
    for _, d in ipairs(Difficulties) do
        local entry = statsData[d]
        if type(entry) == "table" and tonumber(entry.levelReq) then
            reqs[d] = tonumber(entry.levelReq)
        end
    end
    if next(reqs) then DungeonReqs[name] = reqs end
end

local function refreshDungeonReqs()
    for _, name in ipairs(DungeonOrder) do
        if not EventDungeons[name] then
            fetchDungeonReqs(name)
            task.wait(0.1)
        end
    end
end


local masterEnabled          = false
local managerThread          = nil
local hardcoreMode           = false
local privateLobby           = false
local waitMembers            = true
local rejoinTimeout          = 45
local autoAcceptEnabled      = true
local configuredMembers      = {}
local lastQueuedMode         = nil
local acceptConn             = nil


local autoJoinEnabled        = false 
local targetJoinUsername     = ""
local autoReturnLobbyEnabled = true 
local returnLobbyDelay       = 4    

local statusLabel, levelLabel, bestLabel
local statRunsLabel, statWinsLabel, statClearLabel, statSpellsLabel
local detailStatusAt = 0

local function setStatus(text)
    detailStatusAt = os.clock()
    if statusLabel then statusLabel:SetText("State: " .. text) end
    print(text)
end

local function parseNames(str)
    local out = {}
    if not str then return out end
    local cleaned = str:gsub("%s+", "")
    for n in cleaned:gmatch("([^,]+)") do
        if n ~= "" then table.insert(out, n:lower()) end
    end
    return out
end

local function dungeonNameValue()
    return Workspace:FindFirstChild("dungeonName")
end

local function inDungeon()
    local dn = dungeonNameValue()
    local v = dn and dn.Value or ""
    return v ~= "" and v ~= "Lobby"
end

local function currentDungeonName()
    local dn = dungeonNameValue()
    local v = dn and dn.Value or ""
    if v == "Lobby" then return "" end
    return v
end

local function myPhaseFolderAndEntry()
    local games = Workspace:FindFirstChild("games")
    if not games then return nil, nil end
    for _, fname in ipairs({ "inLobby", "inGame" }) do
        local folder = games:FindFirstChild(fname)
        if folder then
            local entry = folder:FindFirstChild(localPlayer.Name)
            if entry then return folder, entry end
        end
    end
    return nil, nil
end

local function myEntry()
    local _, entry = myPhaseFolderAndEntry()
    return entry
end

local function entryMapName(entry)
    if not entry then return nil end
    local m = entry:FindFirstChild("mapName")
    if m and m.Value ~= nil and type(m.Value) == "string" then return m.Value end
    return nil
end

local function discoverMode(entry)
    if not entry then return nil end
    for _, v in ipairs(entry:GetChildren()) do
        local n = v.Name:lower()
        if (n:find("diff") or n:find("mode")) and v.Value ~= nil then
            local val = tostring(v.Value)
            for _, d in ipairs(Difficulties) do
                if val:lower() == d:lower() then return d end
            end
        end
    end
    return nil
end

local function readLevelValue(v)
    local ok, val = pcall(function() return v.Value end)
    if not ok then return nil end
    if type(val) == "number" then return val end
    if type(val) == "string" then
        return tonumber((val:gsub("[%s,]", "")))
    end
    return nil
end

local function getLevelForPlayer(p)
    if not p then return nil, nil end
    local ls = p:FindFirstChild("leaderstats")
    if ls then
        local exact = ls:FindFirstChild("Level")
        if exact then
            local n = readLevelValue(exact)
            if n then return n, "leaderstats.Level" end
        end
        for _, v in ipairs(ls:GetChildren()) do
            if v.Name:lower():find("level") then
                local n = readLevelValue(v)
                if n then return n, "leaderstats." .. v.Name end
            end
        end
    end
    for _, v in ipairs(p:GetChildren()) do
        if v.Name:lower():find("level") then
            local n = readLevelValue(v)
            if n then return n, "player." .. v.Name end
        end
    end
    local data = Workspace:FindFirstChild("playerData") or Workspace:FindFirstChild("data")
    if data then
        local pd = data:FindFirstChild(p.Name) or data:FindFirstChild(tostring(p.UserId))
        if pd then
            local exact = pd:FindFirstChild("Level")
            if exact then
                local n = readLevelValue(exact)
                if n then return n, "playerData.Level" end
            end
            for _, v in ipairs(pd:GetChildren()) do
                if v.Name:lower():find("level") then
                    local n = readLevelValue(v)
                    if n then return n, "playerData." .. v.Name end
                end
            end
        end
    end
    return nil, nil
end

local function scanPartyMembers()
    local me = localPlayer.Name
    local folder, entry = myPhaseFolderAndEntry()
    local myMap = entryMapName(entry)
    local seen, members = {}, {}

    if folder and myMap and myMap ~= "" and myMap ~= "Lobby" then
        for _, other in ipairs(folder:GetChildren()) do
            if other.Name ~= me and not seen[other.Name]
                and Players:FindFirstChild(other.Name)
                and entryMapName(other) == myMap then
                seen[other.Name] = true
                table.insert(members, other.Name)
            end
        end
    end

    for _, name in ipairs(configuredMembers) do
        if name ~= me:lower() and not seen[name] then
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Name:lower() == name then
                    seen[p.Name] = true
                    table.insert(members, p.Name)
                    break
                end
            end
        end
    end
    return members
end

local function isWorse(curName, curMode, bestName, bestMode)
    if curName ~= bestName then
        return (orderIndex[curName] or -1) < (orderIndex[bestName] or -1)
    end
    if not curMode then return false end
    return (diffIndex[curMode] or -1) < (diffIndex[bestMode] or -1)
end

local function fireStart()
    if startRemote then fireRemoteSafe(startRemote) end
    if changeStartRemote then
        task.wait(0.3)
        fireRemoteSafe(changeStartRemote)
    end
end

local lastReplayAt = 0
local function fireReplay()
    if replayRemote then fireRemoteSafe(replayRemote) end
end

local function returnToLobby()
    local t = 0
    while (inDungeon() or myEntry()) and masterEnabled and t < 30 do
        if t % 3 == 0 then leaveLobbyFire() end
        setStatus("Returning to lobby...")
        task.wait(1)
        t = t + 1
    end
end

local function createDungeonLobby(mapName, mode)
    mode = clampMode(mapName, mode)
    if not createLobbyRemote then
        setStatus("Create remote not found")
        return false
    end
    local ok, result = pcall(function()
        return createLobbyRemote:InvokeServer(mapName, mode, 0, hardcoreMode, privateLobby, false)
    end)
    local success = ok and (result == true or (type(result) == "table" and result[1] == true))
    if not success then
        setStatus("createLobby failed: " .. tostring(result))
    end
    return success
end

local function waitForEntry(timeout)
    local t = 0
    while masterEnabled and t < timeout do
        if myEntry() then return true end
        task.wait(1)
        t = t + 1
    end
    return myEntry() ~= nil
end

local function waitForDungeon(timeout)
    local t = 0
    while masterEnabled and t < timeout do
        if inDungeon() then return true end
        task.wait(1)
        t = t + 1
    end
    return inDungeon()
end

local function startWithMembers(expectedNames, shouldWait)
    if shouldWait and waitMembers and #expectedNames > 0 then
        local t = 0
        while masterEnabled and t < rejoinTimeout do
            local present = {}
            for _, entry in ipairs(scanPartyMembers()) do present[entry:lower()] = true end
            local missing = {}
            for _, n in ipairs(expectedNames) do
                local onServer = false
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Name:lower() == n:lower() then onServer = true; break end
                end
                if onServer and not present[n:lower()] then
                    table.insert(missing, n)
                end
            end
            if #missing == 0 then break end
            setStatus("Waiting for members: " .. table.concat(missing, ", "))
            task.wait(1)
            t = t + 1
        end
    end
    setStatus("Starting dungeon...")
    task.wait(2)
    fireStart()
    return waitForDungeon(90)
end

local function restartParty(best, mode, previousMembers)
    setStatus("Upgrading to " .. best .. " (" .. clampMode(best, mode) .. ") — restarting party...")
    lastQueuedMode = nil
    returnToLobby()
    if not masterEnabled then return end
    task.wait(1)

    if not createDungeonLobby(best, mode) then return end
    lastQueuedMode = clampMode(best, mode)
    waitForEntry(10)

    local expected = {}
    local seenNames = {}
    for _, n in ipairs(previousMembers or {}) do
        if not seenNames[n:lower()] then seenNames[n:lower()] = true; table.insert(expected, n) end
    end
    for _, n in ipairs(configuredMembers) do
        if not seenNames[n] then seenNames[n] = true; table.insert(expected, n) end
    end

    startWithMembers(expected, true)
end

local function keepReplaying(name)
    setStatus("Replaying " .. name .. "...")
    if replayRemote then
        fireReplay()
        lastReplayAt = os.clock()
        task.wait(8)
        return
    end
    task.wait(5)
    if masterEnabled and not inDungeon() and myEntry() then
        fireStart()
    end
end

local function waitForRunToFinish()
    local function getFlag()
        local d  = Workspace:FindFirstChild("dungeon")
        if not d then return nil end
        local br = d:FindFirstChild("bossRoom")
        return br and br:FindFirstChild("dungeonFinished")
    end

    local t = 0
    while not Workspace:FindFirstChild("dungeon") and masterEnabled and t < 30 do
        task.wait(1)
        t = t + 1
    end

    local flag = getFlag()
    if flag and flag.Value then
        local t2 = 0
        while masterEnabled and t2 < 60 do
            if not inDungeon() then return true end
            flag = getFlag()
            if not (flag and flag.Value) then break end
            task.wait(0.5)
            t2 = t2 + 0.5
        end
    end

    while masterEnabled do
        if not inDungeon() then return true end
        flag = getFlag()
        if flag and flag.Value then break end
        task.wait(1)
    end
    if not masterEnabled then return false end

    task.wait(4)
    return true
end

local function runCycle()
    if inDungeon() then
        local curName = currentDungeonName()
        if curName == "" then return end
        setStatus(curName .. " — running (waiting for dungeon end)...")
        if not waitForRunToFinish() then return end
        if not masterEnabled then return end

        local members = scanPartyMembers()
        local myLvl, lvlSrc = getLevelForPlayer(localPlayer)
        if levelLabel then
            levelLabel:SetText("Your level: " .. tostring(myLvl or "?") .. (lvlSrc and (" (" .. lvlSrc .. ")") or ""))
        end
        if not myLvl then
            setStatus("Level data not loaded — replaying current")
            keepReplaying(curName)
            return
        end

        local best, mode = bestPickForLevel(myLvl)
        if bestLabel then
            bestLabel:SetText("Best for your level: " .. (best and (best .. " (" .. mode .. ")") or "none"))
        end
        if not best then
            setStatus("No dungeon available for level " .. tostring(myLvl) .. " — replaying current")
            keepReplaying(curName)
            return
        end

        local curMode = lastQueuedMode or discoverMode(myEntry())
        if isWorse(curName, curMode, best, mode) then
            restartParty(best, mode, members)
        else
            keepReplaying(curName)
        end
        return
    end

    if os.clock() - lastReplayAt < 15 then return end
    local members = scanPartyMembers()

    local myLvl, lvlSrc = getLevelForPlayer(localPlayer)
    if levelLabel then
        levelLabel:SetText("Your level: " .. tostring(myLvl or "?") .. (lvlSrc and (" (" .. lvlSrc .. ")") or ""))
    end
    if not myLvl then
        setStatus("Waiting for level data...")
        task.wait(2)
        return
    end

    local best, mode = bestPickForLevel(myLvl)
    if bestLabel then
        bestLabel:SetText("Best for your level: " .. (best and (best .. " (" .. mode .. ")") or "none"))
    end
    if not best then
        setStatus("Level " .. tostring(myLvl) .. " — too low for any dungeon")
        task.wait(4)
        return
    end

    local entry = myEntry()
    local map = entryMapName(entry)
    if entry and map and map ~= "" and map ~= "Lobby" then
        local curMode = lastQueuedMode or discoverMode(entry)
        if isWorse(map, curMode, best, mode) then
            restartParty(best, mode, members)
        else
            setStatus("Lobby matches best — " .. map)
            startWithMembers(members, false)
        end
    else
        setStatus("Creating " .. best .. " (" .. mode .. ")...")
        if createDungeonLobby(best, mode) then
            lastQueuedMode = clampMode(best, mode)
            waitForEntry(10)
            local expected = {}
            for _, n in ipairs(members) do table.insert(expected, n) end
            for _, n in ipairs(configuredMembers) do
                local dup = false
                for _, m in ipairs(expected) do
                    if m:lower() == n then dup = true; break end
                end
                if not dup then table.insert(expected, n) end
            end
            startWithMembers(expected, true)
        else
            task.wait(4)
        end
    end
end

local function managerLoop()
    setStatus("Dungeon Manager running...")
    while masterEnabled do
        local ok, err = pcall(runCycle)
        if not ok then warn("cycle error: " .. tostring(err)) end
        task.wait(1)
    end
    setStatus("Dungeon Manager stopped.")
    managerThread = nil
end

local function onJoinRequest(requestId, displayName, eventType)
    if not autoAcceptEnabled then return end
    if eventType == "close" or requestId == nil then return end
    if respondJoinRemote then fireRemoteSafe(respondJoinRemote, requestId, true) end
    print("Accepted join request from " .. tostring(displayName))
end

local function connectAccept()
    if acceptConn or not showJoinRemote then return end
    acceptConn = showJoinRemote.OnClientEvent:Connect(onJoinRequest)
end

local function disconnectAccept()
    if acceptConn then
        pcall(function() acceptConn:Disconnect() end)
        acceptConn = nil
    end
end


task.spawn(function()
    local dungeonFinishDetectedAt = nil
    local wasInDungeon = false

    while true do
        task.wait(1)
        local inDun = inDungeon()

        if inDun then
            wasInDungeon = true
            local d = Workspace:FindFirstChild("dungeon")
            local bossRoom = d and d:FindFirstChild("bossRoom")
            local fin = bossRoom and bossRoom:FindFirstChild("dungeonFinished")
            local progress = Workspace:FindFirstChild("dungeonProgress")
            local pg = localPlayer:FindFirstChild("PlayerGui")
            local dc = pg and pg:FindFirstChild("dungeonClear")
            local gd = pg and pg:FindFirstChild("gameDefeat")
            local lives = d and (d:FindFirstChild("lives") or d:FindFirstChild("Lives"))

            local isFinished = false
            if fin and fin.Value == true then
                isFinished = true
            elseif progress and progress.Value == "bossKilled" then
                isFinished = true
            elseif dc and dc.Enabled then
                isFinished = true
            elseif gd and gd.Enabled then
                isFinished = true
            elseif lives and lives.Value <= 0 then
                isFinished = true
            end

            
            local leaderGone = false
            if targetJoinUsername ~= "" then
                local leaderFound = false
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Name:lower() == targetJoinUsername:lower() then
                        leaderFound = true
                        break
                    end
                end
                if not leaderFound then
                    leaderGone = true
                end
            end

            if isFinished or leaderGone then
                if not dungeonFinishDetectedAt then
                    dungeonFinishDetectedAt = tick()
                end

               
                local waitSec = leaderGone and 1 or (returnLobbyDelay or 4)

                if autoReturnLobbyEnabled and (tick() - dungeonFinishDetectedAt >= waitSec) then
                    
                    if not masterEnabled or leaderGone then
                        setStatus("Dungeon completed — returning to lobby...")
                        leaveLobbyFire()
                    end
                end
            else
                dungeonFinishDetectedAt = nil
            end
        else
            if wasInDungeon then
                wasInDungeon = false
                dungeonFinishDetectedAt = nil
            end
        end
    end
end)


task.spawn(function()
    while true do
        if autoJoinEnabled and targetJoinUsername ~= "" and sendJoinRemote then
            pcall(function()
                sendJoinRemote:InvokeServer(targetJoinUsername)
            end)
        end
        task.wait(2)
    end
end)

-- ====================================================================
-- 9. GIAO DIỆN TAB: MAIN
-- ====================================================================
LeftCol:AddToggle("Master", {
    Text     = "Auto Best Dungeon",
    Default  = false,
    Callback = function(value)
        masterEnabled = value
        if value then
            if not managerThread then
                managerThread = task.spawn(managerLoop)
            end
        else
            lastQueuedMode = nil
        end
    end,
})

LeftCol:AddToggle("Hardcore", {
    Text     = "Hardcore Lobby",
    Default  = false,
    Callback = function(value) hardcoreMode = value end,
})

LeftCol:AddToggle("Private", {
    Text     = "Private Lobby",
    Default  = false,
    Callback = function(value) privateLobby = value end,
})

LeftCol:AddToggle("WaitMembers", {
    Text     = "Wait For Members After restart",
    Default  = true,
    Callback = function(value) waitMembers = value end,
})

LeftCol:AddSlider("RejoinTimeout", {
    Text     = "Member Rejoin Timeout (s)",
    Default  = 45,
    Min      = 10,
    Max      = 120,
    Rounding = 0,
    Callback = function(value) rejoinTimeout = value end,
})

LeftCol:AddInput("Members", {
    Default     = "",
    Numeric     = false,
    Finished    = true,
    Text        = "Member Usernames (Host only)",
    Placeholder = "alt1, alt2",
    Callback    = function(value) configuredMembers = parseNames(value) end,
})

LeftCol:AddToggle("AutoAccept", {
    Text     = "Auto Accept Join Requests",
    Default  = true,
    Callback = function(value)
        autoAcceptEnabled = value
        if value then connectAccept() else disconnectAccept() end
    end,
})

LeftCol:AddDivider()

LeftCol:AddInput("TargetUsernameJoin", {
    Default     = "",
    Numeric     = false,
    Finished    = false,
    Text        = "Host Username to join",
    Placeholder = "Host Username",
    Callback    = function(value) targetJoinUsername = value end,
})

LeftCol:AddToggle("AutoSendJoinReq", {
    Text     = "Auto Send Join Request (For Alt)",
    Default  = false,
    Callback = function(value) autoJoinEnabled = value end,
})

LeftCol:AddToggle("AutoReturnLobby", {
    Text     = "Auto Return Lobby (When Dungeon Ends)",
    Default  = true,
    Callback = function(value) autoReturnLobbyEnabled = value end,
})

LeftCol:AddSlider("ReturnLobbyDelay", {
    Text     = "Return Lobby Delay (s)",
    Default  = 4,
    Min      = 1,
    Max      = 15,
    Rounding = 0,
    Callback = function(value) returnLobbyDelay = value end,
})

LeftCol:AddDivider()

LeftCol:AddButton({
    Text = "Refresh Server Requirements",
    Func = function()
        task.spawn(function()
            refreshDungeonReqs()
            Library:Notify("Dungeon requirements refreshed.")
        end)
    end,
})

LeftCol:AddButton({
    Text = "Return To Lobby Now",
    Func = function()
        task.spawn(function()
            leaveLobbyFire()
            Library:Notify("Leaving dungeon / Returning to lobby...")
        end)
    end,
})

local accountLabel = RightCol:AddLabel("Account: —")
statusLabel        = RightCol:AddLabel("State: Idle")
bestLabel          = RightCol:AddLabel("Best for your level: —")
levelLabel         = RightCol:AddLabel("Your level: —")

local function refreshStatus()
    if accountLabel then
        accountLabel:SetText("Account: " .. localPlayer.Name .. " (" .. tostring(localPlayer.UserId) .. ")")
    end
    local myLvl, lvlSrc = getLevelForPlayer(localPlayer)
    if levelLabel then
        levelLabel:SetText("Your level: " .. tostring(myLvl or "?") .. (lvlSrc and (" (" .. lvlSrc .. ")") or ""))
    end
    if bestLabel then
        if myLvl then
            local b, m = bestPickForLevel(myLvl)
            bestLabel:SetText("Best for your level: " .. (b and (b .. " (" .. m .. ")") or "none"))
        else
            bestLabel:SetText("Best for your level: —")
        end
    end
    if statusLabel then
        if masterEnabled then
            if os.clock() - detailStatusAt >= 5 then
                local dn = dungeonNameValue()
                local v = dn and dn.Value or ""
                statusLabel:SetText(inDungeon() and ("State: In dungeon — " .. v) or "State: Lobby")
            end
        else
            statusLabel:SetText(inDungeon() and ("State: In dungeon (" .. (currentDungeonName() or "?") .. ")") or "State: Idle (Lobby)")
        end
    end
end

task.spawn(function()
    while true do
        refreshStatus()
        task.wait(1)
    end
end)


WebhookLeft:AddInput("WebhookURLInput", {
    Default     = "",
    Numeric     = false,
    Finished    = true,
    Text        = "Discord Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback    = function(value) WEBHOOK_URL = value end,
})

WebhookLeft:AddInput("DiscordIDInput", {
    Default     = "",
    Numeric     = false,
    Finished    = true,
    Text        = "Discord User ID (For Pings)",
    Placeholder = "1234567890",
    Callback    = function(value) DISCORD_ID = value end,
})

WebhookLeft:AddToggle("EnableWebhook", {
    Text     = "Enable Discord Webhook",
    Default  = false,
    Callback = function(value) SEND_WEBHOOK = value end,
})

WebhookLeft:AddToggle("SendStatsEmbedToggle", {
    Text     = "Send Session Stats Embed",
    Default  = true,
    Callback = function(value) SEND_STATS = value end,
})

WebhookLeft:AddSlider("StatsEveryWinsSlider", {
    Text     = "Stats Every X Wins",
    Default  = 1,
    Min      = 1,
    Max      = 20,
    Rounding = 0,
    Callback = function(value) STATS_EVERY_WINS = value end,
})

WebhookLeft:AddToggle("PingEpicToggle", {
    Text     = "Ping on Epic Drop",
    Default  = true,
    Callback = function(value) PING_ON_EPIC = value end,
})

WebhookLeft:AddToggle("PingLegendaryToggle", {
    Text     = "Ping on Legendary Drop",
    Default  = true,
    Callback = function(value) PING_ON_LEGENDARY = value end,
})

WebhookLeft:AddToggle("PingUltimateToggle", {
    Text     = "Ping on Ultimate Drop",
    Default  = true,
    Callback = function(value) PING_ON_ULTIMATE = value end,
})

WebhookLeft:AddButton({
    Text = "Send Test Webhook",
    Func = function()
        task.spawn(function()
            if WEBHOOK_URL == "" then
                Library:Notify("Please enter a Webhook URL first!", 3)
                return
            end
            local payload = {
                ["content"] = DISCORD_ID ~= "" and ("<@" .. DISCORD_ID .. ">") or "",
                ["embeds"] = {{
                    ["title"] = "Webhook sent successfully",
                    ["description"] = "hieutrung doggy",
                    ["color"] = 65280,
                    ["fields"] = {
                        { ["name"] = "Account", ["value"] = localPlayer.Name .. " (" .. tostring(localPlayer.UserId) .. ")", ["inline"] = true },
                        { ["name"] = "Time",    ["value"] = os.date("%Y-%m-%d %H:%M:%S"), ["inline"] = true }
                    },
                    ["footer"] = { ["text"] = "hieutrung doggy x aphalia" },
                    ["timestamp"] = DateTime.now():ToIsoDate()
                }}
            }
            local ok = postWebhook(payload)
            if ok then
                Library:Notify("Test webhook sent successfully!", 3)
            else
                Library:Notify("Failed to send webhook. Check URL/executor!", 4)
            end
        end)
    end,
})

statRunsLabel   = WebhookRight:AddLabel("Total runs: 0")
statWinsLabel   = WebhookRight:AddLabel("Wins: 0 | Losses: 0")
statClearLabel  = WebhookRight:AddLabel("Average clear: —")
statSpellsLabel = WebhookRight:AddLabel("EIF: 0 | EIR: 0")

local function updateStatsLabels()
    if statRunsLabel then statRunsLabel:SetText("Total runs: " .. tostring(stats.runs)) end
    if statWinsLabel then statWinsLabel:SetText("Wins: " .. tostring(stats.wins) .. " | Losses: " .. tostring(stats.losses)) end
    if statClearLabel then
        statClearLabel:SetText(stats.wins > 0 and ("Average clear: " .. fmtTime(stats.clearTime / stats.wins)) or "Average clear: —")
    end
    if statSpellsLabel then statSpellsLabel:SetText("EIF: " .. tostring(stats.eif) .. " | EIR: " .. tostring(stats.eir)) end
end

task.spawn(function()
    while true do
        updateStatsLabels()
        task.wait(2)
    end
end)

WebhookRight:AddButton({
    Text = "Send Stats Embed Now",
    Func = function()
        task.spawn(function()
            if WEBHOOK_URL == "" then
                Library:Notify("Please enter a Webhook URL first!", 3)
                return
            end
            postWebhook(buildStatsEmbed())
            Library:Notify("Stats embed sent to Discord.", 3)
        end)
    end,
})

WebhookRight:AddButton({
    Text = "Reset Session Stats",
    Func = function()
        if _G.resetSessionStats then _G.resetSessionStats() end
        updateStatsLabels()
        Library:Notify("Session stats have been reset.", 3)
    end,
})


local MenuGroup = Tabs.UISettings:AddLeftGroupbox("Menu")
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "End",
    NoUI    = true,
    Text    = "Menu keybind",
})
Library.ToggleKeybind = Options.MenuKeybind

MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = Library.ShowCustomCursor ~= false,
    Callback = function(value) Library.ShowCustomCursor = value end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values  = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text    = "DPI Scale",
    Callback = function(value)
        local dpi = tonumber(value:gsub("%%", ""))
        if dpi then pcall(function() Library:SetDPIScale(dpi) end) end
    end,
})

MenuGroup:AddDivider()
MenuGroup:AddButton({ Text = "Unload", Func = function() Library:Unload() end })

local ConfigRoot = "AutoBestDungeon/" .. tostring(localPlayer.UserId)
if ThemeManager then
    ThemeManager:SetLibrary(Library)
    ThemeManager:SetFolder("AutoBestDungeon/themes")
    ThemeManager:ApplyToTab(Tabs.UISettings)
end
if SaveManager then
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
    SaveManager:SetFolder(ConfigRoot)
    SaveManager:BuildConfigSection(Tabs.UISettings)
    SaveManager:LoadAutoloadConfig()
end

Library:OnUnload(function()
    masterEnabled = false
    disconnectAccept()
end)

connectAccept()


local runActive, runFired = false, false
local currentDungeon = nil
local runStart, runStartGold, runStartGems, runStartLevel = 0, 0, 0, 0
local prevInvCounts    = nil
local baselineDeadline = 0
local baselineWarned   = false
local lastWebhookTime  = 0
local lastLoopTime     = 0
local lastInvScan      = 0
local lastScreenLoot   = 0
local lastInvCount     = 0
local zeroTimerSince   = nil
local lastWinSeen      = 0
local lastBossKilled   = 0
local lastClearSeen    = 0
local lastDefeatSeen   = 0
local staleScreenKeys  = {}
local runEpoch         = 0
local invReadBusy      = false
local invReadStart     = 0
local lastInventoryError = nil
local lastInventoryErrorAt = 0

local function checkTimerIsZero(playerGui)
    if not playerGui then return false end
    local ok, hit = pcall(function()
        for _, v in ipairs(playerGui:GetDescendants()) do
            if v:IsA("TextLabel") and (v.Text == "00:01" or v.Text == "00:00") then
                return true
            end
        end
        return false
    end)
    return ok and hit or false
end

local function scrapeScreenInto(col, staleKeys)
    local tally = {}
    for _, item in ipairs(getLootFromUI()) do
        local key = item.Name .. "|" .. tostring(item.Rarity)
        if not staleKeys[key] then
            tally[key] = (tally[key] or 0) + 1
        end
    end
    for key, n in pairs(tally) do
        local src = col.src and col.src[key]
        local prev = src and src.screen or 0
        if n > prev then
            local name, rarity = key:match("^(.*)|(.*)$")
            collectorAdd(col, name, rarity, nil, "screen", n - prev)
        end
    end
end

local function inventoryDiffSpawn(col, onDone, checkEpoch)
    invReadBusy  = true
    invReadStart = tick()
    local epoch = checkEpoch and runEpoch or nil
    task.spawn(function()
        local list, inventoryError = readInventory()
        invReadBusy = false
        if not list and inventoryError
            and (inventoryError ~= lastInventoryError or tick() - lastInventoryErrorAt >= 15) then
            lastInventoryError = inventoryError
            lastInventoryErrorAt = tick()
        end
        local fresh = (not checkEpoch) or (epoch == runEpoch)
        local cur, total = nil, 0
        if list and fresh then
            cur = listToCounts(list)
            if col and prevInvCounts then
                local catByKey = {}
                for _, it in ipairs(list) do catByKey[it.Name .. "|" .. it.Rarity] = it.Cat end
                for key, count in pairs(cur) do
                    local inc = count - (prevInvCounts[key] or 0)
                    if inc > 0 then
                        local name, rarity = key:match("^(.*)|(.*)$")
                        collectorAdd(col, name, rarity, catByKey[key], "inv", inc)
                    end
                end
            end
            prevInvCounts = cur
            for _, c in pairs(cur) do total = total + c end
        end
        if onDone then onDone(fresh and cur or nil, total) end
    end)
end

local function sawWinSignal()
    return lastWinSeen > 0 or lastBossKilled > 0 or lastClearSeen > 0
end

local function startRun(dungeon, now)
    runActive       = true
    runFired        = false
    runEpoch        = runEpoch + 1
    currentDungeon  = dungeon
    runStart        = now
    runStartGold    = getStat("Gold") or 0
    runStartGems    = getStat("Gems") or 0
    runStartLevel   = getStat("Level") or 0
    prevInvCounts    = nil
    baselineDeadline = now + 5
    baselineWarned   = false
    lastInvScan     = 0
    lastScreenLoot  = 0
    lastInvCount    = 0
    zeroTimerSince  = nil
    lastWinSeen     = 0
    lastBossKilled  = 0
    lastClearSeen   = 0
    lastDefeatSeen  = 0
    runCollector    = { drops = {}, index = {}, src = {} }
    staleScreenKeys = {}
    for _, item in ipairs(getLootFromUI()) do
        staleScreenKeys[item.Name .. "|" .. tostring(item.Rarity)] = true
    end
    print("Run started — new dungeon instance detected.")
end

local sweepPending = false
local sweepDone    = false
local sweepCol, sweepStale = nil, nil

local function requestSweep(col, stale, timeout)
    sweepCol, sweepStale = col, stale
    sweepDone    = false
    sweepPending = true
    local deadline = tick() + (timeout or 30)
    while not sweepDone and tick() < deadline do task.wait(0.25) end
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if tick() - invReadStart > 12 then invReadBusy = false end
        if sweepPending and not invReadBusy then
            sweepPending = false
            local col, stale = sweepCol, sweepStale
            scrapeScreenInto(col, stale)
            inventoryDiffSpawn(col, function() sweepDone = true end)
        elseif runActive and not runFired and not invReadBusy then
            if tick() - lastInvScan >= 1 then
                lastInvScan = tick()
                local wasBaseline = prevInvCounts == nil
                inventoryDiffSpawn(runCollector, function(counts, total)
                    if counts then
                        lastInvCount = total
                        if wasBaseline then baselineWarned = false end
                    elseif wasBaseline and not baselineWarned and tick() > baselineDeadline then
                        baselineWarned = true
                    end
                end, true)
            end
        end
    end
end)

local function endRun(isWin)
    runFired = true
    local reportCol    = runCollector
    local reportStale  = staleScreenKeys
    local myDungeon    = currentDungeon
    local myRunStart   = runStart
    local myStartGold  = runStartGold
    local myStartGems  = runStartGems
    local myStartLevel = runStartLevel
    local myClearTime  = tick() - runStart
    local myMap        = getMapName()
    task.spawn(function()
        local endAt = tick()
        local lastCount, stable = -1, 0
        while tick() - endAt < 3 do
            scrapeScreenInto(reportCol, reportStale)
            if not invReadBusy then requestSweep(reportCol, reportStale, 1) end
            local d = Workspace:FindFirstChild("dungeon")
            if d and myDungeon and d ~= myDungeon then break end
            if #reportCol.drops == lastCount then
                stable = stable + 1
                if stable >= 2 and not screenVisible() and tick() - endAt > 1.5 then break end
            else
                stable = 0
                lastCount = #reportCol.drops
            end
            task.wait(0.5)
        end

        sendDiscordEmbed(isWin, reportCol.drops, {
            Level      = tostring(getStat("Level") or myStartLevel),
            GoldEarned = deltaStr((getStat("Gold") or myStartGold) - myStartGold),
            TotalGold  = abbrevNum(getStat("Gold") or 0),
            GemsEarned = deltaStr((getStat("Gems") or myStartGems) - myStartGems),
            TotalGems  = abbrevNum(getStat("Gems") or 0),
            RunTime    = fmtTime(tick() - myRunStart),
            Inventory  = (lastInvCount > 0) and (lastInvCount .. "/" .. INV_CAPACITY) or "—",
        })
        lastWebhookTime = tick()

        foldRunIntoStats(reportCol, isWin, myClearTime)
        saveStats()
        pcall(function()
            appendRunRecord({
                time  = os.date("%Y-%m-%d %H:%M:%S"),
                map   = myMap,
                win   = isWin,
                clear = math.floor(myClearTime + 0.5),
                drops = reportCol.drops,
            })
        end)
        maybeSendStats(isWin)

        local before = #reportCol.drops
        task.wait(30)
        local d = Workspace:FindFirstChild("dungeon")
        if d and myDungeon and d ~= myDungeon then return end
        requestSweep(reportCol, reportStale, 15)
        if #reportCol.drops > before then
            local late = {}
            for i = before + 1, #reportCol.drops do table.insert(late, reportCol.drops[i]) end
            foldItemsIntoStats(late)
            saveStats()
            pcall(function()
                appendRunRecord({
                    time  = os.date("%Y-%m-%d %H:%M:%S"),
                    map   = myMap,
                    win   = isWin,
                    clear = math.floor(myClearTime + 0.5),
                    late  = true,
                    drops = late,
                })
            end)
            sendDiscordEmbed(isWin, late, {
                Level   = tostring(getStat("Level") or myStartLevel),
                RunTime = fmtTime(tick() - myRunStart),
            }, "late loot")
            lastWebhookTime = tick()
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.05)
        local now = tick()
        local throttled = lastLoopTime > 0 and (now - lastLoopTime) > 0.3
        lastLoopTime = now

        local dungeon   = Workspace:FindFirstChild("dungeon")
        local playerGui = localPlayer:FindFirstChild("PlayerGui")

        if dungeon and dungeon ~= currentDungeon then
            if runActive and not runFired then
                local win = sawWinSignal()
                endRun(win)
            end
            startRun(dungeon, now)
        end

        if runActive and dungeon == currentDungeon and dungeon then
            local bossRoom = dungeon:FindFirstChild("bossRoom")
            local fin = bossRoom and bossRoom:FindFirstChild("dungeonFinished")
            if fin and fin.Value == true then lastWinSeen = now end
            local progress = Workspace:FindFirstChild("dungeonProgress")
            if progress and progress.Value == "bossKilled" then lastBossKilled = now end
            if playerGui then
                local dc = playerGui:FindFirstChild("dungeonClear")
                if dc and dc.Enabled then lastClearSeen = now end
                local gd = playerGui:FindFirstChild("gameDefeat")
                if gd and gd.Enabled then lastDefeatSeen = now end
            end

            if not runFired then
                if now - lastScreenLoot >= 0.5 then
                    lastScreenLoot = now
                    scrapeScreenInto(runCollector, staleScreenKeys)
                end

                local lives = dungeon:FindFirstChild("lives") or dungeon:FindFirstChild("Lives")

                if fin and fin.Value == true then
                    zeroTimerSince = nil
                    if now - lastWebhookTime > 10 then endRun(true) end
                else
                    local isLose = false
                    if lives and lives.Value <= 0 then
                        isLose = true
                    elseif playerGui and (playerGui:FindFirstChild("gameDefeat") and playerGui.gameDefeat.Enabled) then
                        isLose = true
                    elseif not throttled and checkTimerIsZero(playerGui) then
                        if not zeroTimerSince then zeroTimerSince = now end
                        if now - zeroTimerSince >= 0.5 then isLose = true end
                    else
                        zeroTimerSince = nil
                    end

                    if isLose and (now - lastWebhookTime > 10) then endRun(false) end
                end
            end
        end

        if runActive and not dungeon then
            if not runFired and (now - runStart > 5) and (now - lastWebhookTime > 10) then
                local win = sawWinSignal()
                endRun(win)
            elseif runFired then
                runActive = false
            end
        end
    end
end)


task.spawn(function()
    task.wait(3)
    refreshDungeonReqs()
end)

Library:Notify("hieutrung doggy + Webhook loaded! User: " .. tostring(localPlayer.UserId), 4)
print("Loaded successfully — configs at: " .. ConfigRoot)
