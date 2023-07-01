local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()



local Window = OrionLib:MakeWindow({Name = "Lunar Ware 🌙 [BETA] ", HidePremium = false, SaveConfig = false, ConfigFolder = "OrionTest", IntroEnabled = false})

--[[
Name = <string> - The name of the UI.
HidePremium = <bool> - Whether or not the user details shows Premium status or not.
SaveConfig = <bool> - Toggles the config saving in the UI.
ConfigFolder = <string> - The name of the folder where the configs are saved.
IntroEnabled = <bool> - Whether or not to show the intro animation.
IntroText = <string> - Text to show in the intro animation.
IntroIcon = <string> - URL to the image you want to use in the intro animation.
Icon = <string> - URL to the image you want displayed on the window.
CloseCallback = <function> - Function to execute when the window is closed.
]]


local Tab = Window:MakeTab({
	Name = "Silent Aim",
	Icon = "rbxassetid://116881696",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Silent Aim"
})

Tab:AddButton({
	Name = "Load Lunar Silent 🌙",
	Callback = function()
      		

        getgenv().Yuth = {
            Silent = {
                Enabled = true,
                Keybind = "p",
                Prediction = 0.01172,
                AutoPrediction = false,
            },
            FOV = {
                Visible = true,
                Radius = 40,
            },
            Tracer = {
                Key = "Q",
                Enabled = true,
                Prediction = 0.0123018,
                Smoothness = 6.666,
            },
            Checks = {
                Death = true,
                Knocked = true,
                NoGroundShots = true,
            },
            Misc = {
                Shake = true,
                ShakeValue = 20.5,
            },
            Macro = {
                Enabled = false,
                Keybind = "q",
            },
        }
        --I removed the group so yall dumbasses can use it
        
        local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
        local Notify = AkaliNotif.Notify;
        
        --- the code shit
        getgenv().partlol = "Head"
        getgenv().partt = "Head"
        
        local Prey = nil 
        local Plr = nil
        
        local Players, Client, Mouse, RS, Camera =
        game:GetService("Players"),
        game:GetService("Players").LocalPlayer,
        game:GetService("Players").LocalPlayer:GetMouse(),
        game:GetService("RunService"),
        game.Workspace.CurrentCamera
        
        local Circle = Drawing.new("Circle")
        Circle.Color = Color3.new(1,1,1)
        Circle.Thickness = 1
        
        local UpdateFOV = function ()
        if (not Circle) then
            return Circle
        end
        Circle.Visible = getgenv().Yuth.FOV["Visible"]
        Circle.Radius = getgenv().Yuth.FOV["Radius"] * 3
        Circle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
        return Circle
        end
        
        RS.Heartbeat:Connect(UpdateFOV)
        
        
        ClosestPlrFromMouse = function()
        local Target, Closest = nil, 1/0
        
        for _ ,v in pairs(Players:GetPlayers()) do
            if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
        
                if (Circle.Radius > Distance and Distance < Closest and OnScreen) then
                    Closest = Distance
                    Target = v
                end
            end
        end
        return Target
        end
        
        local WTS = function (Object)
        local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
        return Vector2.new(ObjectVector.X, ObjectVector.Y)
        end
        
        local IsOnScreen = function (Object)
        local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
        return IsOnScreen
        end
        
        local FilterObjs = function (Object)
        if string.find(Object.Name, "Gun") then
            return
        end
        if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
            return true
        end
        end
        
        local GetClosestBodyPart = function (character)
        local ClosestDistance = 1/0
        local BodyPart = nil
        if (character and character:GetChildren()) then
            for _,  x in next, character:GetChildren() do
                if FilterObjs(x) and IsOnScreen(x) then
                    local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if (Circle.Radius > Distance and Distance < ClosestDistance) then
                        ClosestDistance = Distance
                        BodyPart = x
                    end
                end
            end
        end
        return BodyPart
        end
        
        local Prey
        
        task.spawn(function ()
        while task.wait() do
            if Prey then
                if getgenv().Yuth.Silent.Enabled then
                    getgenv().partlol = tostring(GetClosestBodyPart(Prey.Character))
                end
            end
        end
        end)
        
        local grmt = getrawmetatable(game)
        local backupindex = grmt.__index
        setreadonly(grmt, false)
        
        grmt.__index = newcclosure(function(self, v)
        if (getgenv().Yuth.Silent.Enabled and Mouse and tostring(v) == "Hit") then
        
            Prey = ClosestPlrFromMouse()
        
            if Prey then
                local endpoint = game.Players[tostring(Prey)].Character[getgenv().partlol].CFrame + (
                    game.Players[tostring(Prey)].Character[getgenv().partlol].Velocity * getgenv().Yuth.Silent.Prediction
                )
                return (tostring(v) == "Hit" and endpoint)
            end
        end
        return backupindex(self, v)
        end)
        
        local CC = game.Workspace.CurrentCamera
        local Mouse = game.Players.LocalPlayer:GetMouse()
        local Plr
        
        
        Mouse.KeyDown:Connect(function(Key)
            local Keybind = getgenv().Yuth.Tracer.Key:lower()
            if (Key == Keybind) then
                if getgenv().Yuth.Tracer.Enabled == true then
                    IsTargetting = not IsTargetting
                    if IsTargetting then
                        Plr = GetClosest()
                    else
                        if Plr ~= nil then
                            Plr = nil
                        end
                    end
                end
            end
        end)
        
        function GetClosest()
            local closestPlayer
            local shortestDistance = math.huge
            for i, v in pairs(game.Players:GetPlayers()) do
                pcall(function()
        
                    if v ~= game.Players.LocalPlayer and v.Character and
                        v.Character:FindFirstChild("Humanoid") then
                        local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                        local magnitude =
                        (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
                        if (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude < shortestDistance then
                            closestPlayer = v
                            shortestDistance = magnitude
                        end
                    end
                end)
            end
            return closestPlayer
        end
        
        local function IsOnScreen(Object)
            local IsOnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(Object.Position)
            return IsOnScreen
        end
        
        local function Filter(Object)
            if string.find(Object.Name, "Gun") then
                return
            end
            if Object:IsA("Part") or Object:IsA("MeshPart") then
                return true
            end
        end
        
        local function WTSPos(Position)
            local ObjectVector = game.Workspace.CurrentCamera:WorldToScreenPoint(Position)
            return Vector2.new(ObjectVector.X, ObjectVector.Y)
        end
        
        local function WTS(Object)
            local ObjectVector = game.Workspace.CurrentCamera:WorldToScreenPoint(Object.Position)
            return Vector2.new(ObjectVector.X, ObjectVector.Y)
        end
        
        function GetNearestPartToCursorOnCharacter(character)
            local ClosestDistance = math.huge
            local BodyPart = nil
        
            if (character and character:GetChildren()) then
                for k,  x in next, character:GetChildren() do
                    if Filter(x) and IsOnScreen(x) then
                        local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            
                        if Distance < ClosestDistance then
                            ClosestDistance = Distance
                            BodyPart = x
                        end
                    end
                end
            end
        
            return BodyPart
        end
        
        Mouse.KeyDown:Connect(function(Key)
            local Keybind = getgenv().Yuth.Silent.Keybind:lower()
            if (Key == Keybind) then
                    if getgenv().Yuth.Silent.Enabled == true then
                        getgenv().Yuth.Silent.Enabled = false
                        if getgenv().Yuth.Silent.Notifications == true then
                            Notify({
                                Description = "Silentaim Disabled";
                                Title = "Yuth";
                                Duration = 1.5;
                                });
                            
                        
                    else
                        getgenv().Yuth.Silent.Enabled = true
                        if getgenv().Yuth.Silent.Notifications == true then
                        Notify({
                            Description = "Silentaim Enabled";
                            Title = "Yuth";
                            Duration = 1.5;
                            });
                    end
                    end
                end
                    end
        end)
        
        
        RS.RenderStepped:Connect(function()
            if getgenv().Yuth.Checks.NoGroundShots == true and Prey.Character:FindFirstChild("Humanoid") == Enum.HumanoidStateType.Freefall then
                pcall(function()
                    local TargetVelv5 = targ.Character[getgenv().partlol]
                    TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 5), TargetVelv5.Velocity.Z)
                    TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 5), TargetVelv5.Velocity.Z)
                end)
            end
            
        if getgenv().Yuth.Checks.Death == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
                    if Plr.Character.Humanoid.health < 2 then
                        Plr = nil
                        IsTargetting = false
                    end
                end
                if getgenv().Yuth.Checks.Death == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
                    if Client.Character.Humanoid.health < 2 then
                        Plr = nil
                        IsTargetting = false
                    end
        end
                if getgenv().Yuth.Checks.Knocked == true and Prey and Prey.Character then 
                    local KOd = Prey.Character:WaitForChild("BodyEffects")["K.O"].Value
                    local Grabbed = Prey.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                    if KOd or Grabbed then
                        Prey = nil
                    end
            end
                if getgenv().Yuth.Checks.Knocked == true and Plr and Plr.Character then 
                    local KOd = Plr.Character:WaitForChild("BodyEffects")["K.O"].Value
                    local Grabbed = Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                    if KOd or Grabbed then
                        Plr = nil
                        IsTargetting = false
                    end
                end
        end)
        
        
        game.RunService.Heartbeat:Connect(function()
                if getgenv().Yuth.Misc.Shake then
                    local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().partt].Position + Plr.Character[getgenv().partt].Velocity * getgenv().Yuth.Tracer.Prediction +
                    Vector3.new(
                        math.random(-getgenv().Yuth.Misc.ShakeValue, getgenv().Yuth.Misc.ShakeValue),
                        math.random(-getgenv().Yuth.Misc.ShakeValue, getgenv().Yuth.Misc.ShakeValue),
                        math.random(-getgenv().Yuth.Misc.ShakeValue, getgenv().Yuth.Misc.ShakeValue)
                    ) * 0.1)
                    Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Yuth.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                else
                    local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().partt].Position + Plr.Character[getgenv().partt].Velocity * getgenv().Yuth.Tracer.Prediction)
                    Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Yuth.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                end
        end)
        
        task.spawn(function()
            while task.wait() do
                if getgenv().Yuth.Tracer.Enabled and Plr ~= nil and (Plr.Character) then
                    getgenv().partt = tostring(GetNearestPartToCursorOnCharacter(Plr.Character))
                end
            end
        end)
        
        
        local Player = game:GetService("Players").LocalPlayer
                    local Mouse = Player:GetMouse()
                    local SpeedGlitch = false
                    Mouse.KeyDown:Connect(function(Key)
                        if getgenv().Yuth.Macro.Enabled == true and Key == getgenv().Yuth.Macro.Keybind then
                            SpeedGlitch = not SpeedGlitch
                            if SpeedGlitch == true then
                                repeat game:GetService("RunService").Heartbeat:wait()
                                    keypress(0x49)
                                    game:GetService("RunService").Heartbeat:wait()
        
                                    keypress(0x4F)
                                    game:GetService("RunService").Heartbeat:wait()
        
                                    keyrelease(0x49)
                                    game:GetService("RunService").Heartbeat:wait()
        
                                    keyrelease(0x4F)
                                    game:GetService("RunService").Heartbeat:wait()
        
                                until SpeedGlitch == false
                            end
                        end
                    end)
                    
        
        
        while getgenv().Yuth.Silent.AutoPrediction == true do
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            local pingValue = string.split(ping, " ")[1]
            local pingNumber = tonumber(pingValue)
           
            if pingNumber < 30 then
                Yuth.Silent.Prediction = 0.12588
            elseif pingNumber < 40 then
                Yuth.Silent.Prediction = 0.119
            elseif pingNumber < 50 then
                Yuth.Silent.Prediction = 0.1247
            elseif pingNumber < 60 then
                Yuth.Silent.Prediction = 0.127668
            elseif pingNumber < 70 then
                Yuth.Silent.Prediction = 0.12731
            elseif pingNumber < 80 then
                Yuth.Silent.Prediction = 0.12951
            elseif pingNumber < 90 then
                Yuth.Silent.Prediction = 0.1318
            elseif pingNumber < 100 then
                Yuth.Silent.Prediction = 0.1357
            elseif pingNumber < 110 then
                Yuth.Silent.Prediction = 0.133340
                 elseif pingNumber < 120 then
                Yuth.Silent.Prediction = 0.1455
                 elseif pingNumber < 130 then
                Yuth.Silent.Prediction = 0.143765
                 elseif pingNumber < 140 then
                Yuth.Silent.Prediction = 0.156692
                 elseif pingNumber < 150 then
                Yuth.Silent.Prediction = 0.1223333
                 elseif pingNumber < 160 then
                Yuth.Silent.Prediction = 0.1521
                elseif pingNumber < 170 then
                Yuth.Silent.Prediction = 0.1626
                elseif pingNumber < 180 then
                Yuth.Silent.Prediction = 0.1923111
                elseif pingNumber < 190 then
                Yuth.Silent.Prediction = 0.19284
                elseif pingNumber < 200 then
                Yuth.Silent.Prediction = 0.166547
                elseif pingNumber < 210 then
                Yuth.Silent.Prediction = 0.16942
                elseif pingNumber < 260 then
                Yuth.Silent.Prediction = 0.1651
                elseif pingNumber < 310 then
                Yuth.Silent.Prediction = 0.16780
            end
         
            wait(0.1)
        end



  	end    
})



