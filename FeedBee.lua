

local Config = getgenv().Config
local FeedConfig = Config["Auto Feed"]
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ClientStatCache = require(RS:WaitForChild("ClientStatCache"))
local Player = Players.LocalPlayer
local Events = RS:WaitForChild("Events")

local Cache = { data = nil, last = 0 }
local FEED_DONE = false
local FEED_TARGETS = nil

local ITEM_KEYS = {
    MoonCharm = "MoonCharm", Pineapple = "Pineapple", Strawberry = "Strawberry",
    Blueberry = "Blueberry", SunflowerSeed = "SunflowerSeed", Bitterberry = "Bitterberry",
    Neonberry = "Neonberry", GingerbreadBear = "GingerbreadBear", Treat = "Treat"
}

local BOND_ITEMS = {
    { Name = "Neonberry", Value = 500 },
    { Name = "MoonCharm", Value = 250 },
    { Name = "GingerbreadBear", Value = 250 },
    { Name = "Bitterberry", Value = 100 },
    { Name = "Pineapple", Value = 50 },
    { Name = "Strawberry", Value = 50 },
    { Name = "Blueberry", Value = 50 },
    { Name = "SunflowerSeed", Value = 50 },
    { Name = "Treat", Value = 10 }
}

local QUEST_ORDER = {
    "Treat Tutorial", "Bonding With Bees", "Search For A Sunflower Seed",
    "The Gist Of Jellies", "Search For Strawberries", "Binging On Blueberries",
    "Royal Jelly Jamboree", "Search For Sunflower Seeds", "Picking Out Pineapples", "Seven To Seven"
}

local QUEST_TREAT_REQ = {
    ["Treat Tutorial"] = 1, ["Bonding With Bees"] = 5, ["Search For A Sunflower Seed"] = 10,
    ["The Gist Of Jellies"] = 15, ["Search For Strawberries"] = 20, ["Binging On Blueberries"] = 30,
    ["Royal Jelly Jamboree"] = 50, ["Search For Sunflower Seeds"] = 100, ["Picking Out Pineapples"] = 250,
    ["Seven To Seven"] = 500
}

local QUEST_FRUIT_REQ = {
    ["Search For A Sunflower Seed"] = { SunflowerSeed = 1 },
    ["Search For Strawberries"] = { Strawberry = 5 },
    ["Binging On Blueberries"] = { Blueberry = 10 },
    ["Search For Sunflower Seeds"] = { SunflowerSeed = 25 },
    ["Picking Out Pineapples"] = { Pineapple = 25 },
    ["Seven To Seven"] = { Blueberry = 25, Strawberry = 25 }
}

local function getCache()
    if tick() - Cache.last > 1 then
        local ok, res = pcall(function() return require(RS.ClientStatCache):Get() end)
        if ok then Cache.data = res; Cache.last = tick() end
    end
    return Cache.data
end

local function deepFind(tbl, key, seen)
    if type(tbl) ~= "table" then return end
    seen = seen or {}
    if seen[tbl] then return end
    seen[tbl] = true
    for k, v in pairs(tbl) do
        if k == key then return v end
        if type(v) == "table" then
            local f = deepFind(v, key, seen)
            if f then return f end
        end
    end
end

local function getInventory()
    local cache = getCache()
    if not cache or not cache.Eggs then return {} end
    local inv = {}
    for name, key in pairs(ITEM_KEYS) do
        inv[name] = tonumber(cache.Eggs[key]) or 0
    end
    return inv
end

local function getBees()
    local cache = getCache()
    local bees = {}
    if not cache or not cache.Honeycomb then return bees end
    for cx, col in pairs(cache.Honeycomb) do
        for cy, bee in pairs(col) do
            if bee and bee.Lvl then
                local x = tonumber(tostring(cx):match("%d+"))
                local y = tonumber(tostring(cy):match("%d+"))
                if x and y then
                    table.insert(bees, { col = x, row = y, level = bee.Lvl })
                end
            end
        end
    end
    return bees
end

local function getBondLeft(col, row)
    local result
    pcall(function() result = Events.GetBondToLevel:InvokeServer(col, row) end)
    if type(result) == "number" then return result end
    if type(result) == "table" then
        for _, v in pairs(result) do
            if type(v) == "number" then return v end
        end
    end
end

local function buyTreat()
    local cfg = FeedConfig
    if not cfg or not cfg["Auto Buy Treat"] then return end
    local honey = Player.CoreStats.Honey.Value
    if honey < 10000000 then return end
    pcall(function()
        Events.ItemPackageEvent:InvokeServer("Purchase", { ["Type"] = "Treat", ["Amount"] = 1000, ["Category"] = "Eggs" })
    end)
end


