-- x2hieutrung cracked

local u1 = loadstring(game:HttpGet('https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua'))()
local v2 = loadstring(game:HttpGet('https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua'))()

loadstring(game:HttpGet('https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua'))()

local u3 = u1:CreateWindow({
    Title = 'DOG HUB ( x2HieuTrung Cracked ) : Stand Upright Rebooted',
    SubTitle = 'v3.0',
    TabWidth = 140,
    Size = UDim2.fromOffset(490, 390),
    Acrylic = true,
    Theme = 'Dark',
    MinimizeKey = Enum.KeyCode.RightControl,
})
local v4 = {
    FarmingQuests = u3:AddTab({
        Title = 'Farming & Quests',
        Icon = 'sword',
    }),
    AutoFarmLevels = u3:AddTab({
        Title = 'Auto Farm',
        Icon = 'binary',
    }),
    BossFarm = u3:AddTab({
        Title = 'Boss Farm',
        Icon = 'skull',
    }),
    StandFarm = u3:AddTab({
        Title = 'Stand Farm',
        Icon = 'apple',
    }),
    AutoBuy = u3:AddTab({
        Title = 'Shop',
        Icon = 'shopping-cart',
    }),
    DungeonFarm = u3:AddTab({
        Title = 'Dungeon Farm',
        Icon = 'swords',
    }),
    ItemFarm = u3:AddTab({
        Title = 'Items Farm',
        Icon = 'box',
    }),
    Settings = u3:AddTab({
        Title = 'Settings',
        Icon = 'server-cog',
    }),
}
local _Options = u1.Options
local _LocalPlayer = game:GetService('Players').LocalPlayer
local _RunService = game:GetService('RunService')
local _Workspace = game:GetService('Workspace')
local _ReplicatedStorage = game:GetService('ReplicatedStorage')

game:GetService('HttpService')

getgenv().BeginFarm = false

local function u12(p10, p11)
    if p10 and p10:IsA('BasePart') then
        pcall(function()
            p10.CFrame = p11
            p10.Velocity = Vector3.new(0, 0, 0)
        end)
    end
end
local function u14()
    local v13 = _LocalPlayer.Character or _LocalPlayer.CharacterAdded:Wait()

    if v13:WaitForChild('HumanoidRootPart', 3) and v13:WaitForChild('Humanoid', 3) then
        return v13
    else
        return nil
    end
end

local v15 = u14()

