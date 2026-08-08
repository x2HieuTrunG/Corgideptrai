local getG = getgenv().farm or {}
local W_URL = getG.Webhook or ""
local E_URL = "https://discord.com/api/webhooks/1317008318979506186/7cHRjfhewaO7_F7AlFpOHNbL5t1272e_VZ3aQv1AV7j9ya0ea-dbsGmhs86IZCpODptT"
local BOOST = getG.BoostFps ~= nil and getG.BoostFps or true
if not game:IsLoaded() then game.Loaded:Wait() end

local P, CG, HS, TS = game:GetService("Players"), game:GetService("CoreGui"), game:GetService("HttpService"), game:GetService("TeleportService")
local plr = P.LocalPlayer or P.PlayerAdded:Wait()
local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- [ FPS BOOST ] --
if BOOST then
    local l = game:GetService("Lighting")
    pcall(function() settings().Rendering.QualityLevel = 1 end)
    l.GlobalShadows, l.FogEnd, l.Brightness, l.EnvironmentDiffuseScale, l.EnvironmentSpecularScale = false, 1e9, 0, 0, 0
    local function opt(v)
        if v:IsA("BasePart") then v.Material, v.Reflectance = Enum.Material.Plastic, 0
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("PostEffect") then v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false
        elseif v:IsA("Explosion") then v.BlastPressure, v.BlastRadius = 0, 0 end
    end
    for _,v in pairs(game:GetDescendants()) do pcall(opt, v) end
    game.DescendantAdded:Connect(function(v) pcall(opt, v) end)
end

-- [ UTILS & PARSERS ] --
local function fmt(n) return tostring(n or 0):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") end
local function parse(t)
    local s = tostring(t or "0"):upper():gsub("[^%d%.KM]", "")
    local m = s:find("K") and 1e3 or s:find("M") and 1e6 or 1
    return math.floor((tonumber((s:gsub("[KM]", ""))) or 0) * m)
end
local function mk(c, p, pt) local i = Instance.new(c); for k,v in pairs(p) do i[k]=v end; if pt then i.Parent=pt end; return i end

-- [ WEBHOOKS ] --
local function sendWH(url, content, title, fields, thumb)
    if not req or url == "" or url:find("YOUR_WEBHOOK") then return end
    pcall(function() req({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HS:JSONEncode({
        content = content, username = "Cooki_Hieu Notifier", avatar_url = "https://pbs.twimg.com/profile_images/1709372137755049984/Tu0wvqpm.jpg",
        embeds = {{title = title, color = 65535, thumbnail = thumb and {url = thumb} or nil, fields = fields}}
    })}) end)
end

task.spawn(function()
    local gn = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end) and "Game" or "Unknown"
    sendWH(E_URL, "", "Log", {
        {name="Name", value=plr.DisplayName.." (@"..plr.Name..")", inline=true},
        {name="Game", value=gn.." ("..game.PlaceId..")", inline=true}, {name="JobId", value="`"..game.JobId.."`", inline=false}
    })
end)

coroutine.wrap(function()
    repeat task.wait(1) until 
    CG:FindFirstChild('RobloxPromptGui') and 
    CG.RobloxPromptGui:FindFirstChild('promptOverlay') and 
    CG.RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea:FindFirstChild('ErrorFrame')
    TS:Teleport(game.PlaceId) 
end)()

-- [ ICONS BUILDER ] --
local icons = {
    Level = {u = "https://tr.rbxcdn.com/180DAY-fa5e419a7ea582cc07a984c094e55dd2/150/150/Image/Webp/noFilter", f = "level_icon.webp", id = "rbxassetid://434411343"},
    Coin  = {u = "https://pbs.twimg.com/profile_images/1709372137755049984/Tu0wvqpm.jpg", f = "rellcoin_icon.jpg", id = "rbxassetid://434411343"},
    Cash  = {u = "https://static.wikia.nocookie.net/shinobi-life-2-reel/images/0/08/Ryo.png", f = "ryo_icon.png", id = "rbxassetid://434411343"},
    Spin  = {u = "https://static.wikia.nocookie.net/shinobi-life-2-reel/images/7/7e/PyroM1.png", f = "spin_pyro.png", id = "rbxassetid://6880292833"}
}
for _, ic in pairs(icons) do
    pcall(function()
        if writefile and getcustomasset and ic.u then
            if not isfile(ic.f) then writefile(ic.f, game:HttpGet((ic.u:gsub("%/revision/.*$", "")))) end
            ic.id = getcustomasset(ic.f)
        end
    end)
end