local function feedBee(col, row, bondLeft)
    buyTreat()
    local inv = getInventory()
    local remaining = bondLeft
    for _, item in ipairs(BOND_ITEMS) do
        if remaining <= 0 then break end
        if FeedConfig["Bee Food"][item.Name] then
            local have = inv[item.Name] or 0
            if have > 0 then
                local need = math.ceil(remaining / item.Value)
                local use = math.min(have, need)
                pcall(function()
                    Events.ConstructHiveCellFromEgg:InvokeServer(col, row, ITEM_KEYS[item.Name], use, false)
                end)
                remaining -= (use * item.Value)
                task.wait(3)
            end
        end
    end
end

local function isQuestCompleted(list, name)
    for _, q in pairs(list or {}) do
        if tostring(q) == name then return true end
    end
    return false
end

local function getCurrentQuest(completed)
    for _, q in ipairs(QUEST_ORDER) do
        if not isQuestCompleted(completed, q) then return q end
    end
end

local function getGlobalReserve(completed)
    local treat = 0
    local fruits = {}
    for _, q in ipairs(QUEST_ORDER) do
        if not isQuestCompleted(completed, q) then
            treat += (QUEST_TREAT_REQ[q] or 0)
            local f = QUEST_FRUIT_REQ[q]
            if f then
                for name, amt in pairs(f) do
                    fruits[name] = (fruits[name] or 0) + amt
                end
            end
        end
    end
    return treat, fruits
end


local function autoFeed()
    if FEED_DONE or not FeedConfig["Enable"] then return end

    local cache = getCache()
    if not cache then return end

    local completed = deepFind(cache, "Completed") or {}
    local currentQuest = getCurrentQuest(completed)

    if not currentQuest then
        FEED_DONE = true
        return
    end

    local isFinalQuest = (currentQuest == "Seven To Seven")
    local reserveTreat, reserveFruits = getGlobalReserve(completed)

    local bees = getBees()
    table.sort(bees, function(a, b) return a.level < b.level end)

    local maxCount = FeedConfig["Bee Amount"] or 50
    local targetLevel = 15 -- def

    if not FEED_TARGETS then
        FEED_TARGETS = {}
        for _, b in ipairs(bees) do
            if b.level < targetLevel then
                FEED_TARGETS[#FEED_TARGETS + 1] = b
                if #FEED_TARGETS >= maxCount then break end
            end
        end

        if #FEED_TARGETS == 0 then
            print("[AutoFeed] Không có ong cần feed")
            FEED_DONE = true
            return
        end
        print("[AutoFeed] Lock", #FEED_TARGETS, "bees để feed tới level", targetLevel)
    end

    local finished = 0

    for _, b in ipairs(FEED_TARGETS) do
        local bondLeft = getBondLeft(b.col, b.row)

        if not bondLeft or bondLeft <= 0 then
            finished += 1
            continue
        end

        local remaining = bondLeft
        local inventory = getInventory()
        local fedSomething = false

        for _, item in ipairs(BOND_ITEMS) do
            if remaining <= 0 then break end
            if FeedConfig["Bee Food"] and FeedConfig["Bee Food"][item.Name] then
                local keep = 0

                if not isFinalQuest then
                    if item.Name == "Treat" then keep = reserveTreat end
                    if reserveFruits[item.Name] then keep = reserveFruits[item.Name] end
                end

                local have = (inventory[item.Name] or 0) - keep
                if have > 0 then
                    local need = math.ceil(remaining / item.Value)
                    local use = math.min(have, need)

                    if use > 0 then
                        local keyName = ITEM_KEYS[item.Name]
                        local bondGain = use * item.Value

                        print("[AutoFeed] Bee[" .. b.col .. "," .. b.row .. "] | Lv " .. b.level .. " -> " .. targetLevel .. " | Item " .. item.Name .. " | Use " .. use .. " | Bond +" .. bondGain)
                        Events.ConstructHiveCellFromEgg:InvokeServer(b.col, b.row, keyName, use, false)

                        remaining -= bondGain
                        fedSomething = true
                        task.wait(2)
                        return
                    end
                end
            end
        end

        
        if not fedSomething and FeedConfig["Auto Buy Treat"] then
            local haveTreat = inventory["Treat"] or 0
            local freeTreat = haveTreat - reserveTreat
            local needTreat = math.max(0, math.ceil(remaining / 10) - freeTreat)

            if needTreat > 0 then
                local honey = Player.CoreStats.Honey.Value
                local cost = needTreat * 10000

                if honey >= cost then
                    print("[AutoFeed] BUY Treat | Need " .. needTreat .. " | Cost " .. cost .. " | Honey " .. honey)
                    Events.ItemPackageEvent:InvokeServer("Purchase", { Type = "Treat", Amount = needTreat, Category = "Eggs" })
                    task.wait(1.5)
                    return
                else
                    print("[AutoFeed] Not enough honey to buy Treat")
                end
            end
        end
    end

    if finished >= #FEED_TARGETS then
        print("[AutoFeed] DONE: Done", #FEED_TARGETS, "Until level", targetLevel)
        FEED_DONE = true
    end
end


task.spawn(function()
    while task.wait(3) do
        autoFeed()
    end
end)
