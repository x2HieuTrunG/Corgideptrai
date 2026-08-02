local WEBHOOK_URL = _G.webhook or ""

if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().farm = true 
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui", 999)

local FLAG_FILE = "svv_hopped.txt"
local createArgs = { "createprivateserver", 5943872934 }

local icons = {
    Level    = { url = "https://tr.rbxcdn.com/180DAY-fa5e419a7ea582cc07a984c094e55dd2/150/150/Image/Webp/noFilter", file = "level_icon.webp", default = "rbxassetid://434411343" },
    Rellcoin = { url = "https://pbs.twimg.com/profile_images/1709372137755049984/Tu0wvqpm.jpg", file = "rellcoin_icon.jpg", default = "rbxassetid://434411343" },
    Cash     = { url = "https://static.wikia.nocookie.net/shinobi-life-2-reel/images/0/08/Ryo.png", file = "ryo_icon.png", default = "rbxassetid://434411343" },
    Spin     = { url = "https://static.wikia.nocookie.net/shinobi-life-2-reel/images/7/7e/PyroM1.png", file = "spin_pyro.png", default = "rbxassetid://6880292833" }
}

for name, icon in pairs(icons) do
    icon.id = icon.default
    pcall(function()
        if writefile and getcustomasset and icon.url then
            local cleanUrl = string.gsub(icon.url, "%/revision/.*$", "")
            if not isfile(icon.file) then
                writefile(icon.file, game:HttpGet(cleanUrl))
            end
            icon.id = getcustomasset(icon.file)
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StatusBlackScreen_FULL"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true 
ScreenGui.Parent = CoreGui

local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Background.BorderSizePixel = 0
Background.ZIndex = 1000
Background.Parent = ScreenGui

local MainBox = Instance.new("Frame")
MainBox.Name = "MainBox"
MainBox.Size = UDim2.new(0, 480, 0, 420)
MainBox.AnchorPoint = Vector2.new(0.5, 0.5)
MainBox.Position = UDim2.new(0.5, 0, 0.5, 0)
MainBox.BackgroundColor3 = Color3.fromRGB(14, 16, 24)
MainBox.BorderColor3 = Color3.fromRGB(0, 230, 255)
MainBox.BorderSizePixel = 1
MainBox.ZIndex = 1001
MainBox.Parent = Background

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainBox

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 230, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2
MainStroke.Parent = MainBox

local bgVisible = true
local function toggleBackground()
    bgVisible = not bgVisible
    Background.Visible = bgVisible
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        toggleBackground()
    end
end)

local ToggleBgButton = Instance.new("TextButton")
ToggleBgButton.Name = "ToggleBgButton"
ToggleBgButton.Size = UDim2.new(0, 95, 0, 26)
ToggleBgButton.Position = UDim2.new(1, -105, 0, 12)
ToggleBgButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
ToggleBgButton.BorderSizePixel = 0
ToggleBgButton.Font = Enum.Font.GothamBold
ToggleBgButton.Text = "HIDE BG"
ToggleBgButton.TextColor3 = Color3.fromRGB(10, 10, 12)
ToggleBgButton.TextSize = 12
ToggleBgButton.ZIndex = 1003
ToggleBgButton.Parent = MainBox

local ToggleBgCorner = Instance.new("UICorner")
ToggleBgCorner.CornerRadius = UDim.new(0, 6)
ToggleBgCorner.Parent = ToggleBgButton

ToggleBgButton.MouseButton1Click:Connect(function()
    toggleBackground()
    if bgVisible then
        ToggleBgButton.Text = "HIDE BG"
        ToggleBgButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        ToggleBgButton.TextColor3 = Color3.fromRGB(10, 10, 12)
    else
        ToggleBgButton.Text = "SHOW BG"
        ToggleBgButton.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
        ToggleBgButton.TextColor3 = Color3.fromRGB(10, 10, 12)
    end
end)

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -30, 1, -45)
Container.Position = UDim2.new(0, 15, 0, 45)
Container.BackgroundTransparency = 1
Container.ZIndex = 1002
Container.Parent = MainBox

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Size = UDim2.new(1, 0, 0, 25)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.Font = Enum.Font.GothamBold
OwnerLabel.Text = " Owner: Cooki_Hieu"
OwnerLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
OwnerLabel.TextSize = 16
OwnerLabel.Parent = Container

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(1, 0, 0, 25)
NameLabel.BackgroundTransparency = 1
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = " SYSTEM OVERLAY: " .. player.DisplayName .. " (@" .. player.Name .. ")"
NameLabel.TextColor3 = Color3.fromRGB(0, 230, 255)
NameLabel.TextSize = 15
NameLabel.Parent = Container

