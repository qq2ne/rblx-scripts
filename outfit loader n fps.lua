repeat
    wait() -- Wait until the game is loaded
until game:IsLoaded()

-- Variables to store GUI references
local statsGui
local outfitGui

-- Function to create the FPS and Ping GUI
local function createStatsGui()
    statsGui = Instance.new("ScreenGui")
    local fpsLabel = Instance.new("TextLabel")
    local pingLabel = Instance.new("TextLabel")

    -- ScreenGui properties for statsGui
    statsGui.Parent = game.CoreGui
    statsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- FPS Label properties
    fpsLabel.Name = "Fps"
    fpsLabel.Parent = statsGui
    fpsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fpsLabel.BackgroundTransparency = 1.000
    fpsLabel.Position = UDim2.new(0.5, -66, 0, -30) -- Centered and higher on the screen
    fpsLabel.Size = UDim2.new(0, 125, 0, 25)
    fpsLabel.Font = Enum.Font.SourceSans
    fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green color
    fpsLabel.TextScaled = true
    fpsLabel.TextSize = 14.000
    fpsLabel.TextWrapped = true
    fpsLabel.Active = true -- Ensure the label is active for dragging

    -- Ping Label properties
    pingLabel.Name = "Ping"
    pingLabel.Parent = statsGui
    pingLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pingLabel.BackgroundTransparency = 1.000
    pingLabel.Position = UDim2.new(0.5, -61, 0, -4) -- Next to the FPS label
    pingLabel.Size = UDim2.new(0, 125, 0, 25)
    pingLabel.Font = Enum.Font.SourceSans
    pingLabel.TextColor3 = Color3.fromRGB(253, 253, 253)
    pingLabel.TextScaled = true
    pingLabel.TextSize = 14.000
    pingLabel.TextWrapped = true

    -- FPS Script
    local fpsScript = Instance.new('LocalScript', fpsLabel)
    local RunService = game:GetService("RunService")

    RunService.RenderStepped:Connect(function(frame) -- This will fire every time a frame is rendered
        fpsLabel.Text = ("FPS: " .. math.round(1/frame))
    end)

    -- Ping Script
    local pingScript = Instance.new('LocalScript', pingLabel)

    RunService.RenderStepped:Connect(function()
        pingLabel.Text = ("Ping: " .. game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString())
    end)
end