if v15 then
    local _HumanoidRootPart = v15.HumanoidRootPart
    local _CFrame = _HumanoidRootPart.CFrame

    u12(_HumanoidRootPart, CFrame.new(28150.3086, 35.9711533, -269.263519, 0.898707032, -9.38510212e-8, 0.438549489, 0.000386293803, 0.999999583, -0.000791406957, -0.43854934, 0.000880651933, 0.898706675))
    task.wait(0.2)
    u12(_HumanoidRootPart, CFrame.new(111.568245, 67.8253555, -504.725433, -0.139709324, -1.02523202e-7, -0.990192533, -0.00119501015, 0.999999285, 0.000168504135, 0.990191817, 0.00120683177, -0.139709219))
    task.wait(0.2)
    u12(_HumanoidRootPart, CFrame.new(12004.6465, -3.5425477, -4455.771, -0.200845346, 1.5954464400000001e-8, -0.97962296, -0.00104438537, 0.999999404, 0.000214139422, 0.979622424, 0.00106611277, -0.200845227))
    task.wait(0.2)
    u12(_HumanoidRootPart, CFrame.new(-5186.38232, -450.836853, -3802.86426, 0.944326222, -1.01374319e-7, 0.329010695, 1.1014469e-7, 1, -8.01856448e-9, -0.329010695, 4.38109211e-8, 0.944326222))
    task.wait(0.2)
    u12(_HumanoidRootPart, _CFrame)

    local u18 = false
    local u19 = -8
    local u20 = 0

    local function u23(p21, p22)
        return pcall(function()
            if p22 == nil then
                p21:FireServer()
            else
                p21:FireServer(p22)
            end
        end)
    end
    local function u30(p24)
        if p24 and p24:FindFirstChild('StandEvents') then
            local _M1 = p24.StandEvents:FindFirstChild('M1')

            if _M1 and not _LocalPlayer.PlayerGui.CDgui.fortnite:FindFirstChild('Punch') then
                u23(_M1, true)
                task.wait(0.05)
            end

            local v26, v27, v28 = pairs(p24.StandEvents:GetChildren())

            while true do
                local v29

                v28, v29 = v26(v27, v28)

                if v28 == nil then
                    break
                end
                if v29:IsA('RemoteEvent') and v29.Name ~= 'M1' and not table.find({
                    'Block',
                    'Quote',
                    'Pose',
                    'Summon',
                    'Heal',
                    'Jump',
                    'TogglePilot',
                }, v29.Name) then
                    u23(v29, true)
                    task.wait(0.05)
                end
            end
        end
    end
    local function u38(p31, p32)
        if p31 and (p31:FindFirstChild('StandEvents') and p32) then
            if p32.M1 and p31.StandEvents:FindFirstChild('M1') and not _LocalPlayer.PlayerGui.CDgui.fortnite:FindFirstChild('Punch') then
                u23(p31.StandEvents.M1, true)
            end

            local v33, v34, v35 = pairs(p32)

            while true do
                local v36

                v35, v36 = v33(v34, v35)

                if v35 == nil then
                    break
                end
                if v36 and v35 ~= 'M1' then
                    local v37 = p31.StandEvents:FindFirstChild(v35)

                    if v37 then
                        u23(v37, true)
                    end
                end
            end
        end
    end
    local function u45()
        local v39 = u14()
        local v40 = {
            'None',
        }

        if v39 and v39:FindFirstChild('StandEvents') then
            local v41, v42, v43 = pairs(v39.StandEvents:GetChildren())

            while true do
                local v44

                v43, v44 = v41(v42, v43)

                if v43 == nil then
                    break
                end
                if v44:IsA('RemoteEvent') and not table.find({
                    'Block',
                    'Quote',
                    'Pose',
                    'Summon',
                    'Heal',
                    'Jump',
                    'TogglePilot',
                }, v44.Name) then
                    table.insert(v40, v44.Name)
                end
            end
        end

        return v40
    end

    local u46 = false
    local u47 = nil
    local u48 = {
        ['Bad Gi [Lvl. 1+]'] = {
            npcName = 'Giorno',
            range = 8,
            loadCFrame = CFrame.new(-700.536438, 70.0818481, -837.761169, 0.087131381, 0, -0.996196866, 0, 1, 0, 0.996196866, 0, 0.087131381),
            'Bad Gi',
        },
        ['Scary Monster [Lvl. 10+]'] = {
            npcName = 'Scared Noob',
            range = 8,
            loadCFrame = CFrame.new(-691.044983, 73.0222321, -1062.31665, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747),
            'Scary Monster',
        },
        ['Giorno Giovanna [Lvl. 20+]'] = {
            npcName = 'Koichi',
            range = 8,
            loadCFrame = CFrame.new(-195.531723, 69.9809418, -534.950073, 0, 0, -1, 0, 1, 0, 1, 0, 0),
            'Giorno Giovanna',
        },
        ['Rker Dummy [Lvl. 30+]'] = {
            npcName = 'aLLmemester',
            range = 8,
            loadCFrame = CFrame.new(-624.51062, 69.9093475, -472.346008, -0.707068563, 0, -0.707145572, 0, 1, 0, 0.707145572, 0, -0.707068563),
            'Rker Dummy',
        },
        ['Yoshikage Kira [Lvl. 40+]'] = {
            npcName = 'Okayasu',
            range = 8,
            loadCFrame = CFrame.new(-534.294983, 70.0820007, -1039.84399, 1, 0, 0, 0, 1, 0, 0, 0, 1),
            'Yoshikage Kira',
        },
        ['Dio Over Heaven [Lvl. 50+]'] = {
            npcName = 'Joseph Joestar',
            range = 10,
            loadCFrame = CFrame.new(33.1749992, 97.1800003, -884.434021, -1.1920929000000002e-7, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929000000002e-7),
            'Dio Over Heaven',
        },
        ['Angelo [Lvl. 75+]'] = {
            npcName = 'Josuke',
            range = 10,
            loadCFrame = CFrame.new(-589.617004, 72.461998, -651.528992, 0.258864343, 0, -0.965913713, 0, 1, 0, 0.965913713, 0, 0.258864343),
            'Angelo',
        },
        ['Alien [Lvl. 100+]'] = {
            npcName = 'Rohan',
            range = 10,
            loadCFrame = CFrame.new(-206.270004, 73.0220032, -712.692993, 1, 0, 0, 0, 1, 0, 0, 0, 1),
            'Alien',
        },
        ['Jotaro Part 4 [Lvl. 125+]'] = {
            npcName = 'DIO',
            range = 10,
            loadCFrame = CFrame.new(-384.623993, 69.9909973, -73.7870026, -0.134667635, 0, 0.990891039, 0, 1, 0, -0.990891039, 0, -0.134667635),
            'Jotaro Part 4',
        },
        ['Kakyoin [Lvl. 150+]'] = {
            npcName = 'Muhammed Avdol',
            range = 10,
            loadCFrame = CFrame.new(-240.203003, 69.9810028, -166.317001, 0.79861635, 0, 0.601840496, 0, 1, 0, -0.601840496, 0, 0.79861635),
            'Kakyoin',
        },
        ['Jungle Bandit [Lvl. 175+]'] = {
            npcName = 'Giorno',
            range = 12,
            loadCFrame = CFrame.new(-504.627014, 69.9229965, 13.2069998, 0.996191859, 0, 0.0871884301, 0, 1, 0, -0.0871884301, 0, 0.996191859),
            'Jungle Bandit',
        },
        ['Sewer Vampire [Lvl. 200+]'] = {
            npcName = 'Zeppeli',
            range = 12,
            loadCFrame = CFrame.new(-5235.70898, -447.78125, -3740.56592, 0.996191859, 0, 0.0871884301, 0, 1, 0, -0.0871884301, 0, 0.996191859),
            'Sewer Vampire',
        },
        ['Pillerman [Lvl. 275+]'] = {
            npcName = 'Young Joseph',
            range = 12,
            loadCFrame = CFrame.new(-698.304993, 69.6139984, -129.304001, 0.996191859, 0, 0.0871884301, 0, 1, 0, -0.0871884301, 0, 0.996191859),
            'Pillerman',
        },
    }

    local function u55(p49)
        local v50, v51, v52 = ipairs(_Workspace.Map.NPCs:GetChildren())

        while true do
            local v53

            v52, v53 = v50(v51, v52)

            if v52 == nil then
                break
            end
            if v53.Name == 'Giorno' and v53:FindFirstChild('Head') and v53.Head:FindFirstChild('Main') and v53.Head.Main:FindFirstChild('Text') then
                local _Text = v53.Head.Main.Text.Text

                if p49 == 'Bad Gi [Lvl. 1+]' and _Text == 'Giorno Giovanna [Lvl. 1+]' or p49 == 'Jungle Bandit [Lvl. 175+]' and _Text == 'Giorno Giovanna [Lvl. 175+]' then
                    return v53
                end
            end
        end

        return nil
    end
    local function u61(p56)
        local v57, v58, v59 = pairs(_Workspace.Living:GetChildren())

        while true do
            local v60

            v59, v60 = v57(v58, v59)

            if v59 == nil then
                break
            end
            if v60.Name == p56 and v60:FindFirstChild('Humanoid') and v60.Humanoid.Health > 0 then
                return v60
            end
        end

        return nil
    end
    local function u69(p62, p63)
        local v64 = u14()

        if v64 and (p62 and p62.PrimaryPart) then
            local _HumanoidRootPart2 = v64:FindFirstChild('HumanoidRootPart')
            local _PrimaryPart = p62.PrimaryPart
            local _Stand = v64:FindFirstChild('Stand')

            if _Stand then
                _Stand = v64.Stand:FindFirstChild('HumanoidRootPart')
            end
            if _HumanoidRootPart2 and _PrimaryPart then
                pcall(function()
                    local v68 = _PrimaryPart.CFrame * CFrame.new(0, p63 + u19, u20) * CFrame.Angles(math.rad(-90), 0, 0)

                    _HumanoidRootPart2.CFrame = v68
                    _HumanoidRootPart2.Velocity = Vector3.new(0, 0, 0)

                    if _Stand then
                        _Stand.CFrame = v68
                        _Stand.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end
        end
    end
    local function u85()
        if u47 then
            u47:Disconnect()
        end

        local u70 = false
        local u71 = 0
        local u72 = 0.2

        u47 = _RunService.Heartbeat:Connect(function()
            if not u46 then
                u47:Disconnect()

                return
            end

            local v73 = u14()

            if not v73 then
                return
            end

            local _Value = _Options.SelectQuest.Value

            if not (_Value and u48[_Value]) then
                return
            end

            local v75 = u48[_Value]

            if not u70 then
                u12(v73.HumanoidRootPart, v75.loadCFrame)

                u70 = true
            end

            local v76 = tick()

            if u72 <= v76 - u71 then
                if _Value == 'Bad Gi [Lvl. 1+]' or _Value == 'Jungle Bandit [Lvl. 175+]' then
                    local v77 = u55(_Value)

                    if v77 then
                        u23(v77.Done)
                        u23(v77.QuestDone)
                    end
                else
                    local v78, v79, v80 = ipairs(_Workspace.Map.NPCs:GetChildren())

                    while true do
                        local v81

                        v80, v81 = v78(v79, v80)

                        if v80 == nil then
                            break
                        end
                        if v81.Name == v75.npcName then
                            u23(v81.Done)
                            u23(v81.QuestDone)

                            break
                        end
                    end
                end

                u71 = v76
            end

            local v82 = u61(v75[1])

            if v82 then
                u69(v82, v75.range)

                if v73:FindFirstChild('Aura') and not v73.Aura.Value then
                    u23(v73.StandEvents.Summon)
                end

                local v83 = _Options.SelectedSkills and _Options.SelectedSkills.Value or {}

                if next(v83) then
                    u38(v73, v83)
                elseif u18 then
                    u30(v73)
                end
            else
                v73.Humanoid.Sit = false

                local v84 = v73.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)

                u12(v73.HumanoidRootPart, v84)
                task.wait(0.3)
            end
        end)
    end

    v4.FarmingQuests:AddDropdown('SelectQuest', {
        Title = 'Select Quest',
        Values = {
            'Bad Gi [Lvl. 1+]',
            'Scary Monster [Lvl. 10+]',
            'Giorno Giovanna [Lvl. 20+]',
            'Rker Dummy [Lvl. 30+]',
            'Yoshikage Kira [Lvl. 40+]',
            'Dio Over Heaven [Lvl. 50+]',
            'Angelo [Lvl. 75+]',
            'Alien [Lvl. 100+]',
            'Jotaro Part 4 [Lvl. 125+]',
            'Kakyoin [Lvl. 150+]',
            'Jungle Bandit [Lvl. 175+]',
            'Sewer Vampire [Lvl. 200+]',
            'Pillerman [Lvl. 275+]',
        },
        Multi = false,
        Default = 'Bad Gi [Lvl. 1+]',
    })
    v4.FarmingQuests:AddToggle('AutoFarm', {
        Title = 'Auto Farm & Quests',
        Default = false,
    })
    _Options.AutoFarm:OnChanged(function()
        u46 = _Options.AutoFarm.Value

        if u46 then
            if isLevelFarming then
                u1:Notify({
                    Title = 'Error',
                    Content = 'Please disable Auto Farm All Levels first!',
                    Duration = 5,
                })

                u46 = false

                _Options.AutoFarm:SetValue(false)

                return
            end

            task.spawn(u85)
        end
    end)

    local u86 = false
    local u87 = nil
    local u88 = {
        ['Bad Gi [Lvl. 1+]'] = {
            range = 8,
            loadCFrame = CFrame.new(-700.536438, 70.0818481, -837.761169, 0.087131381, 0, -0.996196866, 0, 1, 0, 0.996196866, 0, 0.087131381),
            'Bad Gi',
            'Giorno',
        },
        ['Scary Monster [Lvl. 10+]'] = {
            range = 8,
            loadCFrame = CFrame.new(-691.044983, 73.0222321, -1062.31665, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747),
            'Scary Monster',
            'Scared Noob',
        },
        ['Giorno Giovanna [Lvl. 20+]'] = {
            range = 8,
            loadCFrame = CFrame.new(-195.531723, 69.9809418, -534.950073, 0, 0, -1, 0, 1, 0, 1, 0, 0),
            'Giorno Giovanna',
            'Koichi',
        },
        ['Rker Dummy [Lvl. 30+]'] = {
            range = 8,
            loadCFrame = CFrame.new(-624.51062, 69.9093475, -472.346008, -0.707068563, 0, -0.707145572, 0, 1, 0, 0.707145572, 0, -0.707068563),
            'Rker Dummy',
            'aLLmemester',
        },
        ['Yoshikage Kira [Lvl. 40+]'] = {
            range = 8,
            loadCFrame = CFrame.new(-534.294983, 70.0820007, -1039.84399, 1, 0, 0, 0, 1, 0, 0, 0, 1),
            'Yoshikage Kira',
            'Okayasu',
        },
        ['Dio Over Heaven [Lvl. 50+]'] = {
            range = 10,
            loadCFrame = CFrame.new(33.1749992, 97.1800003, -884.434021, -1.1920929000000002e-7, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929000000002e-7),
            'Dio Over Heaven',
            'Joseph Joestar',
        },
        ['Angelo [Lvl. 75+]'] = {
            range = 10,
            loadCFrame = CFrame.new(-589.617004, 72.461998, -651.528992, 0.258864343, 0, -0.965913713, 0, 1, 0, 0.965913713, 0, 0.258864343),
            'Angelo',
            'Josuke',
        },
        ['Alien [Lvl. 100+]'] = {
            range = 10,
            loadCFrame = CFrame.new(-206.270004, 73.0220032, -712.692993, 1, 0, 0, 0, 1, 0, 0, 0, 1),
            'Alien',
            'Rohan',
        },
        ['Jotaro Part 4 [Lvl. 125+]'] = {
            range = 10,
            loadCFrame = CFrame.new(-384.623993, 69.9909973, -73.7870026, -0.134667635, 0, 0.990891039, 0, 1, 0, -0.990891039, 0, -0.134667635),
            'Jotaro Part 4',
            'DIO',
        },
        ['Kakyoin [Lvl. 150+]'] = {
            range = 10,
            loadCFrame = CFrame.new(-240.203003, 69.9810028, -166.317001, 0.79861635, 0, 0.601840496, 0, 1, 0, -0.601840496, 0, 0.79861635),
            'Kakyoin',
            'Muhammed Avdol',
        },
        ['Jungle Bandit [Lvl. 175+]'] = {
            range = 12,
            loadCFrame = CFrame.new(-504.627014, 69.9229965, 13.2069998, 0.996191859, 0, 0.0871884301, 0, 1, 0, -0.0871884301, 0, 0.996191859),
            'Jungle Bandit',
            'Giorno',
        },
        ['Sewer Vampire [Lvl. 200+]'] = {
            range = 12,
            loadCFrame = CFrame.new(-5235.70898, -447.78125, -3740.56592, 0.996191859, 0, 0.0871884301, 0, 1, 0, -0.0871884301, 0, 0.996191859),
            'Sewer Vampire',
            'Zeppeli',
        },
        ['Pillerman [Lvl. 275+]'] = {
            range = 12,
            loadCFrame = CFrame.new(-698.304993, 69.6139984, -129.304001, 0.996191859, 0, 0.0871884301, 0, 1, 0, -0.0871884301, 0, 0.996191859),
            'Pillerman',
            'Young Joseph',
        },
    }
    local u89 = {
        {
            minLevel = 1,
            maxLevel = 10,
            name = 'Bad Gi [Lvl. 1+]',
        },
        {
            minLevel = 11,
            maxLevel = 20,
            name = 'Scary Monster [Lvl. 10+]',
        },
        {
            minLevel = 21,
            maxLevel = 30,
            name = 'Giorno Giovanna [Lvl. 20+]',
        },
        {
            minLevel = 31,
            maxLevel = 40,
            name = 'Rker Dummy [Lvl. 30+]',
        },
        {
            minLevel = 41,
            maxLevel = 50,
            name = 'Yoshikage Kira [Lvl. 40+]',
        },
        {
            minLevel = 51,
            maxLevel = 75,
            name = 'Dio Over Heaven [Lvl. 50+]',
        },
        {
            minLevel = 76,
            maxLevel = 100,
            name = 'Angelo [Lvl. 75+]',
        },
        {
            minLevel = 101,
            maxLevel = 125,
            name = 'Alien [Lvl. 100+]',
        },
        {
            minLevel = 126,
            maxLevel = 150,
            name = 'Jotaro Part 4 [Lvl. 125+]',
        },
        {
            minLevel = 151,
            maxLevel = 175,
            name = 'Kakyoin [Lvl. 150+]',
        },
        {
            minLevel = 176,
            maxLevel = 200,
            name = 'Jungle Bandit [Lvl. 175+]',
        },
        {
            minLevel = 201,
            maxLevel = 275,
            name = 'Sewer Vampire [Lvl. 200+]',
        },
        {
            minLevel = 276,
            maxLevel = math.huge,
            name = 'Pillerman [Lvl. 275+]',
        },
    }

    local function u97(p90, p91)
        local v92, v93, v94 = pairs(_Workspace.Living:GetChildren())
        local v95 = {}

        while true do
            local v96

            v94, v96 = v92(v93, v94)

            if v94 == nil then
                break
            end
            if v96.Name == p90 and v96:FindFirstChild('Humanoid') and v96.Humanoid.Health > 0 then
                table.insert(v95, v96)

                if p91 <= #v95 then
                    break
                end
            end
        end

        return v95
    end
    local function u105(p98, p99)
        local v100 = u14()

        if v100 and (p98 and p98.PrimaryPart) then
            local _HumanoidRootPart3 = v100:FindFirstChild('HumanoidRootPart')
            local _PrimaryPart2 = p98.PrimaryPart
            local _Stand2 = v100:FindFirstChild('Stand')

            if _Stand2 then
                _Stand2 = v100.Stand:FindFirstChild('HumanoidRootPart')
            end
            if _HumanoidRootPart3 and _PrimaryPart2 then
                pcall(function()
                    local v104 = _PrimaryPart2.CFrame * CFrame.new(0, p99 + u19, u20) * CFrame.Angles(math.rad(-90), 0, 0)

                    _HumanoidRootPart3.CFrame = v104
                    _HumanoidRootPart3.Velocity = Vector3.new(0, 0, 0)

                    if _Stand2 then
                        _Stand2.CFrame = v104
                        _Stand2.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end
        end
    end
    local function u123()
        if u87 then
            u87:Disconnect()
        end

        local u106 = 0
        local u107 = 1
        local u108 = 0.2
        local u109 = false

        u87 = _RunService.Heartbeat:Connect(function()
            if not u86 then
                u87:Disconnect()

                return
            end

            local v110 = u14()

            if not v110 then
                return
            end

            local v111 = _LocalPlayer.Data.Level.Value or 1
            local v112, v113, v114 = ipairs(u89)
            local v115 = nil

            while true do
                local v116

                v114, v116 = v112(v113, v114)

                if v114 == nil then
                    break
                end
                if v116.minLevel <= v111 and v111 <= v116.maxLevel then
                    v115 = u88[v116.name]

                    break
                end
            end

            if v115 then
                if not u109 then
                    u12(v110.HumanoidRootPart, v115.loadCFrame)

                    u109 = true
                end

                local v117 = u97(v115[1], 5)

                if #v117 <= 0 then
                    v110.Humanoid.Sit = false

                    local v118 = v110.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)

                    u12(v110.HumanoidRootPart, v118)
                    task.wait(0.3)
                else
                    local v119 = tick()

                    if u108 <= v119 - u106 then
                        u107 = u107 % #v117 + 1
                        u106 = v119
                    end

                    local v120 = v117[u107]

                    if v120 then
                        u105(v120, v115.range)

                        local v121 = v115[2] == 'Giorno' and u55(v115[1] == 'Bad Gi' and 'Bad Gi [Lvl. 1+]' or 'Jungle Bandit [Lvl. 175+]') or _Workspace.Map.NPCs:FindFirstChild(v115[2])

                        if v121 then
                            u23(v121.Done)
                            u23(v121.QuestDone)
                        end
                        if v110:FindFirstChild('Aura') and not v110.Aura.Value then
                            u23(v110.StandEvents.Summon)
                        end

                        local v122 = _Options.SelectedSkills and _Options.SelectedSkills.Value or {}

                        if next(v122) then
                            u38(v110, v122)
                        elseif u18 then
                            u30(v110)
                        end
                    end
                end
            else
                task.wait(0.3)
            end
        end)
    end

    v4.AutoFarmLevels:AddToggle('AutoFarmLevels', {
        Title = 'Auto Farm All Levels',
        Icon = 'play',
        Default = false,
    })
    _Options.AutoFarmLevels:OnChanged(function()
        u86 = _Options.AutoFarmLevels.Value

        if u86 then
            if u46 then
                u1:Notify({
                    Title = 'Error',
                    Content = 'Please disable Auto Farm & Quests first!',
                    Duration = 5,
                })

                u86 = false

                _Options.AutoFarmLevels:SetValue(false)

                return
            end

            task.spawn(u123)
        end
    end)

    local u124 = false
    local u125 = {}
    local u126 = nil
    local u127 = nil
    local u128 = false
    local u129 = {
        ['Jotaro Over Heaven'] = {range = 10},
        ['Alternate Jotaro Part 4'] = {range = 10},
        JohnnyJoestar = {range = 10},
        ['Giorno Giovanna Requiem'] = {range = 10},
    }
    local u130 = {
        ['Alternate Jotaro Part 4'] = CFrame.new(0, 100, 0),
    }

    local function u136()
        local v131, v132, v133 = pairs(_Workspace.Living:GetChildren())
        local v134 = {}

        while true do
            local v135

            v133, v135 = v131(v132, v133)

            if v133 == nil then
                break
            end
            if table.find(u125, v135.Name) and v135:FindFirstChild('Humanoid') and v135.Humanoid.Health > 0 then
                table.insert(v134, v135)
            end
        end

        return v134
    end
    local function u142()
        local v137, v138, v139 = pairs(_Workspace.Living:GetChildren())
        local v140 = {}

        while true do
            local v141

            v139, v141 = v137(v138, v139)

            if v139 == nil then
                break
            end
            if v141.Name:find('Minion') and v141:FindFirstChild('Humanoid') and v141.Humanoid.Health > 0 then
                table.insert(v140, v141)
            end
        end

        return v140
    end
    local function u150()
        local v143 = u14()

        if not v143 then
            return false
        end

        local v144 = u142()

        if #v144 == 0 then
            return true
        end

        local v145, v146, v147 = pairs(v144)

        while true do
            local v148

            v147, v148 = v145(v146, v147)

            if v147 == nil then
                break
            end

            u105(v148, 10)

            if v143:FindFirstChild('Aura') and not v143.Aura.Value then
                u23(v143.StandEvents.Summon)
            end

            local v149 = _Options.SelectedSkills and _Options.SelectedSkills.Value or {}

            if next(v149) then
                u38(v143, v149)
            elseif u18 then
                u30(v143)
            end

            task.wait(0.5)
        end

        return #u142() == 0
    end
    local function u153(p151)
        local v152 = u14()

        if v152 and u130[p151] then
            u12(v152.HumanoidRootPart, u130[p151])
        end
    end
    local function u161(p154, p155)
        local v156 = u14()

        if v156 and (p154 and p154.PrimaryPart) then
            local _HumanoidRootPart4 = v156:FindFirstChild('HumanoidRootPart')
            local _PrimaryPart3 = p154.PrimaryPart
            local _Stand3 = v156:FindFirstChild('Stand')

            if _Stand3 then
                _Stand3 = v156.Stand:FindFirstChild('HumanoidRootPart')
            end
            if _HumanoidRootPart4 and _PrimaryPart3 then
                pcall(function()
                    local v160 = _PrimaryPart3.CFrame * CFrame.new(0, p155 + u19, u20) * CFrame.Angles(math.rad(-90), 0, 0)

                    _HumanoidRootPart4.CFrame = v160
                    _HumanoidRootPart4.Velocity = Vector3.new(0, 0, 0)

                    if _Stand3 then
                        _Stand3.CFrame = v160
                        _Stand3.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end
        end
    end
    local function u171()
        if u126 then
            u126:Disconnect()
        end

        u126 = _RunService.Heartbeat:Connect(function()
            if u124 then
                local v162 = u136()

                if #v162 > 0 and not u128 then
                    if u46 then
                        u127 = 'FarmingQuests'
                        u46 = false

                        _Options.AutoFarm:SetValue(false)

                        if u47 then
                            u47:Disconnect()
                        end
                    elseif u86 then
                        u127 = 'AutoFarmLevels'
                        u86 = false

                        _Options.AutoFarmLevels:SetValue(false)

                        if u87 then
                            u87:Disconnect()
                        end
                    end

                    u128 = true

                    u1:Notify({
                        Title = 'Info',
                        Content = 'Bosses detected! Starting Boss Farm.',
                        Duration = 3,
                    })
                end
                if u128 and 0 < #v162 then
                    local v163, v164, v165 = pairs(v162)

                    while true do
                        local v166

                        v165, v166 = v163(v164, v165)

                        if v165 == nil then
                            break
                        end
                        if v166.Name ~= 'Alternate Jotaro Part 4' then
                            u161(v166, u129[v166.Name].range)
                        elseif u150() then
                            u161(v166, u129[v166.Name].range)
                        end

                        local v167 = u14()

                        if v167 then
                            if v167.Humanoid.Health <= 0 then
                                u1:Notify({
                                    Title = 'Warning',
                                    Content = 'Character died! Pausing Boss Farm.',
                                    Duration = 5,
                                })

                                u124 = false

                                _Options.AutoFarmBoss:SetValue(false)

                                return
                            end
                            if v167:FindFirstChild('Aura') and not v167.Aura.Value then
                                u23(v167.StandEvents.Summon)
                            end

                            local v168 = _Options.SelectedSkills and _Options.SelectedSkills.Value or {}

                            if next(v168) then
                                u38(v167, v168)
                            elseif u18 then
                                u30(v167)
                            end
                        end
                    end
                elseif u128 and #v162 == 0 then
                    local v169 = u14()

                    if v169 then
                        v169.Humanoid.Sit = false
                    end
                    if u127 ~= 'FarmingQuests' then
                        if u127 == 'AutoFarmLevels' then
                            u86 = true

                            _Options.AutoFarmLevels:SetValue(true)
                            task.spawn(u123)
                            u1:Notify({
                                Title = 'Info',
                                Content = 'Bosses defeated! Resuming Auto Farm All Levels.',
                                Duration = 3,
                            })
                        end
                    else
                        u46 = true

                        _Options.AutoFarm:SetValue(true)
                        task.spawn(u85)
                        u1:Notify({
                            Title = 'Info',
                            Content = 'Bosses defeated! Resuming Farming & Quests.',
                            Duration = 3,
                        })
                    end

                    u127 = nil
                    u128 = false
                end
                if #v162 == 0 and not u128 then
                    if table.find(u125, 'Alternate Jotaro Part 4') then
                        u153('Alternate Jotaro Part 4')
                        u1:Notify({
                            Title = 'Info',
                            Content = 'Teleporting to Alternate Jotaro Part 4 spawn point.',
                            Duration = 3,
                        })
                    end

                    task.wait(1)
                end
            else
                u126:Disconnect()

                local v170 = u14()

                if v170 then
                    v170.Humanoid.Sit = false

                    if table.find(u125, 'Alternate Jotaro Part 4') then
                        u153('Alternate Jotaro Part 4')
                    end
                end

                u128 = false
            end
        end)
    end

    v4.BossFarm:AddDropdown('SelectBosses', {
        Title = 'Bosses',
        Icon = 'users',
        Values = {
            'Jotaro Over Heaven',
            'Alternate Jotaro Part 4',
            'JohnnyJoestar',
            'Giorno Giovanna Requiem',
        },
        Multi = true,
        Default = {},
    })
    _Options.SelectBosses:OnChanged(function(p172)
        u125 = {}

        local v173, v174, v175 = pairs(p172)

        while true do
            local v176

            v175, v176 = v173(v174, v175)

            if v175 == nil then
                break
            end
            if v176 then
                table.insert(u125, v175)
            end
        end
    end)
    v4.BossFarm:AddToggle('AutoFarmBoss', {
        Title = 'Auto Farm',
        Icon = 'play',
        Default = false,
    })
    _Options.AutoFarmBoss:OnChanged(function()
        u124 = _Options.AutoFarmBoss.Value

        if u124 then
            if #u125 == 0 then
                u1:Notify({
                    Title = 'Error',
                    Content = 'Please select at least one boss first!',
                    Duration = 5,
                })

                u124 = false

                _Options.AutoFarmBoss:SetValue(false)

                return
            end

            u1:Notify({
                Title = 'Info',
                Content = 'Boss Farm enabled! Waiting for bosses to spawn...',
                Duration = 3,
            })
            task.spawn(u171)
        else
            local v177 = u14()

            if v177 then
                v177.Humanoid.Sit = false

                if table.find(u125, 'Alternate Jotaro Part 4') then
                    u153('Alternate Jotaro Part 4')
                end
            end

            u1:Notify({
                Title = 'Info',
                Content = 'Boss Farm disabled!',
                Duration = 3,
            })
        end
    end)

    local u178 = {
        ['King Crimson'] = 'KingCrimson',
        ['Crazy Diamond'] = 'CrazyDiamond',
        ['Hierophant Green'] = 'HG',
        ['Silver Chariot'] = 'SilverChariot',
        ['The World'] = 'TheWorld',
        ["Dio's The World"] = 'DTW',
        ['Star Platinum'] = 'StarPlatinum',
        ['Killer Queen'] = 'KillerQueen',
        ['Dirty Deeds Done Dirt Cheap'] = 'D4C',
        ['White Snake'] = 'WhiteSnake',
        ['Golden Experience'] = 'GE',
        ['Tusk Act1'] = 'TA1',
        ['The Hand'] = 'TheHand',
        Cream = 'Cream',
        ['Diver Down'] = 'DiverDown',
        ["Jotaro's Star Platinum"] = 'JotarosStarPlatinum',
        ["Magician's Red"] = 'MR',
        ['Sticky Fingers'] = 'StickyFingers',
        ['Premier Macho'] = 'PM',
        ['Putrid Whine'] = 'PutridWhine',
        ['Silver Chariot OVA'] = 'SCOVA',
        ['Star Platinum OVA'] = 'StarPlatinumOVA',
        ['The World OVA'] = 'TWOVA',
        ['Stone Free'] = 'StoneFree',
        ['The World Alternate Universe'] = 'TWAU',
        ['Soft And Wet'] = 'SoftAndWet',
    }
    local u179 = {}
    local u180 = {}
    local u181 = 'Stand Arrow'
    local u182 = 'None'
    local u183 = false
    local _MarketplaceService = game:GetService('MarketplaceService')
    local _LocalPlayer2 = game:GetService('Players').LocalPlayer
    local _ReplicatedStorage2 = game:GetService('ReplicatedStorage')

    local function u190(p187, p188, p189)
        u1:Notify({
            Title = p187,
            Content = p188,
            Duration = p189 or 5,
        })
    end
    local function u192()
        local v191 = _LocalPlayer2.Character or _LocalPlayer2.CharacterAdded:Wait()

        if v191:WaitForChild('HumanoidRootPart', 5) and v191:WaitForChild('Humanoid', 5) then
            return v191
        else
            return nil
        end
    end
    local function u197(p193, p194)
        local v195 = _LocalPlayer2.Backpack:FindFirstChild(p193)

        if p194:FindFirstChild(p193) then
            p194.Humanoid:UnequipTools()
            task.wait(0.1)
        end
        if not v195 then
            return false
        end

        p194.Humanoid:EquipTool(v195)
        task.wait(0.1)

        if not p194:FindFirstChild(p193) then
            return false
        end

        p194[p193]:Activate()
        u23(_ReplicatedStorage2.Events.UseItem)

        local _ProximityPrompt = p194[p193]:FindFirstChildOfClass('ProximityPrompt')

        if _ProximityPrompt then
            fireproximityprompt(_ProximityPrompt, 1)
        end

        task.wait(0.5)

        return true
    end
    local function u200(p198, p199)
        return pcall(function()
            if p199 == nil then
                p198:FireServer()
            else
                p198:FireServer(p199)
            end
        end)
    end
    local function u206()
        local v201 = _LocalPlayer2.Data and (_LocalPlayer2.Data.Stand and _LocalPlayer2.Data.Stand.Value) or 'None'
        local v202 = _LocalPlayer2.Data and _LocalPlayer2.Data.Attri and (_LocalPlayer2.Data.Attri.Value or 'None') or 'None'
        local v203 = tostring(v202)
        local v204 = table.find(u179, v201)
        local v205 = table.find(u180, v203)

        if u182 == 'StandCheck' then
            return v204
        end
        if u182 == 'AttributeCheck' then
            return v205
        end
        if u182 == 'StandOrAttriCheck' then
            return v204 or v205
        end
        if u182 ~= 'StandAndAttriCheck' then
            return false
        end
        if not v204 then
            v205 = v204
        end

        return v205
    end
    local function u208()
        local v207 = u192()

        if v207 then
            v207.Humanoid:UnequipTools()

            v207.Humanoid.Sit = false
        end
    end
    local function u224()
        local v209 = u192()

        if not v209 then
            return false, 'no_character'
        end

        local v210 = _LocalPlayer2.Data and _LocalPlayer2.Data.Stand and (_LocalPlayer2.Data.Stand.Value or 'None') or 'None'

        if not u206() then
            if v210 == 'None' then
                if not u197(u181, v209) then
                    return false, 'no_item'
                end

                local v211 = tick() + 5

                while tick() < v211 and (_LocalPlayer2.Data and _LocalPlayer2.Data.Stand) and (_LocalPlayer2.Data.Stand.Value == 'None' and u183) do
                    task.wait(0.1)
                end

                return true, 'used_item'
            else
                if not u197('Rokakaka', v209) then
                    return false, 'no_rokakaka'
                end

                local v212 = tick() + 5

                while tick() < v212 and (_LocalPlayer2.Data and _LocalPlayer2.Data.Stand) and (_LocalPlayer2.Data.Stand.Value ~= 'None' and u183) do
                    task.wait(0.1)
                end

                return true, 'used_rokakaka'
            end
        end

        local v213 = false
        local v214 = _LocalPlayer2.Data and _LocalPlayer2.Data.Level and (_LocalPlayer2.Data.Level.Value or 1) or 1
        local v215 = pcall(function()
            return _MarketplaceService:UserOwnsGamePassAsync(_LocalPlayer2.UserId, 142794026)
        end) and true or false
        local v216 = pcall(function()
            return _MarketplaceService:UserOwnsGamePassAsync(_LocalPlayer2.UserId, 146346514)
        end) and true or false
        local v217 = {
            1,
            2,
            4,
            3,
            5,
        }

        if v215 then
            table.insert(v217, 3)
        end
        if v214 >= 120 then
            table.insert(v217, 4)
        end
        if v216 then
            table.insert(v217, 5)
        end

        local v218, v219, v220 = ipairs(v217)

        while true do
            local v221

            v220, v221 = v218(v219, v220)

            if v220 == nil then
                break
            end

            local v222 = _LocalPlayer2.Data['Slot' .. v221 .. 'Stand']

            if v222 and v222.Value == 'None' then
                u200(_ReplicatedStorage2.Events.SwitchStand, 'Slot' .. v221)

                local v223 = tick() + 5

                while tick() < v223 and (_LocalPlayer2.Data and _LocalPlayer2.Data.Stand) and (_LocalPlayer2.Data.Stand.Value ~= 'None' and u183) do
                    task.wait(0.1)
                end

                if _LocalPlayer2.Data and _LocalPlayer2.Data.Stand and _LocalPlayer2.Data.Stand.Value == 'None' then
                    u190('Info', 'Stored stand in Slot ' .. v221, 3)

                    return true, 'stored'
                end

                break
            end
        end

        if v213 then
            return true, 'stored'
        else
            return false, 'no_slots'
        end
    end

    v4.StandFarm:AddDropdown('SelectStands', {
        Title = 'Stands',
        Icon = 'star',
        Values = {
            'King Crimson',
            'Crazy Diamond',
            'Hierophant Green',
            'Silver Chariot',
            'The World',
            "Dio's The World",
            'Star Platinum',
            'Killer Queen',
            'Dirty Deeds Done Dirt Cheap',
            'White Snake',
            'Golden Experience',
            'Tusk Act1',
            'The Hand',
            'Cream',
            'Diver Down',
            "Jotaro's Star Platinum",
            "Magician's Red",
            'Sticky Fingers',
            'Premier Macho',
            'Putrid Whine',
            'Silver Chariot OVA',
            'Star Platinum OVA',
            'The World OVA',
            'Stone Free',
            'The World Alternate Universe',
            'Soft And Wet',
        },
        Multi = true,
        Default = {},
    })
    _Options.SelectStands:OnChanged(function(p225)
        u179 = {}

        local v226, v227, v228 = pairs(p225)

        while true do
            local v229

            v228, v229 = v226(v227, v228)

            if v228 == nil then
                break
            end
            if v229 then
                local v230 = u178[v228]

                if v230 then
                    table.insert(u179, v230)
                end
            end
        end
    end)
    v4.StandFarm:AddDropdown('SelectAttributes', {
        Title = 'Attributes',
        Icon = 'award',
        Values = {
            'None',
            'Strong',
            'Tough',
            'Sloppy',
            'Powerful',
            'Manic',
            'Enrage',
            'Lethargic',
            'Godly',
            'Daemon',
            'Invincible',
            'Tragic',
            'Scourge',
            'GlassCannon',
            'Hacker',
            'Legendary',
        },
        Multi = true,
        Default = {},
    })
    _Options.SelectAttributes:OnChanged(function(p231)
        u180 = {}

        local v232, v233, v234 = pairs(p231)

        while true do
            local v235

            v234, v235 = v232(v233, v234)

            if v234 == nil then
                break
            end
            if v235 then
                table.insert(u180, v234)
            end
        end
    end)
    v4.StandFarm:AddDropdown('SelectItem', {
        Title = 'Item to Use',
        Icon = 'tool',
        Values = {
            'Stand Arrow',
            'Charged Arrow',
            'Kars Mask',
        },
        Default = 1,
    })
    _Options.SelectItem:OnChanged(function(p236)
        u181 = p236
    end)
    v4.StandFarm:AddDropdown('SelectCondition', {
        Title = 'Condition',
        Icon = 'check',
        Values = {
            'None',
            'StandCheck',
            'AttributeCheck',
            'StandOrAttriCheck',
            'StandAndAttriCheck',
        },
        Default = 1,
    })
    _Options.SelectCondition:OnChanged(function(p237)
        u182 = p237
    end)
    v4.StandFarm:AddToggle('StartStandFarm', {
        Title = 'Start Farm',
        Icon = 'play',
        Default = false,
    })
    _Options.StartStandFarm:OnChanged(function()
        u183 = _Options.StartStandFarm.Value

        if u183 then
            if u182 == 'None' then
                u190('Error', 'Select a condition first!', 5)

                u183 = false

                _Options.StartStandFarm:SetValue(false)

                return
            end
            if (u182 == 'StandCheck' or u182 == 'StandOrAttriCheck' or u182 == 'StandAndAttriCheck') and #u179 == 0 then
                u190('Error', 'Select at least one Stand!', 5)

                u183 = false

                _Options.StartStandFarm:SetValue(false)

                return
            end
            if (u182 == 'AttributeCheck' or u182 == 'StandOrAttriCheck' or u182 == 'StandAndAttriCheck') and #u180 == 0 then
                u190('Error', 'Select at least one Attribute!', 5)

                u183 = false

                _Options.StartStandFarm:SetValue(false)

                return
            end

            u208()
            u190('Info', 'Stand Farm Started!', 3)
            task.spawn(function()
                _LocalPlayer2.CharacterAdded:Connect(function()
                    if u183 then
                        u208()
                    end
                end)

                while u183 do
                    if isItemFarming then
                        while isItemFarming and u183 do
                            task.wait(1)
                        end

                        if not u183 then
                            break
                        end
                    end

                    local v238, v239 = u224()

                    if not v238 then
                        if v239 == 'no_character' then
                            while not _LocalPlayer2.Character and u183 do
                                task.wait(1)
                            end
                        elseif v239 == 'no_item' then
                            u190('Warning', 'Out of ' .. u181 .. '!', 5)

                            while not _LocalPlayer2.Backpack:FindFirstChild(u181) and u183 do
                                task.wait(1)
                            end
                        elseif v239 == 'no_rokakaka' then
                            u190('Warning', 'Out of Rokakaka!', 5)

                            while not _LocalPlayer2.Backpack:FindFirstChild('Rokakaka') and u183 do
                                task.wait(1)
                            end
                        elseif v239 == 'no_slots' then
                            u190('Warning', 'No empty slots available!', 5)

                            u183 = false

                            _Options.StartStandFarm:SetValue(false)

                            break
                        end
                    end

                    task.wait(0.1)
                end

                u208()
                u190('Info', 'Stand Farm Stopped!', 3)
            end)
        else
            u190('Info', 'Stand Farm Stopped!', 3)
        end
    end)
    v4.StandFarm:AddButton({
        Title = 'Open Storage',
        Icon = 'archive',
        Callback = function()
            u200(_Workspace.Map.NPCs.admpn.Done)
        end,
    })

    local u240 = 1

    v4.AutoBuy:AddButton({
        Title = 'Teleport to Shop 1',
        Icon = 'map-pin',
        Callback = function()
            local v241 = u14()

            if v241 then
                u12(v241.HumanoidRootPart, CFrame.new(11926.0732, -3.33700514, -4513.32227))

                if v241:FindFirstChild('Stand') then
                    u12(v241.Stand.HumanoidRootPart, v241.HumanoidRootPart.CFrame)
                end
            end
        end,
    })
    v4.AutoBuy:AddButton({
        Title = 'Teleport to Shop 2',
        Icon = 'map-pin',
        Callback = function()
            local v242 = u14()

            if v242 then
                u12(v242.HumanoidRootPart, CFrame.new(-426.638123, 67.1232071, -156.04895))

                if v242:FindFirstChild('Stand') then
                    u12(v242.Stand.HumanoidRootPart, v242.HumanoidRootPart.CFrame)
                end
            end
        end,
    })
    v4.AutoBuy:AddInput('BuyAmount', {
        Title = 'Amount',
        Icon = 'hash',
        Default = '1',
        Numeric = true,
        Callback = function(p243)
            u240 = tonumber(p243) or 1
        end,
    })

    local v244, v245, v246 = ipairs({
        {
            'Rokakaka (2,500c)',
            'MerchantAU',
            'Option2',
            'apple',
        },
        {
            'Stand Arrow (3,500c)',
            'MerchantAU',
            'Option4',
            'arrow-right',
        },
        {
            'Charged Arrow (50,000c)',
            'Merchantlvl120',
            'Option2',
            'zap',
        },
        {
            'Dio Diary (1,500,000c)',
            'Merchantlvl120',
            'Option3',
            'book',
        },
        {
            'Requiem Arrow (1,500,000c)',
            'Merchantlvl120',
            'Option4',
            'arrow-up',
        },
    })
    local u247 = u38
    local u248 = u20
    local u249 = u124
    local u250 = u86
    local u251 = u30
    local u252 = u18
    local u253 = u46
    local u254 = u19
    local u255 = _LocalPlayer
    local u256 = u23
    local u257 = u240

    while true do
        local u258

        v246, u258 = v244(v245, v246)

        if v246 == nil then
            break
        end

        v4.AutoBuy:AddButton({
            Title = u258[1],
            Icon = u258[4],
            Callback = function()
                for _ = 1, u257 do
                    _ReplicatedStorage.Events.BuyItem:FireServer(u258[2], u258[3])
                end
            end,
        })
    end

    local u259 = {
        ['Dungeon [Lvl.15+]'] = {
            npcMonster = 'i_stabman [Lvl. 15+]',
            bossName = 'Bad Gi Boss',
            range = 7,
            loadCFrame = CFrame.new(-13445.3252, -60.2168045, -2222.99097, -1, 0, 0, 0, 1, 0, 0, 0, -1),
        },
        ['Dungeon [Lvl.40+]'] = {
            npcMonster = 'i_stabman [Lvl. 40+]',
            bossName = 'Dio [Dungeon]',
            range = 10,
            loadCFrame = CFrame.new(-13475.2158, -62.0921021, -2217.27539, -1, 0, 0, 0, 1, 0, 0, 0, -1),
        },
        ['Dungeon [Lvl.80+]'] = {
            npcMonster = 'i_stabman [Lvl. 80+]',
            bossName = 'Homeless Lord',
            range = 12,
            loadCFrame = CFrame.new(-13219.7607, -64.0739975, -2350.44189, -1.1920929000000002e-7, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929000000002e-7),
        },
        ['Dungeon [Lvl.100+]'] = {
            npcMonster = 'i_stabman [Lvl. 100+]',
            bossName = 'Diavolo [Dungeon]',
            range = 10,
            loadCFrame = CFrame.new(-13336.2656, -63.1334457, -2391.11108, -1, 0, 0, 0, 1, 0, 0, 0, -1),
        },
        ['Dungeon [Lvl.200+]'] = {
            npcMonster = 'i_stabman [Lvl. 200+]',
            bossName = 'Jotaro P6 [Dungeon]',
            range = 15,
            loadCFrame = CFrame.new(-4.18469238, 33.3382645, -132.123505, -1, 0, 0, 0, 1, 0, 0, 0, -1),
        },
    }
    local u260 = 'Dungeon [Lvl.15+]'
    local u261 = false
    local u262 = nil
    local u263 = 0
    local u264 = 'NPC'
    local u265 = nil
    local u266 = 0
    local u267 = 0
    local u268 = false

    local function u270()
        local _QuestGui = u255.PlayerGui:FindFirstChild('QuestGui')

        return _QuestGui and (_QuestGui:FindFirstChild('Active') and _QuestGui.Active.Value) or false
    end
    local function u276()
        local v271, v272, v273 = ipairs(_Workspace.Map.NPCs:GetChildren())

        while true do
            local v274

            v273, v274 = v271(v272, v273)

            if v273 == nil then
                break
            end
            if v274.Name:find('i_stabman') and v274:FindFirstChild('Head') and v274.Head:FindFirstChild('Main') and (v274.Head.Main:FindFirstChild('Text') and v274.Head.Main.Text.Text == u259[u260].npcMonster) then
                local _HumanoidRootPart5 = v274:FindFirstChild('HumanoidRootPart')

                if _HumanoidRootPart5 then
                    u265 = _HumanoidRootPart5.CFrame + Vector3.new(0, 3, 5)

                    return v274
                end
            end
        end

        return nil
    end
    local function u283()
        local v277, v278, v279 = pairs(_Workspace.Living:GetChildren())

        while true do
            local v280

            v279, v280 = v277(v278, v279)

            if v279 == nil then
                break
            end
            if v280.Name == 'Boss' and v280:FindFirstChild('Humanoid') and v280.Humanoid.Health > 0 then
                local _Head = v280:FindFirstChild('Head')

                if _Head and _Head:FindFirstChild('Display') and _Head.Display:FindFirstChild('Frame') then
                    local v282 = _Head.Display.Frame:FindFirstChild('TextLabel') or _Head.Display.Frame:FindFirstChild('t')

                    if v282 and v282.Text == u259[u260].bossName then
                        return v280
                    end
                end
            end
        end

        return nil
    end
    local function u291(p284)
        local v285 = u14()

        if v285 and (p284 and p284:FindFirstChild('HumanoidRootPart')) then
            local _HumanoidRootPart6 = v285:FindFirstChild('HumanoidRootPart')
            local _HumanoidRootPart7 = p284.HumanoidRootPart
            local _Stand4 = v285:FindFirstChild('Stand')

            if _Stand4 then
                _Stand4 = v285.Stand:FindFirstChild('HumanoidRootPart')
            end

            local _range = u259[u260].range

            if _HumanoidRootPart6 and _HumanoidRootPart7 then
                pcall(function()
                    local v290 = _HumanoidRootPart7.CFrame * CFrame.new(0, _range + u254, u248) * CFrame.Angles(math.rad(-90), 0, 0)

                    _HumanoidRootPart6.CFrame = v290
                    _HumanoidRootPart6.Velocity = Vector3.new(0, 0, 0)

                    if _Stand4 then
                        _Stand4.CFrame = v290
                        _Stand4.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end
        end
    end
    local function u295(p292)
        if p292 and p292:FindFirstChild('Humanoid') then
            local v293 = tick()

            if v293 - u267 >= 2 then
                local _Health = p292.Humanoid.Health

                if u266 <= _Health then
                    local _ = 0 >= u266
                end

                u266 = _Health
                u267 = v293
            end
        end
    end

    v4.DungeonFarm:AddDropdown('ChooseDungeon', {
        Title = 'Dungeon',
        Icon = 'list',
        Values = {
            'Dungeon [Lvl.15+]',
            'Dungeon [Lvl.40+]',
            'Dungeon [Lvl.80+]',
            'Dungeon [Lvl.100+]',
            'Dungeon [Lvl.200+]',
        },
        Default = 1,
    })
    _Options.ChooseDungeon:OnChanged(function()
        u260 = _Options.ChooseDungeon.Value
        u264 = 'NPC'
        u265 = nil
        u266 = 0
        u267 = 0
        u268 = false
    end)
    v4.DungeonFarm:AddToggle('AutoFarmDungeon', {
        Title = 'Auto Farm',
        Icon = 'play',
        Default = false,
    })
    _Options.AutoFarmDungeon:OnChanged(function()
        u261 = _Options.AutoFarmDungeon.Value

        if u253 or (u250 or u249) then
            u1:Notify({
                Title = 'Error',
                Content = 'Please disable other farming modes first!',
                Duration = 5,
            })

            u261 = false

            _Options.AutoFarmDungeon:SetValue(false)

            return
        elseif u260 and u259[u260] then
            if u261 then
                u264 = 'NPC'
                u268 = false

                u1:Notify({
                    Title = 'Info',
                    Content = 'Dungeon Farm Started',
                    Duration = 3,
                })
                task.spawn(function()
                    u262 = _RunService.Heartbeat:Connect(function()
                        if u261 then
                            local v296 = u14()

                            if v296 and v296:FindFirstChild('HumanoidRootPart') then
                                local _HumanoidRootPart8 = v296.HumanoidRootPart
                                local v298 = tick()

                                if not u268 then
                                    u12(v296.HumanoidRootPart, u259[u260].loadCFrame)

                                    u268 = true

                                    task.wait(0.5)
                                end
                                if u270() or u264 ~= 'NPC' then
                                    if u264 == 'Boss' then
                                        local v299 = u283()

                                        if v299 then
                                            u291(v299)
                                            u295(v299)

                                            if v296:FindFirstChild('Aura') and not v296.Aura.Value then
                                                u256(v296.StandEvents.Summon)
                                            end

                                            local v300 = _Options.SelectedSkills and _Options.SelectedSkills.Value or {}

                                            if next(v300) then
                                                u247(v296, v300)
                                            elseif u252 then
                                                u251(v296)
                                            end
                                        elseif v298 - u263 > 5 and u265 then
                                            u12(_HumanoidRootPart8, u265)

                                            u263 = v298

                                            local v301 = u276()
                                            local v302 = v301 and v301:FindFirstChild('QuestDone')

                                            if v302 then
                                                u256(v302)
                                            end

                                            u264 = 'NPC'
                                        end
                                    end
                                else
                                    local v303 = u276()
                                    local v304 = v303 and 1 < v298 - u263 and v303:FindFirstChild('HumanoidRootPart')

                                    if v304 then
                                        u12(v296.HumanoidRootPart, v304.CFrame + Vector3.new(0, 2, 2))

                                        u263 = v298

                                        local _ProximityPrompt2 = v304:FindFirstChildOfClass('ProximityPrompt')

                                        if _ProximityPrompt2 then
                                            fireproximityprompt(_ProximityPrompt2, 20)
                                        end

                                        local _Done = v303:FindFirstChild('Done')

                                        if _Done then
                                            u256(_Done)
                                        end

                                        u264 = 'Boss'

                                        task.wait(5)
                                    end
                                end
                            end
                        else
                            if u262 then
                                u262:Disconnect()
                            end

                            local v307 = u14()

                            if v307 then
                                v307.Humanoid.Sit = false

                                if u265 then
                                    u12(v307.HumanoidRootPart, u265)
                                end
                            end

                            u264 = 'NPC'

                            u1:Notify({
                                Title = 'Info',
                                Content = 'Dungeon Farm Stopped',
                                Duration = 3,
                            })

                            return
                        end
                    end)
                end)
            end
        else
            u1:Notify({
                Title = 'Error',
                Content = 'No valid dungeon selected!',
                Duration = 5,
            })

            u261 = false

            _Options.AutoFarmDungeon:SetValue(false)
        end
    end)
    v4.DungeonFarm:AddButton({
        Title = 'Refresh',
        Icon = 'refresh-cw',
        Callback = function()
            local v308 = u14()

            if v308 then
                v308.Humanoid.Sit = false
            end
        end,
    })

    local u309 = false
    local u310 = nil

    local function u313(p311, p312)
        if p311 and p311:IsA('BasePart') then
            pcall(function()
                p311.CFrame = p312
                p311.Velocity = Vector3.new(0, 0, 0)
            end)
        end
    end

    v4.ItemFarm:AddButton({
        Title = 'Teleport Safe Zone',
        Icon = 'map-pin',
        Callback = function()
            local v314 = u14()

            if v314 then
                u12(v314.HumanoidRootPart, CFrame.new(3343.3833, 98.8131409, -143.222626))

                if v314:FindFirstChild('Stand') then
                    u12(v314.Stand.HumanoidRootPart, v314.HumanoidRootPart.CFrame)
                end
            end
        end,
    })
    v4.ItemFarm:AddButton({
        Title = 'Teleport Word',
        Icon = 'map-pin',
        Callback = function()
            local v315 = u14()

            if v315 then
                u12(v315.HumanoidRootPart, CFrame.new(-505.547211, 93.7540131, -503.090698))

                if v315:FindFirstChild('Stand') then
                    u12(v315.Stand.HumanoidRootPart, v315.HumanoidRootPart.CFrame)
                end
            end
        end,
    })
    v4.ItemFarm:AddToggle('FarmItems', {
        Title = 'Farm Items',
        Icon = 'play',
        Default = false,
    })
    _Options.FarmItems:OnChanged(function()
        u309 = _Options.FarmItems.Value
        _G.On = u309

        if u309 and (u253 or u250 or (u249 or u261)) then
            u309 = false
            _G.On = false

            _Options.FarmItems:SetValue(false)
        else
            if u310 then
                u310:Disconnect()
            end
            if u309 then
                u310 = _RunService.Heartbeat:Connect(function()
                    if u309 and _G.On then
                        local v316 = u14()

                        if v316 and v316:FindFirstChild('HumanoidRootPart') then
                            local _HumanoidRootPart9 = v316.HumanoidRootPart
                            local v318, v319, v320 = pairs(_Workspace.Vfx:GetDescendants())

                            while true do
                                local v321

                                v320, v321 = v318(v319, v320)

                                if v320 == nil then
                                    break
                                end
                                if v321:IsA('BasePart') and (v321.Name == 'Handle' or v321.Name:find('Item')) and v321.Parent then
                                    local v322 = v321.Parent:FindFirstChild('ProximityPrompt') or v321:FindFirstChild('ProximityPrompt')

                                    if v322 then
                                        local _Magnitude = (_HumanoidRootPart9.Position - v321.Position).Magnitude

                                        if _Magnitude > 5 then
                                            u313(_HumanoidRootPart9, CFrame.new(v321.Position + Vector3.new(0, 3, 0)))
                                            task.wait(0.5)
                                        end
                                        if _Magnitude <= 5 then
                                            fireproximityprompt(v322, 20)
                                            task.wait(0.3)
                                        end
                                    end
                                end
                            end

                            if _Workspace:FindFirstChild('Items') then
                                local v324, v325, v326 = pairs(_Workspace.Items:GetChildren())

                                while true do
                                    local v327

                                    v326, v327 = v324(v325, v326)

                                    if v326 == nil then
                                        break
                                    end
                                    if v327:IsA('BasePart') and v327:FindFirstChild('ProximityPrompt') then
                                        local _Magnitude2 = (_HumanoidRootPart9.Position - v327.Position).Magnitude

                                        if _Magnitude2 > 5 then
                                            u313(_HumanoidRootPart9, CFrame.new(v327.Position + Vector3.new(0, 3, 0)))
                                            task.wait(0.5)
                                        end
                                        if _Magnitude2 <= 5 then
                                            fireproximityprompt(v327.ProximityPrompt, 20)
                                            task.wait(0.3)
                                        end
                                    end
                                end
                            end

                            task.wait(0.5)
                        else
                            task.wait(1)
                        end
                    else
                        if u310 then
                            u310:Disconnect()
                        end

                        local v329 = u14()

                        if v329 then
                            v329.Humanoid.Sit = false
                        end

                        return
                    end
                end)
            else
                if u310 then
                    u310:Disconnect()
                end

                local v330 = u14()

                if v330 then
                    v330.Humanoid.Sit = false
                end
            end
        end
    end)

    local u331 = false

    local function u332()
        task.spawn(function()
            while u331 do
                if u14() then
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 'W', false, game)
                    task.wait(0.1)
                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 'W', false, game)
                    task.wait(300)
                else
                    task.wait(5)
                end
            end
        end)
    end

    v4.Settings:AddToggle('AntiAFK', {
        Title = 'Anti-AFK',
        Icon = 'clock',
        Default = false,
    })
    _Options.AntiAFK:OnChanged(function()
        u331 = _Options.AntiAFK.Value

        if u331 then
            u332()
        end
    end)
    v4.Settings:AddToggle('UseAllSkills', {
        Title = 'All Skills',
        Icon = 'wand',
        Default = false,
    })
    _Options.UseAllSkills:OnChanged(function()
        u252 = _Options.UseAllSkills.Value
    end)
    v4.Settings:AddDropdown('SelectedSkills', {
        Title = 'Skills',
        Icon = 'list',
        Values = u45(),
        Multi = true,
        Default = {},
    })
    v4.Settings:AddButton({
        Title = 'Refresh Skills',
        Icon = 'refresh-cw',
        Callback = function()
            local v333 = u45()

            _Options.SelectedSkills:SetValues(v333)

            local _Value2 = _Options.SelectedSkills.Value
            local v335, v336, v337 = pairs(_Value2)
            local v338 = {}

            while true do
                local v339

                v337, v339 = v335(v336, v337)

                if v337 == nil then
                    break
                end
                if v339 and table.find(v333, v337) then
                    v338[v337] = true
                end
            end

            _Options.SelectedSkills:SetValue(v338)
            u1:Notify({
                Title = 'Info',
                Content = 'Skills refreshed successfully!',
                Duration = 3,
            })
        end,
    })
    v4.Settings:AddSlider('YOffset', {
        Title = 'Y Offset',
        Description = 'Adjust vertical distance',
        Default = -5,
        Min = -10,
        Max = 20,
        Rounding = 1,
        Callback = function(p340)
            u254 = p340
        end,
    })
    v4.Settings:AddSlider('ZOffset', {
        Title = 'Z Offset',
        Description = 'Adjust horizontal distance',
        Default = 0,
        Min = -10,
        Max = 10,
        Rounding = 1,
        Callback = function(p341)
            u248 = p341
        end,
    })

    local _VirtualInputManager = game:GetService('VirtualInputManager')
    local _UserInputService = game:GetService('UserInputService')

    _G.Asd = false

    local u344 = {}
    local _P = Enum.KeyCode.P

    local function u347(p346)
        if p346 == 'E' then
            _VirtualInputManager:SendKeyEvent(true, 'E', false, game)
            task.wait(4)
            _VirtualInputManager:SendKeyEvent(false, 'E', false, game)
        elseif p346 == 'LeftClick' then
            _VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            _VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        elseif p346 == 'RightClick' then
            _VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            task.wait(0.05)
            _VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        else
            _VirtualInputManager:SendKeyEvent(true, p346, false, game)
            task.wait(0.1)
            _VirtualInputManager:SendKeyEvent(false, p346, false, game)
        end
    end
    local function u352()
        task.spawn(function()
            while _G.Asd do
                if u14() then
                    local v348, v349, v350 = pairs(u344)

                    while true do
                        local v351

                        v350, v351 = v348(v349, v350)

                        if v350 == nil then
                            break
                        end
                        if v351 then
                            u347(v350)

                            if v350 == 'E' then
                                task.wait(0.5)
                            elseif v350 == 'LeftClick' or v350 == 'RightClick' then
                                task.wait(0)
                            else
                                task.wait(0.2)
                            end
                        end
                    end

                    task.wait(0.5)
                else
                    task.wait(1)
                end
            end
        end)
    end

    _UserInputService.InputBegan:Connect(function(p353, p354)
        if not p354 then
            if p353.KeyCode == _P then
                _G.Asd = not _G.Asd

                if _G.Asd then
                    if next(u344) == nil then
                        u1:Notify({
                            Title = 'Error',
                            Content = 'Please select at least one key first!',
                            Duration = 5,
                        })

                        _G.Asd = false

                        _Options.UseKeySkills:SetValue(false)

                        return
                    end

                    u1:Notify({
                        Title = 'Info',
                        Content = "Key Skills activated with '" .. _P.Name .. "'!",
                        Duration = 3,
                    })
                    u352()
                    _Options.UseKeySkills:SetValue(true)
                else
                    u1:Notify({
                        Title = 'Info',
                        Content = "Key Skills stopped with '" .. _P.Name .. "'!",
                        Duration = 3,
                    })
                    _Options.UseKeySkills:SetValue(false)
                end
            end
        end
    end)
    v4.Settings:AddDropdown('SelectKeySkills', {
        Title = 'Key Skills',
        Icon = 'keyboard',
        Values = {
            'E',
            'R',
            'T',
            'Y',
            'J',
            'H',
            'F',
            'Z',
            'X',
            'C',
            'V',
            'LeftClick',
            'RightClick',
        },
        Multi = true,
        Default = {},
    })
    _Options.SelectKeySkills:OnChanged(function(p355)
        u344 = {}

        local v356, v357, v358 = pairs(p355)

        while true do
            local v359

            v358, v359 = v356(v357, v358)

            if v358 == nil then
                break
            end
            if v359 then
                u344[v358] = true
            end
        end
    end)
    v4.Settings:AddToggle('UseKeySkills', {
        Title = 'Use Keys',
        Icon = 'play',
        Default = false,
    })
    _Options.UseKeySkills:OnChanged(function()
        _G.Asd = _Options.UseKeySkills.Value

        if _G.Asd then
            if next(u344) == nil then
                u1:Notify({
                    Title = 'Error',
                    Content = 'Please select at least one key first!',
                    Duration = 5,
                })

                _G.Asd = false

                _Options.UseKeySkills:SetValue(false)

                return
            end

            u1:Notify({
                Title = 'Info',
                Content = 'Key Skills activated via GUI!',
                Duration = 3,
            })
            u352()
        else
            u1:Notify({
                Title = 'Info',
                Content = 'Key Skills stopped via GUI!',
                Duration = 3,
            })
        end
    end)

    local _ScreenGui = Instance.new('ScreenGui')

    _ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild('PlayerGui')
    _ScreenGui.Name = 'FloatingButtonGui'
    _ScreenGui.ResetOnSpawn = false

    local _ImageButton = Instance.new('ImageButton')

    _ImageButton.Size = UDim2.new(0, 40, 0, 40)
    _ImageButton.Position = UDim2.new(0.5, -25, 0.5, -25)
    _ImageButton.BackgroundTransparency = 1
    _ImageButton.Image = 'rbxassetid://12514663645'
    _ImageButton.Parent = _ScreenGui

    local _UICorner = Instance.new('UICorner')

    _UICorner.CornerRadius = UDim.new(1, 0)
    _UICorner.Parent = _ImageButton

    local u363 = nil
    local u364 = nil
    local u365 = nil
    local u366 = nil

    _ImageButton.InputBegan:Connect(function(p367)
        if p367.UserInputType == Enum.UserInputType.MouseButton1 or p367.UserInputType == Enum.UserInputType.Touch then
            u363 = true
            u365 = p367.Position
            u366 = _ImageButton.Position

            p367.Changed:Connect(function()
                if p367.UserInputState == Enum.UserInputState.End then
                    u363 = false
                end
            end)
        end
    end)
    _ImageButton.InputChanged:Connect(function(p368)
        if p368.UserInputType == Enum.UserInputType.MouseMovement or p368.UserInputType == Enum.UserInputType.Touch then
            u364 = p368
        end
    end)
    _UserInputService.InputChanged:Connect(function(p369)
        if u363 and p369 == u364 then
            local v370 = p369.Position - u365

            _ImageButton.Position = UDim2.new(u366.X.Scale, u366.X.Offset + v370.X, u366.Y.Scale, u366.Y.Offset + v370.Y)
        end
    end)

    local u371 = true
    local _TweenService = game:GetService('TweenService')

    _ImageButton.MouseButton1Click:Connect(function()
        u371 = not u371

        u3:Minimize(not u371)

        local v373 = {
            ImageTransparency = u371 and 0 or 0.5,
        }

        _TweenService:Create(_ImageButton, TweenInfo.new(0.3), v373):Play()
    end)
    u3:SelectTab(1)
    u1:Notify({
        Title = 'EDU HUB',
        Content = 'The script has been loaded.',
        Duration = 8,
    })
    v2:LoadAutoloadConfig()
end
