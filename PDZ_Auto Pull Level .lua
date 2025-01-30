local RimusLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Duc18-code/scriptducv3/refs/heads/main/UInew.lua"))() 
local Notify = RimusLib:MakeNotify({
    Title = "Thông Báo",
    Content = "Đã tải xong giao diện!",
    Image = "rbxassetid://100756646036568",
    Time = 1,
    Delay = 5
})

local RimusHub = RimusLib:MakeGui({
    NameHub = "PhatDepZai Hub",
    NameGam = "     [Main]",
    Icon = "rbxassetid://100756646036568"
})

-- Tab Main
local TabMain = RimusHub:CreateTab({
    Name = "Tab Main",
    Icon = "rbxassetid://100756646036568"
})

-- Status Mũ Admin
local AdminHatStatus = TabMain:AddLabel({
    Title = "Status Mũ Admin: 🔴", -- Mặc định là không có
    Icon = "rbxassetid://100756646036568"
})

-- Status Mảnh Gương
local MirrorStatus = TabMain:AddLabel({
    Title = "Status Mảnh Gương: 🔴", -- Mặc định là không có
    Icon = "rbxassetid://100756646036568"
})

-- Status Pull Level
TabMain:AddLabel({
    Title = "Status Pull Level: Đang update!",
    Icon = "rbxassetid://100756646036568"
})

-- Status Mirage Island
TabMain:AddLabel({
    Title = "Status Mirage Island: Đang update!",
    Icon = "rbxassetid://100756646036568"
})

-- Đợi nhân vật tải xong
game.Players.LocalPlayer.CharacterAdded:Wait()

-- Debug: In danh sách vật phẩm để xác định tên
print("Debug: Danh sách vật phẩm trong Character:")
for _, item in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if item:IsA("Accessory") then
        print("Accessory Name:", item.Name)
    end
end

print("Debug: Danh sách vật phẩm trong Backpack:")
for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    print("Backpack Item Name:", item.Name)
end

-- Kiểm tra mũ admin (Valkyrie Helm)
local function checkAdminHat()
    if game.Players.LocalPlayer.Character then
        local hasAdminHat = false
        for _, item in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if item:IsA("Accessory") and item.Name == "Valkyrie Helm" then
                hasAdminHat = true
                break
            end
        end

        AdminHatStatus:Set({
            Title = "Status Mũ Admin: " .. (hasAdminHat and "🟢" or "🔴")
        })
    end
end

-- Kiểm tra mảnh gương (Mirror Fractal)
local function checkMirror()
    local hasMirror = false
    local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name == "Mirror Fractal" then
                hasMirror = true
                break
            end
        end
    end

    MirrorStatus:Set({
        Title = "Status Mảnh Gương: " .. (hasMirror and "🟢" or "🔴")
    })
end

-- Liên tục kiểm tra trạng thái
game:GetService("RunService").RenderStepped:Connect(function()
    checkAdminHat()
    checkMirror()
end)