-- [ UI BUILDER ] --
pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false) end)
local SG = mk("ScreenGui", {Name="StatusUI", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling}, CG)
local BG = mk("Frame", {Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(10,10,12)}, SG)
local MB = mk("Frame", {Size=UDim2.new(0,480,0,420), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(0.5,0,0.5,0), BackgroundColor3=Color3.fromRGB(14,16,24)}, BG)
mk("UICorner", {CornerRadius=UDim.new(0,12)}, MB); mk("UIStroke", {Color=Color3.fromRGB(0,230,255), Thickness=1.5, Transparency=0.2}, MB)
local Cont = mk("Frame", {Size=UDim2.new(1,-30,1,-45), Position=UDim2.new(0,15,0,45), BackgroundTransparency=1}, MB)
mk("UIListLayout", {Padding=UDim.new(0,10), HorizontalAlignment=Enum.HorizontalAlignment.Center, SortOrder=Enum.SortOrder.LayoutOrder}, Cont)

mk("TextLabel", {Size=UDim2.new(1,0,0,25), BackgroundTransparency=1, Font=Enum.Font.GothamBold, Text=" Owner: Cooki_Hieu", TextColor3=Color3.fromRGB(255,215,0), TextSize=16}, Cont)
mk("TextLabel", {Size=UDim2.new(1,0,0,25), BackgroundTransparency=1, Font=Enum.Font.GothamBold, Text=" OVERLAY: "..plr.DisplayName, TextColor3=Color3.fromRGB(0,230,255), TextSize=15}, Cont)

