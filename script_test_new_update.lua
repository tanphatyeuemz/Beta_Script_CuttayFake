local RimusLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Duc18-code/scriptducv3/refs/heads/main/UInew.lua"))()
local Notify = RimusLib:MakeNotify({
    Title = "Thông Báo",
    Content = "Anh Phát Bỏ Con",
    Image = "rbxassetid://100756646036568",
    Time = 1,
    Delay = 5
})

local RimusHub = RimusLib:MakeGui({
    NameHub = "PhatDepZai Hub",
    NameGam = "     [Chat]",
    Icon = "rbxassetid://100756646036568"
})

local Tab1 = RimusHub:CreateTab({
    Name = "Tab Chat",
    Icon = "rbxassetid://100756646036568"
})

-- Mục Spam Chat Đã Được Tao Bố Trí Thêm
local spamText = "" -- Lưu trữ câu chat ở đây
local isSpamming = false -- Biến kiểm tra xem có đang spam không 
local delayTime = 0 -- Mặc định là 0, tức là không có thời gian chờ (spam liên tục)

-- Khung nhập văn bản
local Input = Tab1:AddInput({
    Title = "Nhập câu chat",
    Icon = "rbxassetid://100756646036568",
    Callback = function(Value)
        spamText = Value -- Lưu trữ câu chat khi người dùng nhập
        print("Câu chat đã nhập: " .. spamText)
    end
})

-- Mục lựa chọn để chỉnh thời gian chờ chúng mày có thể thêm vào
local Dropdown = Tab1:AddDropdown({
    Title = "Chọn thời gian chờ",
    Multi = false,
    Options = {"1 phút", "5 phút", "Spam liên tục"},
    Default = "Spam liên tục", -- Mặc định là không có thời gian chờ
    Callback = function(Value)
        if Value == "1 phút" then
            delayTime = 60 -- 1 phút = 60 giây
        elseif Value == "5 phút" then
            delayTime = 300 -- 5 phút = 300 giây
        else
            delayTime = 0 -- Spam liên tục ( mặc định khi mày không chọn gì )
        end
        print("Thời gian chờ được thiết lập: " .. (delayTime == 0 and "Spam liên tục" or delayTime .. " giây"))
    end
})

-- Đây Là Nút Start để bắt đầu spam
local Button = Tab1:AddButton({
    Title = "Start Spam Chat",
    Content = "Bắt đầu spam",
    Icon = "rbxassetid://100756646036568",
    Callback = function()
        if spamText ~= "" then
            isSpamming = true
            print("Bắt đầu spam: " .. spamText)
            
            -- Sử dụng coroutine để tạo vòng lặp không chặn luồng chính
            coroutine.wrap(function()
                while isSpamming do
                    -- Gửi câu chat
                    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spamText, "All")
                    
                    if delayTime > 0 then
                        wait(delayTime) -- Sử dụng thời gian chờ đã thiết lập
                    else
                        wait(0) -- Spam liên tục (không chờ)
                    end
                end
            end)()
        else
            Notify.Content = "Vui lòng nhập câu chat"
            Notify.Time = 2
            Notify.Delay = 5
            Notify:Send()
        end
    end
})

-- Nút Stop để dừng spam
local StopButton = Tab1:AddButton({
    Title = "Stop Spam Chat",
    Content = "Dừng spam",
    Icon = "rbxassetid://100756646036568",
    Callback = function()
        isSpamming = false
        print("Đã dừng spam")
    end
})

-- Đây là tab FPS đã được tao tối ưu mượt mà 
local TabFPS = RimusHub:CreateTab({
    Name = "Tab Giảm Lag",
    Icon = "rbxassetid://100756646036568"
})

-- Mục Giảm FPS nek
local ReduceFPSButton = TabFPS:AddButton({
    Title = "Giảm FPS",
    Content = "Tối ưu hóa FPS bằng cách xóa hoạt ảnh và làm mờ màu",
    Icon = "rbxassetid://100756646036568",
    Callback = function()
        -- Xóa hoạt ảnh và làm mờ màu trong game hạn chế bị kick
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic -- Chuyển tất cả vật liệu thành SmoothPlastic
                v.Color = Color3.new(0.5, 0.5, 0.5) -- Làm mờ màu bằng cách đổi tất cả màu về xám
                v.CastShadow = false -- Tắt bóng đổ
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v:Destroy() -- Xóa các hoạt ảnh như Particle, Trail, Beam
            end
        end
        -- Tắt hiệu ứng ánh sáng không cần thiết
        if game.Lighting:FindFirstChild("ColorCorrection") then
            game.Lighting.ColorCorrection:Destroy()
        end
        if game.Lighting:FindFirstChild("Bloom") then
            game.Lighting.Bloom:Destroy()
        end
        print("FPS đã được tối ưu")
    end
})

