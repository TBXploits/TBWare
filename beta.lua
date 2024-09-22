if TBX_Loaded and TBX_FPS then
    return
-- error("Loaded Already!")
end
local repo = "https://raw.githubusercontent.com/MrIcMe/linoria/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
ver = game:HttpGet("https://raw.githubusercontent.com/TBXploits/TBWare/main/version.lua")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local Window =
    Library:CreateWindow(
    {
        Title = "TBWare v" .. ver,
        Center = true,
        AutoShow = true,
        TabPadding = 8,
        MenuFadeTime = 0.2
    }
)

local Tabs = {
    Main = Window:AddTab("Main"),
    Ifm = Window:AddTab("Info")
    ["TBWare Settings"] = Window:AddTab("TBWare Settings")
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Main Settings")
local RightGroupBox = Tabs.Main:AddRightGroupbox("Additional Settings")

getgenv().ison = false
getgenv().FSPD = false
getgenv().FJMP = false
getgenv().FBTH = false
getgenv().met1 = nil
getgenv().met2 = nil
getgenv().clicktp = nil

function stringToRGB(str)
    local r, g, b = str:match("(%d+),%s*(%d+),%s*(%d+)")
    return tonumber(r), tonumber(g), tonumber(b)
end

LeftGroupBox:AddInput(
    "FillColor",
    {
        Text = "Fill Color (R, G, B)",
        Default = "153, 255, 255",
        Placeholder = "R, G, B (e.g. 153, 255, 255)",
        Numeric = false,
        Finished = true,
        Callback = function(value)
            getgenv().Clr = value
        end
    }
)

LeftGroupBox:AddInput(
    "OutlineColor",
    {
        Text = "Outline Color (R, G, B)",
        Default = "255, 255, 255",
        Placeholder = "R, G, B (e.g. 255, 255, 255)",
        Numeric = false,
        Finished = true,
        Callback = function(value)
            getgenv().OClr = value
        end
    }
)

function cesp(character, head, txt)
    local part = head
    local billboardGui = part:FindFirstChild("BillboardGui")
    local textLabel = billboardGui and billboardGui:FindFirstChild("TextLabel")

    if not billboardGui then
        billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "BillboardGui"
        billboardGui.Parent = part
        billboardGui.Adornee = part
        billboardGui.Size = UDim2.new(0, 150, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 2, 0)
        billboardGui.AlwaysOnTop = true

        textLabel = Instance.new("TextLabel")
        textLabel.Name = "TextLabel"
        textLabel.Parent = billboardGui
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextSize = 20
        textLabel.Font = Enum.Font.SciFi
    end

    if textLabel then
        textLabel.Text = txt
    end

    local highlight = character:FindFirstChild("TBXP")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "TBXP"
        highlight.Parent = character
        highlight.Adornee = character

        local r, g, b = stringToRGB(getgenv().Clr)
        highlight.FillColor = r and g and b and Color3.fromRGB(r, g, b) or Color3.fromRGB(153, 255, 255)

        local x, y, z = stringToRGB(getgenv().OClr)
        highlight.OutlineColor = x and y and z and Color3.fromRGB(x, y, z) or Color3.new(1, 1, 1)

        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.HealthChanged:Connect(function()
            textLabel.Text = player.Name .. " | Health: " .. string.format("%.2f", humanoid.Health)
        end)
    end
end

local function onCharacterAdded(player)
    player.CharacterAdded:Connect(function(character)
        local head = character:WaitForChild("Head")
        cesp(character, head, player.Name .. " | Health: " .. string.format("%.2f", character:FindFirstChildOfClass("Humanoid").Health))
    end)
end

local function onPlayerRemoving(player)
    if player.Character then
        local highlight = player.Character:FindFirstChild("TBXP")
        local billboard = player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("BillboardGui")
        if highlight then
            highlight:Destroy()
        end
        if billboard then
            billboard:Destroy()
        end
    end
end

local rs = game:GetService("RunService")
local espConnection

LeftGroupBox:AddToggle(
    "ESP",
    {
        Text = "Enable ESP",
        Default = false,
        Callback = function(state)
            if state then
                Library:Notify("ESP is now enabled", 3)
                espConnection =
                    rs.RenderStepped:Connect(
                    function()
                        for _, player in pairs(game.Players:GetPlayers()) do
                            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                                cesp(
                                    player.Character,
                                    player.Character.Head,
                                    player.Name .. " | Health: " .. string.format("%.2f", player.Character.Humanoid.Health)
                                )
                            end
                        end
                    end
                )

                game.Players.PlayerAdded:Connect(onCharacterAdded)
                game.Players.PlayerRemoving:Connect(onPlayerRemoving)
            else
                Library:Notify("ESP is now disabled", 3)
                if espConnection then
                    espConnection:Disconnect()
                    espConnection = nil
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character then
                            local highlight = player.Character:FindFirstChild("TBXP")
                            local billboard = player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("BillboardGui")
                            if highlight then
                                highlight:Destroy()
                            end
                            if billboard then
                                billboard:Destroy()
                            end
                        end
                    end
                end
            end
        end
    }
)

LeftGroupBox:AddDivider()

RightGroupBox:AddToggle(
    "ForceSetSpeed",
    {
        Text = "Force Set Speed",
        Default = false,
        Callback = function(state)
            getgenv().FSPD = state
        end
    }
)

RightGroupBox:AddToggle(
    "ForceSetJump",
    {
        Text = "Force Set Jump",
        Default = false,
        Callback = function(state)
            getgenv().FJMP = state
        end
    }
)

RightGroupBox:AddToggle(
    "ForceSetBoth",
    {
        Text = "Force Set Both",
        Default = false,
        Callback = function(state)
            getgenv().FBTH = state
        end
    }
)

LeftGroupBox:AddInput(
    "Speed",
    {
        Text = "Speed",
        Default = "16",
        Placeholder = "Value",
        Numeric = true,
        Finished = true,
        Callback = function(value)
            getgenv().Speed = value
        end
    }
)

LeftGroupBox:AddInput(
    "Jump",
    {
        Text = "Jump Power",
        Default = "50",
        Placeholder = "Value",
        Numeric = true,
        Finished = true,
        Callback = function(value)
            getgenv().Jump = value
        end
    }
)

LeftGroupBox:AddButton(
    "Set Speed",
    function()
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = getgenv().Speed
        end
    end
)

LeftGroupBox:AddButton(
    "Set Jump",
    function()
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = getgenv().Jump
        end
    end
)

LeftGroupBox:AddButton(
    "Set Both",
    function()
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = getgenv().Speed
            hum.JumpPower = getgenv().Jump
        end
    end
)

LeftGroupBox:AddDivider()

local ProximityPromptService = game:GetService("ProximityPromptService")

LeftGroupBox:AddToggle(
    'IIT1',
    {
    Text = "Instant Interact Method 1",
    Default = false,
    Tooltip = "Set Prompt Duration 0",
    Callback = function(b)
        if b then
            met1 = ProximityPromptService.PromptShown:Connect(function(prompt)
                prompt.HoldDuration = 0
            end)
        else
        met1:Disconnect()
        end
    end
    }
)

LeftGroupBox:AddToggle(
    'IIT2',
    {
    Text = "Instant Interact Method 2",
    Default = false,
    Tooltip = "Fire Prompt Instantly After Hold",
    Callback = function(b)
        if b then
            met2 = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                fireproximityprompt(prompt)
            end)
        else
        met2:Disconnect()
        end
    end
    }
)

