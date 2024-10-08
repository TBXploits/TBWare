local notify = {}

local Player = game.Players.LocalPlayer
local function TweenNotification(frame, timer, duration)
    timer:TweenSize(UDim2.new(0, 0, 0.05, 0), "InOut", "Linear", duration, false)
    wait(duration)
    frame:TweenPosition(UDim2.new(2, 0, 0, 20), "In", "Quad", 0.5, true)
    wait(0.5)
    frame:Destroy()
end

function notify.new(title, description, imageId, duration)
    local ScreenGui =
        Player:FindFirstChild("PlayerGui"):FindFirstChild("NotificationGui") or
        Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
    local NotificationFrame = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local DescriptionLabel = Instance.new("TextLabel")
    local ImageLabel = Instance.new("ImageLabel")
    local TimerIndicator = Instance.new("Frame")

    NotificationFrame.Size = UDim2.new(0, 300, 0, 100)
    NotificationFrame.Position = UDim2.new(2, 0, 0, 20)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.AnchorPoint = Vector2.new(1, 0)
    NotificationFrame.Parent = ScreenGui

    ImageLabel.Size = UDim2.new(0, 80, 0, 80)
    ImageLabel.Position = UDim2.new(0, 10, 0, 10)
    ImageLabel.Image = "rbxthumb://type=Asset&w=768&h=432&id=" .. imageId
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Parent = NotificationFrame

    TitleLabel.Size = UDim2.new(0, 210, 0, 30)
    TitleLabel.Position = UDim2.new(0, 100, 0, 10)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.Parent = NotificationFrame

    DescriptionLabel.Size = UDim2.new(0, 210, 0, 30)
    DescriptionLabel.Position = UDim2.new(0, 100, 0, 45)
    DescriptionLabel.Text = description
    DescriptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.TextSize = 25
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.TextScaled = true
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.Parent = NotificationFrame

    TimerIndicator.Size = UDim2.new(1, 0, 0, 5)
    TimerIndicator.Position = UDim2.new(0, 0, 0.925, 1)
    TimerIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    TimerIndicator.Parent = NotificationFrame

    NotificationFrame:TweenPosition(UDim2.new(1.3, -310, 0, 20), "Out", "Quad", 0.5, true)
    wait(0.5)
    TweenNotification(NotificationFrame, TimerIndicator, duration)
end
return notify