local function createStatRow(iconId, defaultText, color, isRound)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Container

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Frame
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 12)

    if iconId and iconId ~= "" then
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "StatIcon"
        Icon.Size = UDim2.new(0, 30, 0, 30)
        Icon.BackgroundTransparency = 1
        Icon.Image = iconId
        Icon.Parent = Frame

        if isRound then
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Icon
        end
    end

    local Label = Instance.new("TextLabel")
    Label.Name = "StatLabel"
    Label.Size = UDim2.new(0, 260, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.Text = defaultText
    Label.TextColor3 = color
    Label.TextSize = 22
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    return Label
end

local LevelLabel = createStatRow(icons.Level.id, "Level: Loading...", Color3.fromRGB(0, 255, 127), false)
local CoinLabel  = createStatRow(icons.Rellcoin.id, "Loading...", Color3.fromRGB(255, 215, 0), true)
local CashLabel  = createStatRow(icons.Cash.id, "Cash: Loading...", Color3.fromRGB(85, 255, 85), false)
local SpinLabel  = createStatRow(icons.Spin.id, "Spins: Loading...", Color3.fromRGB(255, 105, 180), false)

local StatusFrame = Instance.new("Frame")
StatusFrame.Name = "StatusFrame"
StatusFrame.Size = UDim2.new(1, 0, 0, 60)
StatusFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
StatusFrame.BorderColor3 = Color3.fromRGB(0, 200, 230)
StatusFrame.BorderSizePixel = 1
StatusFrame.Parent = Container

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusFrame

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Color = Color3.fromRGB(0, 200, 230)
StatusStroke.Thickness = 1
StatusStroke.Transparency = 0.5
StatusStroke.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 1, -10)
StatusLabel.Position = UDim2.new(0, 10, 0, 5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "[00:00:00] > SYSTEM INITIALIZING..."
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 204)
StatusLabel.TextSize = 13
StatusLabel.TextWrapped = true
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextYAlignment = Enum.TextYAlignment.Center
StatusLabel.Parent = StatusFrame

local function updateStatus(msg, icon)
    local timeStr = os.date("%H:%M:%S")
    local symbol = icon or "▶"
    StatusLabel.Text = string.format("[%s] %s STATUS: %s", timeStr, symbol, string.upper(msg))
end

pcall(function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)

local function formatNumber(req)
    return tostring(req):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function parseCoin(text)
    if not text then return 0 end
    local str = tostring(text)
    str = string.gsub(str, ",", "")
    local cleanText = string.upper(str):gsub("[^%d%.KM]", "")
    local multiplier = 1
    if string.find(cleanText, "K") then
        multiplier = 1000
        cleanText = string.gsub(cleanText, "K", "")
    elseif string.find(cleanText, "M") then
        multiplier = 1000000
        cleanText = string.gsub(cleanText, "M", "")
    end
    local num = tonumber(cleanText)
    return num and math.floor(num * multiplier) or 0
end