Tab:AddButton({
	Name = "Load Steamable Lunar Silent 🌙",
	Callback = function()
      		



        getgenv().Yuth = {
            Silent = {
                Enabled = true,
                Keybind = "p",
                Prediction = 0.01172,
                AutoPrediction = false,
            },
            FOV = {
                Visible = false,
                Radius = 40,
            },
            Tracer = {
                Key = "Q",
                Enabled = true,
                Prediction = 0.0123018,
                Smoothness = 6.666,
            },
            Checks = {
                Death = true,
                Knocked = true,
                NoGroundShots = true,
            },
            Misc = {
                Shake = true,
                ShakeValue = 20.5,
            },
            Macro = {
                Enabled = false,
                Keybind = "q",
            },
        }
        --I removed the group so yall dumbasses can use it
        
        local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
        local Notify = AkaliNotif.Notify;
        
        --- the code shit
        getgenv().partlol = "Head"
        getgenv().partt = "Head"
        
        local Prey = nil 
        local Plr = nil
        
        local Players, Client, Mouse, RS, Camera =
        game:GetService("Players"),
        game:GetService("Players").LocalPlayer,
        game:GetService("Players").LocalPlayer:GetMouse(),
        game:GetService("RunService"),
        game.Workspace.CurrentCamera
        
        local Circle = Drawing.new("Circle")
        Circle.Color = Color3.new(1,1,1)
        Circle.Thickness = 1
        
        local UpdateFOV = function ()
        if (not Circle) then
            return Circle
        end
        Circle.Visible = getgenv().Yuth.FOV["Visible"]
        Circle.Radius = getgenv().Yuth.FOV["Radius"] * 3
        Circle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
        return Circle
        end
        
        RS.Heartbeat:Connect(UpdateFOV)
        
        
        ClosestPlrFromMouse = function()
        local Target, Closest = nil, 1/0
        
        for _ ,v in pairs(Players:GetPlayers()) do
            if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
        
                if (Circle.Radius > Distance and Distance < Closest and OnScreen) then
                    Closest = Distance
                    Target = v
                end
            end
        end
        return Target
        end
        
        local WTS = function (Object)
        local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
        return Vector2.new(ObjectVector.X, ObjectVector.Y)
        end
        
        local IsOnScreen = function (Object)
        local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
        return IsOnScreen
        end
        
        local FilterObjs = function (Object)
        if string.find(Object.Name, "Gun") then
            return
        end
        if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
            return true
        end
        end
        
        local GetClosestBodyPart = function (character)
        local ClosestDistance = 1/0
        local BodyPart = nil
        if (character and character:GetChildren()) then
            for _,  x in next, character:GetChildren() do
                if FilterObjs(x) and IsOnScreen(x) then
                    local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if (Circle.Radius > Distance and Distance < ClosestDistance) then
                        ClosestDistance = Distance
                        BodyPart = x
                    end
                end
            end
        end
        return BodyPart
        end
        
        local Prey
        
        task.spawn(function ()
        while task.wait() do
            if Prey then
                if getgenv().Yuth.Silent.Enabled then
                    getgenv().partlol = tostring(GetClosestBodyPart(Prey.Character))
                end
            end
        end
        end)
        
        local grmt = getrawmetatable(game)
        local backupindex = grmt.__index
        setreadonly(grmt, false)
        
        grmt.__index = newcclosure(function(self, v)
        if (getgenv().Yuth.Silent.Enabled and Mouse and tostring(v) == "Hit") then
        
            Prey = ClosestPlrFromMouse()
        
            if Prey then
                local endpoint = game.Players[tostring(Prey)].Character[getgenv().partlol].CFrame + (
                    game.Players[tostring(Prey)].Character[getgenv().partlol].Velocity * getgenv().Yuth.Silent.Prediction
                )
                return (tostring(v) == "Hit" and endpoint)
            end
        end
        return backupindex(self, v)
        end)
        
        local CC = game.Workspace.CurrentCamera
        local Mouse = game.Players.LocalPlayer:GetMouse()
        local Plr
        
        
        Mouse.KeyDown:Connect(function(Key)
            local Keybind = getgenv().Yuth.Tracer.Key:lower()
            if (Key == Keybind) then
                if getgenv().Yuth.Tracer.Enabled == true then
                    IsTargetting = not IsTargetting
                    if IsTargetting then
                        Plr = GetClosest()
                    else
                        if Plr ~= nil then
                            Plr = nil
                        end
                    end
                end
            end
        end)
        
        function GetClosest()
            local closestPlayer
            local shortestDistance = math.huge
            for i, v in pairs(game.Players:GetPlayers()) do
                pcall(function()
        
                    if v ~= game.Players.LocalPlayer and v.Character and
                        v.Character:FindFirstChild("Humanoid") then
                        local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                        local magnitude =
                        (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
                        if (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude < shortestDistance then
                            closestPlayer = v
                            shortestDistance = magnitude
                        end
                    end
                end)
            end
            return closestPlayer
        end
        
        local function IsOnScreen(Object)
            local IsOnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(Object.Position)
            return IsOnScreen
        end
        
        local function Filter(Object)
            if string.find(Object.Name, "Gun") then
                return
            end
            if Object:IsA("Part") or Object:IsA("MeshPart") then
                return true
            end
        end
        
        local function WTSPos(Position)
            local ObjectVector = game.Workspace.CurrentCamera:WorldToScreenPoint(Position)
            return Vector2.new(ObjectVector.X, ObjectVector.Y)
        end
        
        local function WTS(Object)
            local ObjectVector = game.Workspace.CurrentCamera:WorldToScreenPoint(Object.Position)
            return Vector2.new(ObjectVector.X, ObjectVector.Y)
        end
        
        function GetNearestPartToCursorOnCharacter(character)
            local ClosestDistance = math.huge
            local BodyPart = nil
        
            if (character and character:GetChildren()) then
                for k,  x in next, character:GetChildren() do
                    if Filter(x) and IsOnScreen(x) then
                        local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            
                        if Distance < ClosestDistance then
                            ClosestDistance = Distance
                            BodyPart = x
                        end
                    end
                end
            end
        
            return BodyPart
        end
        
        Mouse.KeyDown:Connect(function(Key)
            local Keybind = getgenv().Yuth.Silent.Keybind:lower()
            if (Key == Keybind) then
                    if getgenv().Yuth.Silent.Enabled == true then
                        getgenv().Yuth.Silent.Enabled = false
                        if getgenv().Yuth.Silent.Notifications == true then
                            Notify({
                                Description = "Silentaim Disabled";
                                Title = "Yuth";
                                Duration = 1.5;
                                });
                            
                        
                    else
                        getgenv().Yuth.Silent.Enabled = true
                        if getgenv().Yuth.Silent.Notifications == true then
                        Notify({
                            Description = "Silentaim Enabled";
                            Title = "Yuth";
                            Duration = 1.5;
                            });
                    end
                    end
                end
                    end
        end)
        
        
        RS.RenderStepped:Connect(function()
            if getgenv().Yuth.Checks.NoGroundShots == true and Prey.Character:FindFirstChild("Humanoid") == Enum.HumanoidStateType.Freefall then
                pcall(function()
                    local TargetVelv5 = targ.Character[getgenv().partlol]
                    TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 5), TargetVelv5.Velocity.Z)
                    TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 5), TargetVelv5.Velocity.Z)
                end)
            end
            
        if getgenv().Yuth.Checks.Death == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
                    if Plr.Character.Humanoid.health < 2 then
                        Plr = nil
                        IsTargetting = false
                    end
                end
                if getgenv().Yuth.Checks.Death == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
                    if Client.Character.Humanoid.health < 2 then
                        Plr = nil
                        IsTargetting = false
                    end
        end
                if getgenv().Yuth.Checks.Knocked == true and Prey and Prey.Character then 
                    local KOd = Prey.Character:WaitForChild("BodyEffects")["K.O"].Value
                    local Grabbed = Prey.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                    if KOd or Grabbed then
                        Prey = nil
                    end
            end
                if getgenv().Yuth.Checks.Knocked == true and Plr and Plr.Character then 
                    local KOd = Plr.Character:WaitForChild("BodyEffects")["K.O"].Value
                    local Grabbed = Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                    if KOd or Grabbed then
                        Plr = nil
                        IsTargetting = false
                    end
                end
        end)
        
        
        game.RunService.Heartbeat:Connect(function()
                if getgenv().Yuth.Misc.Shake then
                    local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().partt].Position + Plr.Character[getgenv().partt].Velocity * getgenv().Yuth.Tracer.Prediction +
                    Vector3.new(
                        math.random(-getgenv().Yuth.Misc.ShakeValue, getgenv().Yuth.Misc.ShakeValue),
                        math.random(-getgenv().Yuth.Misc.ShakeValue, getgenv().Yuth.Misc.ShakeValue),
                        math.random(-getgenv().Yuth.Misc.ShakeValue, getgenv().Yuth.Misc.ShakeValue)
                    ) * 0.1)
                    Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Yuth.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                else
                    local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().partt].Position + Plr.Character[getgenv().partt].Velocity * getgenv().Yuth.Tracer.Prediction)
                    Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Yuth.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                end
        end)
        
        task.spawn(function()
            while task.wait() do
                if getgenv().Yuth.Tracer.Enabled and Plr ~= nil and (Plr.Character) then
                    getgenv().partt = tostring(GetNearestPartToCursorOnCharacter(Plr.Character))
                end
            end
        end)
        
        
        local Player = game:GetService("Players").LocalPlayer
                    local Mouse = Player:GetMouse()
                    local SpeedGlitch = false
                    Mouse.KeyDown:Connect(function(Key)
                        if getgenv().Yuth.Macro.Enabled == true and Key == getgenv().Yuth.Macro.Keybind then
                            SpeedGlitch = not SpeedGlitch
                            if SpeedGlitch == true then
                                repeat game:GetService("RunService").Heartbeat:wait()
                                    keypress(0x49)
                                    game:GetService("RunService").Heartbeat:wait()
        
                                    keypress(0x4F)
                                    game:GetService("RunService").Heartbeat:wait()
        
                                    keyrelease(0x49)
                                    game:GetService("RunService").Heartbeat:wait()
        
                                    keyrelease(0x4F)
                                    game:GetService("RunService").Heartbeat:wait()
        
                                until SpeedGlitch == false
                            end
                        end
                    end)
                    
        
        
        while getgenv().Yuth.Silent.AutoPrediction == true do
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            local pingValue = string.split(ping, " ")[1]
            local pingNumber = tonumber(pingValue)
           
            if pingNumber < 30 then
                Yuth.Silent.Prediction = 0.12588
            elseif pingNumber < 40 then
                Yuth.Silent.Prediction = 0.119
            elseif pingNumber < 50 then
                Yuth.Silent.Prediction = 0.1247
            elseif pingNumber < 60 then
                Yuth.Silent.Prediction = 0.127668
            elseif pingNumber < 70 then
                Yuth.Silent.Prediction = 0.12731
            elseif pingNumber < 80 then
                Yuth.Silent.Prediction = 0.12951
            elseif pingNumber < 90 then
                Yuth.Silent.Prediction = 0.1318
            elseif pingNumber < 100 then
                Yuth.Silent.Prediction = 0.1357
            elseif pingNumber < 110 then
                Yuth.Silent.Prediction = 0.133340
                 elseif pingNumber < 120 then
                Yuth.Silent.Prediction = 0.1455
                 elseif pingNumber < 130 then
                Yuth.Silent.Prediction = 0.143765
                 elseif pingNumber < 140 then
                Yuth.Silent.Prediction = 0.156692
                 elseif pingNumber < 150 then
                Yuth.Silent.Prediction = 0.1223333
                 elseif pingNumber < 160 then
                Yuth.Silent.Prediction = 0.1521
                elseif pingNumber < 170 then
                Yuth.Silent.Prediction = 0.1626
                elseif pingNumber < 180 then
                Yuth.Silent.Prediction = 0.1923111
                elseif pingNumber < 190 then
                Yuth.Silent.Prediction = 0.19284
                elseif pingNumber < 200 then
                Yuth.Silent.Prediction = 0.166547
                elseif pingNumber < 210 then
                Yuth.Silent.Prediction = 0.16942
                elseif pingNumber < 260 then
                Yuth.Silent.Prediction = 0.1651
                elseif pingNumber < 310 then
                Yuth.Silent.Prediction = 0.16780
            end
         
            wait(0.1)
        end





  	end    
})
-- end silent