LeftGroupBox:AddToggle(
    "ClickTP",
    {
        Text = "Click Teleport",
        Default = false,
        Tooltip = "Click TP!",
        Callback = function(state)

            if state then
                clicktp = mouse.Button1Down:Connect(function()
                    local hitPosition = mouse.Hit.p
                    player.Character:PivotTo(CFrame.new(hitPosition))
                end)
            else
                clicktp:Disconnect()
            end
        end
    }
)

task.spawn(
    function()
        while true do
            wait()
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if getgenv().FSPD then
                    hum.WalkSpeed = getgenv().Speed
                end
                if getgenv().FJMP then
                    hum.JumpPower = getgenv().Jump
                end
                if getgenv().FBTH then
                    hum.WalkSpeed = getgenv().Speed
                    hum.JumpPower = getgenv().Jump
                end
            end
        end
    end
)

local function onPlayerDeath(player)
    if not player or not player.Character or not player.Character:FindFirstChildOfClass("Humanoid") then
        return
    end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Died:Connect(
            function()
                if not getgenv().notified[player.UserId] then
                    Library:Notify(player.Name .. " has died.", 5)
                    getgenv().notified[player.UserId] = true
                end
            end
        )
    end
end

getgenv().notified = {}

for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        onPlayerDeath(player)
    end
end

