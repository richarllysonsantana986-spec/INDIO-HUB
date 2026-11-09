-- INDIO HUB | Interface visual
-- LocalScript para uso em uma experiência própria no Roblox Studio.
-- Inclui painel arrastável e otimização visual reversível.
-- Não inclui aimbot, ESP, injeção ou bypass de anti-cheat.

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("IndioHub")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "IndioHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(310, 205)
panel.Position = UDim2.new(0.5, -155, 0.5, -102)
panel.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(235, 45, 55)
stroke.Thickness = 1.5
stroke.Parent = panel

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = Color3.fromRGB(27, 27, 33)
header.BorderSizePixel = 0
header.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "INDIO HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 19
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 30)
close.Position = UDim2.new(1, -42, 0, 9)
close.BackgroundColor3 = Color3.fromRGB(175, 35, 45)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = close

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -28, 0, 30)
status.Position = UDim2.fromOffset(14, 57)
status.BackgroundTransparency = 1
status.Text = "Painel carregado"
status.TextColor3 = Color3.fromRGB(195, 195, 205)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

local optimize = Instance.new("TextButton")
optimize.Size = UDim2.new(1, -28, 0, 42)
optimize.Position = UDim2.fromOffset(14, 96)
optimize.BackgroundColor3 = Color3.fromRGB(190, 35, 48)
optimize.Text = "ATIVAR OTIMIZAÇÃO VISUAL"
optimize.TextColor3 = Color3.new(1, 1, 1)
optimize.Font = Enum.Font.GothamBold
optimize.TextSize = 13
optimize.Parent = panel

local optCorner = Instance.new("UICorner")
optCorner.CornerRadius = UDim.new(0, 8)
optCorner.Parent = optimize

local note = Instance.new("TextLabel")
note.Size = UDim2.new(1, -28, 0, 42)
note.Position = UDim2.fromOffset(14, 148)
note.BackgroundTransparency = 1
note.Text = "Ferramenta local para sua própria experiência Roblox."
note.TextColor3 = Color3.fromRGB(145, 145, 155)
note.Font = Enum.Font.Gotham
note.TextSize = 11
note.TextWrapped = true
note.Parent = panel

local optimized = false
local originalShadows = Lighting.GlobalShadows

local function changeEffects(enabled)
    optimized = enabled
    Lighting.GlobalShadows = enabled and false or originalShadows

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if enabled then
                if obj:GetAttribute("IndioOldShadow") == nil then
                    obj:SetAttribute("IndioOldShadow", obj.CastShadow)
                end
                obj.CastShadow = false
            else
                local old = obj:GetAttribute("IndioOldShadow")
                if old ~= nil then
                    obj.CastShadow = old
                    obj:SetAttribute("IndioOldShadow", nil)
                end
            end
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail")
            or obj:IsA("Beam") or obj:IsA("Fire")
            or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            if enabled then
                if obj:GetAttribute("IndioOldEnabled") == nil then
                    obj:SetAttribute("IndioOldEnabled", obj.Enabled)
                end
                obj.Enabled = false
            else
                local old = obj:GetAttribute("IndioOldEnabled")
                if old ~= nil then
                    obj.Enabled = old
                    obj:SetAttribute("IndioOldEnabled", nil)
                end
            end
        end
    end

    optimize.Text = enabled and "DESATIVAR OTIMIZAÇÃO" or "ATIVAR OTIMIZAÇÃO VISUAL"
    status.Text = enabled and "Otimização visual ativada" or "Otimização visual desativada"
end

optimize.MouseButton1Click:Connect(function()
    changeEffects(not optimized)
end)

Workspace.DescendantAdded:Connect(function(obj)
    if not optimized then return end
    if obj:IsA("BasePart") then
        obj:SetAttribute("IndioOldShadow", obj.CastShadow)
        obj.CastShadow = false
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail")
        or obj:IsA("Beam") or obj:IsA("Fire")
        or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        obj:SetAttribute("IndioOldEnabled", obj.Enabled)
        obj.Enabled = false
    end
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Permite arrastar o painel pelo cabeçalho (mouse e toque).
local dragging = false
local dragInput, dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

print("[INDIO HUB] Interface carregada.")
