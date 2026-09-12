local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local Workspace          = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

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
    if not remotes then return nil end
    if type(names) == "string" then names = { names } end
    for _, n in ipairs(names) do
        local lower = n:lower()
        for _, v in ipairs(remotes:GetChildren()) do
            if v.Name:lower() == lower then return v end
        end
    end
    return nil
end

local createLobbyRemote  = findRemote({ "createLobby", "createDungeon" })
local startRemote        = findRemote("startDungeon")
local changeStartRemote  = findRemote("changeStartValue")
local replayRemote       = findRemote("replayDungeon")
local dungeonStatsRemote = findRemote("getDungeonStats")
local respondJoinRemote  = findRemote("respondJoinRequest")
local showJoinRemote     = findRemote("showJoinRequest")
local sendJoinRemote     = findRemote("sendJoinRequest") -- [NEW] Remote để gửi yêu cầu join
local leaveRemote        = findRemote({ "ReturnToLobbyEvent", "teleToLobby", "leaveDungeon", "goLobby", "leaveGame" })

local okWin, Window = pcall(function()
    return Library:CreateWindow({
        Title    = "hieutrung doggy",
        Footer   = "created by the one and only. x2hieutrung",
        Center   = true,
        AutoShow = true,
        Size     = UDim2.new(0, 500, 0, 320),
    })
end)
if not okWin or not Window then
    warn("CreateWindow failed — script aborted")
    return
end

local Tabs = {
    Main      = Window:AddTab("Main"),
    UISettings = Window:AddTab("UI Settings"),
}

local LeftCol  = Tabs.Main:AddLeftGroupbox("Manager")
local RightCol = Tabs.Main:AddRightGroupbox("Status")

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
    local ok, stats = pcall(function() return dungeonStatsRemote:InvokeServer(name) end)
    if not ok or type(stats) ~= "table" then return end
    local reqs = {}
    for _, d in ipairs(Difficulties) do
        local entry = stats[d]
        if type(entry) == "table" and tonumber(entry.levelReq) then
            reqs[d] = tonumber(entry.levelReq)
        end
    end
    if next(reqs) then
        DungeonReqs[name] = reqs
        print("" .. name .. " reqs (server): updated")
    end
end

local function refreshDungeonReqs()
    for _, name in ipairs(DungeonOrder) do
        if not EventDungeons[name] then
            fetchDungeonReqs(name)
            task.wait(0.1)
        end
    end
end

local masterEnabled      = false
local managerThread      = nil
local hardcoreMode       = false
local privateLobby       = false
local waitMembers        = true
local rejoinTimeout      = 45
local autoAcceptEnabled  = true
local configuredMembers  = {}
local lastQueuedMode     = nil
local acceptConn         = nil

-- [NEW] Biến trạng thái cho tính năng Auto Join Request
local autoJoinEnabled    = false 
local targetJoinUsername = ""

local statusLabel, levelLabel, bestLabel
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
    if startRemote then pcall(function() startRemote:FireServer() end) end
    if changeStartRemote then
        task.wait(0.3)
        pcall(function() changeStartRemote:FireServer() end)
    end
end

local lastReplayAt = 0

local function fireReplay()
    if replayRemote then
        pcall(function() replayRemote:FireServer() end)
    end
end

local function leaveLobbyFire()
    if leaveRemote then pcall(function() leaveRemote:FireServer() end) end
end

local function returnToLobby()
    local t = 0
    while myEntry() and masterEnabled and t < 30 do
        if t % 5 == 0 then leaveLobbyFire() end
        setStatus("Leaving party...")
        task.wait(1)
        t = t + 1
    end
end

local function createDungeonLobby(mapName, mode)
    mode = clampMode(mapName, mode)
    if not createLobbyRemote then
        setStatus("Create remote not found (createLobby / createDungeon)")
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

    task.wait(5)
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
    setStatus("aphalia running...")
    while masterEnabled do
        local ok, err = pcall(runCycle)
        if not ok then
            warn("cycle error: " .. tostring(err))
        end
        task.wait(1)
    end
    setStatus("aphalia stopped.")
    managerThread = nil
end

local function onJoinRequest(requestId, displayName, eventType)
    if not autoAcceptEnabled then return end
    if eventType == "close" or requestId == nil then return end
    pcall(function() respondJoinRemote:FireServer(requestId, true) end)
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
    Text        = "Member Usernames",
    Placeholder = "alt1, alt2 (optional)",
    Callback    = function(value)
        configuredMembers = parseNames(value)
    end,
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
    Text        = "Username to send join request",
    Placeholder = "Name",
    Callback    = function(value)
        targetJoinUsername = value
    end,
})

LeftCol:AddToggle("AutoSendJoinReq", {
    Text     = "Auto Send Join Request",
    Default  = false,
    Callback = function(value)
        autoJoinEnabled = value
    end,
})


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
---------------------------------------

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
            statusLabel:SetText("State: Idle")
        end
    end
end

task.spawn(function()
    while true do
        refreshStatus()
        task.wait(1)
    end
end)

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
    Callback = function(value)
        Library.ShowCustomCursor = value
    end,
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

task.spawn(function()
    task.wait(3)
    refreshDungeonReqs()
end)

task.spawn(function()
    task.wait(6)
    local lvl, src = getLevelForPlayer(localPlayer)
    if lvl then
        print("Level read: " .. tostring(lvl) .. " (from " .. tostring(src) .. ")")
        return
    end
    local parts = {}
    local ls = localPlayer:FindFirstChild("leaderstats")
    if ls then
        for _, v in ipairs(ls:GetChildren()) do
            local ok, val = pcall(function() return v.Value end)
            table.insert(parts, v.ClassName .. " " .. v.Name .. "=" .. (ok and tostring(val) or "<err>"))
        end
    else
        table.insert(parts, "<no leaderstats on LocalPlayer>")
    end
    warn("Could not read your level. leaderstats contents: " .. table.concat(parts, " | "))
end)

Library:Notify("hieutrung doggy loaded — configs for user " .. tostring(localPlayer.UserId))
print("Loaded successfully (configs -> " .. ConfigRoot .. ")")Fte