game.Players.PlayerAdded:Connect(onPlayerDeath)

RightGroupBox:AddButton(
    "Anti-Slip",
    function()
        local plr = game.Players.LocalPlayer
        local chr = plr.Character
        local hm = chr and chr:FindFirstChildOfClass("Humanoid")
        local hrp = chr and chr:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CustomPhysicalProperties = PhysicalProperties.new(100, 1, 1)
            Library:Notify("Anti-Slip Executed.", 3)
        end
    end
)

RightGroupBox:AddDivider()

RightGroupBox:AddDropdown(
    "Player",
    {
        SpecialType = "Player",
        Text = "Target Player",
        Tooltip = "Select Target Player!",
        Callback = function(Value)
            getgenv().Selected = Value
        end
    }
)

RightGroupBox:AddButton(
    "Teleport To Target",
    function()
        game.Players.LocalPlayer.Character:PivotTo(game.Players[Selected].Character.HumanoidRootPart.CFrame)
    end
)

RightGroupBox:AddButton(
    "Client Bring Target",
    function()
        game.Players[Selected].Character.HumanoidRootPart.CFrame =
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end
)

RightGroupBox:AddToggle(
    "View",
    {
        Text = "View Target",
        Default = false,
        Tooltip = "View Target Player",
        Callback = function(YesNo)
            getgenv().Viewing = YesNo
            getgenv().running_view = YesNo
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")

            local player = Players.LocalPlayer

            if Viewing then
                pcall(
                    function()
                        while running_view do
                            wait()
                            local targetName = Selected
                            local target = Workspace:FindFirstChild(targetName)

                            if target then
                                local character = player.Character
                                if character then
                                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                                    if humanoidRootPart then
                                        local camera = Workspace.CurrentCamera
                                        camera.CameraSubject = target
                                        camera.CFrame =
                                            CFrame.new(target.Position + Vector3.new(0, 5, 10), target.Position)
                                    end
                                end
                            end
                        end
                    end
                )
            else
                local character = player.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local camera = Workspace.CurrentCamera
                        camera.CameraSubject = character:FindFirstChildOfClass("Humanoid")
                        camera.CFrame =
                            CFrame.new(humanoidRootPart.Position + Vector3.new(0, 5, 10), humanoidRootPart.Position)
                    end
                end
            end
        end
    }
)

Ifm:AddLabel("Account Age:"..player.AccountAge)
Ifm:AddLabel("Username:"..player.Name)
Ifm:AddLabel("Display:"..player.DisplayName)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection =
    game:GetService("RunService").RenderStepped:Connect(
    function()
    FrameCounter += 1
        if (tick() - FrameTimer) > 1 then
            FPS = FrameCounter
            FrameCounter = 0
            FrameTimer = tick()
        end
        Library:SetWatermark("TBWare | FPS: " .. FPS)
        getgenv().TBX_FPS = true
    end
)
getgenv().TBX_Loaded = true
local MenuGroup = Tabs["TBWare Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddButton(
    "Unload",
    function()
        pcall(function()
            Library:Unload()
            getgenv().TBX_Loaded = nil
            getgenv().TBX_FPS = nil
            getgenv().FSPD = false
            getgenv().FJMP = false
            getgenv().FBTH = false
            getgenv().Viewing = false
            getgenv().running_view = false
            if met1 ~= nil then met1:Disconnect() end
            if met2 ~= nil then met2:Disconnect() end
            if clicktp ~= nil then clicktp:Disconnect() end
        end)
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local camera = Workspace.CurrentCamera
                camera.CameraSubject = character:FindFirstChildOfClass("Humanoid")
                camera.CFrame = CFrame.new(humanoidRootPart.Position + Vector3.new(0, 5, 10), humanoidRootPart.Position)
            end
        end
        espConnection:Disconnect()
        espConnection = nil
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("TBXP")
                local billboard =
                    player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("BillboardGui")
                if highlight then
                    highlight:Destroy()
                end
                if billboard then
                    billboard:Destroy()
                end
            end
        end
    end
)
MenuGroup:AddInput(
    "MenuKeybind",
    {
        Text = "Menu Keybind",
        Default = "End",
        Placeholder = "Keybind",
        Numeric = false,
        Finished = true,
        Callback = function(value)
            Library.ToggleKeybind = value
        end
    }
)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:BuildConfigSection(Tabs["TBWare Settings"])
ThemeManager:ApplyToTab(Tabs["TBWare Settings"])