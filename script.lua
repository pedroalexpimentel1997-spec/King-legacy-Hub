-- [[ KING LEGACY ULTRA HUB - DELTA EXECUTOR EDITION ]] --
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/GGBV9/GGHUB/main/GG"))()

local Window = Rayfield:CreateWindow({
   Name = "👑 King Legacy: Ultra Hub (Delta) 👑",
   LoadingTitle = "Iniciando no Delta Executor...",
   LoadingSubtitle = "Otimizado para Mobile/PC",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- [[ VARIÁVEIS DE CONTROLE ]] --
getgenv().AutoFarm = false
getgenv().AutoSea = false
getgenv().AutoSerpente = false
getgenv().AutoBigMom = false
getgenv().AutoPesca = false
getgenv().EspFrutas = false

-- [[ SERVIÇOS DO ROBLOX ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

-- 🛡️ ANTI-AFK ADAPTADO PARA DELTA MOBILE (Evita desconexão em segundo plano)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

-- 🛡️ PROTETOR DE QUEDA E ESTABILIDADE (Bypass de Velocidade Nátivo do Delta)
RunService.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().AutoFarm or getgenv().AutoSea then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- 🛡️ TWEEN SUAVE ADAPTADO PARA MOBILE
local function DeltaSecureMove(targetCFrame, speed)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local duration = distance / (speed or 230) 
        
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- 🛡️ BYPASS DE CLICK / ATAQUE COM DELAY HUMANO
local lastAttack = 0
local function BypassAttack()
    if os.clock() - lastAttack >= 0.15 then
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
            if tool then
                if tool.Parent == LocalPlayer.Backpack then
                    char:FindFirstChildOfClass("Humanoid"):EquipTool(tool)
                end
                tool:Activate()
                lastAttack = os.clock()
            end
        end
    end
end

-- [[ COORDENADAS ]] --
local IslandPositions = {
    ["Spawn Island"] = CFrame.new(100, 50, 100),
    ["Marineford"] = CFrame.new(-2000, 60, 1500),
    ["Fishland"] = CFrame.new(3500, -1000, -2000),
    ["Dressrosa"] = CFrame.new(5000, 100, 4000),
    ["Loaf Island"] = CFrame.new(-6000, 80, -3000),
    ["Fiend Island"] = CFrame.new(8000, 150, 1000)
}

-- [[ ABAS DA UI ]] --
local TabFarm = Window:CreateTab("🌾 Auto Farm", 4483362458)
local TabSea = Window:CreateTab("🌊 Sea Events", 4483362458)
local TabTP = Window:CreateTab("📍 Teleports", 4483362458)
local TabVisual = Window:CreateTab("👁️ ESP / Visuais", 4483362458)

-- [[ LÓGICA: AUTO FARM LEVEL ]] --
TabFarm:CreateToggle({
   Name = "Auto Farm Level (Seguro - Delta)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoFarm = Value
       task.spawn(function()
           while getgenv().AutoFarm do
               task.wait(0.1)
               pcall(function()
                   for _, monster in pairs(workspace.Monster:GetChildren()) do
                       if monster:FindFirstChild("Humanoid") and monster.Humanoid.Health > 0 then
                           if (monster.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 600 then
                               repeat
                                   task.wait()
                                   LocalPlayer.Character.HumanoidRootPart.CFrame = monster.HumanoidRootPart.CFrame * CFrame.new(0, 9, 0)
                                   BypassAttack()
                               until not getgenv().AutoFarm or not monster:FindFirstChild("Humanoid") or monster.Humanoid.Health <= 0
                           end
                       end
                   end
               end)
           end
       end)
   end,
})

-- [[ LÓGICA: SEA EVENTS ]] --
TabSea:CreateToggle({
   Name = "Auto Ataque Sea Beast & Barco",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoSea = Value
       task.spawn(function()
           while getgenv().AutoSea do
               task.wait(0.5)
               pcall(function()
                   for _, boss in pairs(workspace.Monster:GetChildren()) do
                       if boss.Name:find("Sea Beast") or boss.Name:find("Ghost Ship") then
                           if boss:FindFirstChild("HumanoidRootPart") and boss.Humanoid.Health > 0 then
                               LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 22, 0)
                               BypassAttack()
                           end
                       end
                   end
               end)
           end
       end)
   end,
})

-- [[ LÓGICA: TELEPORTS ]] --
TabTP:CreateDropdown({
   Name = "Selecionar Ilha (Seas 1, 2 e 3)",
   Options = {"Spawn Island", "Marineford", "Fishland", "Dressrosa", "Loaf Island", "Fiend Island"},
   CurrentOption = {"Spawn Island"},
   MultipleOptions = false,
   Callback = function(Option)
       local targetCF = IslandPositions[Option]
       if targetCF then
           DeltaSecureMove(targetCF, 280)
       end
   end,
})

-- [[ LÓGICA: VISUAIS / ESP ]] --
local function CreateDeltaESP(object, text, color)
    if object:FindFirstChild("DeltaESP") then return end
    local bbg = Instance.new("BillboardGui", object)
    bbg.Name = "DeltaESP"
    bbg.AlwaysOnTop = true
    bbg.Size = UDim2.new(0, 80, 0, 20)
    bbg.Adornee = object
    
    local lbl = Instance.new("TextLabel", bbg)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color
    lbl.TextSize = 12
    lbl.Text = text
end

TabVisual:CreateToggle({
   Name = "ESP Frutas (Otimizado)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().EspFrutas = Value
       if not Value then
           for _, v in pairs(workspace:GetDescendants()) do
               if v.Name == "DeltaESP" then v:Destroy() end
           end
       else
           task.spawn(function()
               while getgenv().EspFrutas do
                   task.wait(3)
                   for _, v in pairs(workspace:GetChildren()) do
                       if v:IsA("Tool") and v.Name:find("Fruit") and v:FindFirstChild("Handle") then
                           CreateDeltaESP(v.Handle, v.Name, Color3.fromRGB(0, 255, 100))
                       end
                   end
               end
           end)
       end
   end,
})

-- Notificação Delta Inicial
Rayfield:Notify({
   Title = "Delta Protegido!",
   Content = "Bypasses ativos e estáveis. Abra o menu no RightShift.",
   Duration = 4,
})
