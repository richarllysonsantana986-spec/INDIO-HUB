-- INDIO HUB | Otimizador Visual
-- LocalScript para uso em sua própria experiência Roblox

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Reduz sombras e efeitos de água
Lighting.GlobalShadows = false

local terrain = Workspace:FindFirstChildOfClass("Terrain")
if terrain then
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
end

local function optimize(object)
    if object:IsA("BasePart") then
        object.CastShadow = false
    elseif object:IsA("ParticleEmitter")
        or object:IsA("Trail")
        or object:IsA("Beam")
        or object:IsA("Fire")
        or object:IsA("Smoke")
        or object:IsA("Sparkles") then
        object.Enabled = false
    end
end

-- Otimiza objetos existentes
for _, object in ipairs(Workspace:GetDescendants()) do
    optimize(object)
end

-- Otimiza objetos adicionados durante o jogo
Workspace.DescendantAdded:Connect(optimize)

print("[INDIO HUB] Otimizador visual ativado!")
