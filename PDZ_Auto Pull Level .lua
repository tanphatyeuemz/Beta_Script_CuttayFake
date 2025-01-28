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

-- Kiểm tra mũ admin
local function checkAdminHat()
    local hasAdminHat = false
    for _, item in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if item:IsA("Accessory") and item.Name == "AdminHat" then -- Tên mũ admin
            hasAdminHat = true
            break
        end
    end

    AdminHatStatus:Set({
        Title = "Status Mũ Admin: " .. (hasAdminHat and "🟢" or "🔴")
    })
end

-- Liên tục kiểm tra trạng thái mũ admin
game:GetService("RunService").RenderStepped:Connect(checkAdminHat)

-- Status Mảnh Gương
local MirrorStatus = TabMain:AddLabel({
    Title = "Status Mảnh Gương: 🔴", -- Mặc định là không có
    Icon = "rbxassetid://100756646036568"
})

-- Kiểm tra mảnh gương
local function checkMirror()
    local hasMirror = false
    for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if item.Name == "MirrorPiece" then -- Tên mảnh gương
            hasMirror = true
            break
        end
    end

    MirrorStatus:Set({
        Title = "Status Mảnh Gương: " .. (hasMirror and "🟢" or "🔴")
    })
end

-- Liên tục kiểm tra trạng thái mảnh gương
game:GetService("RunService").RenderStepped:Connect(checkMirror)

-- Status Pull Level
TabMain:AddLabel({
    Title = "Status Pull Level: Dev đang update, sẽ có sớm!",
    Icon = "rbxassetid://100756646036568"
})