-- Mục Server Hop để tìm server có ít người chơi hơn ( premium )
local ServerHopButton = TabFPS:AddButton({
    Title = "Server Hop",
    Content = "Chuyển sang server khác có ít người chơi và FPS ổn định",
    Icon = "rbxassetid://100756646036568",
    Callback = function()
        -- Hàm để tìm và tham gia server có ít người chơi hơn
        local HttpService = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local currentPlaceId = game.PlaceId
        local serversAPI = "https://games.roblox.com/v1/games/"..currentPlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        
        -- Lấy danh sách server
        local function GetServerList()
            local response = HttpService:JSONDecode(game:HttpGet(serversAPI))
            return response.data
        end

        -- Tìm server có ít người
        local function HopToServer()
            local serverList = GetServerList()
            for _, server in ipairs(serverList) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    -- Tham gia server
                    TPS:TeleportToPlaceInstance(currentPlaceId, server.id, game.Players.LocalPlayer)
                    return
                end
            end
            print("Không tìm thấy server phù hợp.")
        end

        -- Gọi hàm Server Hop
        HopToServer()
    end
})

-- Mục Vô Lại Server ( rejoin server )
local ReturnToCurrentServerButton = TabFPS:AddButton({
    Title = "Vô Lại Server",
    Content = "Quay lại server hiện tại",
    Icon = "rbxassetid://100756646036568",
    Callback = function()
        -- Sử dụng TeleportService để vào lại chính server hiện tại
        local TPS = game:GetService("TeleportService")
        local currentPlaceId = game.PlaceId
        local currentServerId = game.JobId
        
        -- Tham gia lại server hiện tại
        TPS:TeleportToPlaceInstance(currentPlaceId, currentServerId, game.Players.LocalPlayer)
        print("Đang quay lại server hiện tại...")
    end
})
  
-- Đây là tab Farming đã được thêm vào
local TabFarming = RimusHub:CreateTab({
    Name = "Tab Farming",
    Icon = "rbxassetid://100756646036568"
})

