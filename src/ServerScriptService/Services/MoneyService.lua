local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PathfindingService = game:GetService('PathfindingService')

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local GameData = require(ReplicatedStorage.GameData)

local MoneyService = Knit.CreateService {
    Name = "MoneyService";
    Client = {};
}

MoneyService.Client.MoneyChanged = Knit.CreateSignal()


function MoneyService.Client:GetMoney(plr) 
    return MoneyService:GetMoney(plr)
end


function MoneyService:GetMoney(plr)

    local PlayerDataService = Knit.GetService('PlayerDataService')
    return PlayerDataService:GetDirectory(plr, 'Obrian', GameData.DefaultCash)

end


function MoneyService:ChangeMoney(plr, amount)

    local PlayerDataService = Knit.GetService('PlayerDataService')
    local currentValue = PlayerDataService:GetDirectory(plr, 'Obrian', GameData.DefaultCash)
    local newValue = PlayerDataService:SetDirectory(plr, 'Obrian', math.clamp(currentValue + amount,0,math.huge))

end


function MoneyService:KnitStart()
    
    local PlayerDataService = Knit.GetService('PlayerDataService')
    local counter = 0
    RunService.Heartbeat:Connect(function(dt)
        counter += dt
        if counter > 60 then
            counter = 0

            for _,plr in pairs(Players:GetChildren()) do
                local currentValue = PlayerDataService:GetDirectory(plr, 'Obrian', GameData.DefaultCash)
                local newValue = PlayerDataService:SetDirectory(plr, 'Obrian', currentValue + GameData.CashPerMinute)
            end
        end
    end)

end




return MoneyService