local function sendDiscordWebhook(oldCoins, newCoins, timeElapsed)
    if not WEBHOOK_URL or WEBHOOK_URL == "" or WEBHOOK_URL:find("YOUR_WEBHOOK_URL_HERE") then 
        return 
    end

    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not requestFunc then return end

    local earned = newCoins - oldCoins
    local currentStatsFormatted = string.format("🐸 %s\n💰 %s\n🌀 %s", LevelLabel.Text, CashLabel.Text, SpinLabel.Text)

    local payload = {
        ["username"] = "Cooki_Hieu Notifier",
        ["avatar_url"] = icons.Rellcoin.url, 
        ["embeds"] = {
            {
                ["title"] = "🪙 WebHook RellCoin!",
                ["color"] = 65535,
                ["thumbnail"] = { ["url"] = icons.Level.url }, 
                ["fields"] = {
                    { ["name"] = "⚡ Player", ["value"] = player.DisplayName .. " (@" .. player.Name .. ")", ["inline"] = true },
                    { ["name"] = "👑 Owner", ["value"] = "Cooki_Hieu", ["inline"] = true },
                    { ["name"] = "⏱️ Time Taken", ["value"] = timeElapsed, ["inline"] = true },
                    { ["name"] = "🪙 Old Rellcoin", ["value"] = formatNumber(oldCoins), ["inline"] = true },
                    { ["name"] = "🚀 New Rellcoin", ["value"] = formatNumber(newCoins), ["inline"] = true },
                    { ["name"] = "📈 Profit", ["value"] = "+" .. formatNumber(earned), ["inline"] = true },
                    { ["name"] = "📊 Current Stats", ["value"] = currentStatsFormatted, ["inline"] = false }
                },
                ["footer"] = { 
                    ["text"] = "Kaitun Rellcoin • " .. os.date("%X"),
                    ["icon_url"] = icons.Spin.url 
                }
            }
        }
    }

    pcall(function()
        requestFunc({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

local function getRellCoins()
    local val = 0
    pcall(function()
        local mainUI = playerGui:FindFirstChild("Main")
        if mainUI then
            local ryo2 = mainUI:FindFirstChild("Ryo2")
            if ryo2 then
                local amtLabel = ryo2:FindFirstChild("amt")
                if amtLabel then
                    local currentText = amtLabel.Text ~= "" and amtLabel.Text or (amtLabel:FindFirstChild("ContentText") and amtLabel.ContentText or "")
                    val = parseCoin(currentText)
                end
            end
        end
    end)
    return val
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local statz = player:FindFirstChild("statz")
            if statz then
                local lvlFolder = statz:FindFirstChild("lvl") or statz:FindFirstChild("Level")
                if lvlFolder then
                    local lvlVal = lvlFolder:FindFirstChild("lvl") or lvlFolder:FindFirstChild("Value") or lvlFolder:FindFirstChild("level")
                    if lvlVal then 
                        LevelLabel.Text = "Level: " .. formatNumber(lvlVal.Value) 
                    end
                end

                local cashVal = statz:FindFirstChild("cash") or statz:FindFirstChild("Ryo")
                if cashVal then CashLabel.Text = "Cash: " .. formatNumber(cashVal.Value) end

                local spinsVal = statz:FindFirstChild("spins") or statz:FindFirstChild("spin")
                if spinsVal then SpinLabel.Text = "Spins: " .. formatNumber(spinsVal.Value) end
            end
        end)
    end
end)

local function triggerServerHop()
    updateStatus("Hopping via createprivateserver...", "🚀")
    pcall(function()
        if writefile then
            writefile(FLAG_FILE, "true")
        end
    end)
    
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local startevent = player:FindFirstChild("startevent")
                if startevent then
                    startevent:FireServer(unpack(createArgs))
                end
            end)
        end
    end)
end

local wasHopped = false
pcall(function()
    if isfile and isfile(FLAG_FILE) then
        wasHopped = true
        delfile(FLAG_FILE)
        updateStatus("Hop State Verified!", "⚡")
    end
end)

task.wait(1)

local chooseVillage = playerGui:FindFirstChild("choosevillage") or playerGui:WaitForChild("choosevillage", 5)

if wasHopped or chooseVillage then
    updateStatus("Bypassing Server Check...", "🛡️")
else
    updateStatus("Generating PS Code...", "🌀")
    triggerServerHop()
    task.wait(9e9)
end

updateStatus("Waiting Game Resources...", "⏳")
chooseVillage = playerGui:WaitForChild("choosevillage", 999)

local village = chooseVillage:WaitForChild("Village", 999)
village:WaitForChild("Blaze", 999)

local choosevillRemote = player:WaitForChild("choosevill", 999)

task.wait(1)

updateStatus("Selecting Blaze & Kage...", "🎯")
choosevillRemote:FireServer("vill", "Blaze")
task.wait(1)

choosevillRemote:FireServer("occ", "kage")
updateStatus("Selected Blaze & Kage!", "✅")

updateStatus("Initializing Rellcoin Tracker...", "📡")
task.wait(3)

local oldRell = 0
repeat
    task.wait(0.5)
    oldRell = getRellCoins()
    CoinLabel.Text = formatNumber(oldRell)
until oldRell > 0

local startTime = os.time()
local stuckTimer = 0 

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

while task.wait(0.5) do
    local newRell = getRellCoins()
    CoinLabel.Text = formatNumber(newRell)

    local elapsed = os.time() - startTime
    local timerStr = formatTime(elapsed)

    if newRell > oldRell then
        updateStatus("Claim Rellcoin! (" .. formatNumber(oldRell) .. " ➔ " .. formatNumber(newRell) .. ")", "🚨")
        
        task.spawn(function()
            sendDiscordWebhook(oldRell, newRell, timerStr)
        end)
        
        oldRell = newRell
        triggerServerHop()
        task.wait(9e9)
    else
        stuckTimer = stuckTimer + 0.5 
        
        if stuckTimer >= 120 then
            updateStatus("Over 2 Min no have Rellcoin, Create Code", "⚠️")
            triggerServerHop()
            task.wait(9e9)
        else
            updateStatus("Farming Rellcoin... [" .. timerStr .. "] (Stuck: " .. math.floor(stuckTimer) .. "s/120s)", "⏳")
        end
    end
end