-- Function to create the outfit loader GUI
local function createOutfitLoaderGui()
    outfitGui = Instance.new("ScreenGui")
    outfitGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local function Morph(UserId)
        local player = game.Players.LocalPlayer
        local appearance = nil
        
        -- Check if UserId is valid
        if UserId > 0 then
            appearance = game.Players:GetCharacterAppearanceAsync(UserId)
        else
            warn("Invalid UserId:", UserId)
            return
        end
        
        for i,v in pairs(player.Character:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("CharacterMesh") or v:IsA("BodyColors") then
                v:Destroy()
            end
        end

        if player.Character.Head:FindFirstChild("face") then
            player.Character.Head.face:Destroy()
        end

        if appearance then
            for i,v in pairs(appearance:GetChildren()) do
                if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then
                    v.Parent = player.Character
                elseif v:IsA("Accessory") then
                    player.Character.Humanoid:AddAccessory(v)
                elseif v.Name == "R6" then
                    if player.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
                        v:FindFirstChildOfClass("CharacterMesh").Parent = player.Character
                    end
                elseif v.Name == "R15" then
                    if player.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
                        v:FindFirstChildOfClass("CharacterMesh").Parent = player.Character
                    end
                end
            end

            if appearance:FindFirstChild("face") then
                appearance.face.Parent = player.Character.Head
            else
                local face = Instance.new("Decal")
                face.Face = "Front"
                face.Name = "face"
                face.Texture = "rbxasset://textures/face.png"
                face.Transparency = 0
                face.Parent = player.Character.Head
            end

            -- Reload Character
            local parent = player.Character.Parent
            player.Character.Parent = nil
            player.Character.Parent = parent
        else
            warn("Failed to fetch character appearance for UserId:", UserId)
        end
    end

    -- Creating the GUI elements for outfit loader
    local outfitLoaderFrame = Instance.new("Frame")
    outfitLoaderFrame.Size = UDim2.new(0.16, 0, 0.2, 0)
    outfitLoaderFrame.Position = UDim2.new(0.375, 0, 0.3, 0)
    outfitLoaderFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    outfitLoaderFrame.BorderSizePixel = 2
    outfitLoaderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    outfitLoaderFrame.Active = true
    outfitLoaderFrame.Draggable = true
    outfitLoaderFrame.Parent = outfitGui

    local outfitLoaderLabel = Instance.new("TextLabel")
    outfitLoaderLabel.Text = "Outfits Loader"
    outfitLoaderLabel.Size = UDim2.new(1, 0, 0.1, 0)
    outfitLoaderLabel.Position = UDim2.new(0, 0, 0, 0)
    outfitLoaderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    outfitLoaderLabel.Parent = outfitLoaderFrame

    local userIdTextBox = Instance.new("TextBox")
    userIdTextBox.Size = UDim2.new(0.8, 0, 0.1, 0) -- Adjusted size to fit within the frame
    userIdTextBox.Position = UDim2.new(0.1, 0, 0.2, 0) -- Adjusted position to fit within the frame
    userIdTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    userIdTextBox.Parent = outfitLoaderFrame

    local loadButton = Instance.new("TextButton")
    loadButton.Text = "Load"
    loadButton.Size = UDim2.new(0.8, 0, 0.1, 0) -- Adjusted size to fit within the frame
    loadButton.Position = UDim2.new(0.1, 0, 0.35, 0) -- Adjusted position to fit within the frame
    loadButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadButton.Parent = outfitLoaderFrame

    loadButton.MouseButton1Click:Connect(function()
        local userId = tonumber(userIdTextBox.Text)
        if userId then
            Morph(userId)
        else
            warn("Invalid UserId entered:", userIdTextBox.Text)
        end
    end)

    local defaultFitButton = Instance.new("TextButton")
    defaultFitButton.Text = "Default Fit"
    defaultFitButton.Size = UDim2.new(0.8, 0, 0.1, 0) -- Adjusted size to fit within the frame
    defaultFitButton.Position = UDim2.new(0.1, 0, 0.5, 0) -- Adjusted position to fit within the frame
    defaultFitButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    defaultFitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    defaultFitButton.Parent = outfitLoaderFrame

    defaultFitButton.MouseButton1Click:Connect(function()
        Morph(game.Players.LocalPlayer.UserId)
    end)

    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0.05, 0, 0.05, 0)
    closeButton.Position = UDim2.new(0.95, 0, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = outfitLoaderFrame

    closeButton.MouseButton1Click:Connect(function()
        outfitLoaderFrame:Destroy()
    end)

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Text = "Player List"
    dropdownButton.Size = UDim2.new(0.8, 0, 0.1, 0)
    dropdownButton.Position = UDim2.new(0.1, 0, 0.75, 0)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.Parent = outfitLoaderFrame

    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(0.8, 0, 0.4, 0)
    dropdownList.Position = UDim2.new(0.1, 0, 0.85, 0)
    dropdownList.BackgroundTransparency = 0.5
    dropdownList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dropdownList.Visible = false
    dropdownList.Parent = outfitLoaderFrame

    local function updatePlayerList()
        local playerList = game.Players:GetPlayers()
        for _, child in ipairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        local yOffset = 0
        for _, player in ipairs(playerList) do
            local playerNameButton = Instance.new("TextButton")
            playerNameButton.Text = player.Name
            playerNameButton.Size = UDim2.new(1, 0, 0, 20)
            playerNameButton.Position = UDim2.new(0, 0, 0, yOffset)
            playerNameButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            playerNameButton.Parent = dropdownList

            playerNameButton.MouseButton1Click:Connect(function()
                userIdTextBox.Text = tostring(player.UserId)
                dropdownList.Visible = false
            end)

            yOffset = yOffset + 20
        end
    end

    dropdownButton.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        if dropdownList.Visible then
            updatePlayerList()
        end
    end)

    game.Players.PlayerAdded:Connect(updatePlayerList)
    game.Players.PlayerRemoving:Connect(updatePlayerList)
end

-- Function to handle player character respawn
local function onCharacterAdded(character)
    createStatsGui()
    createOutfitLoaderGui()
end

-- Initial GUI creation
createStatsGui()
createOutfitLoaderGui()

-- Connect character added event to recreate the UI on respawn
game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

local function toggleOutfitLoaderUI()
    if outfitGui then
        outfitGui.Enabled = not outfitGui.Enabled
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        toggleOutfitLoaderUI()
    end
end)