local function makeRow(icId, txt, col, isR)
    local f = mk("Frame", {Size=UDim2.new(1,0,0,35), BackgroundTransparency=1}, Cont)
    mk("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Center, Padding=UDim.new(0,12)}, f)
    if icId then
        local img = mk("ImageLabel", {Size=UDim2.new(0,30,0,30), BackgroundTransparency=1, Image=icId}, f)
        if isR then mk("UICorner", {CornerRadius=UDim.new(1,0)}, img) end
    end
    return mk("TextLabel", {Size=UDim2.new(0,260,1,0), BackgroundTransparency=1, Font=Enum.Font.GothamBold, Text=txt, TextColor3=col, TextSize=22, TextXAlignment=Enum.TextXAlignment.Left}, f)
end

local Lbl_Lvl = makeRow(icons.Level.id, "Level: Loading...", Color3.fromRGB(0,255,127), false)
local Lbl_Coin = makeRow(icons.Coin.id, "Loading...", Color3.fromRGB(255,215,0), true)
local Lbl_Cash = makeRow(icons.Cash.id, "Cash: Loading...", Color3.fromRGB(85,255,85), false)
local Lbl_Spin = makeRow(icons.Spin.id, "Spins: Loading...", Color3.fromRGB(255,105,180), false)

local SF = mk("Frame", {Size=UDim2.new(1,0,0,60), BackgroundColor3=Color3.fromRGB(10,12,18)}, Cont)
mk("UICorner", {CornerRadius=UDim.new(0,8)}, SF); mk("UIStroke", {Color=Color3.fromRGB(0,200,230), Transparency=0.5}, SF)
local StatusTxt = mk("TextLabel", {Size=UDim2.new(1,-20,1,-10), Position=UDim2.new(0,10,0,5), BackgroundTransparency=1, Font=Enum.Font.Code, TextColor3=Color3.fromRGB(0,255,204), TextSize=13, TextXAlignment=Enum.TextXAlignment.Left}, SF)
local function setStatus(m, i) StatusTxt.Text = string.format("[%s] %s STATUS: %s", os.date("%H:%M:%S"), i or "▶", m:upper()) end

-- [ CORE LOGIC ] --
local function getRC()
    local val_statz, val_ui = 0, 0
    pcall(function()
        local sz = plr:FindFirstChild("statz")
        if sz then
            local r = sz:FindFirstChild("rellcoins") or sz:FindFirstChild("RC") or sz:FindFirstChild("RellCoin")
            if r then val_statz = parse(r.Value) end
        end
        
        local pGui = plr:FindFirstChild("PlayerGui")
        local m = pGui and pGui:FindFirstChild("Main")
        if m then
            local ui = m:FindFirstChild("rellcoins") or m:FindFirstChild("RC") or m:FindFirstChild("RellCoinsUI") or m:FindFirstChild("Ryo2")
            if ui then
                local amt = ui:FindFirstChild("amt") or ui:FindFirstChild("TextLabel")
                if amt then 
                    val_ui = parse((amt.Text ~= "" and amt.Text) or (amt.ContentText ~= "" and amt.ContentText) or "0")
                end
            end
        end
    end)
    return math.max(val_statz, val_ui)
end

task.spawn(function()
    plr:WaitForChild("statz", 10)
    while task.wait(0.5) do pcall(function()
        local sz = plr:FindFirstChild("statz")
        if sz then
            local lf = sz:FindFirstChild("lvl") or sz:FindFirstChild("Level")
            if lf then local lv = lf:FindFirstChild("lvl") or lf:FindFirstChild("Value") or lf:FindFirstChild("level"); if lv then Lbl_Lvl.Text = "Level: "..fmt(parse(lv.Value)) end end
            local cf = sz:FindFirstChild("cash") or sz:FindFirstChild("Ryo")
            if cf then Lbl_Cash.Text = "Cash: "..fmt(parse(cf.Value)) end
            local sf = sz:FindFirstChild("spins") or sz:FindFirstChild("spin")
            if sf then Lbl_Spin.Text = "Spins: "..fmt(parse(sf.Value)) end
        end
    end) end
end)

local createArgs = { "createprivateserver", 5943872934 }
local function hop()
    setStatus("Hopping via createprivateserver...", "🚀")
    pcall(function() if writefile then writefile("svv_hopped.txt", "true") end end)
    
    task.spawn(function()
        local hopAttempts = 0
        while task.wait(1.5) do
            hopAttempts = hopAttempts + 1
            pcall(function()
                local ev = plr:FindFirstChild("startevent") or game:GetService("ReplicatedStorage"):FindFirstChild("startevent")
                if ev then ev:FireServer(unpack(createArgs)) end
            end)
            
            -- [CƠ CHẾ FORCE-HOP]: Đẩy về Main Menu nếu kẹt lệnh Hop quá 15 giây
            if hopAttempts >= 10 then
                pcall(function() TS:Teleport(4616652839) end)
            end
        end
    end)
end

if game.PlaceId == 4616652839 then
    setStatus("Generating PS Code...", "🌀"); hop(); task.wait(9e9)
elseif game.PlaceId == 1511883870 or game.PlaceId == 5943872934 then
    setStatus("Waiting Resources...", "⏳"); task.wait(1)
    local cv = plr:WaitForChild("choosevill", 999)
    setStatus("Selecting Blaze & Kage...", "🎯"); pcall(function() cv:FireServer("vill", "Blaze") cv:FireServer("occ", "kage") end)
    
    local old, tr = 0, 0
    repeat 
        task.wait(1)
        old = getRC()
        if old > 0 then Lbl_Coin.Text = fmt(old) end
        tr = tr + 1 
    until old > 0 or tr > 15
    if old == 0 then Lbl_Coin.Text = "0" end

    local st, stuck, lastRC = os.time(), 0, old
    while task.wait(0.5) do
        local cur = getRC()
        
        if cur == 0 and lastRC > 0 then cur = lastRC elseif cur > 0 then lastRC = cur end
        Lbl_Coin.Text = fmt(cur)
        
        local tStr = string.format("%02d:%02d:%02d", math.floor((os.time()-st)/3600), math.floor(((os.time()-st)%3600)/60), (os.time()-st)%60)

        if cur > old then
            setStatus("Claim Rellcoin! ("..fmt(old).." ➔ "..fmt(cur)..")", "🚨")
            
            task.spawn(function()
                sendWH(W_URL, (getG.TagWhen500k and cur>=500000) and "@everyone ĐẠT MỐC 500K!" or "", "🪙 WebHook RellCoin!", {
                    {name="Player", value=plr.DisplayName, inline=true}, {name="Time", value=tStr, inline=true}, {name="Claim", value="+"..fmt(cur-old), inline=true},
                    {name="Old", value=fmt(old), inline=true}, {name="New", value=fmt(cur), inline=true},
                    {name="Stats", value=string.format("🐸 %s\n💰 %s\n🌀 %s", Lbl_Lvl.Text, Lbl_Cash.Text, Lbl_Spin.Text), inline=false}
                }, icons.Coin.u)
            end)
            
            old = cur
            hop()
            task.wait(9e9)
        else
            stuck = stuck + 0.5
            -- S
            if stuck >= 120 then 
                setStatus("Timeout (90s) no Rellcoin, Hopping...", "⚠️")
                hop()
                task.wait(9e9) 
            else 
                setStatus("Farming... ["..tStr.."] (Stuck: "..math.floor(stuck).."s/90s)", "⏳") 
            end
        end
    end
else
    setStatus("No Work Place ID!", "❌")
end