local Tab = Window:MakeTab({
	Name = "Aimlock",
	Icon = "rbxassetid://2215351502",
	PremiumOnly = false
})




local Section = Tab:AddSection({
	Name = "Aimlock"
})



Tab:AddButton({
	Name = "Load Lunar Lock 🌙",
	Callback = function()
      		





        getgenv().dot = {
            Main = {
            Enabled = true,
            Keybind = Enum.KeyCode.Q,
            HitPart = "HumanoidRootPart", --Options: "Head", "UpperTorso", "HumanoidRootPart" or "LowerTorso" ~ Other: "Random Upper", "Random Lower" and "Crazy"
            Airshot_function = true,
            --
            Prediction_Amount = 0.165,
            Auto_Prediction = true,
            Auto_Prediction_Section = {
            P10 = 0.135,
            P20 = 0.05,
            P30 = 0.1,
            P40 = 0.11,
            P50 = 0.114,
            P60 = 0.121,
            P70 = 0.125,
            P80 = 0.129,
            P90 = 0.1295,
            P100 = 0.13,
            P110 = 0.1315,
            P120 = 0.1344,
            P130 = 0.1411,
            P140 = 0.15,
            P150 = 0.1555,
            },
            --
            Notifcation = false,
            Notifcation_Type = "Kali", -- Types: "Xaxa", "Kali" or "Roblox"
            },
            
            Checks = {
            KOCheck = true,
            WallkCheck = false,
            DeadCheck = false,
            },
            
            Box_Visual = {
            Visible = true,
            --
            Color = Color3.fromRGB(105, 95, 245),
            Transparency = 0.3,
            Shape = "Box", -- Options: "Ball", "Box", "Cylinder"
            Size = "Medium",-- Options: "Small", "Medium", "Large"
            Material = "SmoothPlastic", -- Options: "ForceField", "SmoothPlastic", "Neon" or "Glass"
            },
            
            Dot_Visual = {
            Visible = true,
            --
            Color = Color3.fromRGB(255, 255, 255),
            Size = "Small", -- Options: "Small", "Medium", Large
            
            },
            
            Fov_Visual = {
            Visible = false,
            --
            Color = Color3.fromRGB(0, 0, 0),
            Filled = false,
            Radius = 120,
            Transparency = 0.7,
            NumSides = 0,
            Thickness = 0,
            
            },
            
            HighLight_Visual = {
            Highlight_Target = false,
            Highlight_Color_Fill = Color3.fromRGB(105, 95, 245),
            Highlight_Color_OutLine = Color3.fromRGB(255, 255, 255),
            
            },
            --
            
            Gun_Visuals = {
            
            -- Important --
            Game = "Da hood", -- Options: "Untitled Hood", "Hood Customs", "Dh Aim Trainer" and "Da hood"
            
            -- Main --
            Enable = true,
            GunMats = "Neon",
            GunColor = Color3.fromRGB(105, 95, 245), -- Use Bright Colors To Get That Glow Effect If Ur Using "Neon" --
            GunReflectance = 1,
            GunTransparency = 0,
            
            -- Gun Beam --
            GunBeam = true,
            GunBeamColor = Color3.fromRGB(105, 95, 245),
            
            -- Extra --
            GunTexture = false,
            GunTextureId = "11516328794",
            },
            --
            
            Visuals = {
            Enabled = false,
            Dead_Chams = false,
            Dead_Chams_Color = Color3.fromRGB(105, 95, 245),
            
            
            },
            
            }
            
            
            
            --------------------------------------------
            
            local notificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/xaxas-notification/src.lua"))();
            local notifications = notificationLibrary.new({
            NotificationLifetime = 1.5,
            NotificationPosition = "Middle",
            
            TextFont = Enum.Font.Code,
            TextColor = Color3.fromRGB(255, 255, 255),
            TextSize = 17,
            
            TextStrokeTransparency = 0,
            TextStrokeColor = Color3.fromRGB(0, 0, 0)
            });
            
            --
            
            local NotifyLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))()
            local Notify = NotifyLibrary.Notify
            
            
            --------------------------------------------
            
            
            repeat
            wait()
            until game:IsLoaded()
            
            
            --// Dot
            local placemarker = Instance.new("Part", game.Workspace)
            
            function makemarker(Parent, Adornee, Color, Size, Size2)
            local e = Instance.new("BillboardGui", Parent)
            e.Name = "haunts0001"
            e.Adornee = Adornee
            e.Size = UDim2.new(Size, Size2, Size, Size2)
            e.AlwaysOnTop = true
            local a = Instance.new("Frame", e)
            a.Size = UDim2.new(1, 0, 1, 0)
            a.BackgroundTransparency = 0
            a.BackgroundColor3 = Color
            local g = Instance.new("UICorner", a)
            g.CornerRadius = UDim.new(50, 50)
            return(e)
            end
            
            local data = game.Players:GetPlayers()
            
            function noob(player)
            local character
            repeat wait() until player.Character
            local handler = makemarker(guimain, player.Character:WaitForChild("HumanoidRootPart"), getgenv().dot.Dot_Visual.Color, 0.3, 3)
            handler.Name = player.Name
            player.CharacterAdded:connect(function(Char) handler.Adornee = Char:WaitForChild("HumanoidRootPart") end)
            end
            
            for i = 1, #data do
            if data[i] ~= game.Players.LocalPlayer then
            noob(data[i])
            end
            end
            
            game.Players.PlayerAdded:connect(function(Player)
            noob(Player)
            end)
            
            spawn(function()
            placemarker.Anchored = true
            placemarker.CanCollide = false
            placemarker.Transparency = 1
            if getgenv().dot.Dot_Visual.Visible then
            makemarker(placemarker, placemarker, getgenv().dot.Dot_Visual.Color , 0.40, 0)
            end
            end)
            
            
            --// Box Misc
            local Tracer = Instance.new("Part", game.Workspace)
            Tracer.Name = "haunts0001"
            Tracer.Anchored = true
            Tracer.CanCollide = false
            Tracer.Transparency = getgenv().dot.Box_Visual.Transparency
            Tracer.Parent = game.Workspace
            Tracer.Color = getgenv().dot.Box_Visual.Color
            Tracer.Material = getgenv().dot.Box_Visual.Material
            
            if getgenv().dot.Box_Visual.Shape == "Ball" then
            Tracer.Shape = Enum.PartType.Ball
            elseif getgenv().dot.Box_Visual.Shape == "Box" then
            Tracer.Shape = Enum.PartType.Block
            elseif getgenv().dot.Box_Visual.Shape == "Cylinder" then
            Tracer.Shape = Enum.PartType.Cylinder
            end
            
            
            if getgenv().dot.Box_Visual.Size == "Small" then
            Tracer.Size = Vector3.new(4, 4, 4)
            elseif getgenv().dot.Box_Visual.Size == "Medium" then
            Tracer.Size = Vector3.new(7, 7, 7)
            elseif getgenv().dot.Box_Visual.Size == "Large" then
            Tracer.Size = Vector3.new(12, 12, 12)
            end
            
            
            --// Circle
            local plry = game.Players.LocalPlayer
            local mouse = plry:GetMouse()
            local Runserv = game:GetService("RunService")
            
            circle = Drawing.new("Circle")
            circle.Color = getgenv().dot.Fov_Visual.Color
            circle.Thickness = getgenv().dot.Fov_Visual.Thickness
            circle.NumSides = getgenv().dot.Fov_Visual.NumSides
            circle.Radius = getgenv().dot.Fov_Visual.Radius
            circle.Thickness = getgenv().dot.Fov_Visual.Thickness
            circle.Transparency = getgenv().dot.Fov_Visual.Transparency
            circle.Visible = getgenv().dot.Fov_Visual.Visible
            circle.Filled = getgenv().dot.Fov_Visual.Filled
            
            Runserv.RenderStepped:Connect(function()
            circle.Position = Vector2.new(mouse.X,mouse.Y+35)
            end)
            
            local guimain = Instance.new("Folder", game.CoreGui)
            local CC = game:GetService("Workspace").CurrentCamera
            local LocalMouse = game.Players.LocalPlayer:GetMouse()
            local Locking = false
            
            
            --
            if getgenv().CheckIfScriptLoaded == true then
            game.StarterGui:SetCore("SendNotification", {
            Title = "dot.lua",
            Text = "Already Loaded!",
            Duration = 3,
            Icon = "rbxassetid://12990104891"
            })
            return
            end
            
            getgenv().CheckIfScriptLoaded = true
            
            local UserInputService = game:GetService("UserInputService")
            local LocalHL = Instance.new("Highlight")
            
            UserInputService.InputBegan:Connect(function(keygo,ok)
            if (not ok) then
            if (keygo.KeyCode == getgenv().dot.Main.Keybind) then
            if getgenv().dot.Main.Enabled == true then
            Locking = not Locking
            
            if Locking then
            Plr = getClosestPlayerToCursor()
            
            --// Notifications
            if getgenv().dot.HighLight_Visual.Highlight_Target == true then
            LocalHL.Parent = Plr.Character
            LocalHL.FillColor = getgenv().dot.HighLight_Visual.Highlight_Color_Fill
            LocalHL.OutlineColor = getgenv().dot.HighLight_Visual.Highlight_Color_OutLine
            else
            LocalHL.Parent = game.CoreGui
            end
            
            if getgenv().dot.Main.Notifcation == true and getgenv().dot.Main.Notifcation_Type == "Roblox" then
            game.StarterGui:SetCore("SendNotification", {
            Title = "dot.lua";
            Text = "Locked to: "..tostring(Plr.Character.Humanoid.DisplayName);
            Icon = "rbxassetid://12990104891"
            })
            elseif getgenv().dot.Main.Notifcation == true and getgenv().dot.Main.Notifcation_Type == "Xaxa" then
            notifications:BuildNotificationUI();
            notifications:Notify("Locked to: " .. Plr.Character.Humanoid.DisplayName);
            elseif getgenv().dot.Main.Notifcation == true and getgenv().dot.Main.Notifcation_Type == "Kali" then
            Notify({
            Title = "dot.lua",
            Description = "Locked to: " .. Plr.Character.Humanoid.DisplayName,
            Duration = 4
            })
            end
            
            
            elseif not Locking then
            
            if getgenv().dot.HighLight_Visual.Highlight_Target == true then
            LocalHL.Parent = game.CoreGui
            end
            
            if getgenv().dot.Main.Notifcation == true and getgenv().dot.Main.Notifcation_Type == "Roblox" then
            game.StarterGui:SetCore("SendNotification", {
            Title = "dot.lua";
            Text = "Unlocked";
            Icon = "rbxassetid://12990104891"
            })
            elseif getgenv().dot.Main.Notifcation == true and getgenv().dot.Main.Notifcation_Type == "Xaxa" then
            notifications:BuildNotificationUI();
            notifications:Notify("Unlocked");
            elseif getgenv().dot.Main.Notifcation == true and getgenv().dot.Main.Notifcation_Type == "Kali" then
            Notify({
            Title = "dot.lua",
            Description = "Unlocked",
            Duration = 4
            })
            elseif getgenv().dot.Main.Enabled == false then
            game.StarterGui:SetCore("SendNotification", {
            Title = "dot.lua",
            Text = "Target isn't enabled",
            Duration = 5,
            Icon = "rbxassetid://12990104891"
            
            })
            end
            end
            end
            end
            end
            end)
            
            --
            
            function getClosestPlayerToCursor()
            local closestPlayer
            local shortestDistance = circle.Radius
            
            for i, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("LowerTorso") then
            local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(LocalMouse.X, LocalMouse.Y)).magnitude
            if magnitude < shortestDistance then
            closestPlayer = v
            shortestDistance = magnitude
            end
            end
            end
            return closestPlayer
            end
            
            --
            
            if getgenv().dot.Box_Visual.Visible then
            game:GetService("RunService").RenderStepped:connect(function()
            if Locking and Plr.Character:FindFirstChild("HumanoidRootPart") then
            Tracer.CFrame = CFrame.new(Plr.Character.HumanoidRootPart.Position + (Plr.Character.HumanoidRootPart.Velocity * getgenv().dot.Main.Prediction_Amount))
            else
            Tracer.CFrame = CFrame.new(0, 9999, 0)
            end
            end)
            end
            
            if getgenv().dot.Dot_Visual.Visible then
            game:GetService("RunService").RenderStepped:connect(function()
            if Locking and Plr.Character:FindFirstChild("HumanoidRootPart") then
            placemarker.CFrame = CFrame.new(Plr.Character.HumanoidRootPart.Position + (Plr.Character.HumanoidRootPart.Velocity * getgenv().dot.Main.Prediction_Amount))
            else
            placemarker.CFrame = CFrame.new(0, 9999, 0)
            end
            end)
            end
            
            --
            
            local rawmetatable = getrawmetatable(game)
            local old = rawmetatable.__namecall
            setreadonly(rawmetatable, false)
            rawmetatable.__namecall = newcclosure(function(...)
            local args = {...}
            if Locking and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
            args[3] = Plr.Character[getgenv().dot.Main.HitPart].Position+(Plr.Character[getgenv().dot.Main.HitPart].Velocity * getgenv().dot.Main.Prediction_Amount)
            return old(unpack(args))
            end
            return old(...)
            end)
            
            
            local networtserviceping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            local networthmax = string.split(networtserviceping,'(')
            local ping = tonumber(networthmax[1])
            
            if getgenv().dot.Main.Auto_Prediction == false then
            if ping < 150 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P150
            elseif ping < 140 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P140
            elseif ping < 130 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P130
            elseif ping < 120 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P120
            elseif ping < 110 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P110
            elseif ping < 100 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P100
            elseif ping < 90 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P90
            elseif ping < 80 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P80
            elseif ping < 70 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P70
            elseif ping < 60 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P60
            elseif ping < 50 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P50
            elseif ping < 40 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P40
            elseif ping < 30 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P30
            elseif ping < 20 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P20
            elseif ping < 10 then
            getgenv().dot.Main.Prediction_Amount = getgenv().dot.Main.Auto_Prediction_Section.P10
            end
            end
            
            
            --// Dead Chams
            game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().dot.Visuals.Dead_Chams == true then
            for i, v in pairs(game.Players:GetChildren()) do
            if v.Name ~= game.Players.LocalPlayer.Name then
            if v.Character and v.Character:FindFirstChild("Humanoid") then
            if v.Character:WaitForChild("BodyEffects") and v.Character.Humanoid.health < 3 then
            for _, k in pairs(v.Character:GetChildren()) do
            if k:IsA "BasePart" and not k:FindFirstChild "Cham" then
            
            local cham = Instance.new("BoxHandleAdornment", k)
            
            cham.ZIndex = 10
            cham.Adornee = k
            cham.AlwaysOnTop = true
            cham.Size = k.Size
            cham.Transparency = 0.5
            cham.Color3 = getgenv().dot.Visuals.Dead_Chams_Color
            cham.Name = "Cham"
            
            end
            end
            else
            for _, k in pairs(v.Character:GetChildren()) do
            if k:IsA "BasePart" and k:FindFirstChild "Cham" then
            k:FindFirstChild("Cham"):Destroy()
            end
            end
            end
            end
            end
            end
            end
            end)
            
            --
            
            game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().dot.Gun_Visuals.GunBeam == true then
            for _,v in pairs(game.Workspace.Ignored:GetChildren()) do
            if v.Name == "BULLET_RAYS" then
            for _,f in pairs(v:GetChildren()) do
            if f.Name == "GunBeam" then
            --
            f.Brightness = 10
            f.TextureSpeed = 1
            f.TextureLength = 10
            f.LightInfluence = -1
            f.Width0 = 0.1
            f.Width1 = 0.1
            f.LightEmission = 1
            f.Texture = "rbxassetid://1215691065"
            f.Segments = 0
            f.FaceCamera = true
            --
            f.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, getgenv().dot.Gun_Visuals.GunBeamColor),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 95, 245)),
            ColorSequenceKeypoint.new(1, getgenv().dot.Gun_Visuals.GunBeamColor)
            }
            --
            end
            end
            end
            end
            end
            end)
            
            
            while true do
            wait(0.5)
            
            -- Untitled Hood --
            
            if getgenv().dot.Gun_Visuals.Game == "Untitled Hood" and game.PlaceId == 9183932460 then
            
            local lp = game:GetService("Players").LocalPlayer
            local lpn = game:GetService("Players").LocalPlayer.Name
            
            local dbcheck = lp.Backpack:FindFirstChild("[Double-Barrel SG]") or lp.Character:FindFirstChild("[Double-Barrel SG]")
            local revcheck = lp.Backpack:FindFirstChild("[Revolver]") or lp.Character:FindFirstChild("[Revolver]")
            local smgcheck = lp.Backpack:FindFirstChild("[SMG]") or lp.Character:FindFirstChild("[SMG]")
            
            
            if getgenv().dot.Gun_Visuals.Enable == true then
            
            if dbcheck and not lp:FindFirstChildOfClass("[Double-Barrel SG]") then
            
            dbcheck.Default.Material = getgenv().dot.Gun_Visuals.GunMats
            
            dbcheck.Default.Color = getgenv().dot.Gun_Visuals.GunColor
            
            dbcheck.Default.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            dbcheck.Default.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            dbcheck.Default.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            dbcheck.Default.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            dbcheck.Default.TextureID = ''
            end
            end
            
            if revcheck and not lp:FindFirstChildOfClass("[Revolver]") then
            
            revcheck.Default.Material = getgenv().dot.Gun_Visuals.GunMats
            
            revcheck.Default.Color = getgenv().dot.Gun_Visuals.GunColor
            
            revcheck.Default.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            revcheck.Default.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            revcheck.Default.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            revcheck.Default.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            revcheck.Default.TextureID = ''
            end
            end
            
            if smgcheck and not lp:FindFirstChildOfClass("[SMG]") then
            
            smgcheck.Default.Material = getgenv().dot.Gun_Visuals.GunMats
            
            smgcheck.Default.Color = getgenv().dot.Gun_Visuals.GunColor
            
            smgcheck.Default.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            smgcheck.Default.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            smgcheck.Default.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            smgcheck.Default.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            smgcheck.Default.TextureID = ''
            end
            
            end
            end
            end
            
            if getgenv().dot.Gun_Visuals.Game == "Dh Aim Trainer" and game.PlaceId == 7242996350 then
            
            local lp = game:GetService("Players").LocalPlayer
            local lpn = game:GetService("Players").LocalPlayer.Name
            
            
            local dbcheck11 = lp.Backpack:FindFirstChild("[Double-Barrel SG]") or lp.Character:FindFirstChild("[Double-Barrel SG]")
            local revcheck11 = lp.Backpack:FindFirstChild("[Revolver]") or lp.Character:FindFirstChild("[Revolver]")
            
            
            if getgenv().dot.Gun_Visuals.Enable == true then
            
            
            if dbcheck11 and not lp:FindFirstChildOfClass("[Double-Barrel SG]") then
            
            dbcheck11.Handle.Material = getgenv().dot.Gun_Visuals.GunMats
            
            dbcheck11.Handle.Color = getgenv().dot.Gun_Visuals.GunColor
            
            dbcheck11.Handle.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            dbcheck11.Handle.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            dbcheck11.Handle.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            dbcheck11.Handle.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            dbcheck11.Handle.TextureID = ''
            end
            
            end
            
            if revcheck11 and not lp:FindFirstChildOfClass("[Revolver]") then
            
            revcheck11.Handle.Material = getgenv().dot.Gun_Visuals.GunMats
            
            revcheck11.Handle.Color = getgenv().dot.Gun_Visuals.GunColor
            
            revcheck11.Handle.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            revcheck11.Handle.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            revcheck11.Handle.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            revcheck11.Handle.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            revcheck11.Handle.TextureID = ''
            end
            
            end
            end
            end
            
            
            -- Hood Customs --
            
            if getgenv().dot.Gun_Visuals.Game == "Hood Customs" and game.PlaceId == 9825515356 then
            
            
            local lp = game:GetService("Players").LocalPlayer
            local lpn = game:GetService("Players").LocalPlayer.Name
            local Wk = game:GetService("Workspace")
            
            
            local dbcheck22 = lp.Backpack:FindFirstChild("[DoubleBarrel]") or lp.Character:FindFirstChild("[DoubleBarrel]")
            local revcheck22 = lp.Backpack:FindFirstChild("[Revolver]") or lp.Character:FindFirstChild("[Revolver]")
            local smgggcheck22 = lp.Backpack:FindFirstChild("[SMG]") or lp.Character:FindFirstChild("[SMG]")
            
            
            if getgenv().dot.Gun_Visuals.Enable == true then
            
            if dbcheck22 and not lp:FindFirstChildOfClass("[DoubleBarrel]") then
            
            dbcheck22.Handle.Material = getgenv().dot.Gun_Visuals.GunMats
            
            dbcheck22.Handle.Color = getgenv().dot.Gun_Visuals.GunColor
            
            dbcheck22.Handle.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            dbcheck22.Handle.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            dbcheck22.Handle.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            dbcheck22.Default.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            dbcheck22.Default.TextureID = ''
            end
            
            end
            
            if revcheck22 and not lp:FindFirstChildOfClass("[Revolver]") then
            
            revcheck22.Handle.Material = getgenv().dot.Gun_Visuals.GunMats
            
            revcheck22.Handle.Color = getgenv().dot.Gun_Visuals.GunColor
            
            revcheck22.Handle.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            revcheck22.Handle.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            revcheck22.Handle.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            revcheck22.Default.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            revcheck22.Default.TextureID = ''
            end
            end
            
            if smgggcheck22 and not lp:FindFirstChildOfClass("[SMG]") then
            
            smgggcheck22.Handle.Material = getgenv().dot.Gun_Visuals.GunMats
            
            smgggcheck22.Handle.Color = getgenv().dot.Gun_Visuals.GunColor
            
            smgggcheck22.Handle.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            smgggcheck22.Handle.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            smgggcheck22.Handle.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            smgcheck22.Default.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            smgcheck22.Default.TextureID = ''
            end
            
            end
            end
            end
            
            -- Da hood --
            
            if getgenv().dot.Gun_Visuals.Game == "Da hood" and game.PlaceId == 2788229376 then
            
            local lp = game:GetService("Players").LocalPlayer
            local lpn = game:GetService("Players").LocalPlayer.Name
            local Wk = game:GetService("Workspace")
            
            
            local dbcheck33 = lp.Backpack:FindFirstChild("[Double-Barrel SG]") or lp.Character:FindFirstChild("[Double-Barrel SG]")
            local revcheck33 = lp.Backpack:FindFirstChild("[Revolver]") or lp.Character:FindFirstChild("[Revolver]")
            local smgggcheck33 = lp.Backpack:FindFirstChild("[SMG]") or lp.Character:FindFirstChild("[SMG]")
            
            if getgenv().dot.Gun_Visuals.Enable == true then
            
            if dbcheck33 and not lp:FindFirstChildOfClass("[Double-Barrel SG]") then
            
            dbcheck33.Default.Material = getgenv().dot.Gun_Visuals.GunMats
            
            dbcheck33.Default.Color = getgenv().dot.Gun_Visuals.GunColor
            
            dbcheck33.Default.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            dbcheck33.Default.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            dbcheck33.Default.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            dbcheck33.Default.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            dbcheck33.Default.TextureID = ''
            end
            end
            
            if revcheck33 and not lp:FindFirstChildOfClass("[Revolver]") then
            
            revcheck33.Default.Material = getgenv().dot.Gun_Visuals.GunMats
            
            revcheck33.Default.Color = getgenv().dot.Gun_Visuals.GunColor
            
            revcheck33.Default.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            revcheck33.Default.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            revcheck33.Default.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            revcheck33.Default.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            revcheck33.Default.TextureID = ''
            end
            
            end
            
            if smgggcheck33 and not lp:FindFirstChildOfClass("[SMG]") then
            
            smgggcheck33.Default.Material = getgenv().dot.Gun_Visuals.GunMats
            
            smgggcheck33.Default.Color = getgenv().dot.Gun_Visuals.GunColor
            
            smgggcheck33.Default.Reflectance = getgenv().dot.Gun_Visuals.GunReflectance
            
            smgggcheck33.Default.Transparency = getgenv().dot.Gun_Visuals.GunTransparency
            
            smgggcheck33.Default.TextureID = ''
            
            if getgenv().dot.Gun_Visuals.GunTexture == true then
            smgcheck33.Default.TextureID = getgenv().dot.Gun_Visuals.GunTextureId
            else
            smgcheck33.Default.TextureID = ''
            end
            
            end
            end
            end
            wait(30)
            end








  	end    
})




