-- Wooting BlockSpin Script v31 for Zeta --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Settings --
local Settings = {
    SILENT_AIM_ENABLED = false,
    SILENT_AIM_KEY = nil,
    SILENT_AIM_HOLD = false,
    AIM_FOV = 280,
    ESP_ENABLED = false,
    MOUSE_TELEPORT_ENABLED = false,
    MOUSE_TELEPORT_KEY = nil
}
local ESP_Boxes = {}
local ESP_HealthBars = {}

-- Wait for Game to Load --
repeat
    wait(1)
until game:IsLoaded()

-- Wait for Character to Load --
LocalPlayer.CharacterAppearanceLoaded:Connect(function(character)
    print("Character loaded successfully.")
end)

-- UI Setup --
local ScreenGui
local success, err = pcall(function()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WootingUIv31"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
end)
if not success then
    warn("CoreGui failed: " .. err)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WootingUIv31"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

-- fsociety Background Image (Guy Fawkes Mask) --
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.ImageTransparency = 0.8
BackgroundImage.Image = "rbxassetid://2151741365"
BackgroundImage.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Wooting BlockSpin"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Arcade
Title.TextSize = 24
Title.Parent = Frame

-- Tab System --
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 30)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabFrame.Parent = Frame

local function CreateTab(name, pos, callback)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 100, 1, 0)
    TabButton.Position = pos
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.Arcade
    TabButton.TextSize = 14
    TabButton.Parent = TabFrame
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = TabButton

    TabButton.MouseButton1Click:Connect(function()
        callback()
    end)

    return TabButton
end

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 0, 330)
ContentFrame.Position = UDim2.new(0, 0, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Frame

local VisualContent = Instance.new("Frame")
VisualContent.Size = UDim2.new(1, 0, 1, 0)
VisualContent.BackgroundTransparency = 1
VisualContent.Parent = ContentFrame
VisualContent.Visible = true

local CombatContent = Instance.new("Frame")
CombatContent.Size = UDim2.new(1, 0, 1, 0)
CombatContent.BackgroundTransparency = 1
CombatContent.Parent = ContentFrame
CombatContent.Visible = false

local MiscContent = Instance.new("Frame")
MiscContent.Size = UDim2.new(1, 0, 1, 0)
MiscContent.BackgroundTransparency = 1
MiscContent.Parent = ContentFrame
MiscContent.Visible = false

-- Tab Switching --
CreateTab("Visual", UDim2.new(0, 0, 0, 0), function()
    VisualContent.Visible = true
    CombatContent.Visible = false
    MiscContent.Visible = false
end)

CreateTab("Combat", UDim2.new(0, 100, 0, 0), function()
    VisualContent.Visible = false
    CombatContent.Visible = true
    MiscContent.Visible = false
end)

CreateTab("Misc", UDim2.new(0, 200, 0, 0), function()
    VisualContent.Visible = false
    CombatContent.Visible = false
    MiscContent.Visible = true
end)

-- UI Elements --
local function CreateToggle(name, pos, parent, callbackToggle, hasKeybind, callbackKeybind)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 280, 0, hasKeybind and 60 or 30)
    ToggleFrame.Position = pos
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 260, 0, 25)
    ToggleButton.Position = UDim2.new(0, 10, 0, 5)
    ToggleButton.Text = name
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleButton.Font = Enum.Font.Arcade
    ToggleButton.TextSize = 14
    ToggleButton.Parent = ToggleFrame
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = ToggleButton

    local isOn = false
    ToggleButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        ToggleButton.BackgroundColor3 = isOn and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(50, 50, 50)
        callbackToggle(isOn)
    end)

    if hasKeybind then
        local KeybindButton = Instance.new("TextButton")
        KeybindButton.Size = UDim2.new(0, 260, 0, 25)
        KeybindButton.Position = UDim2.new(0, 10, 0, 35)
        KeybindButton.Text = "Set Keybind"
        KeybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        KeybindButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        KeybindButton.Font = Enum.Font.Arcade
        KeybindButton.TextSize = 14
        KeybindButton.Parent = ToggleFrame
        local KeybindCorner = Instance.new("UICorner")
        KeybindCorner.CornerRadius = UDim.new(0, 5)
        KeybindCorner.Parent = KeybindButton

        KeybindButton.MouseButton1Click:Connect(function()
            KeybindButton.Text = "Press a Key..."
            local waiting = true
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
                    callbackKeybind(input.KeyCode)
                    KeybindButton.Text = "Key: " .. input.KeyCode.Name
                    waiting = false
                    connection:Disconnect()
                end
            end)
        end)
    end

    return ToggleButton
end

local function CreateSlider(name, pos, parent, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0, 280, 0, 40)
    SliderFrame.Position = pos
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = name .. ": " .. default
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Arcade
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 10)
    SliderBar.Position = UDim2.new(0, 0, 0, 25)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderBar.Parent = SliderFrame
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    Fill.Parent = SliderBar
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 5)
    FillCorner.Parent = Fill

    local sliding = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
        end
    end)
    SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if sliding then
            local mouseX = Mouse.X - SliderBar.AbsolutePosition.X
            local maxX = SliderBar.AbsoluteSize.X
            local value = math.clamp(min + (mouseX / maxX) * (max - min), min, max)
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Label.Text = name .. ": " .. math.floor(value)
            callback(value)
        end
    end)

    return SliderFrame