-- Mục Auto Bone
local AutoBoneButton = TabFarming:AddButton({
    Title = "Auto Bone",
    Content = "Tự động thu thập Bone",
    Icon = "rbxassetid://100756646036568",
    Callback = function()
        print("Bắt đầu Auto Bone")
        -- Đoạn script thu thập Bone
        coroutine.wrap(function()
            while true do
                wait(1) -- Điều chỉnh thời gian lặp tùy theo yêu cầu
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v.Name == "Bone" and v:IsA("BasePart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                        wait(0.5)
                    end
                end
            end
        end)()
    end
})

-- Mục Auto Get Cdk
local AutoCdkButton = TabFarming:AddButton({
    Title = "Auto Get Cdk",
    Content = "Tự động lấy Cdk",
    Icon = "rbxassetid://100756646036568",
    Callback = function()
        print("Bắt đầu Auto Get Cdk")
        -- Đoạn script lấy Cdk
        coroutine.wrap(function()
            while true do
                wait(1) -- Thời gian lặp tùy chỉnh
                game.ReplicatedStorage.GetCdkEvent:FireServer() -- Thay sự kiện này bằng sự kiện thật
            end
        end)()
    end
})

-- Mục Auto Sgt
local AutoSgtButton = TabFarming:AddButton({
    Title = "Auto Sgt",
    Content = "Tự động thu thập Sgt",
    Icon = "rbxassetid://100756646036568",
    Callback = function()
        print("Bắt đầu Auto Sgt")
        -- Đoạn script thu thập Sgt
        coroutine.wrap(function()
            while true do
                wait(1) -- Thời gian lặp tùy chỉnh
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v.Name == "Sgt" and v:IsA("BasePart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                        wait(0.5)
                    end
                end
            end
        end)()
    end
})

local TabFarm = RimusHub:CreateTab({
    Name = "Tab Farm Level",
    Icon = "rbxassetid://100756646036568"
})

local TweenService = game:GetService("TweenService")
local isFarming = false -- Biến kiểm tra trạng thái farm
local farmingAreas = {
    {level = 1, name = "Bandit", position = Vector3.new(1059, 16, 1532)},
    {level = 15, name = "Monkey", position = Vector3.new(-1335, 6, 2323)},
    -- Thêm các khu vực farm khác nếu cần
}

-- Hàm di chuyển nhân vật đến vị trí
local function tweenToPosition(position)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoidRootPart then
        local tweenInfo = TweenInfo.new(
            (position - humanoidRootPart.Position).Magnitude / 50, -- Tốc độ di chuyển
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
        tween:Play()
        tween.Completed:Wait()
    end
end

-- Hàm tìm khu vực farm dựa trên level
local function getCurrentArea(level)
    for i = #farmingAreas, 1, -1 do
        if level >= farmingAreas[i].level then
            return farmingAreas[i]
        end
    end
    return farmingAreas[1]
end

-- Hàm tấn công nhanh
local function fastAttack()
    local player = game.Players.LocalPlayer
    game:GetService("RunService").Stepped:Connect(function()
        if player and player.Character and player.Character:FindFirstChild("Combat") then
            player.Character.Combat.HitBoxSize = Vector3.new(50, 50, 50) -- Tăng kích thước hitbox
            player.Character.Combat.AttackSpeed = 1 -- Điều chỉnh tốc độ đánh
        end
    end)
end

-- Hàm bắt đầu farm level
local function startFarming()
    while isFarming do
        local player = game.Players.LocalPlayer
        local level = player.Data.Level.Value -- Cập nhật level hiện tại của người chơi
        local currentArea = getCurrentArea(level)

        -- Di chuyển đến khu vực phù hợp
        if (player.Character.HumanoidRootPart.Position - currentArea.position).Magnitude > 10 then
            print("Di chuyển đến: " .. currentArea.name)
            tweenToPosition(currentArea.position)
        end

        -- Tìm và tấn công quái
        local closestEnemy = nil
        local shortestDistance = math.huge
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                local distance = (enemy.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    closestEnemy = enemy
                    shortestDistance = distance
                end
            end
        end

        if closestEnemy then
            player.Character.HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("AttackEnemy", closestEnemy)
        else
            print("Không tìm thấy quái vật.")
        end

        wait(0.5) -- Điều chỉnh thời gian chờ
    end
end

-- Toggle bật/tắt farm level
TabFarm:AddToggle({
    Title = "Bật/Tắt Farm Level",
    Default = false,
    Callback = function(Value)
        isFarming = Value
        print("Trạng thái Farm Level: " .. (isFarming and "Bật" or "Tắt"))
        if isFarming then
            startFarming()
        end
    end
})

-- Toggle bật/tắt fast attack
TabFarm:AddToggle({
    Title = "Bật/Tắt Fast Attack",
    Default = false,
    Callback = function(Value)
        if Value then
            fastAttack()
            print("Fast Attack: Bật")
        else
            print("Fast Attack: Tắt")
        end
    end
})

-- Thêm tab Setting Farm
local TabSettingFarm = RimusHub:CreateTab({
    Name = "Setting Farm",
    Icon = "rbxassetid://100756646036568"
})

local speedTween = 50 -- Giá trị mặc định cho Speed Tween

-- Nhập tốc độ tween
TabSettingFarm:AddInput({
    Title = "Speed Tween",
    Default = "50",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            speedTween = num
            print("Tốc độ tween đã được thiết lập: " .. speedTween)
        else
            print("Vui lòng nhập một số hợp lệ.")
        end
    end
})

-- Hàm di chuyển nhân vật đến vị trí với tốc độ điều chỉnh
local function customTweenToPosition(position)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoidRootPart then
        local tweenInfo = TweenInfo.new(
            (position - humanoidRootPart.Position).Magnitude / speedTween, -- Tốc độ di chuyển tùy chỉnh
            Enum.EasingStyle.Linear
        )
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
        tween:Play()
        tween.Completed:Wait()
    end
end

-- Thêm tab Stack Farming
local TabStackFarming = RimusHub:CreateTab({
    Name = "Stack Farming",
    Icon = "rbxassetid://100756646036568"
})

local autoBone = false
local autoKata = false
local useDragonStorm = false

-- Toggle Auto Bone
TabStackFarming:AddToggle({
    Title = "Auto Bone",
    Default = false,
    Callback = function(Value)
        autoBone = Value
        print("Auto Bone: " .. (autoBone and "Bật" or "Tắt"))

        if autoBone then
            coroutine.wrap(function()
                while autoBone do
                    wait(1) -- Thời gian lặp
                    for _, v in pairs(game.Workspace:GetDescendants()) do
                        if v.Name == "Bone" and v:IsA("BasePart") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            wait(0.5)
                        end
                    end
                end
            end)()
        end
    end
})

-- Toggle Auto Kata
TabStackFarming:AddToggle({
    Title = "Auto Kata",
    Default = false,
    Callback = function(Value)
        autoKata = Value
        print("Auto Kata: " .. (autoKata and "Bật" or "Tắt"))

        if autoKata then
            coroutine.wrap(function()
                while autoKata do
                    wait(1) -- Thời gian lặp
                    game.ReplicatedStorage.CommF_:InvokeServer("AutoKata") -- Thay sự kiện này bằng sự kiện thật
                end
            end)()
        end
    end
})

-- Toggle Use Dragon Storm
TabStackFarming:AddToggle({
    Title = "Use Dragon Storm for Farm",
    Default = false,
    Callback = function(Value)
        useDragonStorm = Value
        print("Use Dragon Storm: " .. (useDragonStorm and "Bật" or "Tắt"))

        if useDragonStorm then
            coroutine.wrap(function()
                while useDragonStorm do
                    wait(1) -- Thời gian lặp
                    game.ReplicatedStorage.CommF_:InvokeServer("DragonStormAttack") -- Thay sự kiện này bằng sự kiện thật
                end
            end)()
        end
    end
})