local Tab = Window:MakeTab({
	Name = "Aimviewer",
	Icon = "rbxassetid://13691551134",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Aimviewer"
})


Tab:AddButton({
	Name = "Load Lunar Aimviewer 🌙",
	Callback = function()
      		

        _G.enable = false
        _G.color = Color3.fromRGB(242, 255, 0)
        _G.toggle_keybind = "i" -- enable tracer and disable
        _G.swith_nigga = 't' -- press t and u will see a noti on the user ur tracer is on 
        _G.method = "MousePos" --had a stroke sotkraakdakdakdkadkadkakdakdakdkdakdakdkadkadka
        
        if game.PlaceId == 2788229376 then
            _G.method = "MousePos"
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        ---------------------------------------------------------------
        local rs = game:GetService("RunService")
        local localPlayer = game.Players.LocalPlayer
        local mouse = localPlayer:GetMouse()
        local target;
        
        
        
        function getgun()
            for i,v in pairs(target.Character:GetChildren()) do
                if v and (v:FindFirstChild('Default') or v:FindFirstChild('Handle') )then
                    return v
                end
            end
        end
        
        function sendnotifi(message)
        
        
            game.StarterGui:SetCore("SendNotification", {
                Title = '';
                Text = message;
                Duration = "1";
            })
        
        end
        
        
        function get_closet()
            local a = math.huge
            local b;
        
        
        
            for i, v in pairs(game.Players:GetPlayers()) do
                if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Head") and  v.Character:FindFirstChild("HumanoidRootPart")  then
                    local c = game.Workspace.CurrentCamera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    local d = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(c.X, c.Y)).Magnitude
        
                    if a > d then
                        b = v
                        a = d
                    end
                end
            end
        
            return b
        end
        
        --- 
        mouse.KeyDown:Connect(function(z)
            if z == _G.toggle_keybind then
                if _G.enable == false then
                    _G.enable = true
                    sendnotifi("enabled")
                elseif _G.enable == true then
                    _G.enable = false 
                    sendnotifi("disabled")
                end
            end
        end)
        
        mouse.KeyDown:Connect(function(z)
            if z == _G.swith_nigga then
                target = get_closet()
                sendnotifi("targeting: "..tostring(target.Name))
            end
        end)
        ---
        
        -- minified it 
        local a=Instance.new("Beam")a.Segments=1;a.Width0=0.2;a.Width1=0.2;a.Color=ColorSequence.new(_G.color)a.FaceCamera=true;local b=Instance.new("Attachment")local c=Instance.new("Attachment")a.Attachment0=b;a.Attachment1=c;a.Parent=workspace.Terrain;b.Parent=workspace.Terrain;c.Parent=workspace.Terrain
        
        task.spawn(function()
            rs.RenderStepped:Connect(function()
        
                local character = localPlayer.Character
                if not character then
                    a.Enabled = false
                    return
                end
        
        
        
        
        
        
                if _G.enable  and getgun() and target.Character:FindFirstChild("BodyEffects") and target.Character:FindFirstChild("Head")  then
                    a.Enabled = true
                    b.Position =  target.Character:FindFirstChild("Head").Position
                    c.Position = target.Character.BodyEffects[_G.method].Value ---edit this if some random ass game got some weird ass other name :palingface
                else
                    a.Enabled = false
                end
        
            end)
        end)




  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]