end

-- Visual Tab (ESP) --
CreateToggle("ESP", UDim2.new(0, 0, 0, 0), VisualContent, function(state)
    Settings.ESP_ENABLED = state
    if not state then
        for _, player in pairs(Players:GetPlayers()) do
            if ESP_Boxes[player] then
                ESP_Boxes[player]:Destroy()
                ESP_Boxes[player] = nil
            end
            if ESP_HealthBars[player] then
                ESP_HealthBars[player].gui:Destroy()
                ESP_HealthBars[player] = nil
            end
        end
    end
end, false, nil)

-- Combat Tab (Silent Aim) --
CreateToggle("Silent Aim", UDim2.new(0, 0, 0, 0), CombatContent, function(state)
    Settings.SILENT_AIM_ENABLED = state
end, true, function(key)
    Settings.SILENT_AIM_KEY = key
end)

CreateSlider("FOV Size", UDim2.new(0, 0, 0, 70), CombatContent, 50, 1000, Settings.AIM_FOV, function(value)
    Settings.AIM_FOV = value
end)

-- Misc Tab (Mouse Teleport) --
CreateToggle("Mouse Teleport", UDim2.new(0, 0, 0, 0), MiscContent, function(state)
    Settings.MOUSE_TELEPORT_ENABLED = state
end, true, function(key)
    Settings.MOUSE_TELEPORT_KEY = key
end)

-- Draggable UI --
local dragging, dragInput, dragStart, startPos
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)
Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- FOV Circle --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = Settings.AIM_FOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Color = Color3.fromRGB(255, 80, 80)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 50
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Radius = Settings.AIM_FOV
    FOVCircle.Visible = Settings.SILENT_AIM_ENABLED
end)

-- Silent Aim with Camera Tracking and Bullet Teleport --
local function GetClosestTarget()
    local closestDist = Settings.AIM_FOV
    local target = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("UpperTorso") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                local torso = player.Character.UpperTorso
                local screenPos, onScreen = Camera:WorldToViewportPoint(torso.Position)
                local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < closestDist and onScreen then
                    closestDist = dist
                    target = player.Character
                end
            end
        end
    end
    return target
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if Settings.SILENT_AIM_KEY and input.KeyCode == Settings.SILENT_AIM_KEY and Settings.SILENT_AIM_ENABLED then
        Settings.SILENT_AIM_HOLD = true
    end

    if Settings.MOUSE_TELEPORT_KEY and input.KeyCode == Settings.MOUSE_TELEPORT_KEY and Settings.MOUSE_TELEPORT_ENABLED then
        print("Teleport key pressed: " .. tostring(Settings.MOUSE_TELEPORT_KEY))
        if not LocalPlayer.Character then
            print("Waiting for character to load...")
            LocalPlayer.CharacterAdded:Wait()
        end
        if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            print("HumanoidRootPart not found!")
            return
        end
        local hrp = LocalPlayer.Character.HumanoidRootPart
        print("Character and HumanoidRootPart found.")
        wait(0.2)
        local success, err = pcall(function()
            local targetPos = Mouse.Hit.Position
            print("Target position from Mouse.Hit: " .. tostring(targetPos))
            hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            print("Teleport attempted.")
        end)
        if not success then
            print("Teleport failed with error: " .. tostring(err))
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if Settings.SILENT_AIM_KEY and input.KeyCode == Settings.SILENT_AIM_KEY then
        Settings.SILENT_AIM_HOLD = false
    end
end)

RunService.RenderStepped:Connect(function()
    if Settings.SILENT_AIM_ENABLED and Settings.SILENT_AIM_HOLD then
        local target = GetClosestTarget()
        if target and target:FindFirstChild("UpperTorso") and target:FindFirstChild("Head") then
            local torsoPos = target.UpperTorso.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, torsoPos)
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                local shootRemote = tool:FindFirstChild("Shoot") or tool:FindFirstChild("Fire")
                if shootRemote and shootRemote:IsA("RemoteEvent") then
                    for i = 1, 5 do
                        shootRemote:FireServer(target.Head.Position)
                    end
                end
            end
        end
    end
end)

