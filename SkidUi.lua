-- [[ SEA HUB UI LIBRARY WITH FULL CUSTOM THEME SETTINGS ]] --

local function GetUi()
    
    pcall(function()
        local core = gethui and gethui() or game:GetService("CoreGui")
        if core:FindFirstChild("Sea Hub GUI") then core["Sea Hub GUI"]:Destroy() end
        if core:FindFirstChild("Sea Hub Notification") then core["Sea Hub Notification"]:Destroy() end
    end)

    getgenv().Tvk = true
    getgenv().Chon = true

    -- Colors Def
    local b = {
        ["Border Color"] = Color3.fromRGB(131, 181, 255),
        ["Click Effect Color"] = Color3.fromRGB(230, 230, 230),
        ["Setting Icon Color"] = Color3.fromRGB(230, 230, 230),
        ["Logo Image"] = "rbxassetid://6248942117",
        ["Search Icon Color"] = Color3.fromRGB(255, 255, 255),
        ["Search Icon Highlight Color"] = Color3.fromRGB(142, 172, 255),
        ["GUI Text Color"] = Color3.fromRGB(230, 230, 230),
        ["Text Color"] = Color3.fromRGB(230, 230, 230),
        ["Placeholder Text Color"] = Color3.fromRGB(140, 140, 140),
        ["Title Text Color"] = Color3.fromRGB(131, 181, 255),
        ["Background Main Color"] = Color3.fromRGB(43, 43, 43),
        ["Background 1 Color"] = Color3.fromRGB(35, 35, 35),
        ["Background 1 Transparency"] = 0,
        ["Background 2 Color"] = Color3.fromRGB(50, 50, 50),
        ["Background 3 Color"] = Color3.fromRGB(28, 28, 28),
        ["Page Selected Color"] = Color3.fromRGB(131, 181, 255),
        ["Section Text Color"] = Color3.fromRGB(131, 181, 255),
        ["Section Underline Color"] = Color3.fromRGB(131, 181, 255),
        ["Toggle Border Color"] = Color3.fromRGB(131, 181, 255),
        ["Toggle Checked Color"] = Color3.fromRGB(131, 181, 255),
        ["Toggle Desc Color"] = Color3.fromRGB(160, 160, 160),
        ["Button Color"] = Color3.fromRGB(131, 181, 255),
        ["Label Color"] = Color3.fromRGB(101, 152, 220),
        ["Dropdown Icon Color"] = Color3.fromRGB(230, 230, 230),
        ["Dropdown Selected Color"] = Color3.fromRGB(131, 181, 255),
        ["Textbox Highlight Color"] = Color3.fromRGB(131, 181, 255),
        ["Slider Line Color"] = Color3.fromRGB(60, 60, 60),
        ["Slider Highlight Color"] = Color3.fromRGB(131, 181, 255),
        ["Tween Animation 1 Speed"] = 0.25
    }

    local c = {} -- Lưu trữ callback khi màu thay đổi
    local function BindColor(colorName, callback)
        if not c[colorName] then c[colorName] = {} end
        table.insert(c[colorName], callback)
        pcall(callback, b[colorName])
    end

    getgenv().UIColor = setmetatable({}, {
        __newindex = function(_, key, val)
            rawset(b, key, val)
            if c[key] then
                for _, fn in ipairs(c[key]) do
                    pcall(fn, val)
                end
            end
        end,
        __index = b
    })

    local t = {}
    local u = {}
    local w = game:GetService("TweenService")
    local x = game:GetService("UserInputService")
    local isDraggingElement = false

    -- Hiệu ứng click chuột an toàn
    function u.ButtonEffect()
        pcall(function()
            if not Drawing then return end
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            local circle = Drawing.new("Circle")
            circle.Visible = true
            circle.Radius = 10
            circle.Filled = true
            circle.Color = getgenv().UIColor["Click Effect Color"]
            circle.Position = Vector2.new(mouse.X, mouse.Y + 35)

            local n = Instance.new("NumberValue")
            n.Value = 10
            local trans = Instance.new("NumberValue")
            trans.Value = 1

            w:Create(n, TweenInfo.new(0.25), {Value = 25}):Play()
            w:Create(trans, TweenInfo.new(0.25), {Value = 0}):Play()

            n:GetPropertyChangedSignal("Value"):Connect(function() circle.Radius = n.Value end)
            trans:GetPropertyChangedSignal("Value"):Connect(function() circle.Transparency = trans.Value end)

            task.delay(0.3, function()
                pcall(function()
                    circle:Remove()
                    n:Destroy()
                    trans:Destroy()
                end)
            end)
        end)
    end

    u.GetIMG = function(img)
        return img or ""
    end

    local function ProtectParent(gui)
        if gethui then
            gui.Parent = gethui()
        elseif syn and syn.protect_gui then
            syn.protect_gui(gui)
            gui.Parent = game:GetService("CoreGui")
        else
            pcall(function() gui.Parent = game:GetService("CoreGui") end)
            if not gui.Parent then
                gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            end
        end
    end

    u.Gui = Instance.new("ScreenGui")
    u.Gui.Name = "Sea Hub GUI"
    u.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    u.NotiGui = Instance.new("ScreenGui")
    u.NotiGui.Name = "Sea Hub Notification"
    u.NotiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    ProtectParent(u.Gui)
    ProtectParent(u.NotiGui)
    getgenv().GUI = u.Gui

    local NotiContainer = Instance.new("Frame", u.NotiGui)
    NotiContainer.AnchorPoint = Vector2.new(1, 1)
    NotiContainer.BackgroundTransparency = 1
    NotiContainer.Position = UDim2.new(1, -10, 1, -10)
    NotiContainer.Size = UDim2.new(0, 320, 1, -20)

    local NotiList = Instance.new("UIListLayout", NotiContainer)
    NotiList.SortOrder = Enum.SortOrder.LayoutOrder
    NotiList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotiList.Padding = UDim.new(0, 6)

    function t.CreateNoti(H)
        local TitleText = H.Title or "Thông báo"
        local DescText = H.Desc or ""
        local ShowTime = H.ShowTime or 5

        local NotiFrame = Instance.new("Frame", NotiContainer)
        NotiFrame.BackgroundTransparency = 1
        NotiFrame.Size = UDim2.new(1, 0, 0, 0)
        NotiFrame.AutomaticSize = Enum.AutomaticSize.Y

        local Container = Instance.new("Frame", NotiFrame)
        Container.Position = UDim2.new(1, 20, 0, 0)
        Container.Size = UDim2.new(1, 0, 0, 0)
        Container.AutomaticSize = Enum.AutomaticSize.Y
        BindColor("Background 3 Color", function(col) Container.BackgroundColor3 = col end)
        Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

        local Top = Instance.new("Frame", Container)
        Top.BackgroundTransparency = 1
        Top.Size = UDim2.new(1, 0, 0, 24)

        local Title = Instance.new("TextLabel", Top)
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 2)
        Title.Size = UDim2.new(1, -40, 1, 0)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 13
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.RichText = true
        Title.Text = TitleText
        BindColor("GUI Text Color", function(col) Title.TextColor3 = col end)

        local CloseBtn = Instance.new("TextButton", Top)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Position = UDim2.new(1, -22, 0, 2)
        CloseBtn.Size = UDim2.new(0, 20, 0, 20)
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = 12

        local Desc = Instance.new("TextLabel", Container)
        Desc.BackgroundTransparency = 1
        Desc.Position = UDim2.new(0, 10, 0, 26)
        Desc.Size = UDim2.new(1, -20, 0, 0)
        Desc.Font = Enum.Font.Gotham
        Desc.Text = DescText
        Desc.TextSize = 12
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        Desc.TextWrapped = true
        Desc.AutomaticSize = Enum.AutomaticSize.Y
        BindColor("Text Color", function(col) Desc.TextColor3 = col end)

        local pad = Instance.new("UIPadding", Container)
        pad.PaddingBottom = UDim.new(0, 8)

        local function Close()
            w:Create(Container, TweenInfo.new(0.25), {Position = UDim2.new(1, 30, 0, 0)}):Play()
            task.wait(0.25)
            NotiFrame:Destroy()
        end

        CloseBtn.MouseButton1Click:Connect(Close)
        w:Create(Container, TweenInfo.new(0.25), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(ShowTime, Close)
    end

    -- // CREATE MAIN WINDOW // --
    function t.CreateMain(H)
        local TitleName = tostring(H.Title or "Sea Hub")
        local SubDesc = H.Desc or ""

        local Main = Instance.new("Frame", u.Gui)
        Main.Name = "Main"
        Main.BackgroundTransparency = 1
        Main.Position = UDim2.new(0.5, -315, 0.5, -180)
        Main.Size = UDim2.new(0, 630, 0, 360)

        -- Kéo thả cửa sổ (Drag Window)
        local isDragging, dragStart, startPos = false, nil, nil
        Main.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isDraggingElement then
                isDragging = true
                dragStart = input.Position
                startPos = Main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isDragging = false
                    end
                end)
            end
        end)
        x.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        local MainContainer = Instance.new("Frame", Main)
        MainContainer.Name = "MainContainer"
        MainContainer.Size = UDim2.new(1, 0, 1, 0)
        BindColor("Background 3 Color", function(col) MainContainer.BackgroundColor3 = col end)
        Instance.new("UICorner", MainContainer).CornerRadius = UDim.new(0, 6)

        local Border = Instance.new("UIStroke", MainContainer)
        Border.Thickness = 1.2
        BindColor("Border Color", function(col) Border.Color = col end)

        -- Top Bar
        local TopBar = Instance.new("Frame", MainContainer)
        TopBar.BackgroundTransparency = 1
        TopBar.Size = UDim2.new(1, 0, 0, 34)

        local Logo = Instance.new("ImageLabel", TopBar)
        Logo.BackgroundTransparency = 1
        Logo.Position = UDim2.new(0, 10, 0, 5)
        Logo.Size = UDim2.new(0, 24, 0, 24)
        Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
        BindColor("Logo Image", function(img) Logo.Image = u.GetIMG(img) end)

        local HeaderText = Instance.new("TextLabel", TopBar)
        HeaderText.BackgroundTransparency = 1
        HeaderText.Position = UDim2.new(0, 42, 0, 0)
        HeaderText.Size = UDim2.new(1, -90, 1, 0)
        HeaderText.Font = Enum.Font.GothamBold
        HeaderText.RichText = true
        HeaderText.TextSize = 14
        HeaderText.TextXAlignment = Enum.TextXAlignment.Left
        local function UpdateHeaderText()
            local col = getgenv().UIColor["Title Text Color"]
            local r, g, b_val = math.floor(col.R * 255), math.floor(col.G * 255), math.floor(col.B * 255)
            HeaderText.Text = string.format('<font color="rgb(%d,%d,%d)">%s</font> %s', r, g, b_val, TitleName, SubDesc)
        end
        BindColor("Title Text Color", UpdateHeaderText)
        BindColor("GUI Text Color", function(col) HeaderText.TextColor3 = col end)

        -- Nút Cài đặt (Bánh Răng)
        local SettingBtn = Instance.new("TextButton", TopBar)
        SettingBtn.AnchorPoint = Vector2.new(1, 0.5)
        SettingBtn.Position = UDim2.new(1, -8, 0.5, 0)
        SettingBtn.Size = UDim2.new(0, 26, 0, 26)
        SettingBtn.BackgroundTransparency = 1
        SettingBtn.Text = ""

        local SettingIcon = Instance.new("ImageLabel", SettingBtn)
        SettingIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        SettingIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        SettingIcon.Size = UDim2.new(0, 18, 0, 18)
        SettingIcon.BackgroundTransparency = 1
        SettingIcon.Image = "rbxassetid://7397332215"
        BindColor("Setting Icon Color", function(col) SettingIcon.ImageColor3 = col end)

        -- Khu vực chuyển đổi giữa Main Tabs & Custom Settings
        local SwitchContainer = Instance.new("Frame", MainContainer)
        SwitchContainer.Position = UDim2.new(0, 0, 0, 36)
        SwitchContainer.Size = UDim2.new(1, 0, 1, -36)
        SwitchContainer.BackgroundTransparency = 1
        SwitchContainer.ClipsDescendants = true

        local SwitchLayout = Instance.new("UIPageLayout", SwitchContainer)
        SwitchLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SwitchLayout.EasingDirection = Enum.EasingDirection.InOut
        SwitchLayout.EasingStyle = Enum.EasingStyle.Quad
        SwitchLayout.TweenTime = 0.3
        SwitchLayout.ScrollWheelInputEnabled = false

        -- [PAGE 0: NỘI DUNG CHÍNH (MAIN TABS)]
        local MainTabWrapper = Instance.new("Frame", SwitchContainer)
        MainTabWrapper.LayoutOrder = 0
        MainTabWrapper.Size = UDim2.new(1, 0, 1, 0)
        MainTabWrapper.BackgroundTransparency = 1

        local Sidebar = Instance.new("Frame", MainTabWrapper)
        Sidebar.Position = UDim2.new(0, 8, 0, 2)
        Sidebar.Size = UDim2.new(0, 160, 1, -10)
        BindColor("Background 1 Color", function(col) Sidebar.BackgroundColor3 = col end)
        BindColor("Background 1 Transparency", function(trans) Sidebar.BackgroundTransparency = trans end)
        Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)

        local ControlList = Instance.new("ScrollingFrame", Sidebar)
        ControlList.BackgroundTransparency = 1
        ControlList.BorderSizePixel = 0
        ControlList.Position = UDim2.new(0, 4, 0, 6)
        ControlList.Size = UDim2.new(1, -8, 1, -12)
        ControlList.ScrollBarThickness = 3
        ControlList.CanvasSize = UDim2.new(0, 0, 0, 0)

        local ControlLayout = Instance.new("UIListLayout", ControlList)
        ControlLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ControlLayout.Padding = UDim.new(0, 4)
        ControlLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ControlList.CanvasSize = UDim2.new(0, 0, 0, ControlLayout.AbsoluteContentSize.Y + 10)
        end)

        local PageHolder = Instance.new("Frame", MainTabWrapper)
        PageHolder.Position = UDim2.new(0, 175, 0, 2)
        PageHolder.Size = UDim2.new(1, -183, 1, -10)
        PageHolder.ClipsDescendants = true
        BindColor("Background 1 Color", function(col) PageHolder.BackgroundColor3 = col end)
        BindColor("Background 1 Transparency", function(trans) PageHolder.BackgroundTransparency = trans end)
        Instance.new("UICorner", PageHolder).CornerRadius = UDim.new(0, 4)

        local PageLayout = Instance.new("UIPageLayout", PageHolder)
        PageLayout.FillDirection = Enum.FillDirection.Vertical
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.EasingStyle = Enum.EasingStyle.Quart
        PageLayout.TweenTime = 0.25
        PageLayout.ScrollWheelInputEnabled = false

        -- [PAGE 1: TRANG CÀI ĐẶT CUSTOM UI]
        local SettingsWrapper = Instance.new("Frame", SwitchContainer)
        SettingsWrapper.LayoutOrder = 1
        SettingsWrapper.Size = UDim2.new(1, 0, 1, 0)
        SettingsWrapper.BackgroundTransparency = 1

        local SettingsHeader = Instance.new("Frame", SettingsWrapper)
        SettingsHeader.Position = UDim2.new(0, 10, 0, 0)
        SettingsHeader.Size = UDim2.new(1, -20, 0, 30)
        SettingsHeader.BackgroundTransparency = 1

        local SettingsTitle = Instance.new("TextLabel", SettingsHeader)
        SettingsTitle.Size = UDim2.new(0.5, 0, 1, 0)
        SettingsTitle.BackgroundTransparency = 1
        SettingsTitle.Font = Enum.Font.GothamBold
        SettingsTitle.Text = "Custom GUI Settings"
        SettingsTitle.TextSize = 14
        SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
        BindColor("GUI Text Color", function(col) SettingsTitle.TextColor3 = col end)

        local SearchFrame = Instance.new("Frame", SettingsHeader)
        SearchFrame.AnchorPoint = Vector2.new(1, 0.5)
        SearchFrame.Position = UDim2.new(1, 0, 0.5, 0)
        SearchFrame.Size = UDim2.new(0, 160, 0, 22)
        BindColor("Background 2 Color", function(col) SearchFrame.BackgroundColor3 = col end)
        Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 4)

        local SearchInput = Instance.new("TextBox", SearchFrame)
        SearchInput.Position = UDim2.new(0, 6, 0, 0)
        SearchInput.Size = UDim2.new(1, -12, 1, 0)
        SearchInput.BackgroundTransparency = 1
        SearchInput.Font = Enum.Font.Gotham
        SearchInput.PlaceholderText = "Tìm mục cài đặt..."
        SearchInput.Text = ""
        SearchInput.TextSize = 11
        SearchInput.TextXAlignment = Enum.TextXAlignment.Left
        BindColor("Text Color", function(col) SearchInput.TextColor3 = col end)
        BindColor("Placeholder Text Color", function(col) SearchInput.PlaceholderColor3 = col end)

        local SettingsScroll = Instance.new("ScrollingFrame", SettingsWrapper)
        SettingsScroll.Position = UDim2.new(0, 10, 0, 34)
        SettingsScroll.Size = UDim2.new(1, -20, 1, -40)
        SettingsScroll.BackgroundTransparency = 1
        SettingsScroll.ScrollBarThickness = 4
        SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

        local SettingsList = Instance.new("UIListLayout", SettingsScroll)
        SettingsList.SortOrder = Enum.SortOrder.LayoutOrder
        SettingsList.Padding = UDim.new(0, 8)
        SettingsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, SettingsList.AbsoluteContentSize.Y + 15)
        end)

        -- Logic chuyển tab Settings
        local isSettingsOpen = false
        SettingBtn.MouseButton1Click:Connect(function()
            u.ButtonEffect()
            isSettingsOpen = not isSettingsOpen
            w:Create(SettingIcon, TweenInfo.new(0.3), {Rotation = isSettingsOpen and 180 or 0}):Play()
            SwitchLayout:JumpToIndex(isSettingsOpen and 1 or 0)
        end)

        -- Hàm tạo Section bên Custom Settings
        local function CreateSettingSection(title)
            local Sec = Instance.new("Frame", SettingsScroll)
            Sec.Name = title
            Sec.Size = UDim2.new(1, 0, 0, 30)
            Sec.AutomaticSize = Enum.AutomaticSize.Y
            BindColor("Background 3 Color", function(col) Sec.BackgroundColor3 = col end)
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 4)

            local Head = Instance.new("TextLabel", Sec)
            Head.Name = "SecTitle"
            Head.BackgroundTransparency = 1
            Head.Position = UDim2.new(0, 10, 0, 4)
            Head.Size = UDim2.new(1, -20, 0, 20)
            Head.Font = Enum.Font.GothamBold
            Head.Text = title
            Head.TextSize = 13
            Head.TextXAlignment = Enum.TextXAlignment.Left
            BindColor("Section Text Color", function(col) Head.TextColor3 = col end)

            local Line = Instance.new("Frame", Sec)
            Line.Position = UDim2.new(0, 10, 0, 26)
            Line.Size = UDim2.new(1, -20, 0, 1)
            Line.BorderSizePixel = 0
            BindColor("Section Underline Color", function(col) Line.BackgroundColor3 = col end)

            local Content = Instance.new("Frame", Sec)
            Content.BackgroundTransparency = 1
            Content.Position = UDim2.new(0, 8, 0, 32)
            Content.Size = UDim2.new(1, -16, 0, 0)
            Content.AutomaticSize = Enum.AutomaticSize.Y

            local CLayout = Instance.new("UIListLayout", Content)
            CLayout.SortOrder = Enum.SortOrder.LayoutOrder
            CLayout.Padding = UDim.new(0, 6)

            local pad = Instance.new("UIPadding", Sec)
            pad.PaddingBottom = UDim.new(0, 8)

            local Tools = {}

            -- Tạo Color Picker
            function Tools.CreateColorPicker(colorTitle, colorKey)
                local curCol = getgenv().UIColor[colorKey] or Color3.fromRGB(255, 255, 255)
                local h, s, v = Color3.toHSV(curCol)
                local isOpen = false
                local isRainbow = false

                local Frame = Instance.new("Frame", Content)
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.ClipsDescendants = true
                BindColor("Background 1 Color", function(col) Frame.BackgroundColor3 = col end)
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

                local Title = Instance.new("TextLabel", Frame)
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.Size = UDim2.new(1, -90, 0, 32)
                Title.Font = Enum.Font.GothamBold
                Title.Text = colorTitle
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left
                BindColor("Text Color", function(col) Title.TextColor3 = col end)

                local PreviewBtn = Instance.new("TextButton", Frame)
                PreviewBtn.Position = UDim2.new(1, -75, 0, 6)
                PreviewBtn.Size = UDim2.new(0, 65, 0, 20)
                PreviewBtn.BackgroundColor3 = curCol
                PreviewBtn.Text = ""
                Instance.new("UICorner", PreviewBtn).CornerRadius = UDim.new(0, 4)

                -- Khung chỉnh màu mở rộng
                local Drop = Instance.new("Frame", Frame)
                Drop.Position = UDim2.new(0, 10, 0, 36)
                Drop.Size = UDim2.new(1, -20, 0, 170)
                Drop.BackgroundTransparency = 1

                -- Bảng Saturation & Value
                local SVBox = Instance.new("ImageLabel", Drop)
                SVBox.Size = UDim2.new(0, 260, 0, 130)
                SVBox.Image = "rbxassetid://4155801252"
                SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                Instance.new("UICorner", SVBox).CornerRadius = UDim.new(0, 4)

                local SVCursor = Instance.new("Frame", SVBox)
                SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                SVCursor.Size = UDim2.new(0, 6, 0, 6)
                SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", SVCursor).CornerRadius = UDim.new(1, 0)

                -- Thanh Hue Bar
                local HueBar = Instance.new("Frame", Drop)
                HueBar.Position = UDim2.new(0, 270, 0, 0)
                HueBar.Size = UDim2.new(0, 20, 0, 130)
                HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", HueBar).CornerRadius = UDim.new(0, 4)

                local HueGrad = Instance.new("UIGradient", HueBar)
                HueGrad.Rotation = 90
                HueGrad.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
                }

                local HueCursor = Instance.new("Frame", HueBar)
                HueCursor.AnchorPoint = Vector2.new(0, 0.5)
                HueCursor.Position = UDim2.new(0, 0, 1 - h, 0)
                HueCursor.Size = UDim2.new(1, 0, 0, 3)
                HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                -- Thông số RGB & Hex
                local Inputs = Instance.new("Frame", Drop)
                Inputs.Position = UDim2.new(0, 300, 0, 0)
                Inputs.Size = UDim2.new(1, -300, 0, 130)
                Inputs.BackgroundTransparency = 1

                local HexBox = Instance.new("TextBox", Inputs)
                HexBox.Position = UDim2.new(0, 0, 0, 5)
                HexBox.Size = UDim2.new(1, 0, 0, 24)
                BindColor("Background 2 Color", function(col) HexBox.BackgroundColor3 = col end)
                BindColor("Text Color", function(col) HexBox.TextColor3 = col end)
                HexBox.Font = Enum.Font.GothamBold
                HexBox.TextSize = 11
                HexBox.Text = string.format("#%02X%02X%02X", math.floor(curCol.R * 255), math.floor(curCol.G * 255), math.floor(curCol.B * 255))
                Instance.new("UICorner", HexBox).CornerRadius = UDim.new(0, 3)

                local RainbowBtn = Instance.new("TextButton", Inputs)
                RainbowBtn.Position = UDim2.new(0, 0, 0, 36)
                RainbowBtn.Size = UDim2.new(1, 0, 0, 24)
                BindColor("Background 2 Color", function(col) RainbowBtn.BackgroundColor3 = col end)
                RainbowBtn.Font = Enum.Font.GothamBold
                RainbowBtn.Text = "Rainbow: Tắt"
                RainbowBtn.TextSize = 11
                RainbowBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                Instance.new("UICorner", RainbowBtn).CornerRadius = UDim.new(0, 3)

                local function UpdateColor(newColor, skipHex)
                    curCol = newColor
                    PreviewBtn.BackgroundColor3 = curCol
                    SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    if not skipHex then
                        HexBox.Text = string.format("#%02X%02X%02X", math.floor(curCol.R * 255), math.floor(curCol.G * 255), math.floor(curCol.B * 255))
                    end
                    getgenv().UIColor[colorKey] = curCol
                end

                PreviewBtn.MouseButton1Click:Connect(function()
                    u.ButtonEffect()
                    isOpen = not isOpen
                    w:Create(Frame, TweenInfo.new(0.2), {Size = isOpen and UDim2.new(1, 0, 0, 215) or UDim2.new(1, 0, 0, 32)}):Play()
                end)

                -- Kéo Saturation & Value
                local isDraggingSV = false
                SVBox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDraggingSV = true
                        isDraggingElement = true
                    end
                end)

                -- Kéo Hue
                local isDraggingHue = false
                HueBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDraggingHue = true
                        isDraggingElement = true
                    end
                end)

                x.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if isDraggingSV then
                            local px = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                            local py = math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                            s = px
                            v = 1 - py
                            SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                            UpdateColor(Color3.fromHSV(h, s, v))
                        elseif isDraggingHue then
                            local py = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                            h = 1 - py
                            HueCursor.Position = UDim2.new(0, 0, py, 0)
                            SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                            UpdateColor(Color3.fromHSV(h, s, v))
                        end
                    end
                end)

                x.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDraggingSV = false
                        isDraggingHue = false
                        isDraggingElement = false
                    end
                end)

                -- Nhập mã Hex
                HexBox.FocusLost:Connect(function()
                    local cleanHex = HexBox.Text:gsub("#", "")
                    if #cleanHex == 6 then
                        local r_val = tonumber(cleanHex:sub(1, 2), 16)
                        local g_val = tonumber(cleanHex:sub(3, 4), 16)
                        local b_c = tonumber(cleanHex:sub(5, 6), 16)
                        if r_val and g_val and b_c then
                            local col = Color3.fromRGB(r_val, g_val, b_c)
                            h, s, v = Color3.toHSV(col)
                            SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                            HueCursor.Position = UDim2.new(0, 0, 1 - h, 0)
                            UpdateColor(col, true)
                        end
                    end
                end)

                -- Toggle Rainbow
                RainbowBtn.MouseButton1Click:Connect(function()
                    isRainbow = not isRainbow
                    RainbowBtn.Text = isRainbow and "Rainbow: Bật" or "Rainbow: Tắt"
                    RainbowBtn.TextColor3 = isRainbow and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 200, 200)
                    if isRainbow then
                        task.spawn(function()
                            while isRainbow do
                                h = (h + 0.01) % 1
                                HueCursor.Position = UDim2.new(0, 0, 1 - h, 0)
                                UpdateColor(Color3.fromHSV(h, s, v))
                                task.wait(0.04)
                            end
                        end)
                    end
                end)
            end

            -- Tạo Slider trong Settings
            function Tools.CreateSettingSlider(sTitle, sKey, min, max, precise)
                local val = getgenv().UIColor[sKey] or min

                local Frame = Instance.new("Frame", Content)
                Frame.Size = UDim2.new(1, 0, 0, 42)
                BindColor("Background 1 Color", function(col) Frame.BackgroundColor3 = col end)
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

                local Label = Instance.new("TextLabel", Frame)
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0, 10, 0, 2)
                Label.Size = UDim2.new(0.6, 0, 0, 20)
                Label.Font = Enum.Font.GothamBold
                Label.Text = sTitle
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                BindColor("Text Color", function(col) Label.TextColor3 = col end)

                local ValLabel = Instance.new("TextLabel", Frame)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Position = UDim2.new(0.6, 0, 0, 2)
                ValLabel.Size = UDim2.new(0.4, -10, 0, 20)
                ValLabel.Font = Enum.Font.GothamBold
                ValLabel.Text = tostring(val)
                ValLabel.TextSize = 12
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                BindColor("Text Color", function(col) ValLabel.TextColor3 = col end)

                local Bar = Instance.new("TextButton", Frame)
                Bar.Position = UDim2.new(0, 10, 0, 26)
                Bar.Size = UDim2.new(1, -20, 0, 6)
                Bar.Text = ""
                Bar.AutoButtonColor = false
                BindColor("Background 2 Color", function(col) Bar.BackgroundColor3 = col end)
                Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

                local Fill = Instance.new("Frame", Bar)
                Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                BindColor("Slider Highlight Color", function(col) Fill.BackgroundColor3 = col end)
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                local function Update(nv)
                    nv = math.clamp(nv, min, max)
                    nv = precise and tonumber(string.format("%.2f", nv)) or math.floor(nv)
                    val = nv
                    ValLabel.Text = tostring(val)
                    Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                    getgenv().UIColor[sKey] = val
                end

                local isDragging = false
                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                        isDraggingElement = true
                        local pct = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        Update(min + (max - min) * pct)
                    end
                end)
                x.InputChanged:Connect(function(input)
                    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local pct = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        Update(min + (max - min) * pct)
                    end
                end)
                x.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = false
                        isDraggingElement = false
                    end
                end)
            end

            return Tools
        end

        -- KHỞI TẠO CÁC MỤC CUSTOM GUI TRONG SETTINGS
        local SecMain = CreateSettingSection("Giao diện chính (Main)")
        SecMain.CreateColorPicker("Màu viền (Border Color)", "Border Color")
        SecMain.CreateColorPicker("Màu hiệu ứng Click", "Click Effect Color")
        SecMain.CreateColorPicker("Màu icon Cài đặt", "Setting Icon Color")

        local SecText = CreateSettingSection("Màu chữ (Text)")
        SecText.CreateColorPicker("Màu chữ tiêu đề (Title)", "Title Text Color")
        SecText.CreateColorPicker("Màu chữ GUI Header", "GUI Text Color")
        SecText.CreateColorPicker("Màu văn bản chung (Text)", "Text Color")

        local SecBg = CreateSettingSection("Hình nền & Độ trong suốt")
        SecBg.CreateColorPicker("Màu nền 1 (Background 1)", "Background 1 Color")
        SecBg.CreateSettingSlider("Độ trong suốt nền 1", "Background 1 Transparency", 0, 1, true)
        SecBg.CreateColorPicker("Màu nền 2 (Background 2)", "Background 2 Color")
        SecBg.CreateColorPicker("Màu nền 3 (Background 3)", "Background 3 Color")

        local SecTab = CreateSettingSection("Phân vùng & Tab")
        SecTab.CreateColorPicker("Màu Tab đang chọn", "Page Selected Color")
        SecTab.CreateColorPicker("Màu chữ Section", "Section Text Color")
        SecTab.CreateColorPicker("Màu đường kẻ Section", "Section Underline Color")

        local SecControls = CreateSettingSection("Nút bấm & Toggle")
        SecControls.CreateColorPicker("Màu nút bấm (Button)", "Button Color")
        SecControls.CreateColorPicker("Màu viền Toggle", "Toggle Border Color")
        SecControls.CreateColorPicker("Màu dấu tích Toggle", "Toggle Checked Color")
        SecControls.CreateColorPicker("Màu mô tả Toggle", "Toggle Desc Color")

        local SecSliders = CreateSettingSection("Thanh trượt & Dropdown")
        SecSliders.CreateColorPicker("Màu thanh trượt (Line)", "Slider Line Color")
        SecSliders.CreateColorPicker("Màu thanh trượt (Highlight)", "Slider Highlight Color")
        SecSliders.CreateColorPicker("Màu icon Dropdown", "Dropdown Icon Color")

        -- Lọc tìm kiếm mục Settings
        SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
            local query = string.lower(SearchInput.Text)
            for _, item in ipairs(SettingsScroll:GetChildren()) do
                if item:IsA("Frame") and item:FindFirstChild("SecTitle") then
                    item.Visible = (query == "" or string.find(string.lower(item.SecTitle.Text), query) ~= nil)
                end
            end
        end)

        -- Quản lý các Pages chính
        local Pages = {}
        local orderIndex = 0
        local activeTabBtn = nil

        function Pages.CreatePage(pageCfg)
            local pName = tostring(pageCfg.Page_Name or "Tab")
            orderIndex = orderIndex + 1

            local TabBtn = Instance.new("TextButton", ControlList)
            TabBtn.Size = UDim2.new(1, 0, 0, 30)
            TabBtn.BackgroundTransparency = 1
            TabBtn.Text = "  " .. pName
            TabBtn.Font = Enum.Font.GothamBold
            TabBtn.TextSize = 13
            TabBtn.TextXAlignment = Enum.TextXAlignment.Left
            BindColor("GUI Text Color", function(col) TabBtn.TextColor3 = col end)
            BindColor("Background 2 Color", function(col) TabBtn.BackgroundColor3 = col end)
            Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

            local Indicator = Instance.new("Frame", TabBtn)
            Indicator.Position = UDim2.new(0, 0, 0.2, 0)
            Indicator.Size = UDim2.new(0, 3, 0.6, 0)
            Indicator.Visible = false
            BindColor("Page Selected Color", function(col) Indicator.BackgroundColor3 = col end)
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

            local PageFrame = Instance.new("Frame", PageHolder)
            PageFrame.Name = pName
            PageFrame.Size = UDim2.new(1, 0, 1, 0)
            PageFrame.BackgroundTransparency = 1

            local PageScroll = Instance.new("ScrollingFrame", PageFrame)
            PageScroll.BackgroundTransparency = 1
            PageScroll.BorderSizePixel = 0
            PageScroll.Position = UDim2.new(0, 6, 0, 6)
            PageScroll.Size = UDim2.new(1, -12, 1, -12)
            PageScroll.ScrollBarThickness = 4
            PageScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

            local PageList = Instance.new("UIListLayout", PageScroll)
            PageList.SortOrder = Enum.SortOrder.LayoutOrder
            PageList.Padding = UDim.new(0, 8)
            PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                PageScroll.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
            end)

            local function SelectThisTab()
                u.ButtonEffect()
                if activeTabBtn then
                    activeTabBtn.Indicator.Visible = false
                    w:Create(activeTabBtn.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                end
                Indicator.Visible = true
                w:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
                activeTabBtn = {Btn = TabBtn, Indicator = Indicator}
                PageLayout:JumpTo(PageFrame)
            end

            TabBtn.MouseButton1Click:Connect(SelectThisTab)
            if orderIndex == 1 then SelectThisTab() end

            -- Section trong trang chính
            local SectionHandler = {}
            function SectionHandler.CreateSection(secTitle)
                local SecFrame = Instance.new("Frame", PageScroll)
                SecFrame.Size = UDim2.new(1, 0, 0, 30)
                SecFrame.AutomaticSize = Enum.AutomaticSize.Y
                BindColor("Background 3 Color", function(col) SecFrame.BackgroundColor3 = col end)
                Instance.new("UICorner", SecFrame).CornerRadius = UDim.new(0, 4)

                local SecHeader = Instance.new("TextLabel", SecFrame)
                SecHeader.BackgroundTransparency = 1
                SecHeader.Position = UDim2.new(0, 10, 0, 4)
                SecHeader.Size = UDim2.new(1, -20, 0, 22)
                SecHeader.Font = Enum.Font.GothamBold
                SecHeader.Text = secTitle
                SecHeader.TextSize = 13
                SecHeader.TextXAlignment = Enum.TextXAlignment.Left
                BindColor("Section Text Color", function(col) SecHeader.TextColor3 = col end)

                local SecUnderline = Instance.new("Frame", SecFrame)
                SecUnderline.Position = UDim2.new(0, 10, 0, 28)
                SecUnderline.Size = UDim2.new(1, -20, 0, 1)
                SecUnderline.BorderSizePixel = 0
                BindColor("Section Underline Color", function(col) SecUnderline.BackgroundColor3 = col end)

                local ItemContainer = Instance.new("Frame", SecFrame)
                ItemContainer.BackgroundTransparency = 1
                ItemContainer.Position = UDim2.new(0, 8, 0, 34)
                ItemContainer.Size = UDim2.new(1, -16, 0, 0)
                ItemContainer.AutomaticSize = Enum.AutomaticSize.Y

                local ItemLayout = Instance.new("UIListLayout", ItemContainer)
                ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ItemLayout.Padding = UDim.new(0, 6)

                local padSec = Instance.new("UIPadding", SecFrame)
                padSec.PaddingBottom = UDim.new(0, 8)

                local Elements = {}

                -- Button
                function Elements.CreateButton(cfg, callback)
                    local btnTitle = cfg.Title or "Button"
                    local cb = callback or function() end

                    local Btn = Instance.new("TextButton", ItemContainer)
                    Btn.Size = UDim2.new(1, 0, 0, 30)
                    Btn.Font = Enum.Font.GothamBold
                    Btn.Text = btnTitle
                    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Btn.TextSize = 13
                    BindColor("Button Color", function(col) Btn.BackgroundColor3 = col end)
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

                    Btn.MouseButton1Click:Connect(function()
                        u.ButtonEffect()
                        pcall(cb)
                    end)
                end

                -- Toggle
                function Elements.CreateToggle(cfg, callback)
                    local togTitle = cfg.Title or "Toggle"
                    local togDesc = cfg.Desc or ""
                    local state = cfg.Default or false
                    local cb = callback or function() end

                    local TogFrame = Instance.new("TextButton", ItemContainer)
                    TogFrame.Size = UDim2.new(1, 0, 0, 32)
                    TogFrame.Text = ""
                    TogFrame.AutomaticSize = Enum.AutomaticSize.Y
                    BindColor("Background 1 Color", function(col) TogFrame.BackgroundColor3 = col end)
                    Instance.new("UICorner", TogFrame).CornerRadius = UDim.new(0, 4)

                    local Label = Instance.new("TextLabel", TogFrame)
                    Label.BackgroundTransparency = 1
                    Label.Position = UDim2.new(0, 10, 0, 4)
                    Label.Size = UDim2.new(1, -60, 0, 22)
                    Label.Font = Enum.Font.GothamBold
                    Label.Text = togTitle
                    Label.TextSize = 13
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    BindColor("Text Color", function(col) Label.TextColor3 = col end)

                    if togDesc ~= "" then
                        local Desc = Instance.new("TextLabel", TogFrame)
                        Desc.BackgroundTransparency = 1
                        Desc.Position = UDim2.new(0, 10, 0, 24)
                        Desc.Size = UDim2.new(1, -60, 0, 0)
                        Desc.Font = Enum.Font.Gotham
                        Desc.Text = togDesc
                        Desc.TextSize = 11
                        Desc.TextXAlignment = Enum.TextXAlignment.Left
                        Desc.TextWrapped = true
                        Desc.AutomaticSize = Enum.AutomaticSize.Y
                        BindColor("Toggle Desc Color", function(col) Desc.TextColor3 = col end)
                        local p = Instance.new("UIPadding", TogFrame)
                        p.PaddingBottom = UDim.new(0, 6)
                    end

                    local Box = Instance.new("Frame", TogFrame)
                    Box.AnchorPoint = Vector2.new(1, 0.5)
                    Box.Position = UDim2.new(1, -10, 0.5, 0)
                    Box.Size = UDim2.new(0, 20, 0, 20)
                    BindColor("Background 2 Color", function(col) Box.BackgroundColor3 = col end)
                    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

                    local Check = Instance.new("Frame", Box)
                    Check.AnchorPoint = Vector2.new(0.5, 0.5)
                    Check.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Check.Size = state and UDim2.new(1, -4, 1, -4) or UDim2.new(0, 0, 0, 0)
                    BindColor("Toggle Checked Color", function(col) Check.BackgroundColor3 = col end)
                    Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 2)

                    local function SetState(s)
                        state = s
                        w:Create(Check, TweenInfo.new(0.15), {
                            Size = state and UDim2.new(1, -4, 1, -4) or UDim2.new(0, 0, 0, 0)
                        }):Play()
                        pcall(cb, state)
                    end

                    TogFrame.MouseButton1Click:Connect(function()
                        u.ButtonEffect()
                        SetState(not state)
                    end)

                    pcall(cb, state)
                    return {SetStage = SetState}
                end

                -- Slider
                function Elements.CreateSlider(cfg, callback)
                    local sTitle = cfg.Title or "Slider"
                    local min = tonumber(cfg.Min) or 0
                    local max = tonumber(cfg.Max) or 100
                    local val = tonumber(cfg.Default) or min
                    local precise = cfg.Precise or false
                    local cb = callback or function() end

                    local SliderFrame = Instance.new("Frame", ItemContainer)
                    SliderFrame.Size = UDim2.new(1, 0, 0, 46)
                    BindColor("Background 1 Color", function(col) SliderFrame.BackgroundColor3 = col end)
                    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)

                    local Label = Instance.new("TextLabel", SliderFrame)
                    Label.BackgroundTransparency = 1
                    Label.Position = UDim2.new(0, 10, 0, 4)
                    Label.Size = UDim2.new(1, -70, 0, 20)
                    Label.Font = Enum.Font.GothamBold
                    Label.Text = sTitle
                    Label.TextSize = 13
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    BindColor("Text Color", function(col) Label.TextColor3 = col end)

                    local ValBox = Instance.new("TextBox", SliderFrame)
                    ValBox.BackgroundTransparency = 1
                    ValBox.Position = UDim2.new(1, -65, 0, 4)
                    ValBox.Size = UDim2.new(0, 55, 0, 20)
                    ValBox.Font = Enum.Font.GothamBold
                    ValBox.Text = tostring(val)
                    ValBox.TextSize = 13
                    BindColor("Text Color", function(col) ValBox.TextColor3 = col end)

                    local BarBG = Instance.new("TextButton", SliderFrame)
                    BarBG.Position = UDim2.new(0, 10, 0, 28)
                    BarBG.Size = UDim2.new(1, -20, 0, 8)
                    BarBG.Text = ""
                    BarBG.AutoButtonColor = false
                    BindColor("Slider Line Color", function(col) BarBG.BackgroundColor3 = col end)
                    Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

                    local Fill = Instance.new("Frame", BarBG)
                    Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                    BindColor("Slider Highlight Color", function(col) Fill.BackgroundColor3 = col end)
                    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                    local function UpdateVal(newVal)
                        newVal = math.clamp(newVal, min, max)
                        newVal = precise and tonumber(string.format("%.1f", newVal)) or math.floor(newVal)
                        val = newVal
                        ValBox.Text = tostring(val)
                        w:Create(Fill, TweenInfo.new(0.08), {Size = UDim2.new((val - min) / (max - min), 0, 1, 0)}):Play()
                        pcall(cb, val)
                    end

                    local isDraggingSlider = false
                    BarBG.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            isDraggingSlider = true
                            isDraggingElement = true
                            local pct = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                            UpdateVal(min + (max - min) * pct)
                        end
                    end)

                    x.InputChanged:Connect(function(input)
                        if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            local pct = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                            UpdateVal(min + (max - min) * pct)
                        end
                    end)

                    x.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            isDraggingSlider = false
                            isDraggingElement = false
                        end
                    end)

                    ValBox.FocusLost:Connect(function()
                        local n = tonumber(ValBox.Text)
                        if n then UpdateVal(n) else ValBox.Text = tostring(val) end
                    end)

                    pcall(cb, val)
                    return {SetValue = UpdateVal}
                end

                -- Dropdown
                function Elements.CreateDropdown(cfg, callback)
                    local dTitle = cfg.Title or "Dropdown"
                    local list = cfg.List or {}
                    local current = cfg.Default or (list[1] or "")
                    local cb = callback or function() end
                    local isOpen = false

                    local DropFrame = Instance.new("Frame", ItemContainer)
                    DropFrame.Size = UDim2.new(1, 0, 0, 32)
                    DropFrame.ClipsDescendants = true
                    BindColor("Background 1 Color", function(col) DropFrame.BackgroundColor3 = col end)
                    Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 4)

                    local HeaderBtn = Instance.new("TextButton", DropFrame)
                    HeaderBtn.Size = UDim2.new(1, 0, 0, 32)
                    HeaderBtn.BackgroundTransparency = 1
                    HeaderBtn.Text = ""

                    local Label = Instance.new("TextLabel", HeaderBtn)
                    Label.BackgroundTransparency = 1
                    Label.Position = UDim2.new(0, 10, 0, 0)
                    Label.Size = UDim2.new(1, -40, 1, 0)
                    Label.Font = Enum.Font.GothamBold
                    Label.Text = dTitle .. ": " .. tostring(current)
                    Label.TextSize = 13
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    BindColor("Text Color", function(col) Label.TextColor3 = col end)

                    local Arrow = Instance.new("TextLabel", HeaderBtn)
                    Arrow.BackgroundTransparency = 1
                    Arrow.Position = UDim2.new(1, -25, 0, 0)
                    Arrow.Size = UDim2.new(0, 20, 1, 0)
                    Arrow.Font = Enum.Font.GothamBold
                    Arrow.Text = "▼"
                    Arrow.TextSize = 11
                    BindColor("Dropdown Icon Color", function(col) Arrow.TextColor3 = col end)

                    local Scroll = Instance.new("ScrollingFrame", DropFrame)
                    Scroll.Position = UDim2.new(0, 5, 0, 34)
                    Scroll.Size = UDim2.new(1, -10, 0, 110)
                    Scroll.BackgroundTransparency = 1
                    Scroll.ScrollBarThickness = 3
                    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

                    local SList = Instance.new("UIListLayout", Scroll)
                    SList.SortOrder = Enum.SortOrder.LayoutOrder
                    SList.Padding = UDim.new(0, 3)
                    SList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        Scroll.CanvasSize = UDim2.new(0, 0, 0, SList.AbsoluteContentSize.Y + 5)
                    end)

                    local function RefreshItems()
                        for _, ch in pairs(Scroll:GetChildren()) do
                            if ch:IsA("TextButton") then ch:Destroy() end
                        end
                        for _, item in ipairs(list) do
                            local itemBtn = Instance.new("TextButton", Scroll)
                            itemBtn.Size = UDim2.new(1, 0, 0, 24)
                            itemBtn.Text = tostring(item)
                            itemBtn.Font = Enum.Font.Gotham
                            itemBtn.TextSize = 12
                            BindColor("Background 2 Color", function(col) itemBtn.BackgroundColor3 = col end)
                            BindColor("Text Color", function(col) itemBtn.TextColor3 = col end)
                            Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 3)

                            itemBtn.MouseButton1Click:Connect(function()
                                u.ButtonEffect()
                                current = item
                                Label.Text = dTitle .. ": " .. tostring(current)
                                isOpen = false
                                w:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play()
                                Arrow.Text = "▼"
                                pcall(cb, current)
                            end)
                        end
                    end

                    HeaderBtn.MouseButton1Click:Connect(function()
                        u.ButtonEffect()
                        isOpen = not isOpen
                        w:Create(DropFrame, TweenInfo.new(0.2), {
                            Size = isOpen and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 32)
                        }):Play()
                        Arrow.Text = isOpen and "▲" or "▼"
                    end)

                    RefreshItems()
                    pcall(cb, current)
                    return {
                        GetNewList = function(_, newList)
                            list = newList or {}
                            RefreshItems()
                        end
                    }
                end

                -- Input Box
                function Elements.CreateBox(cfg, callback)
                    local bTitle = cfg.Title or "Input"
                    local placeholder = cfg.Placeholder or "Nhập..."
                    local def = cfg.Default or ""
                    local cb = callback or function() end

                    local BoxFrame = Instance.new("Frame", ItemContainer)
                    BoxFrame.Size = UDim2.new(1, 0, 0, 36)
                    BindColor("Background 1 Color", function(col) BoxFrame.BackgroundColor3 = col end)
                    Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 4)

                    local Label = Instance.new("TextLabel", BoxFrame)
                    Label.BackgroundTransparency = 1
                    Label.Position = UDim2.new(0, 10, 0, 0)
                    Label.Size = UDim2.new(0.5, 0, 1, 0)
                    Label.Font = Enum.Font.GothamBold
                    Label.Text = bTitle
                    Label.TextSize = 13
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    BindColor("Text Color", function(col) Label.TextColor3 = col end)

                    local InBox = Instance.new("TextBox", BoxFrame)
                    InBox.Position = UDim2.new(0.5, 0, 0.15, 0)
                    InBox.Size = UDim2.new(0.5, -10, 0.7, 0)
                    InBox.Font = Enum.Font.Gotham
                    InBox.PlaceholderText = placeholder
                    InBox.Text = def
                    InBox.TextSize = 12
                    BindColor("Background 2 Color", function(col) InBox.BackgroundColor3 = col end)
                    BindColor("Text Color", function(col) InBox.TextColor3 = col end)
                    BindColor("Placeholder Text Color", function(col) InBox.PlaceholderColor3 = col end)
                    Instance.new("UICorner", InBox).CornerRadius = UDim.new(0, 4)

                    InBox.FocusLost:Connect(function()
                        pcall(cb, InBox.Text)
                    end)

                    return {SetValue = function(txt) InBox.Text = txt end}
                end

                return Elements
            end

            return SectionHandler
        end

        return Pages
    end

    return t
end


getgenv().GetUi = GetUi


local Library = GetUi()

Library.CreateNoti({
    Title = "Sea Hub",
    Desc = "Hãy bấm vào icon Bánh Răng ở góc trên phải để đổi màu GUI!",
    ShowTime = 6
})

local Window = Library.CreateMain({
    Title = "Sea Hub",
    Desc = "Custom Theme Edition"
})

local Tab = Window.CreatePage({
    Page_Name = "Main",
    Page_Title = "Cài đặt chính"
})

local Sec = Tab.CreateSection("Chức năng kiểm tra")

Sec.CreateToggle({
    Title = "Auto Farm",
    Desc = "Farm Mob",
    Default = true
}, function(s)
    print("Auto farm:", s)
end)

Sec.CreateSlider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 16
}, function(v)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)

Sec.CreateDropdown({
    Title = "Weapon",
    List = {"Melee", "Sword", "Fruit", "Gun"},
    Default = "Melee"
}, function(sel)
    print("Chọn:", sel)
end)

Sec.CreateButton({
    Title = "Announce",
}, function()
    Library.CreateNoti({
        Title = "Gay",
        Desc = "Sent Gay",
        ShowTime = 3
    })
end)