-- Function to Get Player Inventory --
local function GetPlayerInventory(player)
    local inventory = {}
    
    -- Check the player's Backpack for unequipped tools --
    if player:FindFirstChild("Backpack") then
        for _, item in pairs(player.Backpack:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(inventory, item.Name)
            end
        end
    end
    
    -- Check the player's Character for equipped tools --
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(inventory, item.Name .. " (Equipped)")
            end
        end
    end
    
    -- If inventory is empty, return a default message --
    if #inventory == 0 then
        return "Inventory: Empty"
    end
    
    -- Join the inventory items into a string --
    return "Inventory: " .. table.concat(inventory, ", ")
end

-- ESP with Boxes, Health Bars, and Inventory Display --
local function AddESP(player)
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Box --
        if Settings.ESP_ENABLED then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "WootingESPBox"
            box.Size = Vector3.new(4, 6, 4)
            box.Color3 = Color3.fromRGB(255, 80, 80)
            box.Transparency = 0.6
            box.ZIndex = 10
            box.AlwaysOnTop = true
            box.Adornee = player.Character.HumanoidRootPart
            box.Parent = game.CoreGui
            ESP_Boxes[player] = box
        end

        -- Health Bar, Name, and Inventory --
        if Settings.ESP_ENABLED then
            local healthGui = Instance.new("BillboardGui")
            healthGui.Name = "WootingESPHealth"
            healthGui.Size = UDim2.new(0, 120, 0, 50) -- Increased height to accommodate inventory label
            healthGui.StudsOffset = Vector3.new(0, 3.5, 0)
            healthGui.AlwaysOnTop = true
            healthGui.Adornee = player.Character.HumanoidRootPart
            healthGui.Parent = game.CoreGui

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0, 15)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            nameLabel.TextScaled = true
            nameLabel.Parent = healthGui

            local healthBar = Instance.new("Frame")
            healthBar.Size = UDim2.new(1, 0, 0, 5)
            healthBar.Position = UDim2.new(0, 0, 0, 15)
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            healthBar.Parent = healthGui

            local healthFill = Instance.new("Frame")
            healthFill.Size = UDim2.new(1, 0, 1, 0)
            healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            healthFill.Parent = healthBar

            -- Inventory Label --
            local inventoryLabel = Instance.new("TextLabel")
            inventoryLabel.Size = UDim2.new(1, 0, 0, 30) -- Increased height for wrapping text
            inventoryLabel.Position = UDim2.new(0, 0, 0, 20)
            inventoryLabel.BackgroundTransparency = 1
            inventoryLabel.Text = GetPlayerInventory(player)
            inventoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            inventoryLabel.TextScaled = true
            inventoryLabel.TextWrapped = true
            inventoryLabel.TextYAlignment = Enum.TextYAlignment.Top
            inventoryLabel.Parent = healthGui

            ESP_HealthBars[player] = {gui = healthGui, fill = healthFill, inventory = inventoryLabel}

            -- Listen for inventory changes --
            if player:FindFirstChild("Backpack") then
                player.Backpack.ChildAdded:Connect(function()
                    if ESP_HealthBars[player] and ESP_HealthBars[player].inventory then
                        ESP_HealthBars[player].inventory.Text = GetPlayerInventory(player)
                    end
                end)
                player.Backpack.ChildRemoved:Connect(function()
                    if ESP_HealthBars[player] and ESP_HealthBars[player].inventory then
                        ESP_HealthBars[player].inventory.Text = GetPlayerInventory(player)
                    end
                end)
            end

            -- Listen for equipped tool changes --
            if player.Character then
                player.Character.ChildAdded:Connect(function(child)
                    if child:IsA("Tool") and ESP_HealthBars[player] and ESP_HealthBars[player].inventory then
                        ESP_HealthBars[player].inventory.Text = GetPlayerInventory(player)
                    end
                end)
                player.Character.ChildRemoved:Connect(function(child)
                    if child:IsA("Tool") and ESP_HealthBars[player] and ESP_HealthBars[player].inventory then
                        ESP_HealthBars[player].inventory.Text = GetPlayerInventory(player)
                    end
                end)
            end
        end
    end
end

local function UpdateESP()
    for player, box in pairs(ESP_Boxes) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not Settings.ESP_ENABLED then
            box:Destroy()
            ESP_Boxes[player] = nil
        end
    end
    for player, health in pairs(ESP_HealthBars) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not Settings.ESP_ENABLED then
            health.gui:Destroy()
            ESP_HealthBars[player] = nil
        else
            if player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                health.fill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
            end
            -- Update inventory display --
            if health.inventory then
                health.inventory.Text = GetPlayerInventory(player)
            end
        end
    end
    if Settings.ESP_ENABLED then
        for _, player in pairs(Players:GetPlayers()) do
            if not ESP_Boxes[player] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                AddESP(player)
            end
            if not ESP_HealthBars[player] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                AddESP(player)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if Settings.ESP_ENABLED then AddESP(player) end
    end)
end)

RunService.RenderStepped:Connect(UpdateESP)

-- Cleanup --
ScreenGui.Destroying:Connect(function()
    Settings.SILENT_AIM_ENABLED = false
    Settings.ESP_ENABLED = false
    Settings.MOUSE_TELEPORT_ENABLED = false
    FOVCircle:Remove()
    for _, player in pairs(Players:GetPlayers()) do
        if ESP_Boxes[player] then
            ESP_Boxes[player]:Destroy()
            ESP_Boxes[player] = nil
        end
        if ESP_HealthBars[player] then
            ESP_HealthBars[player].gui:Destroy()
            ESP_HealthBars[player] = nil
        end
    end
end)
